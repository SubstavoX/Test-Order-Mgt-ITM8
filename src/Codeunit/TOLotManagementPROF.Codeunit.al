/// <summary>
/// Codeunit TO Lot Management PROF (ID 6208502).
/// </summary>
codeunit 6208502 "TO Lot Management PROF"
{
    Permissions = TableData "TO Test Order PROF" = rimd;

    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
        Bin: Record Bin;
        BinType: Record "Bin Type";
        BinContentFilter: Record "Bin Content";
        TOEventsSingleInstance: Codeunit "TO Events Single Instance PROF";
        MultipleLbl: Label '(Multiple)';

    /// <summary>
    /// LotNoInfoSetMissingItemTrackingInfo.
    /// </summary>
    /// <param name="LotNoInfo">VAR Record "Lot No. Information".</param>
    /// <param name="DialogFieldCaptionText">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure LotNoInfoSetMissingItemTrackingInfo(var LotNoInfo: Record "Lot No. Information"; DialogFieldCaptionText: Text): Boolean
    var
        Item: Record Item;
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        ItemTrackingCode: Record "Item Tracking Code";
        TrackingNoStatusEntryUpdated: Boolean;
        KeyText: Text;
        ConfirmChangeQst: Label '%1 %2\Do you want to set the %3 ?', comment = '%1 = Item No., %2 = Lot No., %3 = Dialog Field Caption Text';
    begin
        //if TOTestOrder."Test Order Status" <> TOTestOrder."Test Order Status"::Open then
        //    exit;

        if (LotNoInfo."Item No." = '') and (LotNoInfo."Lot No." = '') then
            exit;

        if not Item.Get(LotNoInfo."Item No.") then
            exit(false);

        // Check if Lot tracking is required
        if not ItemTrackingCode.Get(Item."Item Tracking Code") then
            exit(false);

        if not ItemTrackingCode."Lot Specific Tracking" then
            exit(false);

        if DialogFieldCaptionText <> '' then begin
            KeyText := LotNoInfo."Item No.";
            if LotNoInfo."Variant Code" <> '' then
                KeyText := KeyText + '-' + LotNoInfo."Variant Code";
            if LotNoInfo."Lot No." <> '' then
                KeyText := KeyText + '-' + LotNoInfo."Lot No.";

            if not Confirm(ConfirmChangeQst, false, LotNoInfo.TableCaption(), KeyText, DialogFieldCaptionText) then
                exit(false);
        end;

        if not Item.Get(LotNoInfo."Item No.") then
            exit(false);

        TrackingNoStatusEntryUpdated := false;

        TrackingNoStatusEntry.Reset();
        TrackingNoStatusEntry.SetRange("Item No.", LotNoInfo."Item No.");
        TrackingNoStatusEntry.SetRange("Variant Code", LotNoInfo."Variant Code");
        TrackingNoStatusEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        if TrackingNoStatusEntry.FindLast() then begin
            if TrackingNoStatusEntry."Order Type" = TrackingNoStatusEntry."Order Type"::"Test Order" then begin
                if TrackingNoStatusEntry."Original Expiration Date" = 0D then begin
                    TrackingNoStatusEntryUpdated := true;
                    TrackingNoStatusEntry."Original Expiration Date" := TrackingNoStatusEntry."Expiration Date";
                end;
                if TrackingNoStatusEntry."Original Lot No." = '' then begin
                    TrackingNoStatusEntryUpdated := true;
                    TrackingNoStatusEntry."Original Lot No." := TrackingNoStatusEntry."Lot No.";
                end;

                if TrackingNoStatusEntry."Original Expiration Date" <> 0D then
                    LotNoInfo."Original Expiration Date PROF" := TrackingNoStatusEntry."Original Expiration Date";
                if TrackingNoStatusEntry."Original Lot No." <> '' then
                    LotNoInfo."Original Lot No. PROF" := TrackingNoStatusEntry."Original Lot No.";
            end;

            if TrackingNoStatusEntry."Vendor Lot No." = '' then
                LotNoInfo."Vendor Lot No. PROF" := TrackingNoStatusEntry."Vendor Lot No.";
            if TrackingNoStatusEntry."Expiration Date" <> 0D then
                LotNoInfo."Expiration Date PROF" := TrackingNoStatusEntry."Expiration Date";
            if TrackingNoStatusEntry."Retest Date" <> 0D then
                LotNoInfo."Retest Date PROF" := TrackingNoStatusEntry."Retest Date";
            if TrackingNoStatusEntry."Sales Expiration Date" <> 0D then
                LotNoInfo."Sales Expiration Date PROF" := TrackingNoStatusEntry."Sales Expiration Date";
            if TrackingNoStatusEntry."Country/Region of Origin" <> '' then
                LotNoInfo."Country/Region of Origin PROF" := TrackingNoStatusEntry."Country/Region of Origin";
        end;

        //Get Back - Check EW

    end;

    internal procedure ShowLotNoInformationCard(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; RunModal: Boolean)
    var
        LotNoInfo: Record "Lot No. Information";
    begin
        LotNoInfo."Item No." := ItemNo;
        LotNoInfo.TestField("Item No.");
        LotNoInfo.Get(LotNoInfo."Item No.", VariantCode, LotNo);
        LotNoInfo.FilterGroup(2);
        LotNoInfo.SetRange("Item No.", LotNoInfo."Item No.");
        LotNoInfo.SetRange("Variant Code", VariantCode);
        LotNoInfo.SetRange("Lot No.", LotNo);
        LotNoInfo.FilterGroup(0);

        if RunModal then
            Page.RunModal(Page::"Lot No. Information Card", LotNoInfo)
        else
            Page.Run(Page::"Lot No. Information Card", LotNoInfo);
    end;

    internal procedure ShowSerialNoInformationCard(ItemNo: Code[20]; VariantCode: Code[10]; SerialNo: Code[50]; RunModal: Boolean)
    var
        SerialNoInfo: Record "Serial No. Information";
    begin
        SerialNoInfo."Item No." := ItemNo;
        SerialNoInfo.TestField("Item No.");
        SerialNoInfo.Get(SerialNoInfo."Item No.", VariantCode, SerialNo);
        SerialNoInfo.FilterGroup(2);
        SerialNoInfo.SetRange("Item No.", SerialNoInfo."Item No.");
        SerialNoInfo.SetRange("Variant Code", VariantCode);
        SerialNoInfo.SetRange("Serial No.", SerialNo);
        SerialNoInfo.FilterGroup(0);

        if RunModal then
            Page.RunModal(Page::"Serial No. Information Card", SerialNoInfo)
        else
            Page.Run(Page::"Serial No. Information Card", SerialNoInfo);
    end;


    internal procedure CreateTempBinContent(var TempWarehouseEntry: Record "Warehouse Entry" temporary; ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; LocationCode: Code[10]; ResultMode: Option Pick,"Not Pick",All)
    var
        BinContent: Record "Bin Content";
        Item: Record Item;
        EntryNo: Integer;
    begin
        if ItemNo = '' then
            exit;
        Clear(TempWarehouseEntry);
        if not TempWarehouseEntry.IsEmpty() then
            TempWarehouseEntry.DeleteAll();

        Item.Get(ItemNo);

        BinContent.Reset();
        BinContent.SetCurrentKey("Item No.");
        BinContent.SetRange("Item No.", ItemNo);
        BinContent.SetRange("Location Code", LocationCode);
        BinContent.SetRange("Variant Code", VariantCode);
        BinContent.SetFilter("Lot No. Filter", LotNo);
        BinContent.SetFilter("Serial No. Filter", SerialNo);
        BinContent.SetFilter(Quantity, '>%1', 0);

        BinContent.SetAutoCalcFields(Quantity);
        if BinContent.FindSet() then begin
            EntryNo := 0;
            repeat
                GetBinType(BinContent."Bin Type Code");
                if (ResultMode = ResultMode::All) or ((ResultMode = ResultMode::Pick) and (BinType.Pick)) or ((ResultMode = ResultMode::"Not Pick") and (not BinType.Pick)) then begin
                    TempWarehouseEntry.SetRange("Item No.", ItemNo);
                    TempWarehouseEntry.SetRange("Lot No.", LotNo);
                    TempWarehouseEntry.SetRange("Serial No.", SerialNo);
                    TempWarehouseEntry.SetRange("Location Code", BinContent."Location Code");
                    TempWarehouseEntry.SetRange("Variant Code", BinContent."Variant Code");
                    TempWarehouseEntry.SetRange("Bin Code", BinContent."Bin Code");
                    TempWarehouseEntry.SetRange("Zone Code", BinContent."Zone Code");
                    TempWarehouseEntry.SetRange("Unit of Measure Code", BinContent."Unit of Measure Code");
                    TempWarehouseEntry.SetRange("Bin Type Code", BinContent."Bin Type Code");
                    if TempWarehouseEntry.FindFirst() then begin
                        TempWarehouseEntry.Quantity += BinContent.Quantity; // Demands same UOM for the lot
                        TempWarehouseEntry.Modify();
                    end else begin
                        EntryNo += 1;
                        TempWarehouseEntry.Init();
                        TempWarehouseEntry."Item No." := ItemNo;
                        TempWarehouseEntry."Lot No." := LotNo;
                        TempWarehouseEntry."Serial No." := SerialNo;
                        TempWarehouseEntry."Location Code" := BinContent."Location Code";
                        TempWarehouseEntry."Variant Code" := BinContent."Variant Code";
                        TempWarehouseEntry."Bin Code" := BinContent."Bin Code";
                        TempWarehouseEntry."Zone Code" := BinContent."Zone Code";
                        TempWarehouseEntry."Unit of Measure Code" := BinContent."Unit of Measure Code";
                        TempWarehouseEntry."Bin Type Code" := BinContent."Bin Type Code";
                        TempWarehouseEntry."Entry No." := EntryNo;
                        TempWarehouseEntry.Description := Item.Description;
                        TempWarehouseEntry.Quantity := BinContent.Quantity; // Demands same UOM for the lot
                        TempWarehouseEntry.Insert();
                    end;
                end;
            until BinContent.Next() = 0;

            TempWarehouseEntry.Reset();
            // Delete entries where total Quantity is zero
            TempWarehouseEntry.SetRange(Quantity, 0);
            if not TempWarehouseEntry.IsEmpty() then
                TempWarehouseEntry.DeleteAll();
            TempWarehouseEntry.Reset();
        end;
    end;

    internal procedure PostTestOrder(var TOTestOrder: Record "TO Test Order PROF"; OrgLotStatus: Enum "TO Lot Status PROF"; ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo: Boolean)
    begin
        if PostTestOrder(TOTestOrder, OrgLotStatus, ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo, CopyStr(UserId(), 1, 50)) then
            if TOTestOrder."New Lot No." <> '' then
                if TOTestOrder.PostLotNo() <> TOTestOrder."New Lot No." then begin
                    TOTestOrder."New Lot No." := '';
                    TOTestOrder.Modify(false);
                end;
    end;

    internal procedure PostTestOrderSN(var TOTestOrder: Record "TO Test Order PROF"; OrgLotStatus: Enum "TO Lot Status PROF"; ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo: Boolean)
    begin
        if PostTestOrder(TOTestOrder, OrgLotStatus, ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo, CopyStr(UserId(), 1, 50)) then
            if TOTestOrder."New Serial No." <> '' then
                if TOTestOrder.PostSerialNo() <> TOTestOrder."New Serial No." then begin
                    TOTestOrder."New Serial No." := '';
                    TOTestOrder.Modify(false);
                end;
    end;

    local procedure PostTestOrder(var TOTestOrder: Record "TO Test Order PROF"; OrgLotStatus: Enum "TO Lot Status PROF"; ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo: Boolean; UserIDCode: Code[50]): Boolean
    var
        TOSetup: Record "TO Setup PROF";
        LotNoInfo: Record "Lot No. Information";
        LotNoInfo2: Record "Lot No. Information";
        NewLotNoInfo: Record "Lot No. Information";
        Location: Record Location;
        TempLotNoInfo: Record "Lot No. Information" Temporary;
        TempLotNoInfoOrg: Record "Lot No. Information" temporary;
        //SerialNo
        SerialNoInfo: Record "Serial No. Information";
        SerialNoInfo2: Record "Serial No. Information";
        NewSerialNoInfo: Record "Serial No. Information";
        TempSerialNoInfo: Record "Serial No. Information" temporary;
        TempSerialNoInfoOrg: Record "Serial No. Information" temporary;
        DoNotPost: Boolean;
    begin
        if OrgLotStatus <> TOTestOrder."Tracking Status"::"Not Tested" then
            exit(false);
        if TOTestOrder."Tracking Status" = OrgLotStatus then
            exit(false);

        if TOTestOrder."Tracking Status" <> TOTestOrder."Tracking Status"::"Not Tested" then begin
            DoNotPost := TOTestOrder.InternalUseOnlyAndSameExpirationDate();
            if TOTestOrder."Order Type" = TOTestOrder."Order Type"::"Test Order" then begin
                if TOTestOrder."Document Type" = TOTestOrder."Document Type"::Production then
                    DoNotPost := true;
            end else
                if ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo or (TOTestOrder."New Lot No." = '') then
                    DoNotPost := true;
        end else
            exit(false);

        if not LotNoInfo.Get(TOTestOrder."Item No.", TOTestOrder."Variant Code", TOTestOrder."Lot No.") then
            if not SerialNoInfo.Get(TOTestOrder."Item No.", TOTestOrder."Variant Code", TOTestOrder."Serial No.") then
                exit(false);

        if not DoNotPost then begin
            if TOTestOrder."Location Code" = '' then
                if GuiAllowed then
                    TOTestOrder.TestField("Location Code")
                else
                    exit;

            if TOTestOrder."Expiration Date" = 0D then
                if GuiAllowed then
                    TOTestOrder.TestField("Expiration Date")
                else
                    exit;

            if TOSetup.Get() then;
            if TOSetup."Test Order Source Code" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Test Order Source Code")
                else
                    exit;

            // Initial remove blocking - should not block for posting
            if LotNoInfo."Lot No." <> '' then begin
                TempLotNoInfoOrg := LotNoInfo;
                SetLotBlocking(LotNoInfo, false);
                if (TOTestOrder."Order Type" = TOTestOrder."Order Type"::"Test Order") then begin
                    if Location.Get(TOTestOrder."Location Code") then
                        if Location."Directed Put-away and Pick" then
                            // Warehouse Journal required
                            WarehousePosting(TOTestOrder, LotNoInfo.Blocked, WorkDate(), TOTestOrder.Quantity, TOTestOrder."Bin Code", false, UserIDCode);
                    PostItemJrnlNegAdj(TOTestOrder, LotNoInfo.Blocked, OrgLotStatus, WorkDate(), TOTestOrder.Quantity);
                    SetLotBlocking(LotNoInfo, TempLotNoInfoOrg.Blocked);
                end else begin
                    WarehouseReclassification(TOTestOrder, LotNoInfo, OrgLotStatus, UserIDCode);
                    SetLotBlocking(LotNoInfo, TempLotNoInfoOrg.Blocked);

                    //   GetTempBulkItemLotNoInfosFromLotNoInfo(LotNoInfo, TOTestOrder."Local Impact", false, TempLotNoInfo);
                    if not TempLotNoInfo.FindSet() then
                        exit(false);

                    if TOTestOrder.PostLotNo() <> TOTestOrder."Lot No." then
                        NewLotNoInfo.Get(LotNoInfo."Item No.", LotNoInfo."Variant Code", TOTestOrder."New Lot No.");

                    repeat


                        LotNoInfo2.Get(TempLotNoInfo."Item No.", TempLotNoInfo."Variant Code", TempLotNoInfo."Lot No.");

                        if (TOTestOrder.PostLotNo() = TOTestOrder."Lot No.") and (not (TOTestOrder."New Expiration Date" in [0D, TOTestOrder."Expiration Date"])) then
                            ReplaceItemTrkgOnReservationEntries(LotNoInfo2);

                        LotNoInfo2.SetFilter("Location Filter", TOTestOrder."Location Code");
                        LotNoInfo2.CalcFields(Inventory);
                        if LotNoInfo2.Inventory > 0 then begin
                            // Initial remove blocking - should not block for posting
                            TempLotNoInfoOrg := LotNoInfo2;
                            SetLotBlocking(LotNoInfo2, false);
                            PostItemJrnlTransfer(TOTestOrder, OrgLotStatus, WorkDate(), LotNoInfo2.Inventory, LotNoInfo2."Item No.", LotNoInfo2."Variant Code", LotNoInfo2.Blocked);
                            SetLotBlocking(LotNoInfo2, TempLotNoInfoOrg.Blocked);
                        end;
                    until TempLotNoInfo.Next() = 0;
                end;
            End;
            if SerialNoInfo."Serial No." <> '' then begin
                TempSerialNoInfoOrg := SerialNoInfo;
                SetSerialBlocking(SerialNoInfo, false);
                if (TOTestOrder."Order Type" = TOTestOrder."Order Type"::"Test Order") then begin
                    if Location.Get(TOTestOrder."Location Code") then
                        if Location."Directed Put-away and Pick" then
                            // Warehouse Journal required
                            WarehousePosting(TOTestOrder, SerialNoInfo.Blocked, WorkDate(), TOTestOrder.Quantity, TOTestOrder."Bin Code", false, UserIDCode);
                    // PostItemJrnlNegAdj(TOTestOrder, SerialNoInfo.Blocked, OrgLotStatus, WorkDate(), TOTestOrder.Quantity);
                    SetSerialBlocking(SerialNoInfo, TempSerialNoInfoOrg.Blocked);
                end else begin
                    WarehouseReclassificationSN(TOTestOrder, SerialNoInfo, OrgLotStatus, UserIDCode);
                    SetSerialBlocking(SerialNoInfo, TempSerialNoInfoOrg.Blocked);

                    //   GetTempBulkItemLotNoInfosFromLotNoInfo(LotNoInfo, TOTestOrder."Local Impact", false, TempLotNoInfo);
                    if not TempSerialNoInfo.FindSet() then
                        exit(false);

                    if TOTestOrder.PostSerialNo() <> TOTestOrder."Serial No." then
                        NewSerialNoInfo.Get(SerialNoInfo."Item No.", SerialNoInfo."Variant Code", TOTestOrder."New Serial No.");

                    repeat


                        SerialNoInfo2.Get(TempSerialNoInfo."Item No.", TempSerialNoInfo."Variant Code", TempSerialNoInfo."Serial No.");

                        if (TOTestOrder.PostSerialNo() = TOTestOrder."Serial No.") and (not (TOTestOrder."New Expiration Date" in [0D, TOTestOrder."Expiration Date"])) then
                            ReplaceItemTrkgOnReservationEntriesSN(SerialNoInfo2);

                        SerialNoInfo2.SetFilter("Location Filter", TOTestOrder."Location Code");
                        SerialNoInfo2.CalcFields(Inventory);
                        if SerialNoInfo2.Inventory > 0 then begin
                            // Initial remove blocking - should not block for posting
                            TempSerialNoInfoOrg := SerialNoInfo2;
                            SetSerialBlocking(SerialNoInfo2, false);
                            PostItemJrnlTransfer(TOTestOrder, OrgLotStatus, WorkDate(), SerialNoInfo2.Inventory, SerialNoInfo2."Item No.", SerialNoInfo2."Variant Code", SerialNoInfo2.Blocked);
                            SetSerialBlocking(SerialNoInfo2, TempSerialNoInfoOrg.Blocked);
                        end;
                    until TempSerialNoInfo.Next() = 0;
                end;




            end;

            if TOTestOrder.PostLotNo() <> TOTestOrder."Lot No." then
                LotNoInfo.Get(TOTestOrder."Item No.", TOTestOrder."Variant Code", TOTestOrder."New Lot No.");

            if TOTestOrder.PostSerialNo() <> TOTestOrder."Serial No." then
                SerialNoInfo.Get(TOTestOrder."Item No.", TOTestOrder."Variant Code", TOTestOrder."New Serial No.");

            exit(true);
        end;
    end;

    local procedure ReplaceItemTrkgOnReservationEntries(LotNoInfo: Record "Lot No. Information")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Item No.", LotNoInfo."Item No.");
        ReservationEntry.SetRange("Variant Code", LotNoInfo."Variant Code");
        ReservationEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        ReservationEntry.SetRange(Positive, true);
        ReservationEntry.SetFilter("Expiration Date", '<>%1', LotNoInfo."Expiration Date PROF");
        if ReservationEntry.IsEmpty() then
            exit;

        if ReservationEntry.FindSet() then
            repeat
                ReservationEntry."Expiration Date" := LotNoInfo."Expiration Date PROF";
                ReservationEntry."Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
                ReservationEntry."Retest Date PROF" := LotNoInfo."Retest Date PROF";
                ReservationEntry."Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";
                ReservationEntry."Country/Region of Origin PROF" := LotNoInfo."Country/Region of Origin PROF";
                ReservationEntry."Tracking Status PROF" := LotNoInfo."Lot Status PROF";
                ReservationEntry.Modify();
            until ReservationEntry.Next() = 0;
    end;

    local procedure ReplaceItemTrkgOnReservationEntriesSN(SerialNoInfo: Record "Serial No. Information")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Item No.", SerialNoInfo."Item No.");
        ReservationEntry.SetRange("Variant Code", SerialNoInfo."Variant Code");
        ReservationEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
        ReservationEntry.SetRange(Positive, true);
        ReservationEntry.SetFilter("Expiration Date", '<>%1', SerialNoInfo."Expiration Date PROF");
        if ReservationEntry.IsEmpty() then
            exit;

        if ReservationEntry.FindSet() then
            repeat
                ReservationEntry."Expiration Date" := SerialNoInfo."Expiration Date PROF";
                ReservationEntry."Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                ReservationEntry."Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                ReservationEntry."Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";
                ReservationEntry."Country/Region of Origin PROF" := SerialNoInfo."Country/Region of Origin PROF";
                ReservationEntry."Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
                ReservationEntry.Modify();
            until ReservationEntry.Next() = 0;
    end;



    local procedure WarehousePosting(var TOTestOrder: Record "TO Test Order PROF"; Blocked: boolean; PostingDate: Date; QtyToPost: Decimal; BinCode: Code[20]; Reclass: Boolean; UserIDCode: Code[50])
    var
        TOSetup: Record "TO Setup PROF";
        Item: Record Item;
        BinContent: Record "Bin Content";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        Location: Record Location;
        UsageDecision: Record "TO Usage Decision PROF";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        LotQtyOnBin: Decimal;
        SerialQtyOnBin: Decimal;
        QuantityIsZeroMsg: Label '%1 %2. %3 %4. %5 is zero.', comment = '%1 = Table Caption Text, %2 = Test Order No., %3 = Item Caption Text, %4 = Item No., %5 = Field Caption Text';
        ProceedMsg: Label 'Do you want to proceed anyway ?', comment = 'Question to user';
        ItemNotEnoughInventoryErr: Label '%1 %2 has not enough inventory on %3 %4. (%5 < %7) and (%6 < %7)', comment = '%1 = Item Caption Text, %2 = Item No., %3 = Field Caption Text, %4 = Bin Code, %5 = Lot Qty On Bin, %6 = Serial Qty On Bin, %7 = Qty To Post';
    begin
        if UsageDecision.Get(TOTestOrder."Usage Decision") then;

        if TOTestOrder."Item No." = '' then
            if GuiAllowed then
                TOTestOrder.TestField("Item No.")
            else
                exit;

        if Item.Get(TOTestOrder."Item No.") then;
        if QtyToPost <= 0 then begin
            if (Item."Reference Sample PROF" > 0) and not UsageDecision."Block Tracking No." then
                if GuiAllowed then
                    TOTestOrder.FieldError(Quantity)
                else
                    exit;

            if GuiAllowed then
                if not Confirm(StrSubstNo(QuantityIsZeroMsg, TOTestOrder.TableCaption(), TOTestOrder."Test Order No.", Item.TableCaption(), TOTestOrder."Item No.", TOTestOrder.FieldCaption(Quantity)) + ' ' + ProceedMsg, false) then
                    Error('');
            exit;
        end;

        if TOTestOrder."Bin Code" = '' then
            if GuiAllowed then
                TOTestOrder.TestField("Bin Code")
            else
                exit;

        if TOSetup.Get() then;

        BinContent.SetRange("Location Code", TOTestOrder."Location Code");
        BinContent.SetRange("Item No.", TOTestOrder."Item No.");
        BinContent.SetRange("Variant Code", TOTestOrder."Variant Code");
        BinContent.SetRange("Bin Code", BinCode);
        BinContent.SetRange("Unit of Measure Code", TOTestOrder."Unit of Measure Code");
        if BinContent.FindFirst() then;

        // Test if Qty for ItemNo+Bin+LotN is available
        LotQtyOnBin := GetLotQtyOnBin(TOTestOrder."Item No.", TOTestOrder."Lot No.", TOTestOrder."Bin Code");
        SerialQtyOnBin := GetSerialQtyOnBin(TOTestOrder."Item No.", TOTestOrder."Serial No.", TOTestOrder."Bin Code");
        if (LotQtyOnBin < QtyToPost) and (SerialQtyOnBin < QtyToPost) then
            if GuiAllowed then
                Error(ItemNotEnoughInventoryErr, Item.TableCaption(), TOTestOrder."Item No.", TOTestOrder.FieldCaption("Bin Code"), TOTestOrder."Bin Code", LotQtyOnBin, SerialQtyOnBin, QtyToPost)
            else
                exit;

        TempWhseJnlLine.Init();
        if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then begin
            if TOSetup."Warehouse Jnl. Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Jnl. Template Name")
                else
                    exit;

            if TOSetup."Warehouse Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Journal Batch Name")
                else
                    exit;

            TempWhseJnlLine."Journal Template Name" := TOSetup."Warehouse Jnl. Template Name";
            TempWhseJnlLine."Journal Batch Name" := TOSetup."Warehouse Journal Batch Name";
        end else begin
            if TOSetup."Reclass Journal Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Template Name")
                else
                    exit;

            if TOSetup."Reclass Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Batch Name")
                else
                    exit;
            TempWhseJnlLine."Journal Template Name" := TOSetup."Reclass Journal Template Name";
            TempWhseJnlLine."Journal Batch Name" := TOSetup."Reclass Journal Batch Name";
        end;
        //if TOTestOrder."Document No." <> '' then
        //    TempWhseJnlLine."Whse. Document No." := TOTestOrder."Document No."
        //else
        TempWhseJnlLine."Whse. Document No." := TOTestOrder."Test Order No.";
        TempWhseJnlLine."Location Code" := TOTestOrder."Location Code";
        TempWhseJnlLine."New Location Code PROF" := TOTestOrder."Location Code";
        TempWhseJnlLine."Line No." := 0;
        TempWhseJnlLine."Registering Date" := PostingDate;
        TempWhseJnlLine."Item No." := TOTestOrder."Item No.";
        TempWhseJnlLine."From Zone Code" := BinContent."Zone Code";
        TempWhseJnlLine."From Bin Code" := BinContent."Bin Code";
        TempWhseJnlLine.Description := Item.Description;
        TempWhseJnlLine.Validate("Unit of Measure Code", TOTestOrder."Unit of Measure Code"); // Setting also "Qty. per Unit of Measure"

        TempWhseJnlLine.Quantity := QtyToPost;
        TempWhseJnlLine."Qty. (Base)" := Round(TempWhseJnlLine.Quantity * TempWhseJnlLine."Qty. per Unit of Measure", 0.00001);
        TempWhseJnlLine."Qty. (Absolute)" := Abs(TempWhseJnlLine.Quantity);
        TempWhseJnlLine."Qty. (Absolute, Base)" := Abs(TempWhseJnlLine."Qty. (Base)");
        TempWhseJnlLine."Source Code" := TOSetup."Test Order Source Code";

        TempWhseJnlLine."From Bin Type Code" := BinContent."Bin Type Code";
        //// if Reclass then
        TempWhseJnlLine."Entry Type" := TempWhseJnlLine."Entry Type"::Movement;
        TempWhseJnlLine."User ID" := UserIDCode;
        TempWhseJnlLine."Variant Code" := TOTestOrder."Variant Code";

        TempWhseJnlLine."Lot No." := TOTestOrder."Lot No.";
        TempWhseJnlLine."Expiration Date" := TOTestOrder."Expiration Date";
        TempWhseJnlLine."Vendor Lot No. PROF" := TOTestOrder."Vendor Lot No.";
        TempWhseJnlLine."Serial No." := TOTestOrder."Serial No.";
        TempWhseJnlLine."Vendor Serial No. PROF" := TOTestOrder."Vendor Serial No.";
        TempWhseJnlLine."Retest Date PROF" := TOTestOrder."Retest Date";
        TempWhseJnlLine."Sales Expiration Date PROF" := TOTestOrder."Sales Expiration Date";
        TempWhseJnlLine."Tracking Status PROF" := TOTestOrder."Tracking Status";
        //WhseJnlLine.Blocked := GlobalBlocked;
        TempWhseJnlLine."Blocked PROF" := Blocked;

        if Reclass then begin
            Location.Get(TempWhseJnlLine."New Location Code PROF");
            if Location."Directed Put-away and Pick" then begin
                // Only when New Location is a Warehouse Location
                TempWhseJnlLine."To Zone Code" := TempWhseJnlLine."From Zone Code";
                TempWhseJnlLine."To Bin Code" := TempWhseJnlLine."From Bin Code";
                // New Item Tracking Info
                TempWhseJnlLine."New Lot No." := TOTestOrder."New Lot No.";
                TempWhseJnlLine."New Vendor Lot No. PROF" := TOTestOrder."New Vendor Lot No.";
                TempWhseJnlLine."New Expiration Date" := TOTestOrder."New Expiration Date";
                TempWhseJnlLine."New Serial No." := TOTestOrder."New Serial No.";
                TempWhseJnlLine."New Vendor Serial No. PROF" := TOTestOrder."New Vendor Serial No.";
                if TempWhseJnlLine."New Expiration Date" <> 0D then
                    if Format(Item."Retest Calculation PROF") <> '' then
                        TempWhseJnlLine."New Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", TempWhseJnlLine."New Expiration Date");
                TempWhseJnlLine."New Blocked PROF" := UsageDecision."Block Tracking No.";

            end;

        end;
        WhseJnlRegisterLine.Run(TempWhseJnlLine);
    end;

    local procedure PostItemJrnlNegAdj(var TOTestOrder: Record "TO Test Order PROF"; Blocked: Boolean; OrgLotStatus: Enum "TO Lot Status PROF"; PostingDate: Date; QtyToPost: Decimal)
    var
        TOSetup: Record "TO Setup PROF";
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        UsageDecision: Record "TO Usage Decision PROF";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        DimensionMgt: Codeunit DimensionManagement;

        DimSetID: array[10] of Integer;
    begin
        if UsageDecision.Get(TOTestOrder."Usage Decision") then;
        if QtyToPost = 0 then
            exit;
        if TOTestOrder."Item No." = '' then
            exit;
        if Item.Get(TOTestOrder."Item No.") then;

        if TOSetup.Get() then;

        if TOSetup."Test Order Source Code" = '' then
            if GuiAllowed then
                TOSetup.TestField("Test Order Source Code")
            else
                exit;

        if TOSetup."Warehouse Jnl. Template Name" = '' then
            if GuiAllowed then
                TOSetup.TestField("Warehouse Jnl. Template Name")
            else
                exit;

        if TOSetup."Warehouse Journal Batch Name" = '' then
            if GuiAllowed then
                TOSetup.TestField("Warehouse Journal Batch Name")
            else
                exit;

        ItemJnlLine.Init();
        //if TOTestOrder."Document No." <> '' then
        //    ItemJnlLine."Document No." := TOTestOrder."Document No."
        //else
        ItemJnlLine."Document No." := TOTestOrder."Test Order No.";
        ItemJnlLine."Document Line No." := 0;
        ItemJnlLine."Journal Template Name" := TOSetup."Warehouse Jnl. Template Name";
        ItemJnlLine."Journal Batch Name" := TOSetup."Warehouse Journal Batch Name";
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Negative Adjmt.");
        ItemJnlLine.Validate("Posting Date", PostingDate);
        ItemJnlLine.Validate("Item No.", TOTestOrder."Item No.");
        ItemJnlLine."Variant Code" := TOTestOrder."Variant Code";
        if ItemJnlLine."Unit of Measure Code" <> TOTestOrder."Unit of Measure Code" then
            ItemJnlLine.Validate("Unit of Measure Code", TOTestOrder."Unit of Measure Code"); // Setting also "Qty. per Unit of Measure"
        ItemJnlLine."External Document No." := '';
        ItemJnlLine.Description := Item.Description;
        DimSetID[1] := ItemJnlLine."Dimension Set ID";
        DimSetID[2] := TOTestOrder."Dimension Set ID";
        ItemJnlLine."Shortcut Dimension 1 Code" := Item."Global Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := DimensionMgt.GetCombinedDimensionSetID(DimSetID, ItemJnlLine."Shortcut Dimension 1 Code", ItemJnlLine."Shortcut Dimension 2 Code");
        ItemJnlLine."Location Code" := TOTestOrder."Location Code"; //"Transfer-from Code";
        ItemJnlLine."Vendor Lot No. PROF" := TOTestOrder."Vendor Lot No.";
        ItemJnlLine."Vendor Serial No. PROF" := TOTestOrder."Vendor Serial No.";
        ItemJnlLine."Retest Date PROF" := TOTestOrder."Retest Date";
        ItemJnlLine."Sales Expiration Date PROF" := TOTestOrder."Sales Expiration Date";
        ItemJnlLine."Country/Region of Origin PROF" := TOTestOrder."Country/Region of Origin";

        ItemJnlLine.Validate(Quantity, QtyToPost);

        ItemJnlLine."Source Code" := TOSetup."Test Order Source Code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ItemJnlLine."Country/Region Code" := '';
        ItemJnlLine."Transaction Type" := '';
        ItemJnlLine."Transport Method" := '';
        ItemJnlLine."Entry/Exit Point" := '';
        ItemJnlLine.Area := '';
        ItemJnlLine."Transaction Specification" := '';
        //ItemJnlLine."Product Group Code" := TOTestOrder."Product Group Code";
        ItemJnlLine.Validate("Item Category Code", Item."Item Category Code");
        ItemJnlLine."Line No." := 0;

        // Assign Item tracking Info
        //ItemJnlLine.Blocked := GlobalBlocked;
        ItemJnlLine."Blocked PROF" := Blocked;
        ItemJnlLine."New Blocked PROF" := UsageDecision."Block Tracking No.";
        ItemJnlLine."Tracking Status PROF" := OrgLotStatus;
        ItemJnlLine."Tracking Status (New) PROF" := TOTestOrder."Tracking Status";


        AddItemTrkgToItemJnlLine(ItemJnlLine, TOTestOrder."Serial No.", TOTestOrder."Lot No.", 0D);

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;


    local procedure WarehouseReclassification(var TOTestOrder: Record "TO Test Order PROF"; var LotNoInfo: Record "Lot No. Information"; OrgLotStatus: Enum "TO Lot Status PROF"; UserIDCode: Code[50])
    var
        NewLotNoInfo: Record "Lot No. Information";
        NewBulkLotNoInfo: Record "Lot No. Information";
        TempLotNoInfo: Record "Lot No. Information" Temporary;
        Item: Record Item;
        Location: Record Location;
        WarehouseEntry: Record "Warehouse Entry";
        TempWarehouseEntry: Record "Warehouse Entry" temporary;
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        TempWhseItemTrackingLine: Record "Whse. Item Tracking Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        TOSetup: Record "TO Setup PROF";
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        UsageDecision: Record "TO Usage Decision PROF";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        LineNo: Integer;
        EntryNo: Integer;
        EntryNo2: Integer;
        RetestDate: Date;
        SalesExpirationDate: Date;
    begin
        if UsageDecision.Get(TOTestOrder."Usage Decision") then;

        if OrgLotStatus <> TOTestOrder."Tracking Status"::"Not Tested" then
            exit;
        if LotNoInfo.Blocked then
            if GuiAllowed then
                LotNoInfo.FieldError(Blocked)
            else
                exit;

        if LotNoInfo."Lot No." <> TOTestOrder."Lot No." then
            if GuiAllowed then
                LotNoInfo.TestField("Lot No.", TOTestOrder."Lot No.")
            else
                exit;

        if TOTestOrder."Order Type" = TOTestOrder."Order Type"::"Test Order" then begin
            if TOTestOrder.Quantity = 0 then
                if GuiAllowed then
                    TOTestOrder.FieldError(Quantity)
                else
                    exit;

            if TOTestOrder."Bin Code" = '' then
                if GuiAllowed then
                    TOTestOrder.TestField("Bin Code")
                else
                    exit;
        end else
            if UsageDecision.Code <> '' then begin
                if (TOTestOrder."New Lot No." = '') and not UsageDecision."Not Update Lot No & Expir Date" then
                    if GuiAllowed then
                        TOTestOrder.FieldError("New Lot No.")
                    else
                        exit;

                if (TOTestOrder."New Expiration Date" = 0D) and not UsageDecision."Not Update Lot No & Expir Date" then
                    if GuiAllowed then
                        TOTestOrder.FieldError("New Expiration Date")
                    else
                        exit;
            end;


        if Item.Get(TOTestOrder."Item No.") then;
        RetestDate := TOTestOrder."Retest Date";
        SalesExpirationDate := TOTestOrder."Sales Expiration Date";
        if TOTestOrder.PostLotNo() <> TOTestOrder."Lot No." then
            if NewLotNoInfo.Get(LotNoInfo."Item No.", LotNoInfo."Variant Code", TOTestOrder."New Lot No.") then begin
                RetestDate := NewLotNoInfo."Retest Date PROF";
                SalesExpirationDate := NewLotNoInfo."Sales Expiration Date PROF";
            end else
                if not (TOTestOrder."New Expiration Date" in [0D, TOTestOrder."Expiration Date"]) then begin
                    if Format(Item."Retest Calculation PROF") <> '' then
                        RetestDate := CalcDate(Item."Retest Calculation PROF", TOTestOrder."New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        SalesExpirationDate := CalcDate(Item."Sales Expiration Calc. PROF", TOTestOrder."New Expiration Date");
                end;

        if TOSetup.Get() then;
        if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then begin
            if TOSetup."Warehouse Jnl. Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Jnl. Template Name")
                else
                    exit;

            if TOSetup."Warehouse Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Journal Batch Name")
                else
                    exit;

            TempWhseJnlLine2."Journal Template Name" := TOSetup."Warehouse Jnl. Template Name";
            TempWhseJnlLine2."Journal Batch Name" := TOSetup."Warehouse Journal Batch Name";
        end else begin
            if TOSetup."Reclass Journal Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Template Name")
                else
                    exit;

            if TOSetup."Reclass Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Batch Name")
                else
                    exit;

            TempWhseJnlLine2."Journal Template Name" := TOSetup."Reclass Journal Template Name";
            TempWhseJnlLine2."Journal Batch Name" := TOSetup."Reclass Journal Batch Name";
        end;

        if not TempWarehouseEntry.IsEmpty() then
            TempWarehouseEntry.DeleteAll();
        Clear(TempWarehouseEntry);

        //  GetTempBulkItemLotNoInfosFromLotNoInfo(LotNoInfo, TOTestOrder."Local Impact", false, TempLotNoInfo);
        if not TempLotNoInfo.FindSet() then
            exit;

        WarehouseEntry.SetCurrentKey("Item No.", "Lot No.", "Bin Code");
        WarehouseEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        repeat
            WarehouseEntry.SetRange("Item No.", TempLotNoInfo."Item No.");
            if WarehouseEntry.FindSet() then
                repeat
                    TempWarehouseEntry.SetRange("Item No.", WarehouseEntry."Item No.");
                    TempWarehouseEntry.SetRange("Variant Code", WarehouseEntry."Variant Code");
                    TempWarehouseEntry.SetRange("Lot No.", WarehouseEntry."Lot No.");
                    TempWarehouseEntry.SetRange("Zone Code", WarehouseEntry."Zone Code");
                    TempWarehouseEntry.SetRange("Bin Code", WarehouseEntry."Bin Code");
                    TempWarehouseEntry.SetRange("Location Code", WarehouseEntry."Location Code");
                    TempWarehouseEntry.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                    TempWarehouseEntry.SetRange("Bin Type Code", WarehouseEntry."Bin Type Code");
                    if TempWarehouseEntry.FindFirst() then begin
                        TempWarehouseEntry."Qty. (Base)" += WarehouseEntry."Qty. (Base)";
                        TempWarehouseEntry.Modify();
                    end else begin
                        TempWarehouseEntry := WarehouseEntry;
                        TempWarehouseEntry.Insert();
                    end;
                until WarehouseEntry.Next() = 0;
        until TempLotNoInfo.Next() = 0;

        LineNo := 0;
        EntryNo := 0;

        TempWarehouseEntry.Reset();
        if TempWarehouseEntry.FindFirst() then
            repeat
                if TempWarehouseEntry."Qty. (Base)" > 0 then begin
                    Clear(TempWhseJnlLine);
                    TempWhseJnlLine.Init();
                    TempWhseJnlLine."Journal Template Name" := TempWhseJnlLine2."Journal Template Name";
                    TempWhseJnlLine."Journal Batch Name" := TempWhseJnlLine2."Journal Batch Name";
                    LineNo += 10000;
                    TempWhseJnlLine."Line No." := LineNo;
                    TempWhseJnlLine."Registering Date" := WorkDate();
                    //if TOTestOrder."Document No." <> '' then
                    //    TempWhseJnlLine."Whse. Document No." := TOTestOrder."Document No."
                    //else
                    TempWhseJnlLine."Whse. Document No." := TOTestOrder."Test Order No.";

                    WhseJnlTemplate.Get(TempWhseJnlLine."Journal Template Name");
                    TempWhseJnlLine."Source Code" := WhseJnlTemplate."Source Code";

                    TempWhseJnlLine."Location Code" := TempWarehouseEntry."Location Code";
                    if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then begin
                        //TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::"Positive Adjmt.");
                        TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::"Negative Adjmt.");
                        Location.Get(TempWarehouseEntry."Location Code");
                        GetBin(Location.Code, Location."Adjustment Bin Code");
                        TempWhseJnlLine."From Zone Code" := Bin."Zone Code";
                        TempWhseJnlLine."From Bin Code" := Bin.Code;
                        TempWhseJnlLine."From Bin Type Code" := Bin."Bin Type Code";
                        TempWhseJnlLine.Validate("Zone Code", TempWarehouseEntry."Zone Code");
                        TempWhseJnlLine.Validate("Bin Code", TempWarehouseEntry."Bin Code");
                    end else begin
                        TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::Movement);
                        TempWhseJnlLine."From Zone Code" := TempWarehouseEntry."Zone Code";
                        TempWhseJnlLine."From Bin Code" := TempWarehouseEntry."Bin Code";
                        TempWhseJnlLine."From Bin Type Code" := GetBinType(TempWhseJnlLine."Location Code", TempWhseJnlLine."From Bin Code", TempWhseJnlLine."Journal Template Name");
                        TempWhseJnlLine."To Zone Code" := TempWarehouseEntry."Zone Code";
                        TempWhseJnlLine."To Bin Code" := TempWarehouseEntry."Bin Code";
                    end;

                    TempWhseJnlLine."User ID" := UserIDCode;
                    TempWhseJnlLine.Validate("Item No.", TempWarehouseEntry."Item No.");
                    TempWhseJnlLine.Validate("Variant Code", TempWarehouseEntry."Variant Code");
                    TempWhseJnlLine.Validate("Lot No.", TOTestOrder."Lot No.");
                    if TOTestOrder.PostLotNo() <> TOTestOrder."Lot No." then
                        TempWhseJnlLine.Validate("New Lot No.", TOTestOrder."New Lot No.");

                    if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then
                        TempWhseJnlLine.Validate("Qty. (Base)", -TempWarehouseEntry."Qty. (Base)")
                    else
                        TempWhseJnlLine.Validate(Quantity, TempWarehouseEntry."Qty. (Base)");

                    //TempWhseJnlLine."Reason Code" := TOTestOrder."Reason Code";
                    if TempWhseJnlLine.Insert(true) then;

                    EntryNo += 1;
                    Clear(TempWhseItemTrackingLine);
                    TempWhseItemTrackingLine.Init();
                    TempWhseItemTrackingLine."Entry No." := EntryNo;
                    TempWhseItemTrackingLine."Item No." := TempWhseJnlLine."Item No.";
                    TempWhseItemTrackingLine."Variant Code" := TempWhseJnlLine."Variant Code";
                    TempWhseItemTrackingLine."Location Code" := TempWhseJnlLine."Location Code";
                    TempWhseItemTrackingLine.Validate("Quantity (Base)", TempWarehouseEntry."Qty. (Base)");
                    TempWhseItemTrackingLine."Source Type" := Database::"Warehouse Journal Line";
                    TempWhseItemTrackingLine."Source ID" := TempWhseJnlLine."Journal Batch Name";
                    TempWhseItemTrackingLine."Source Batch Name" := TempWhseJnlLine."Journal Template Name";
                    TempWhseItemTrackingLine."Source Ref. No." := TempWhseJnlLine."Line No.";
                    TempWhseItemTrackingLine.Validate("Lot No.", TOTestOrder."Lot No.");
                    TempWhseItemTrackingLine."Tracking Status PROF" := LotNoInfo."Lot Status PROF";
                    TempWhseItemTrackingLine."Expiration Date" := TOTestOrder."Expiration Date";
                    TempWhseItemTrackingLine."Retest Date PROF" := RetestDate;
                    TempWhseItemTrackingLine."Sales Expiration Date PROF" := SalesExpirationDate;
                    TempWhseItemTrackingLine."Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
                    if TOTestorder."Order Type" <> TOTestorder."Order Type"::"Test Order" then begin
                        if TOTestOrder."New Expiration Date" <> 0D then
                            TempWhseItemTrackingLine."New Expiration Date" := TOTestOrder."New Expiration Date"
                        else
                            TempWhseItemTrackingLine."New Expiration Date" := TOTestOrder."Expiration Date";
                        if TOTestOrder."New Vendor Lot No." <> '' then
                            TempWhseItemTrackingLine."New Vendor Lot No. PROF" := TOTestOrder."New Vendor Lot No."
                        else
                            TempWhseItemTrackingLine."New Vendor Lot No. PROF" := TOTestOrder."Vendor Lot No.";
                        TempWhseItemTrackingLine."New Lot No." := TOTestOrder.PostLotNo();
                    end;
                    if TempWhseItemTrackingLine.Insert(true) then;
                end;
            until TempWarehouseEntry.Next() = 0;

        if not TempWhseJnlLine.FindSet() then
            exit;

        EntryNo2 := 0;
        repeat
            TempWhseItemTrackingLine.SetRange("Item No.", TempWhseJnlLine."Item No.");
            TempWhseItemTrackingLine.SetRange("Variant Code", TempWhseJnlLine."Variant Code");
            TempWhseItemTrackingLine.SetRange("Source Ref. No.", TempWhseJnlLine."Line No.");
            if TempWhseItemTrackingLine.FindSet() then
                repeat
                    EntryNo2 += 1;
                    TempWhseTrackingSpecification.TransferFields(TempWhseItemTrackingLine);
                    TempWhseTrackingSpecification."Entry No." := EntryNo2;
                    TempWhseTrackingSpecification."Quantity actual Handled (Base)" := TempWhseTrackingSpecification."Quantity (Base)";
                    if TempWhseTrackingSpecification.Insert(false) then;
                until TempWhseItemTrackingLine.Next() = 0;

            ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseTrackingSpecification, false);
            if TempWhseJnlLine2.FindSet() then
                repeat
                    if not (NewLotNoInfo."Item No." in ['', TempWhseJnlLine2."Item No."]) then
                        if not NewBulkLotNoInfo.Get(TempWhseJnlLine2."Item No.", NewLotNoInfo."Variant Code", NewLotNoInfo."Lot No.") then begin
                            TempLotNoInfo.Get(TempWhseJnlLine2."Item No.", NewLotNoInfo."Variant Code", TOTestOrder."Lot No.");
                            NewBulkLotNoInfo := NewLotNoInfo;
                            NewBulkLotNoInfo."Item No." := TempLotNoInfo."Item No.";
                            NewBulkLotNoInfo."Original Lot No. PROF" := TempLotNoInfo."Original Lot No. PROF";
                            NewBulkLotNoInfo."Original Expiration Date PROF" := TempLotNoInfo."Original Expiration Date PROF";
                            if NewBulkLotNoInfo.Insert(true) then;
                            TrackingNoStatusEntry.DoInsert(NewBulkLotNoInfo, NewBulkLotNoInfo."Test Order No. PROF", UserIDCode, false, false, true);
                        end;
                    WhseJnlRegisterLine.Run(TempWhseJnlLine2);
                until TempWhseJnlLine2.Next() = 0;

            if not TempWhseTrackingSpecification.IsEmpty() then
                TempWhseTrackingSpecification.DeleteAll();
        until TempWhseJnlLine.Next() = 0;
    end;

    Local procedure WarehouseReclassificationSN(var TOTestOrder: Record "TO Test Order PROF"; var SerialNoInfo: Record "Serial No. Information"; OrgLotStatus: Enum "TO Lot Status PROF"; UserIDCode: Code[50])
    var
        NewSerialNoInfo: Record "Serial No. Information";
        NewBulkSerialNoInfo: Record "Serial No. Information";
        TempSerialNoInfo: Record "Serial No. Information" Temporary;
        Item: Record Item;
        Location: Record Location;
        WarehouseEntry: Record "Warehouse Entry";
        TempWarehouseEntry: Record "Warehouse Entry" temporary;
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        TempWhseItemTrackingLine: Record "Whse. Item Tracking Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        TOSetup: Record "TO Setup PROF";
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        UsageDecision: Record "TO Usage Decision PROF";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        LineNo: Integer;
        EntryNo: Integer;
        EntryNo2: Integer;
        RetestDate: Date;
        SalesExpirationDate: Date;
    begin
        if UsageDecision.Get(TOTestOrder."Usage Decision") then;

        if OrgLotStatus <> TOTestOrder."Tracking Status"::"Not Tested" then
            exit;
        if SerialNoInfo.Blocked then
            if GuiAllowed then
                SerialNoInfo.FieldError(Blocked)
            else
                exit;

        if SerialNoInfo."Serial No." <> TOTestOrder."Serial No." then
            if GuiAllowed then
                SerialNoInfo.TestField("Serial No.", TOTestOrder."Serial No.")
            else
                exit;

        if TOTestOrder."Order Type" = TOTestOrder."Order Type"::"Test Order" then begin
            if TOTestOrder.Quantity = 0 then
                if GuiAllowed then
                    TOTestOrder.FieldError(Quantity)
                else
                    exit;

            if TOTestOrder."Bin Code" = '' then
                if GuiAllowed then
                    TOTestOrder.TestField("Bin Code")
                else
                    exit;
        end else
            if UsageDecision.Code <> '' then begin
                if (TOTestOrder."New Serial No." = '') and not UsageDecision."Not Upd. SerialNo & Expir Date" then
                    if GuiAllowed then
                        TOTestOrder.FieldError("New Serial No.")
                    else
                        exit;

                if (TOTestOrder."New Expiration Date" = 0D) and not UsageDecision."Not Upd. SerialNo & Expir Date" then
                    if GuiAllowed then
                        TOTestOrder.FieldError("New Expiration Date")
                    else
                        exit;
            end;


        if Item.Get(TOTestOrder."Item No.") then;
        RetestDate := TOTestOrder."Retest Date";
        SalesExpirationDate := TOTestOrder."Sales Expiration Date";
        if TOTestOrder.PostSerialNo() <> TOTestOrder."Serial No." then
            if NewSerialNoInfo.Get(SerialNoInfo."Item No.", SerialNoInfo."Variant Code", TOTestOrder."New Serial No.") then begin
                RetestDate := NewSerialNoInfo."Retest Date PROF";
                SalesExpirationDate := NewSerialNoInfo."Sales Expiration Date PROF";
            end else
                if not (TOTestOrder."New Expiration Date" in [0D, TOTestOrder."Expiration Date"]) then begin
                    if Format(Item."Retest Calculation PROF") <> '' then
                        RetestDate := CalcDate(Item."Retest Calculation PROF", TOTestOrder."New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        SalesExpirationDate := CalcDate(Item."Sales Expiration Calc. PROF", TOTestOrder."New Expiration Date");
                end;

        if TOSetup.Get() then;
        if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then begin
            if TOSetup."Warehouse Jnl. Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Jnl. Template Name")
                else
                    exit;

            if TOSetup."Warehouse Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Warehouse Journal Batch Name")
                else
                    exit;

            TempWhseJnlLine2."Journal Template Name" := TOSetup."Warehouse Jnl. Template Name";
            TempWhseJnlLine2."Journal Batch Name" := TOSetup."Warehouse Journal Batch Name";
        end else begin
            if TOSetup."Reclass Journal Template Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Template Name")
                else
                    exit;

            if TOSetup."Reclass Journal Batch Name" = '' then
                if GuiAllowed then
                    TOSetup.TestField("Reclass Journal Batch Name")
                else
                    exit;

            TempWhseJnlLine2."Journal Template Name" := TOSetup."Reclass Journal Template Name";
            TempWhseJnlLine2."Journal Batch Name" := TOSetup."Reclass Journal Batch Name";
        end;

        if not TempWarehouseEntry.IsEmpty() then
            TempWarehouseEntry.DeleteAll();
        Clear(TempWarehouseEntry);

        //  GetTempBulkItemLotNoInfosFromLotNoInfo(LotNoInfo, TOTestOrder."Local Impact", false, TempLotNoInfo);
        if not TempSerialNoInfo.FindSet() then
            exit;

        WarehouseEntry.SetCurrentKey("Item No.", "Serial No.", "Bin Code");
        WarehouseEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
        repeat
            WarehouseEntry.SetRange("Item No.", TempSerialNoInfo."Item No.");
            if WarehouseEntry.FindSet() then
                repeat
                    TempWarehouseEntry.SetRange("Item No.", WarehouseEntry."Item No.");
                    TempWarehouseEntry.SetRange("Variant Code", WarehouseEntry."Variant Code");
                    TempWarehouseEntry.SetRange("Serial No.", WarehouseEntry."Serial No.");
                    TempWarehouseEntry.SetRange("Zone Code", WarehouseEntry."Zone Code");
                    TempWarehouseEntry.SetRange("Bin Code", WarehouseEntry."Bin Code");
                    TempWarehouseEntry.SetRange("Location Code", WarehouseEntry."Location Code");
                    TempWarehouseEntry.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                    TempWarehouseEntry.SetRange("Bin Type Code", WarehouseEntry."Bin Type Code");
                    if TempWarehouseEntry.FindFirst() then begin
                        TempWarehouseEntry."Qty. (Base)" += WarehouseEntry."Qty. (Base)";
                        TempWarehouseEntry.Modify();
                    end else begin
                        TempWarehouseEntry := WarehouseEntry;
                        TempWarehouseEntry.Insert();
                    end;
                until WarehouseEntry.Next() = 0;
        until TempSerialNoInfo.Next() = 0;

        LineNo := 0;
        EntryNo := 0;

        TempWarehouseEntry.Reset();
        if TempWarehouseEntry.FindFirst() then
            repeat
                if TempWarehouseEntry."Qty. (Base)" > 0 then begin
                    Clear(TempWhseJnlLine);
                    TempWhseJnlLine.Init();
                    TempWhseJnlLine."Journal Template Name" := TempWhseJnlLine2."Journal Template Name";
                    TempWhseJnlLine."Journal Batch Name" := TempWhseJnlLine2."Journal Batch Name";
                    LineNo += 10000;
                    TempWhseJnlLine."Line No." := LineNo;
                    TempWhseJnlLine."Registering Date" := WorkDate();
                    //if TOTestOrder."Document No." <> '' then
                    //    TempWhseJnlLine."Whse. Document No." := TOTestOrder."Document No."
                    //else
                    TempWhseJnlLine."Whse. Document No." := TOTestOrder."Test Order No.";

                    WhseJnlTemplate.Get(TempWhseJnlLine."Journal Template Name");
                    TempWhseJnlLine."Source Code" := WhseJnlTemplate."Source Code";

                    TempWhseJnlLine."Location Code" := TempWarehouseEntry."Location Code";
                    if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then begin
                        //TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::"Positive Adjmt.");
                        TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::"Negative Adjmt.");
                        Location.Get(TempWarehouseEntry."Location Code");
                        GetBin(Location.Code, Location."Adjustment Bin Code");
                        TempWhseJnlLine."From Zone Code" := Bin."Zone Code";
                        TempWhseJnlLine."From Bin Code" := Bin.Code;
                        TempWhseJnlLine."From Bin Type Code" := Bin."Bin Type Code";
                        TempWhseJnlLine.Validate("Zone Code", TempWarehouseEntry."Zone Code");
                        TempWhseJnlLine.Validate("Bin Code", TempWarehouseEntry."Bin Code");
                    end else begin
                        TempWhseJnlLine.Validate("Entry Type", TempWhseJnlLine."Entry Type"::Movement);
                        TempWhseJnlLine."From Zone Code" := TempWarehouseEntry."Zone Code";
                        TempWhseJnlLine."From Bin Code" := TempWarehouseEntry."Bin Code";
                        TempWhseJnlLine."From Bin Type Code" := GetBinType(TempWhseJnlLine."Location Code", TempWhseJnlLine."From Bin Code", TempWhseJnlLine."Journal Template Name");
                        TempWhseJnlLine."To Zone Code" := TempWarehouseEntry."Zone Code";
                        TempWhseJnlLine."To Bin Code" := TempWarehouseEntry."Bin Code";
                    end;

                    TempWhseJnlLine."User ID" := UserIDCode;
                    TempWhseJnlLine.Validate("Item No.", TempWarehouseEntry."Item No.");
                    TempWhseJnlLine.Validate("Variant Code", TempWarehouseEntry."Variant Code");
                    TempWhseJnlLine.Validate("Serial No.", TOTestOrder."Serial No.");
                    if TOTestOrder.PostSerialNo() <> TOTestOrder."Serial No." then
                        TempWhseJnlLine.Validate("New Serial No.", TOTestOrder."New Serial No.");

                    if TOTestorder."Order Type" = TOTestorder."Order Type"::"Test Order" then
                        TempWhseJnlLine.Validate("Qty. (Base)", -TempWarehouseEntry."Qty. (Base)")
                    else
                        TempWhseJnlLine.Validate(Quantity, TempWarehouseEntry."Qty. (Base)");

                    //TempWhseJnlLine."Reason Code" := TOTestOrder."Reason Code";
                    if TempWhseJnlLine.Insert(true) then;

                    EntryNo += 1;
                    Clear(TempWhseItemTrackingLine);
                    TempWhseItemTrackingLine.Init();
                    TempWhseItemTrackingLine."Entry No." := EntryNo;
                    TempWhseItemTrackingLine."Item No." := TempWhseJnlLine."Item No.";
                    TempWhseItemTrackingLine."Variant Code" := TempWhseJnlLine."Variant Code";
                    TempWhseItemTrackingLine."Location Code" := TempWhseJnlLine."Location Code";
                    TempWhseItemTrackingLine.Validate("Quantity (Base)", TempWarehouseEntry."Qty. (Base)");
                    TempWhseItemTrackingLine."Source Type" := Database::"Warehouse Journal Line";
                    TempWhseItemTrackingLine."Source ID" := TempWhseJnlLine."Journal Batch Name";
                    TempWhseItemTrackingLine."Source Batch Name" := TempWhseJnlLine."Journal Template Name";
                    TempWhseItemTrackingLine."Source Ref. No." := TempWhseJnlLine."Line No.";
                    TempWhseItemTrackingLine.Validate("Serial No.", TOTestOrder."Serial No.");
                    TempWhseItemTrackingLine."Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
                    TempWhseItemTrackingLine."Expiration Date" := TOTestOrder."Expiration Date";
                    TempWhseItemTrackingLine."Retest Date PROF" := RetestDate;
                    TempWhseItemTrackingLine."Sales Expiration Date PROF" := SalesExpirationDate;
                    TempWhseItemTrackingLine."Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                    if TOTestorder."Order Type" <> TOTestorder."Order Type"::"Test Order" then begin
                        if TOTestOrder."New Expiration Date" <> 0D then
                            TempWhseItemTrackingLine."New Expiration Date" := TOTestOrder."New Expiration Date"
                        else
                            TempWhseItemTrackingLine."New Expiration Date" := TOTestOrder."Expiration Date";
                        if TOTestOrder."New Vendor Serial No." <> '' then
                            TempWhseItemTrackingLine."New Vendor Serial No. PROF" := TOTestOrder."New Vendor Serial No."
                        else
                            TempWhseItemTrackingLine."New Vendor Serial No. PROF" := TOTestOrder."Vendor Serial No.";
                        TempWhseItemTrackingLine."New Serial No." := TOTestOrder.PostSerialNo();
                    end;
                    if TempWhseItemTrackingLine.Insert(true) then;
                end;
            until TempWarehouseEntry.Next() = 0;

        if not TempWhseJnlLine.FindSet() then
            exit;

        EntryNo2 := 0;
        repeat
            TempWhseItemTrackingLine.SetRange("Item No.", TempWhseJnlLine."Item No.");
            TempWhseItemTrackingLine.SetRange("Variant Code", TempWhseJnlLine."Variant Code");
            TempWhseItemTrackingLine.SetRange("Source Ref. No.", TempWhseJnlLine."Line No.");
            if TempWhseItemTrackingLine.FindSet() then
                repeat
                    EntryNo2 += 1;
                    TempWhseTrackingSpecification.TransferFields(TempWhseItemTrackingLine);
                    TempWhseTrackingSpecification."Entry No." := EntryNo2;
                    TempWhseTrackingSpecification."Quantity actual Handled (Base)" := TempWhseTrackingSpecification."Quantity (Base)";
                    if TempWhseTrackingSpecification.Insert(false) then;
                until TempWhseItemTrackingLine.Next() = 0;

            ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseTrackingSpecification, false);
            if TempWhseJnlLine2.FindSet() then
                repeat
                    if not (NewSerialNoInfo."Item No." in ['', TempWhseJnlLine2."Item No."]) then
                        if not NewBulkSerialNoInfo.Get(TempWhseJnlLine2."Item No.", NewSerialNoInfo."Variant Code", NewSerialNoInfo."Serial No.") then begin
                            TempSerialNoInfo.Get(TempWhseJnlLine2."Item No.", NewSerialNoInfo."Variant Code", TOTestOrder."Serial No.");
                            NewBulkSerialNoInfo := NewSerialNoInfo;
                            NewBulkSerialNoInfo."Item No." := TempSerialNoInfo."Item No.";
                            NewBulkSerialNoInfo."Original Serial No. PROF" := TempSerialNoInfo."Original Serial No. PROF";
                            NewBulkSerialNoInfo."Original Expiration Date PROF" := TempSerialNoInfo."Original Expiration Date PROF";
                            if NewBulkSerialNoInfo.Insert(true) then;
                            TrackingNoStatusEntry.DoInsertSN(NewBulkSerialNoInfo, NewBulkSerialNoInfo."Test Order No. PROF", UserIDCode, false, false, true);
                        end;
                    WhseJnlRegisterLine.Run(TempWhseJnlLine2);
                until TempWhseJnlLine2.Next() = 0;

            if not TempWhseTrackingSpecification.IsEmpty() then
                TempWhseTrackingSpecification.DeleteAll();
        until TempWhseJnlLine.Next() = 0;
    end;

    local procedure PostItemJrnlTransfer(var TOTestOrder: Record "TO Test Order PROF"; OrgLotStatus: Enum "TO Lot Status PROF"; PostingDate: Date; QtyToPost: Decimal; ItemNo: Code[20]; VariantCode: Code[10]; Blocked: Boolean)
    var
        TOSetup: Record "TO Setup PROF";
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        NewLotNoInfo: Record "Lot No. Information";
        NewSerialNoInfo: Record "Serial No. Information";
        UsageDecision: Record "TO Usage Decision PROF";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        DimensionMgt: Codeunit DimensionManagement;
        DimSetID: array[10] of Integer;
        SalesExpirationDate: Date;
    begin
        if QtyToPost <= 0 then
            exit;
        if TOTestOrder."Item No." = '' then
            exit;
        if Item.Get(ItemNo) then;

        if TOSetup.Get() then;

        if TOSetup."Test Order Source Code" = '' then
            if GuiAllowed then
                TOSetup.TestField("Test Order Source Code")
            else
                exit;

        if TOSetup."Reclass Journal Template Name" = '' then
            if GuiAllowed then
                TOSetup.TestField("Reclass Journal Template Name")
            else
                exit;

        if TOSetup."Reclass Journal Batch Name" = '' then
            if GuiAllowed then
                TOSetup.TestField("Reclass Journal Batch Name")
            else
                exit;
        ItemNo := '';
        ItemJnlLine.Init();
        ItemJnlLine."Document No." := TOTestOrder."Test Order No.";
        ItemJnlLine."Document Line No." := 0;
        ItemJnlLine."Journal Template Name" := TOSetup."Reclass Journal Template Name";
        ItemJnlLine."Journal Batch Name" := TOSetup."Reclass Journal Batch Name";
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Transfer);
        ItemJnlLine.Validate("Posting Date", PostingDate);
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine."Variant Code" := VariantCode;
        if ItemJnlLine."Unit of Measure Code" <> TOTestOrder."Unit of Measure Code" then
            ItemJnlLine.Validate("Unit of Measure Code", TOTestOrder."Unit of Measure Code"); // Setting also "Qty. per Unit of Measure"
        ItemJnlLine."External Document No." := '';
        ItemJnlLine.Description := Item.Description;
        DimSetID[1] := ItemJnlLine."Dimension Set ID";
        DimSetID[2] := TOTestOrder."Dimension Set ID";
        ItemJnlLine."Shortcut Dimension 1 Code" := Item."Global Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := DimensionMgt.GetCombinedDimensionSetID(DimSetID, ItemJnlLine."Shortcut Dimension 1 Code", ItemJnlLine."Shortcut Dimension 2 Code");
        ItemJnlLine."Location Code" := TOTestOrder."Location Code"; //"Transfer-from Code";
        ItemJnlLine."Vendor Lot No. PROF" := TOTestOrder."Vendor Lot No.";
        ItemJnlLine."Vendor Serial No. PROF" := TOTestOrder."Vendor Serial No.";
        ItemJnlLine."Retest Date PROF" := TOTestOrder."Retest Date";
        ItemJnlLine."Sales Expiration Date PROF" := TOTestOrder."Sales Expiration Date";
        if TOTestOrder."Order Type" <> TOTestOrder."Order Type"::"Manual Order" then
            ItemJnlLine."Country/Region of Origin PROF" := TOTestOrder."Country/Region of Origin"
        else
            ItemJnlLine."Country/Region of Origin PROF" := TOTestOrder."New Country/Region of Origin";

        ItemJnlLine.Quantity := QtyToPost;
        ItemJnlLine."Invoiced Quantity" := ItemJnlLine.Quantity;
        ItemJnlLine."Quantity (Base)" :=
          Round(ItemJnlLine.Quantity * ItemJnlLine."Qty. per Unit of Measure", 0.00001);
        ItemJnlLine."Invoiced Qty. (Base)" := ItemJnlLine."Quantity (Base)";

        ItemJnlLine."Source Code" := TOSetup."Test Order Source Code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ItemJnlLine."Country/Region Code" := '';
        ItemJnlLine."Transaction Type" := '';
        ItemJnlLine."Transport Method" := '';
        ItemJnlLine."Entry/Exit Point" := '';
        ItemJnlLine.Area := '';
        ItemJnlLine."Transaction Specification" := '';
        ItemJnlLine.Validate("Item Category Code", Item."Item Category Code");
        ItemJnlLine."Line No." := 0;

        if NewLotNoInfo.Get(ItemNo, VariantCode, TOTestOrder."New Lot No.") then
            SalesExpirationDate := NewLotNoInfo."Sales Expiration Date PROF"
        else
            if NewSerialNoInfo.Get(ItemNo, VariantCode, TOTestOrder."New Serial No.") then
                SalesExpirationDate := NewSerialNoInfo."Sales Expiration Date PROF"
            else
                SalesExpirationDate := TOTestOrder."Sales Expiration Date";

        ItemJnlLine."New Shortcut Dimension 1 Code" := Item."Global Dimension 1 Code";
        ItemJnlLine."New Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        ItemJnlLine."New Location Code" := TOTestOrder."Location Code"; //"Transfer-to Code";
        ItemJnlLine."New Vendor Lot No. PROF" := TOTestOrder."New Vendor Lot No.";
        ItemJnlLine."New Vendor Serial No. PROF" := TOTestOrder."New Vendor Serial No.";
        if not (TOTestOrder."New Expiration Date" in [0D, TOTestOrder."Expiration Date"]) then begin
            if NewLotNoInfo."Item No." <> '' then
                ItemJnlLine."New Retest Date PROF" := NewLotNoInfo."Retest Date PROF"
            else
                if NewSerialNoInfo."Item No." <> '' then
                    ItemJnlLine."New Retest Date PROF" := NewSerialNoInfo."Retest Date PROF"
                else
                    if Format(Item."Retest Calculation PROF") <> '' then
                        ItemJnlLine."New Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", TOTestOrder."New Expiration Date")
                    else
                        ItemJnlLine."New Retest Date PROF" := 0D;
        end else
            if TOTestOrder."New Expiration Date" = TOTestOrder."Expiration Date" then
                ItemJnlLine."New Retest Date PROF" := TOTestOrder."Retest Date"
            else
                ItemJnlLine."New Retest Date PROF" := 0D;

        // Assign Item tracking Info
        ItemJnlLine."Blocked PROF" := Blocked;
        if UsageDecision.Get(TOTestOrder."Usage Decision") then;
        ItemJnlLine."New Blocked PROF" := UsageDecision."Block Tracking No.";
        ItemJnlLine."Tracking Status PROF" := OrgLotStatus;
        ItemJnlLine."Tracking Status (New) PROF" := TOTestOrder."Tracking Status";



        AddItemTrkgToItemJnlLine(ItemJnlLine, TOTestOrder."Serial No.", TOTestOrder."Lot No.", 0D);

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    internal procedure AddItemTrkgToItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; SerialNo: Code[50]; LotNo: Code[50]; NewExpirationDate: Date)
    var
        TempReservationEntryBuffer: Record "Reservation Entry" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OrderLineNo: Integer;
    begin
        if ItemJournalLine."Order Type" = ItemJournalLine."Order Type"::Production then
            OrderLineNo := ItemJournalLine."Order Line No.";
        TempReservationEntryBuffer."Serial No." := SerialNo;
        TempReservationEntryBuffer."Lot No." := LotNo;
        CreateReservEntry.CreateReservEntryFor(Database::"Item Journal Line", ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                                               ItemJournalLine."Journal Batch Name", OrderLineNo, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
                                               Abs(ItemJournalLine.Quantity), Abs(ItemJournalLine."Quantity (Base)"), TempReservationEntryBuffer);

        CreateReservEntry.SetDates(ItemJournalLine."Warranty Date", ItemJournalLine."Expiration Date");

        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer then begin
            CreateReservEntry.SetNewTrackingFromItemJnlLine(ItemJournalLine);
            CreateReservEntry.SetNewExpirationDate(NewExpirationDate);
        end;
        if LotNo <> '' then
            TOEventsSingleInstance.SetAdditionalTrackingInfo(ItemJournalLine."Retest Date PROF", ItemJournalLine."New Retest Date PROF", ItemJournalLine."Sales Expiration Date PROF", ItemJournalLine."Vendor Lot No. PROF", ItemJournalLine."New Vendor Lot No. PROF", ItemJournalLine."Country/Region of Origin PROF")
        else
            if SerialNo <> '' then
                TOEventsSingleInstance.SetAdditionalTrackingInfo(ItemJournalLine."Retest Date PROF", ItemJournalLine."New Retest Date PROF", ItemJournalLine."Sales Expiration Date PROF", ItemJournalLine."Vendor Serial No. PROF", ItemJournalLine."New Vendor Serial No. PROF", ItemJournalLine."Country/Region of Origin PROF");

        CreateReservEntry.CreateEntry(
          ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."Location Code", ItemJournalLine.Description,
          0D, 0D, 0, TempReservationEntryBuffer."Reservation Status"::Prospect);
    end;



    local procedure SetLotBlocking(var LotNoInfo: Record "Lot No. Information"; NewBlocked: Boolean);
    begin
        if LotNoInfo.Blocked = NewBlocked then
            exit;
        LotNoInfo.Blocked := NewBlocked;
        LotNoInfo.Modify();
    end;

    local procedure SetSerialBlocking(var SerialNoInfo: Record "Serial No. Information"; NewBlocked: Boolean);
    begin
        if SerialNoInfo.Blocked = NewBlocked then
            exit;
        SerialNoInfo.Blocked := NewBlocked;
        SerialNoInfo.Modify();
    end;

    local procedure GetLotQtyOnBin(ItemNo: Code[20]; LotNo: Code[50]; BinCode: Code[20]): Decimal
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.Reset();
        WarehouseEntry.SetCurrentKey("Item No.", "Lot No.", "Bin Code");
        WarehouseEntry.SetRange("Item No.", ItemNo);
        WarehouseEntry.SetRange("Lot No.", LotNo);
        WarehouseEntry.SetRange("Bin Code", BinCode);
        WarehouseEntry.CalcSums(WarehouseEntry."Qty. (Base)");
        exit(WarehouseEntry."Qty. (Base)");
    end;

    local procedure GetSerialQtyOnBin(ItemNo: Code[20]; SerialNo: Code[50]; BinCode: Code[20]): Decimal
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.Reset();
        WarehouseEntry.SetCurrentKey("Item No.", "Serial No.", "Bin Code");
        WarehouseEntry.SetRange("Item No.", ItemNo);
        WarehouseEntry.SetRange("Serial No.", SerialNo);
        WarehouseEntry.SetRange("Bin Code", BinCode);
        WarehouseEntry.CalcSums(WarehouseEntry."Qty. (Base)");
        exit(WarehouseEntry."Qty. (Base)");
    end;

    local procedure GetBinType(LocationCode: Code[10]; BinCode: Code[20]; JournalTemplateName: Code[10]): Code[10];
    begin
        GetBin(LocationCode, BinCode);
        WhseJnlTemplate.Get(JournalTemplateName);
        if WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification then
            if Bin."Bin Type Code" <> '' then
                if BinType.Get(Bin."Bin Type Code") then
                    BinType.TestField(Receive, false);

        exit(Bin."Bin Type Code");
    end;

    local procedure GetBin(LocationCode: Code[10]; BinCode: Code[20]);
    begin
        if (LocationCode = '') or (BinCode = '') then
            Bin.Init()
        else
            if (Bin."Location Code" <> LocationCode) or (Bin.Code <> BinCode) then
                Bin.Get(LocationCode, BinCode);
    end;

    internal procedure CalcQtyReleasedForProduction(ItemNo: Code[20]): Decimal
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        AvailableBinQty: Decimal;
    begin
        AvailableBinQty := 0;
        LotNoInfo.Reset();
        LotNoInfo.SetRange("Item No.", ItemNo);
        LotNoInfo.SetRange(Blocked, false);
        // For now "Status" is not used // LotNoInfo.SetRange(Status, LotNoInfo.Status::"Released for production");
        if LotNoInfo.FindSet() then
            repeat
                LotNoInfo.CalcFields(Inventory);
                AvailableBinQty += LotNoInfo.Inventory;
            until LotNoInfo.Next() = 0
        else begin
            SerialNoInfo.Reset();
            SerialNoInfo.SetRange("Item No.", ItemNo);
            SerialNoInfo.SetRange(Blocked, false);
            if SerialNoInfo.FindSet() then
                repeat
                    SerialNoInfo.CalcFields(Inventory);
                    AvailableBinQty += SerialNoInfo.Inventory;
                until SerialNoInfo.Next() = 0;
        end;
        exit(AvailableBinQty);
    end;



    internal procedure QtyAvailableToPick(Item: Record Item; LotNoInfo: Record "Lot No. Information"; AvailableForProduction: Boolean; LotNo: Code[50]; var ZoneCode: Code[10]; var BinCode: Code[20]; var QtyAvailable: Decimal)
    var
        BinContent: Record "Bin Content";
        UsageDecision: Record "TO Usage Decision PROF";
        NoOfBinsWithContent: Integer;
        ApprovedForUse: Boolean;
    begin
        if UsageDecision.Get(LotNoInfo."Usage Decision PROF") then;
        case true of
            (not AvailableForProduction) and (LotNoInfo."Sales Expiration Date PROF" >= Today()) and
            (not LotNoInfo.Blocked) and (LotNoInfo."Lot Status PROF" = LotNoInfo."Lot Status PROF"::Approved) and
            (not LotNoInfo."Internal Use Only PROF"):
                ApprovedForUse := true;

            (AvailableForProduction) and (LotNoInfo."Expiration Date PROF" >= Today()) and (not LotNoInfo.Blocked) and ((LotNoInfo."Lot Status PROF" = LotNoInfo."Lot Status PROF"::Approved) or ((LotNoInfo."Lot Status PROF" = LotNoInfo."Lot Status PROF"::"Not Tested") and (Item."Approved for Internal use PROF"))):
                ApprovedForUse := true;

            (AvailableForProduction) and (LotNoInfo."Expiration Date PROF" >= Today()) and (UsageDecision."Consume Blocked Lot"):
                ApprovedForUse := true;
        end;

        BinContent.Reset();
        BinContent.SetCurrentkey("Item No.");
        BinContent.SetRange("Item No.", Item."No.");
        if LotNo <> '' then
            BinContent.SetFilter("Lot No. Filter", LotNo);
        BinContent.SetFilter("Location Code", BinContentFilter.GetFilter("Location Code"));
        BinContent.SetFilter("Zone Code", BinContentFilter.GetFilter("Zone Code"));
        BinContent.SetFilter("Bin Code", BinContentFilter.GetFilter("Bin Code"));
        if BinContent.FindSet() then begin
            NoOfBinsWithContent := 0;
            repeat
                BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)");
                if (BinContent."Quantity (Base)" <> 0) or (BinContent."Pick Quantity (Base)" <> 0) then begin
                    NoOfBinsWithContent += 1;
                    ZoneCode := BinContent."Zone Code";
                    BinCode := BinContent."Bin Code";
                    if (ApprovedForUse) and ((BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)") <> 0) then
                        if UseForPick(BinContent) then
                            QtyAvailable += (BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)");
                end;
            until BinContent.Next() = 0;

            if NoOfBinsWithContent > 1 then begin
                ZoneCode := '';
                BinCode := MultipleLbl;
            end;

            if QtyAvailable < 0 then
                QtyAvailable := 0;
        end;
    end;

    internal procedure QtyAvailableToPickSN(Item: Record Item; SerialNoInfo: Record "Serial No. Information"; AvailableForProduction: Boolean; SerialNo: Code[50]; var ZoneCode: Code[10]; var BinCode: Code[20]; var QtyAvailable: Decimal)
    var
        BinContent: Record "Bin Content";
        UsageDecision: Record "TO Usage Decision PROF";
        NoOfBinsWithContent: Integer;
        ApprovedForUse: Boolean;
    begin
        if UsageDecision.Get(SerialNoInfo."Usage Decision PROF") then;
        case true of
            (not AvailableForProduction) and (SerialNoInfo."Sales Expiration Date PROF" >= Today()) and
            (not SerialNoInfo.Blocked) and (SerialNoInfo."Serial Status PROF" = SerialNoInfo."Serial Status PROF"::Approved) and
            (not SerialNoInfo."Internal Use Only PROF"):
                ApprovedForUse := true;

            (AvailableForProduction) and (SerialNoInfo."Expiration Date PROF" >= Today()) and (not SerialNoInfo.Blocked) and ((SerialNoInfo."Serial Status PROF" = SerialNoInfo."Serial Status PROF"::Approved) or ((SerialNoInfo."Serial Status PROF" = SerialNoInfo."Serial Status PROF"::"Not Tested") and (Item."Approved for Internal use PROF"))):
                ApprovedForUse := true;

            (AvailableForProduction) and (SerialNoInfo."Expiration Date PROF" >= Today()) and (UsageDecision."Consume Blocked Lot"):
                ApprovedForUse := true;
        end;




        BinContent.Reset();
        BinContent.SetCurrentkey("Item No.");
        BinContent.SetRange("Item No.", Item."No.");
        if SerialNo <> '' then
            BinContent.SetFilter("Serial No. Filter", SerialNo);
        BinContent.SetFilter("Location Code", BinContentFilter.GetFilter("Location Code"));
        BinContent.SetFilter("Zone Code", BinContentFilter.GetFilter("Zone Code"));
        BinContent.SetFilter("Bin Code", BinContentFilter.GetFilter("Bin Code"));
        if BinContent.FindSet() then begin
            NoOfBinsWithContent := 0;
            repeat
                BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)");
                if (BinContent."Quantity (Base)" <> 0) or (BinContent."Pick Quantity (Base)" <> 0) then begin
                    NoOfBinsWithContent += 1;
                    ZoneCode := BinContent."Zone Code";
                    BinCode := BinContent."Bin Code";
                    if (ApprovedForUse) and ((BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)") <> 0) then
                        if UseForPick(BinContent) then
                            QtyAvailable += (BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)");
                end;
            until BinContent.Next() = 0;

            if NoOfBinsWithContent > 1 then begin
                ZoneCode := '';
                BinCode := MultipleLbl;
            end;

            if QtyAvailable < 0 then
                QtyAvailable := 0;
        end;
    end;



    internal procedure QtyAvailableToPickItem(Item: Record Item; AvailableForProduction: Boolean) QtyAvailable: Decimal
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        UsageDecision: Record "TO Usage Decision PROF";
        ZoneCode: Code[10];
        BinCode: Code[20];
        QtyAvailableLot: Decimal;
        QtyAvailableSerial: Decimal;
        UseLot: Boolean;
    begin
        QtyAvailable := 0;
        LotNoInfo.Reset();
        LotNoInfo.SetRange("Item No.", Item."No.");
        if AvailableForProduction then //begin
            LotNoInfo.SetFilter("Expiration Date PROF", '>=%1', WorkDate())
        //end 
        else begin
            LotNoInfo.SetFilter("Sales Expiration Date PROF", '>=%1', WorkDate());
            LotNoInfo.SetRange("Lot Status PROF", LotNoInfo."Lot Status PROF"::Approved);
            LotNoInfo.SetRange("Internal Use Only PROF", false);
        end;
        if LotNoInfo.FindSet() then
            repeat
                UseLot := true;

                if LotNoInfo.Blocked then begin
                    UseLot := false;
                    if AvailableForProduction then
                        if UsageDecision.Get(LotNoInfo."Usage Decision PROF") then
                            if UsageDecision."Consume Blocked Lot" then
                                UseLot := true;
                end;

                if UseLot then begin
                    QtyAvailableLot := 0;
                    QtyAvailableToPick(Item, LotNoInfo, AvailableForProduction, LotNoInfo."Lot No.", ZoneCode, BinCode, QtyAvailableLot);
                    QtyAvailable += QtyAvailableLot;
                end;
            until LotNoInfo.Next() = 0
        else begin
            QtyAvailable := 0;
            SerialNoInfo.Reset();
            SerialNoInfo.SetRange("Item No.", Item."No.");
            if AvailableForProduction then //begin
                SerialNoInfo.SetFilter("Expiration Date PROF", '>=%1', WorkDate())
            //end 
            else begin
                SerialNoInfo.SetFilter("Sales Expiration Date PROF", '>=%1', WorkDate());
                SerialNoInfo.SetRange("Serial Status PROF", SerialNoInfo."Serial Status PROF"::Approved);
                SerialNoInfo.SetRange("Internal Use Only PROF", false);
            end;
            if SerialNoInfo.FindSet() then
                repeat
                    UseLot := true;

                    if SerialNoInfo.Blocked then begin
                        UseLot := false;
                        if AvailableForProduction then
                            if UsageDecision.Get(SerialNoInfo."Usage Decision PROF") then
                                if UsageDecision."Consume Blocked Lot" then
                                    UseLot := true;
                    end;

                    if UseLot then begin
                        QtyAvailableSerial := 0;
                        QtyAvailableToPickSN(Item, SerialNoInfo, AvailableForProduction, SerialNoInfo."Serial No.", ZoneCode, BinCode, QtyAvailableSerial);
                        QtyAvailable += QtyAvailableSerial;
                    end;
                until SerialNoInfo.Next() = 0
        end;
        exit(QtyAvailable);
    end;


    local procedure UseForPick(FromBinContent: Record "Bin Content"): Boolean
    begin
        if FromBinContent."Block Movement" in [FromBinContent."Block Movement"::Outbound, FromBinContent."Block Movement"::All] then
            exit(false);

        GetBinType(FromBinContent."Bin Type Code");
        exit(BinType.Pick);
    end;

    local procedure GetBinType(BinTypeCode: Code[10])
    begin
        if BinTypeCode = '' then
            BinType.Init()
        else
            if BinType.Code <> BinTypeCode then
                BinType.Get(BinTypeCode);
    end;


    internal procedure SetBinFilterOnBinContent(var LotNoInfo: Record "Lot No. Information")
    begin
        BinContentFilter.SetFilter("Location Code", LotNoInfo.GetFilter("Location Filter"));
        BinContentFilter.SetFilter("Zone Code", LotNoInfo.GetFilter("Zone Filter PROF"));
        BinContentFilter.SetFilter("Bin Code", LotNoInfo.GetFilter("Bin Filter"));
    end;

    internal procedure SetBinFilterOnBinContentSN(var SerialNoInfo: Record "Serial No. Information")
    begin
        BinContentFilter.SetFilter("Location Code", SerialNoInfo.GetFilter("Location Filter"));
        BinContentFilter.SetFilter("Zone Code", SerialNoInfo.GetFilter("Zone Filter PROF"));
        BinContentFilter.SetFilter("Bin Code", SerialNoInfo.GetFilter("Bin Filter"));
    end;

    internal procedure GetLocationCode(UserIDCode: Code[50]; LocationFilter: Text; ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; ZoneCode: Code[10]; TryeFirstWithAdjustmentBinCodeNotBlank: Boolean): Code[10]
    var
        Location: Record Location;
        WhseWMSCue: Record "Warehouse WMS Cue";
        BinContent: Record "Bin Content";
    begin
        if LocationFilter <> '' then begin
            Location.Reset();
            Location.SetFilter("Code", LocationFilter);
            if TryeFirstWithAdjustmentBinCodeNotBlank then
                Location.SetFilter("Adjustment Bin Code", '<>%1', '');
            if Location.FindSet() then
                if Location.Next() = 0 then
                    exit(Location."Code");
        end;

        Location.Reset();
        Location.SetFilter("Code", WhseWMSCue.GetEmployeeLocation(UserIDCode));
        if TryeFirstWithAdjustmentBinCodeNotBlank then
            Location.SetFilter("Adjustment Bin Code", '<>%1', '');
        if Location.FindSet() then
            if Location.Next() = 0 then
                exit(Location."Code");

        BinContent.Reset();
        BinContent.SetRange("Item No.", ItemNo);
        BinContent.SetRange("Variant Code", VariantCode);
        BinContent.SetFilter("Lot No. Filter", LotNo);
        BinContent.SetFilter("Serial No. Filter", SerialNo);
        BinContent.SetFilter("Location Code", Location.GetFilter("Code"));
        BinContent.SetFilter("Zone Code", ZoneCode);
        if BinContent.FindFirst() then begin
            BinContent.FilterGroup(2);
            BinContent.SetFilter("Location Code", '<>%1', BinContent."Location Code");
            BinContent.FilterGroup(0);
            if BinContent.IsEmpty() then
                exit(BinContent."Location Code");
        end;

        if TryeFirstWithAdjustmentBinCodeNotBlank then
            exit(GetLocationCode(UserIDCode, LocationFilter, ItemNo, VariantCode, LotNo, SerialNo, ZoneCode, false));

        if UserIDCode <> CopyStr(UserId(), 1, 50) then
            exit(GetLocationCode(CopyStr(UserId(), 1, 50), LocationFilter, ItemNo, VariantCode, LotNo, SerialNo, ZoneCode, TryeFirstWithAdjustmentBinCodeNotBlank));

        Location.Reset();
        Location.SetRange("Directed Put-away and Pick", true);
        if Location.FindSet() then
            if Location.Next() = 0 then
                exit(Location."Code");

        exit('');
    end;


    internal procedure CreateLotNoInfo(var TOTestOrder: Record "TO Test Order PROF"; LotNo: Code[50]; RetestDate: Date; PostingDateTime: DateTime; SalesExpirationDate: Date; CountryCode: Code[10]; OriginalLotNo: Code[50]; OriginalExpirationDate: Date) DateTimeR: DateTime
    begin
        TOTestOrder.TestField("Test Order No.");
        DateTimeR := CreateLotNoInfo(TOTestOrder."Item No.", TOTestOrder."Variant Code", LotNo, TOTestOrder."New Expiration Date",
                                     TOTestOrder."New Vendor Lot No.", RetestDate, PostingDateTime, SalesExpirationDate, CountryCode,
                                     OriginalLotNo, OriginalExpirationDate, TOTestOrder."Tracking Status", TOTestOrder."Internal Use Only", TOTestOrder."Local Impact", TOTestOrder."Test Order No.");
    end;


    internal procedure CreateLotNoInfo(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ExpirationDate: Date; VendorLotNo: Code[50]; RetestDate: Date; PostingDateTime: DateTime; SalesExpirationDate: Date; CountryCode: Code[10]; OriginalLotNo: Code[50]; OriginalExpirationDate: Date; LotStatus: Enum "TO Lot Status PROF"; InternalUseOnly: Boolean;
                                                                                                                                                                                                                                                                                                          LocalImpact: Boolean;
                                                                                                                                                                                                                                                                                                          TestOrderNo: Code[20]): DateTime
    var
        LotNoInfo: Record "Lot No. Information";
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        TestOrder: Record "TO Test Order PROF";
        UsageDecision: Record "TO Usage Decision PROF";
        Item: Record Item;
        UsageDecicion: Record "TO Usage Decision PROF";
        EventSingleInstance: Codeunit "TO Events Single Instance PROF";
    begin
        if (ItemNo = '') or (LotNo = '') then
            exit(0DT);
        if LotNoInfo.Get(ItemNo, VariantCode, LotNo) then
            exit(0DT);


        LotNoInfo.Init();
        LotNoInfo."Item No." := ItemNo;
        LotNoInfo."Variant Code" := VariantCode;
        LotNoInfo."Lot No." := LotNo;
        LotNoInfo."Vendor Lot No. PROF" := VendorLotNo;
        LotNoInfo."Expiration Date PROF" := ExpirationDate;
        LotNoInfo."Retest Date PROF" := RetestDate;
        LotNoInfo."Sales Expiration Date PROF" := SalesExpirationDate;
        LotNoInfo."Country/Region of Origin PROF" := CountryCode;
        LotNoInfo."Original Lot No. PROF" := OriginalLotNo;
        LotNoInfo."Original Expiration Date PROF" := OriginalExpirationDate;
        LotNoInfo."Lot Status PROF" := LotStatus;
        LotNoInfo."Internal Use Only PROF" := InternalUseOnly;
        LotNoInfo."Local Impact PROF" := LocalImpact;

        if Item.Get(ItemNo) then begin
            if Item."QC Required PROF" then begin
                UsageDecicion.Reset();
                UsageDecicion.SetRange("Default Usage Decision", true);
                UsageDecicion.SetRange("Block Tracking No.", true);
                if UsageDecicion.FindFirst() then
                    LotNoInfo.Blocked := UsageDecicion."Block Tracking No.";
            end;


            if Item."QC Required PROF" and LotNoInfo.Blocked then begin
                EventSingleInstance.SetTempLotNoInformation(LotNoInfo);
                LotNoInfo.Blocked := false;
                // LotNoInfo.Modify();
            end;
            LotNoInfo.Description := Item.Description;
        end;

        // Add description field population



        if TestOrderNo <> '' then begin
            if LotNoInfo."Lot Status PROF" <> LotNoInfo."Lot Status PROF"::Approved then
                LotNoInfo."Test Order No. PROF" := TestOrderNo;
            if TestOrder.Get(TestOrderNo) then
                LotNoInfo."Usage Decision PROF" := TestOrder."Usage Decision";
            if UsageDecision.Get(TestOrder."Usage Decision") then
                LotNoInfo.Blocked := UsageDecision."Block Tracking No.";
        end;
        if LotNoInfo.Insert(true) then;
        TrackingNoStatusEntry.DoInsert(LotNoInfo, TestOrderNo, CopyStr(UserId, 1, MaxStrLen(TrackingNoStatusEntry."User ID")), false, false, true);

        exit(LotNoInfo."Creation Date Time PROF");
    end;


    internal procedure CreateSerialNoInfo(var TOTestOrder: Record "TO Test Order PROF"; SerialNo: Code[50]; RetestDate: Date; PostingDateTime: DateTime; SalesExpirationDate: Date; CountryCode: Code[10]; OriginalSerialNo: Code[50]; OriginalExpirationDate: Date) DateTimeR: DateTime
    begin
        TOTestOrder.TestField("Test Order No.");
        DateTimeR := CreateSerialNoInfo(TOTestOrder."Item No.", TOTestOrder."Variant Code", SerialNo, TOTestOrder."New Expiration Date",
                                     TOTestOrder."New Vendor Lot No.", RetestDate, PostingDateTime, SalesExpirationDate, CountryCode,
                                     OriginalSerialNo, OriginalExpirationDate, TOTestOrder."Tracking Status", TOTestOrder."Internal Use Only", TOTestOrder."Local Impact", TOTestOrder."Test Order No.");
    end;


    internal procedure CreateSerialNoInfo(ItemNo: Code[20]; VariantCode: Code[10]; SerialNo: Code[50]; ExpirationDate: Date; VendorSerialNo: Code[50]; RetestDate: Date; PostingDateTime: DateTime; SalesExpirationDate: Date; CountryCode: Code[10]; OriginalSerialNo: Code[50]; OriginalExpirationDate: Date; SerialStatus: Enum "TO Lot Status PROF"; InternalUseOnly: Boolean;
                                                                                                                                                                                                                                                                                                                                  LocalImpact: Boolean;
                                                                                                                                                                                                                                                                                                                                  TestOrderNo: Code[20]): DateTime
    var
        SerialNoInfo: Record "Serial No. Information";
        LotSerialNoStatusEntry: Record "TO Tracking No. Status PROF";
        TestOrder: Record "TO Test Order PROF";
        UsageDecision: Record "TO Usage Decision PROF";
        Item: Record Item;
        UsageDecicion: Record "TO Usage Decision PROF";
        EventSingleInstance: Codeunit "TO Events Single Instance PROF";
    begin
        if (ItemNo = '') or (SerialNo = '') then
            exit(0DT);
        if SerialNoInfo.Get(ItemNo, VariantCode, SerialNo) then
            exit(0DT);

        SerialNoInfo.Init();
        SerialNoInfo."Item No." := ItemNo;
        SerialNoInfo."Variant Code" := VariantCode;
        SerialNoInfo."Serial No." := SerialNo;
        SerialNoInfo."Vendor Serial No. PROF" := VendorSerialNo;
        SerialNoInfo."Expiration Date PROF" := ExpirationDate;
        SerialNoInfo."Retest Date PROF" := RetestDate;
        SerialNoInfo."Sales Expiration Date PROF" := SalesExpirationDate;
        SerialNoInfo."Country/Region of Origin PROF" := CountryCode;
        SerialNoInfo."Original Serial No. PROF" := OriginalSerialNo;
        SerialNoInfo."Original Expiration Date PROF" := OriginalExpirationDate;
        SerialNoInfo."Serial Status PROF" := SerialStatus;
        SerialNoInfo."Internal Use Only PROF" := InternalUseOnly;
        SerialNoInfo."Local Impact PROF" := LocalImpact;

        // Add description field population
        if Item.Get(ItemNo) then begin
            if Item."QC Required PROF" then begin
                UsageDecicion.Reset();
                UsageDecicion.SetRange("Default Usage Decision", true);
                UsageDecicion.SetRange("Block Tracking No.", true);
                if UsageDecicion.FindFirst() then
                    SerialNoInfo.Blocked := UsageDecicion."Block Tracking No.";
            end;

            if Item."QC Required PROF" and SerialNoInfo.Blocked then begin
                EventSingleInstance.SetTempSerialNoInformation(SerialNoInfo);
                SerialNoInfo.Blocked := false;
                // LotNoInfo.Modify();
            end;


            SerialNoInfo.Description := Item.Description;
        end;
        if TestOrderNo <> '' then begin
            if SerialNoInfo."Serial Status PROF" <> SerialNoInfo."Serial Status PROF"::Approved then
                SerialNoInfo."Test Order No. PROF" := TestOrderNo;
            if TestOrder.Get(TestOrderNo) then
                SerialNoInfo."Usage Decision PROF" := TestOrder."Usage Decision";
            if UsageDecision.Get(TestOrder."Usage Decision") then
                SerialNoInfo.Blocked := UsageDecision."Block Tracking No.";
        end;

        if SerialNoInfo.Insert(true) then;
        LotSerialNoStatusEntry.DoInsertSN(SerialNoInfo, TestOrderNo, CopyStr(UserId, 1, MaxStrLen(LotSerialNoStatusEntry."User ID")), false, false, true);

        exit(SerialNoInfo."Creation Date Time PROF");
    end;




    internal procedure LabelHasBeenPrinted(LotNoInfo: Record "Lot No. Information"): Boolean
    begin
        exit((LotNoInfo."No. Printed PROF" > 0) or (LotNoInfo."Last Printed Date PROF" <> 0D));
    end;

    internal procedure SerialInfoSetMissingItemTrackingInfo(var SerialNoInfo: Record "Serial No. Information"; DialogFieldCaptionText: Text): Boolean
    var
        Item: Record Item;
        LotSerialNoStatusEntry: Record "TO Tracking No. Status PROF";
        ItemTrackingCode: Record "Item Tracking Code";
        SerialNoStatusEntryUpdated: Boolean;
        KeyText: Text;
        ConfirmChangeQst: Label '%1 %2\Do you want to set the %3 ?', comment = '%1 = Table Caption Text, %2 = Serial No. Information Key Text, %3 = Field Caption Text';
    begin
        //if TOTestOrder."Test Order Status" <> TOTestOrder."Test Order Status"::Open then
        //    exit;

        if (SerialNoInfo."Item No." = '') and (SerialNoInfo."Serial No." = '') then
            exit;

        if not Item.Get(SerialNoInfo."Item No.") then
            exit(false);

        // Check if Lot tracking is required
        if not ItemTrackingCode.Get(Item."Item Tracking Code") then
            exit(false);

        if not ItemTrackingCode."Lot Specific Tracking" then
            exit(false);

        if DialogFieldCaptionText <> '' then begin
            KeyText := SerialNoInfo."Item No.";
            if SerialNoInfo."Variant Code" <> '' then
                KeyText := KeyText + '-' + SerialNoInfo."Variant Code";
            if SerialNoInfo."Serial No." <> '' then
                KeyText := KeyText + '-' + SerialNoInfo."Serial No.";

            if not Confirm(ConfirmChangeQst, false, SerialNoInfo.TableCaption(), KeyText, DialogFieldCaptionText) then
                exit(false);
        end;

        if not Item.Get(SerialNoInfo."Item No.") then
            exit(false);

        SerialNoStatusEntryUpdated := false;

        LotSerialNoStatusEntry.Reset();
        LotSerialNoStatusEntry.SetRange("Item No.", SerialNoInfo."Item No.");
        LotSerialNoStatusEntry.SetRange("Variant Code", SerialNoInfo."Variant Code");
        LotSerialNoStatusEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
        if LotSerialNoStatusEntry.FindLast() then begin
            if LotSerialNoStatusEntry."Order Type" = LotSerialNoStatusEntry."Order Type"::"Test Order" then begin
                if SerialNoInfo."Original Expiration Date PROF" = 0D then begin
                    SerialNoStatusEntryUpdated := true;
                    SerialNoInfo."Original Expiration Date PROF" := SerialNoInfo."Expiration Date PROF";
                end;
                if SerialNoInfo."Original Serial No. PROF" = '' then begin
                    SerialNoStatusEntryUpdated := true;
                    SerialNoInfo."Original Serial No. PROF" := SerialNoInfo."Serial No.";
                end;

                if SerialNoInfo."Original Expiration Date PROF" <> 0D then
                    SerialNoInfo."Original Expiration Date PROF" := SerialNoInfo."Expiration Date PROF";
                if SerialNoInfo."Original Serial No. PROF" <> '' then
                    SerialNoInfo."Original Serial No. PROF" := SerialNoInfo."Serial No.";
            end;

            if SerialNoInfo."Vendor Serial No. PROF" = '' then
                SerialNoInfo."Vendor Serial No. PROF" := SerialNoInfo."Serial No.";
            if SerialNoInfo."Expiration Date PROF" <> 0D then
                SerialNoInfo."Expiration Date PROF" := SerialNoInfo."Expiration Date PROF";
            if SerialNoInfo."Retest Date PROF" <> 0D then
                SerialNoInfo."Retest Date PROF" := SerialNoInfo."Retest Date PROF";
            if SerialNoInfo."Sales Expiration Date PROF" <> 0D then
                SerialNoInfo."Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";
            if SerialNoInfo."Country/Region of Origin PROF" <> '' then
                SerialNoInfo."Country/Region of Origin PROF" := SerialNoInfo."Country/Region of Origin PROF";
        end;
    end;





}