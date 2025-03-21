/// <summary>
/// Codeunit TO Misc. Events PROF (ID 6208503).
/// </summary>
codeunit 6208503 "TO Misc. Events PROF"
{
    Permissions =
        tabledata "Purch. Rcpt. Line" = rimd,
        tabledata "Sales Shipment Line" = rimd,
        tabledata "Sales Shipment Header" = rimd,
        tabledata "Lot No. Information" = rimd;

    var
        TOEventsSingleInstance: Codeunit "TO Events Single Instance PROF";
        SerialNoRequiredErr: Label 'Serial No. must be specified for this item.';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckItemTrackingInformation', '', false, false)]
    local procedure C22_OnBeforeCheckItemTrackingInfo(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; var ItemTrackingSetup: Record "Item Tracking Setup"; var SignFactor: Decimal; var ItemTrackingCode: Record "Item Tracking Code"; var IsHandled: Boolean; var GlobalItemTrackingCode: Record "Item Tracking Code")
    var
        Item: Record Item;
        LotNoInfo: Record "Lot No. Information";
        NewLotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        NewSerialNoInfo: Record "Serial No. Information";
        ItemLedgerEntry: Record "Item Ledger Entry";
        UsageDecicion: Record "TO Usage Decision PROF";
        CompanyInformation: Record "Company Information";
        LotMgt: Codeunit "TO Lot Management PROF";
        EventSingleInstance: Codeunit "TO Events Single Instance PROF";
        LotNoInfoUpdated: Boolean;
        SerialNoInfoUpdated: Boolean;

    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        // Handle Lot No. Information
        if ItemTrackingSetup."Lot No. Required" then begin
            Clear(LotNoInfo);
            if TrackingSpecification."Lot No." <> '' then
                if not LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.") then;

            if LotNoInfo."Item No." = '' then begin
                Item.Get(ItemJnlLine2."Item No.");
                if TrackingSpecification."Expiration Date" <> 0D then
                    ItemJnlLine2."Item Expiration Date" := TrackingSpecification."Expiration Date"
                else
                    if Format(Item."Expiration Calculation") <> '' then
                        ItemJnlLine2."Item Expiration Date" := CalcDate(Item."Expiration Calculation", Today())
                    else
                        ItemJnlLine2."Item Expiration Date" := Today();

                if TrackingSpecification."Retest Date PROF" <> 0D then
                    ItemJnlLine2."Retest Date PROF" := TrackingSpecification."Retest Date PROF"
                else
                    if Format(Item."Retest Calculation PROF") <> '' then
                        ItemJnlLine2."Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", ItemJnlLine2."Item Expiration Date");

                if TrackingSpecification."New Retest Date PROF" <> 0D then
                    ItemJnlLine2."New Retest Date PROF" := TrackingSpecification."New Retest Date PROF"
                else
                    if Format(Item."Retest Calculation PROF") <> '' then
                        if ItemJnlLine2."New Lot No." <> '' then
                            ItemJnlLine2."New Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", ItemJnlLine2."New Item Expiration Date");

                if TrackingSpecification."Sales Expiration Date PROF" <> 0D then
                    ItemJnlLine2."Sales Expiration Date PROF" := TrackingSpecification."Sales Expiration Date PROF"
                else
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        if ItemJnlLine2."New Lot No." <> '' then
                            ItemJnlLine2."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", ItemJnlLine2."New Item Expiration Date")
                        else
                            ItemJnlLine2."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", ItemJnlLine2."Item Expiration Date");

                ItemJnlLine2."Vendor Lot No. PROF" := TrackingSpecification."Vendor Lot No. PROF";
                ItemJnlLine2."New Vendor Lot No. PROF" := TrackingSpecification."New Vendor Lot No. PROF";
                ItemJnlLine2."Country/Region of Origin PROF" := TrackingSpecification."Country/Region of Origin PROF";

                if TrackingSpecification."Lot No." <> '' then begin
                    //  if not (Item."Bulk Item No." in ['', Item."No."]) then
                    //      if not LotNoInfo.Get(Item."Bulk Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.") then; // Get "Original Lot No." and "Original Expiration Date".
                    if LotNoInfo."Item No." = '' then
                        if not Item."QC Required PROF" then
                            LotNoInfo."Lot Status PROF" := LotNoInfo."Lot Status PROF"::Approved
                        else
                            LotNoInfo."Lot Status PROF" := LotNoInfo."Lot Status PROF"::"Not Tested";
                    TrackingSpecification."Tracking Status PROF" := LotNoInfo."Lot Status PROF";
                    ItemJnlLine2."Tracking Status PROF" := LotNoInfo."Lot Status PROF";



                    LotMgt.CreateLotNoInfo(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.", ItemJnlLine2."Item Expiration Date",
                                           TrackingSpecification."Vendor Lot No. PROF", TrackingSpecification."Retest Date PROF", CreateDateTime(ItemJnlLine2."Posting Date", Time()), ItemJnlLine2."Sales Expiration Date PROF", TrackingSpecification."Country/Region of Origin PROF",
                                           LotNoInfo."Original Lot No. PROF", LotNoInfo."Original Expiration Date PROF", LotNoInfo."Lot Status PROF", LotNoInfo."Internal Use Only PROF", false, '');
                    //    if LotNoInfo."Item No." <> '' then
                    //      LotMgt.CopyItemTrackingComment(LotNoInfo."Item No.", LotNoInfo."Variant Code", LotNoInfo."Lot No.", '', ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.");
                end;
            end else begin // Lot No. Info exists.
                ItemLedgerEntry.SetCurrentKey("Item No.");
                ItemLedgerEntry.SetRange("Item No.", LotNoInfo."Item No.");
                ItemLedgerEntry.SetRange("Variant Code", LotNoInfo."Variant Code");
                ItemLedgerEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
                if ItemLedgerEntry.IsEmpty() then begin
                    LotNoInfoUpdated := false;
                    if (LotNoInfo."Expiration Date PROF" = 0D) and (TrackingSpecification."Expiration Date" <> 0D) then begin
                        LotNoInfoUpdated := true;
                        LotNoInfo."Expiration Date PROF" := TrackingSpecification."Expiration Date";
                    end;
                    if (LotNoInfo."Retest Date PROF" = 0D) and (TrackingSpecification."Retest Date PROF" <> 0D) then begin
                        LotNoInfoUpdated := true;
                        LotNoInfo."Retest Date PROF" := TrackingSpecification."Retest Date PROF";
                    end;
                    if (LotNoInfo."Sales Expiration Date PROF" = 0D) and (TrackingSpecification."Sales Expiration Date PROF" <> 0D) then begin
                        LotNoInfoUpdated := true;
                        LotNoInfo."Sales Expiration Date PROF" := TrackingSpecification."Sales Expiration Date PROF";
                    end;
                    if not (TrackingSpecification."Vendor Lot No. PROF" in ['', LotNoInfo."Vendor Lot No. PROF"]) then begin
                        LotNoInfoUpdated := true;
                        LotNoInfo."Vendor Lot No. PROF" := TrackingSpecification."Vendor Lot No. PROF";
                    end;
                    if not (TrackingSpecification."Country/Region of Origin PROF" in ['', LotNoInfo."Country/Region of Origin PROF"]) then begin
                        LotNoInfoUpdated := true;
                        LotNoInfo."Country/Region of Origin PROF" := TrackingSpecification."Country/Region of Origin PROF";
                    end;
                    if LotNoInfoUpdated then
                        LotNoInfo.Modify();
                end;

                ItemJnlLine2."Item Expiration Date" := LotNoInfo."Expiration Date PROF";
                ItemJnlLine2."Retest Date PROF" := LotNoInfo."Retest Date PROF";
                if TrackingSpecification."New Lot No." <> '' then
                    ItemJnlLine2."New Retest Date PROF" := LotNoInfo."Retest Date PROF";
                ItemJnlLine2."Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";
                ItemJnlLine2."Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
                ItemJnlLine2."New Vendor Lot No. PROF" := TrackingSpecification."New Vendor Lot No. PROF";
                ItemJnlLine2."Country/Region of Origin PROF" := LotNoInfo."Country/Region of Origin PROF";
                // if (ItemJnlLine2."Entry Type" in [ItemJnlLine2."Entry Type"::"Negative Adjmt.", ItemJnlLine2."Entry Type"::"Positive Adjmt."]) or (ItemJnlLine2."Document Type" = ItemJnlLine2."Document Type"::"Purchase Return Shipment") then

                if Item.Get(LotNoInfo."Item No.") then
                    if Item."QC Required PROF" then begin
                        UsageDecicion.Reset();
                        UsageDecicion.SetRange(Code, LotNoInfo."Usage Decision PROF");
                        UsageDecicion.SetRange("Tracking Status", LotNoInfo."Lot Status PROF");
                        if UsageDecicion.FindFirst() then begin
                            LotNoInfo.Blocked := UsageDecicion."Block Tracking No.";
                            EventSingleInstance.SetTempLotNoInformation(LotNoInfo);
                        end;
                    end;
                if LotNoInfo.Blocked then begin
                    LotNoInfo.Blocked := false;
                    LotNoInfo.Modify();
                end;


                if TrackingSpecification."New Lot No." <> '' then
                    if NewLotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.") then
                        if NewLotNoInfo.Blocked then begin
                            EventSingleInstance.SetTempNewLotNoInformation(NewLotNoInfo);
                            NewLotNoInfo.Blocked := false;
                            NewLotNoInfo.Modify();
                        end;
            end;
        end;

        // Handle Serial No. Information
        if ItemTrackingSetup."Serial No. Required" then begin
            Clear(SerialNoInfo);
            if TrackingSpecification."Serial No." <> '' then
                if not SerialNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Serial No.") then;

            if SerialNoInfo."Item No." = '' then begin
                Item.Get(ItemJnlLine2."Item No.");
                if TrackingSpecification."Expiration Date" <> 0D then
                    ItemJnlLine2."Item Expiration Date" := TrackingSpecification."Expiration Date"
                else
                    if Format(Item."Expiration Calculation") <> '' then
                        ItemJnlLine2."Item Expiration Date" := CalcDate(Item."Expiration Calculation", Today())
                    else
                        ItemJnlLine2."Item Expiration Date" := Today();

                if TrackingSpecification."Retest Date PROF" <> 0D then
                    ItemJnlLine2."Retest Date PROF" := TrackingSpecification."Retest Date PROF"
                else
                    if Format(Item."Retest Calculation PROF") <> '' then
                        ItemJnlLine2."Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", ItemJnlLine2."Item Expiration Date");

                if TrackingSpecification."New Retest Date PROF" <> 0D then
                    ItemJnlLine2."New Retest Date PROF" := TrackingSpecification."New Retest Date PROF"
                else
                    if Format(Item."Retest Calculation PROF") <> '' then
                        if ItemJnlLine2."New Serial No." <> '' then
                            ItemJnlLine2."New Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", ItemJnlLine2."New Item Expiration Date");

                if TrackingSpecification."Sales Expiration Date PROF" <> 0D then
                    ItemJnlLine2."Sales Expiration Date PROF" := TrackingSpecification."Sales Expiration Date PROF"
                else
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        if ItemJnlLine2."New Serial No." <> '' then
                            ItemJnlLine2."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", ItemJnlLine2."New Item Expiration Date")
                        else
                            ItemJnlLine2."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", ItemJnlLine2."Item Expiration Date");

                ItemJnlLine2."Vendor Serial No. PROF" := TrackingSpecification."Vendor Serial No. PROF";
                ItemJnlLine2."New Vendor Serial No. PROF" := TrackingSpecification."New Vendor Serial No. PROF";
                ItemJnlLine2."Country/Region of Origin PROF" := TrackingSpecification."Country/Region of Origin PROF";

                if TrackingSpecification."Serial No." <> '' then begin
                    if SerialNoInfo."Item No." = '' then
                        if not Item."QC Required PROF" then
                            SerialNoInfo."Serial Status PROF" := SerialNoInfo."Serial Status PROF"::Approved
                        else
                            SerialNoInfo."Serial Status PROF" := SerialNoInfo."Serial Status PROF"::"Not Tested";
                    TrackingSpecification."Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
                    ItemJnlLine2."Tracking Status PROF" := SerialNoInfo."Serial Status PROF";

                    LotMgt.CreateSerialNoInfo(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Serial No.", ItemJnlLine2."Item Expiration Date",
                                           TrackingSpecification."Vendor Serial No. PROF", TrackingSpecification."Retest Date PROF", CreateDateTime(ItemJnlLine2."Posting Date", Time()), ItemJnlLine2."Sales Expiration Date PROF", TrackingSpecification."Country/Region of Origin PROF",
                                           SerialNoInfo."Original Serial No. PROF", SerialNoInfo."Original Expiration Date PROF", SerialNoInfo."Serial Status PROF", SerialNoInfo."Internal Use Only PROF", false, '');
                end;

                // Add Serial Number handling
                if (ItemTrackingCode."SN Specific Tracking") and (TrackingSpecification."Serial No." = '') then
                    if not IsHandled then
                        Error(SerialNoRequiredErr);
            end else begin // Serial No. Info exists.
                ItemLedgerEntry.SetCurrentKey("Item No.");
                ItemLedgerEntry.SetRange("Item No.", SerialNoInfo."Item No.");
                ItemLedgerEntry.SetRange("Variant Code", SerialNoInfo."Variant Code");
                ItemLedgerEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
                if ItemLedgerEntry.IsEmpty() then begin
                    SerialNoInfoUpdated := false;
                    if (SerialNoInfo."Expiration Date PROF" = 0D) and (TrackingSpecification."Expiration Date" <> 0D) then begin
                        SerialNoInfoUpdated := true;
                        SerialNoInfo."Expiration Date PROF" := TrackingSpecification."Expiration Date";
                    end;
                    if (SerialNoInfo."Retest Date PROF" = 0D) and (TrackingSpecification."Retest Date PROF" <> 0D) then begin
                        SerialNoInfoUpdated := true;
                        SerialNoInfo."Retest Date PROF" := TrackingSpecification."Retest Date PROF";
                    end;
                    if (SerialNoInfo."Sales Expiration Date PROF" = 0D) and (TrackingSpecification."Sales Expiration Date PROF" <> 0D) then begin
                        SerialNoInfoUpdated := true;
                        SerialNoInfo."Sales Expiration Date PROF" := TrackingSpecification."Sales Expiration Date PROF";
                    end;
                    if not (TrackingSpecification."Vendor Serial No. PROF" in ['', SerialNoInfo."Vendor Serial No. PROF"]) then begin
                        SerialNoInfoUpdated := true;
                        SerialNoInfo."Vendor Serial No. PROF" := TrackingSpecification."Vendor Serial No. PROF";
                    end;
                    if not (TrackingSpecification."Country/Region of Origin PROF" in ['', SerialNoInfo."Country/Region of Origin PROF"]) then begin
                        SerialNoInfoUpdated := true;
                        SerialNoInfo."Country/Region of Origin PROF" := TrackingSpecification."Country/Region of Origin PROF";
                    end;
                    if SerialNoInfoUpdated then
                        SerialNoInfo.Modify();
                end;

                ItemJnlLine2."Item Expiration Date" := SerialNoInfo."Expiration Date PROF";
                ItemJnlLine2."Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                if TrackingSpecification."New Serial No." <> '' then
                    ItemJnlLine2."New Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                ItemJnlLine2."Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";
                ItemJnlLine2."Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                ItemJnlLine2."New Vendor Serial No. PROF" := TrackingSpecification."New Vendor Serial No. PROF";
                ItemJnlLine2."Country/Region of Origin PROF" := SerialNoInfo."Country/Region of Origin PROF";

                if Item.Get(SerialNoInfo."Item No.") then
                    if Item."QC Required PROF" then begin
                        UsageDecicion.Reset();
                        UsageDecicion.SetRange(Code, SerialNoInfo."Usage Decision PROF");
                        UsageDecicion.SetRange("Tracking Status", SerialNoInfo."Serial Status PROF");
                        if UsageDecicion.FindFirst() then begin
                            SerialNoInfo.Blocked := UsageDecicion."Block Tracking No.";
                            EventSingleInstance.SetTempSerialNoInformation(SerialNoInfo);
                        end;
                    end;

                if SerialNoInfo.Blocked then begin
                    SerialNoInfo.Blocked := false;
                    SerialNoInfo.Modify();
                end;
                if TrackingSpecification."New Serial No." <> '' then
                    if NewSerialNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Serial No.") then
                        if NewSerialNoInfo.Blocked then begin
                            EventSingleInstance.SetTempNewSerialNoInformation(NewSerialNoInfo);
                            NewSerialNoInfo.Blocked := false;
                            NewSerialNoInfo.Modify();
                        end;
            end;
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterCheckItemTrackingInformation', '', false, false)]
    local procedure OnAfterCheckItemTrackingInformation(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup"; Item: Record Item)
    var
        LotNoInfo: Record "Lot No. Information";
        NewLotNoInfo: Record "Lot No. Information";
        TempLotNoInfo: Record "Lot No. Information" temporary;
        TempNewLotNoInfo: Record "Lot No. Information" temporary;
        SerialNoInfo: Record "Serial No. Information";
        NewSerialNoInfo: Record "Serial No. Information";
        TempSerialNoInfo: Record "Serial No. Information" temporary;
        TempNewSerialNoInfo: Record "Serial No. Information" temporary;
        CompanyInformation: Record "Company Information";
        EventSingleInstance: Codeunit "TO Events Single Instance PROF";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;

        if ItemTrackingSetup."Lot No. Required" then begin
            if TrackingSpecification."New Lot No." <> '' then
                LotNoInfo."Lot No." := TrackingSpecification."New Lot No."
            else
                LotNoInfo."Lot No." := TrackingSpecification."Lot No.";
            if LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", LotNoInfo."Lot No.") then begin
                EventSingleInstance.GetTempLotNoInformation(TempLotNoInfo);

                if (LotNoInfo.RecordId() = TempLotNoInfo.RecordId()) and (LotNoInfo.Blocked <> TempLotNoInfo.Blocked and TempLotNoInfo.Blocked) then begin
                    LotNoInfo.Blocked := TempLotNoInfo.Blocked;
                    LotNoInfo.Modify();
                end;

            end;
            if NewLotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.") then begin
                EventSingleInstance.GetTempNewLotNoInformation(TempNewLotNoInfo);
                if (NewLotNoInfo.RecordId() = TempNewLotNoInfo.RecordId()) and (NewLotNoInfo.Blocked <> TempNewLotNoInfo.Blocked and TempNewLotNoInfo.Blocked) then begin
                    NewLotNoInfo.Blocked := TempNewLotNoInfo.Blocked;
                    NewLotNoInfo.Modify();
                end;
            end;

            /*   if TestOrderSetup.Get() then
                   if TestOrderSetup."Block Tracking No." then begin
                       LotNoInfo.Blocked := true;
                       LotNoInfo.Modify();
                   end;
              */

        end;



        if ItemTrackingSetup."Serial No. Required" then begin
            if TrackingSpecification."New Serial No." <> '' then
                SerialNoInfo."Serial No." := TrackingSpecification."New Serial No."
            else
                SerialNoInfo."Serial No." := TrackingSpecification."Serial No.";
            if SerialNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", SerialNoInfo."Serial No.") then begin
                EventSingleInstance.GetTempSerialNoInformation(TempSerialNoInfo);
                if (SerialNoInfo.RecordId() = TempSerialNoInfo.RecordId()) and (SerialNoInfo.Blocked <> TempSerialNoInfo.Blocked and TempSerialNoInfo.Blocked) then begin
                    SerialNoInfo.Blocked := TempSerialNoInfo.Blocked;
                    SerialNoInfo.Modify();
                end;
            end;
            if NewSerialNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Serial No.") then begin
                EventSingleInstance.GetTempNewSerialNoInformation(TempNewSerialNoInfo);
                if (NewSerialNoInfo.RecordId() = TempNewSerialNoInfo.RecordId()) and (NewSerialNoInfo.Blocked <> TempNewSerialNoInfo.Blocked and TempNewSerialNoInfo.Blocked) then begin
                    NewSerialNoInfo.Blocked := TempNewSerialNoInfo.Blocked;
                    NewSerialNoInfo.Modify();
                end;
            end;
        end;
    end;



    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterSetQtyToHandleAndInvoiceOnBeforeReservEntryModify', '', false, false)]
    local procedure OnAfterSetQtyToHandleAndInvoiceOnBeforeReservEntryModify(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification"; var TotalTrackingSpecification: Record "Tracking Specification"; var ModifyLine: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        // Copy custom fields from Tracking Specification to Reservation Entry
        ReservEntry."Retest Date PROF" := TrackingSpecification."Retest Date PROF";
        ReservEntry."Sales Expiration Date PROF" := TrackingSpecification."Sales Expiration Date PROF";
        ReservEntry."Vendor Lot No. PROF" := TrackingSpecification."Vendor Lot No. PROF";
        ReservEntry."New Vendor Lot No. PROF" := TrackingSpecification."New Vendor Lot No. PROF";
        ReservEntry."Country/Region of Origin PROF" := TrackingSpecification."Country/Region of Origin PROF";
        ModifyLine := true;
    end;

    //After POSTING OF RECEIPT




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure C22_OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        NewItemLedgEntry."Vendor Lot No. PROF" := ItemJournalLine."Vendor Lot No. PROF";
        NewItemLedgEntry."Retest Date PROF" := ItemJournalLine."Retest Date PROF";
        NewItemLedgEntry."Sales Expiration Date PROF" := ItemJournalLine."Sales Expiration Date PROF";
        NewItemLedgEntry."Tracking Status PROF" := ItemJournalLine."Tracking Status PROF";
        //NewItemLedgEntry.Blocked := ItemJournalLine.Blocked;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean)
    var
        Item: Record Item;
        EWTestOrder: Record "TO Test Order PROF";
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        ItemLedgerEntry.Testfield("Item No.");
        Item.Get(ItemLedgerEntry."Item No.");
        //  ItemLedgerEntry."Bulk Item No." := Item."Bulk Item No.";
        ItemLedgerEntry."Origin Document No. PROF" := ItemJournalLine."Origin Document No. PROF";

        if (ItemLedgerEntry."Document Type" <> ItemLedgerEntry."Document Type"::"Sales Return Receipt") then
            EWTestOrder.CreateRecord(ItemLedgerEntry, Item);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLine_OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer)
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        EWTestOrder: Record "TO Test Order PROF";
        SerialNoInformation: Record "Serial No. Information";
        CompanyInformation: Record "Company Information";
        TrackAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        Clear(TrackAssignMgt);
        Item.Get(ItemLedgerEntry."Item No.");
        if ItemLedgerEntry.Positive and (ItemLedgerEntry."Lot No." <> '') and (Item."Item Tracking Code" <> '') and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") then
            if LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") and (not LotNoInformation.Blocked) then begin
                LotNoInformation.Blocked := true;
                LotNoInformation.Modify();
                TrackingNoStatusEntry.DoInsert(LotNoInformation, '', CopyStr(UserId, 1, MaxStrLen(TrackingNoStatusEntry."User ID")), true, false, true);
                EWTestOrder.CreateManuelTestOrder(ItemLedgerEntry, Item);
            end;

        if ItemLedgerEntry.Positive and (ItemLedgerEntry."Serial No." <> '') and (Item."Item Tracking Code" <> '') and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") then
            if SerialNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") and (not SerialNoInformation.Blocked) then begin
                SerialNoInformation.Blocked := true;
                SerialNoInformation.Modify();
                TrackingNoStatusEntry.DoInsertSN(SerialNoInformation, '', CopyStr(UserId, 1, MaxStrLen(TrackingNoStatusEntry."User ID")), true, false, true);
                EWTestOrder.CreateManuelTestOrderSN(ItemLedgerEntry, Item);
            end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertTransferEntry', '', false, false)]
    local procedure C22_OnBeforeInsertTransferEntry(var NewItemLedgerEntry: Record "Item Ledger Entry"; var OldItemLedgerEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        // Here we add the "New" info to the "Item Ledger Entry"."Entry Type"::Transfer part two.
        if LotNoInfo.Get(ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."New Lot No.") then begin
            NewItemLedgerEntry."Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
            NewItemLedgerEntry."Retest Date PROF" := LotNoInfo."Retest Date PROF";
            NewItemLedgerEntry."Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";
            NewItemLedgerEntry."Tracking Status PROF" := LotNoInfo."Lot Status PROF";
            //NewItemLedgerEntry.Blocked := LotNoInfo."Blocked";
        end else
            if SerialNoInfo.Get(ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."New Serial No.") then begin
                NewItemLedgerEntry."Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                NewItemLedgerEntry."Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                NewItemLedgerEntry."Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";
                NewItemLedgerEntry."Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
            end else begin
                NewItemLedgerEntry."Vendor Lot No. PROF" := ItemJournalLine."New Vendor Lot No. PROF";
                NewItemLedgerEntry."Vendor Serial No. PROF" := ItemJournalLine."New Vendor Serial No. PROF";
                NewItemLedgerEntry."Retest Date PROF" := ItemJournalLine."New Retest Date PROF";
                NewItemLedgerEntry."Sales Expiration Date PROF" := ItemJournalLine."Sales Expiration Date PROF";
                NewItemLedgerEntry."Tracking Status PROF" := ItemJournalLine."Tracking Status (New) PROF";
                //NewItemLedgerEntry.Blocked := ItemJournalLine."New Blocked";
            end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertTransferEntryOnTransferValues', '', false, false)]
    local procedure ItemJnlPostLineOnInsertTransferEntryOnTransferValues(var NewItemLedgerEntry: Record "Item Ledger Entry"; OldItemLedgerEntry: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        NewItemLedgerEntry."Vendor Lot No. PROF" := ItemJournalLine."New Vendor Lot No. PROF";
        NewItemLedgerEntry."Vendor Serial No. PROF" := ItemJournalLine."New Vendor Serial No. PROF";
        NewItemLedgerEntry."Retest Date PROF" := ItemJournalLine."New Retest Date PROF";
        NewItemLedgerEntry."Sales Expiration Date PROF" := ItemJournalLine."Sales Expiration Date PROF";
        NewItemLedgerEntry."Tracking Status PROF" := ItemJournalLine."Tracking Status (New) PROF";
        NewItemLedgerEntry."Origin Document No. PROF" := ItemJournalLine."Origin Document No. PROF";

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnInitWhseEntryCopyFromWhseJnlLine', '', false, false)]
    local procedure WhseJnlRegLine_OnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        WarehouseEntry."Retest Date PROF" := WarehouseJournalLine."Retest Date PROF";

        if OnMovement and (WarehouseJournalLine."Entry Type" = WarehouseJournalLine."Entry Type"::Movement) then begin
            if WarehouseJournalLine."New Location Code PROF" <> '' then begin
                WarehouseJournalLine."Location Code" := WarehouseJournalLine."New Location Code PROF";
                if Sign > 0 then
                    WarehouseEntry."Location Code" := WarehouseJournalLine."New Location Code PROF"; // To ensure bin content creation
            end;
            if WarehouseJournalLine."New Retest Date PROF" <> 0D then
                WarehouseEntry."Retest Date PROF" := WarehouseJournalLine."New Retest Date PROF";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignFixedAssetValues', '', false, false)] // #52038377
    local procedure PurchaseLine_OnAfterAssignFixedAssetValues(var PurchLine: Record "Purchase Line"; FixedAsset: Record "Fixed Asset")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if (PurchLine.Type = PurchLine.Type::"Fixed Asset") and (PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::"Acquisition Cost") then begin //  Fixed Asset and Acquisition Cost
            PurchLine.Validate("Depr. Acquisition Cost", true);
            PurchLine.Validate("Depr. until FA Posting Date", true);
        end;
        if (PurchLine.Type = PurchLine.Type::"Fixed Asset") and (PurchLine."FA Posting Type" <> PurchLine."FA Posting Type"::"Acquisition Cost") then begin
            PurchLine.Validate("Depr. Acquisition Cost", false);
            PurchLine.Validate("Depr. until FA Posting Date", false);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", 'OnBeforeCreateReservEntry', '', false, false)]
    local procedure WhseJnlRegBatch_OnBeforeCreateReservEntry(WarehouseJournalLine: Record "Warehouse Journal Line"; var WhseItemTrackingLine: Record "Whse. Item Tracking Line")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        TOEventsSingleInstance.SetAdditionalTrackingInfo(WhseItemTrackingLine."Retest Date PROF", WhseItemTrackingLine."New Retest Date PROF", WhseItemTrackingLine."Sales Expiration Date PROF", WhseItemTrackingLine."Vendor Lot No. PROF", WhseItemTrackingLine."New Vendor Lot No. PROF", WhseItemTrackingLine."Country/Region of Origin PROF");

    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCreateReservEntryFor', '', false, false)]
    local procedure OnAfterCreateReservEntryFor(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        TOEventsSingleInstance.SetAdditionalTrackingInfo(NewTrackingSpecification."Retest Date PROF", NewTrackingSpecification."New Retest Date PROF", NewTrackingSpecification."Sales Expiration Date PROF", NewTrackingSpecification."Vendor Lot No. PROF", NewTrackingSpecification."New Vendor Lot No. PROF", NewTrackingSpecification."Country/Region of Origin PROF");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnCreateEntryOnBeforeSurplusCondition', '', false, false)]
    local procedure CreateReservEntry_OnCreateEntryOnBeforeSurplusCondition(var ReservEntry: Record "Reservation Entry")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        TOEventsSingleInstance.GetAdditionalTrackingInfo(ReservEntry."Retest Date PROF", ReservEntry."New Retest Date PROF", ReservEntry."Sales Expiration Date PROF", ReservEntry."Vendor Lot No. PROF", ReservEntry."New Vendor Lot No. PROF", ReservEntry."Country/Region of Origin PROF");
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnBeforeUpdateItemTracking', '', false, false)]
    local procedure OnBeforeUpdateItemTracking(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    var
        CompanyInformation: Record "Company Information";
        TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        TrackingAssignMgt.ReservationEntrySetItemTrkgFromTrackingSpecification(ReservEntry, TrackingSpecification);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        LotNoInfo: Record "Lot No. Information";
        EWSetup: Record "TO Setup PROF";
        //SalesHeader: Record "Sales Header";
        CompanyInformation: Record "Company Information";
        SerialNoInfo: Record "Serial No. Information";
        PhysInvtPostingNotAllowedErr: Label 'Physical Inventory Posting is not allowed.\\"TO Setup" is restricting posting of Warehouse Journal Lines with "Phys. Inventory".';

    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if WarehouseJournalLine."Phys. Inventory" then
            if EWSetup.Get() and EWSetup."Stop Phys. Invt. Posting" then
                Error(PhysInvtPostingNotAllowedErr);

        // if (WarehouseJournalLine."Source Type" = 37) and (WarehouseJournalLine."Source Subtype" = 2) then
        //     if SalesHeader.Get(SalesHeader."Document Type"::Invoice, WarehouseJournalLine."Source No.") then
        //         if SalesHeader."Allow Post Despite Expired" then
        //             exit;

        if (WarehouseJournalLine."Source Type" = Database::"Sales Line") and (WarehouseJournalLine."Lot No." <> '') and (WarehouseJournalLine."From Bin Code" <> '') and (WarehouseJournalLine."Qty. (Base)" > 0) then
            if LotNoInfo.Get(WarehouseJournalLine."Item No.", WarehouseJournalLine."Variant Code", WarehouseJournalLine."Lot No.") then
                if not CheckSalesAllowed(LotNoInfo, true, false, 0D) then
                    Error(''); // Stopped by user. (Recommended).

        if (WarehouseJournalLine."Source Type" = Database::"Sales Line") and (WarehouseJournalLine."Serial No." <> '') and (WarehouseJournalLine."From Bin Code" <> '') and (WarehouseJournalLine."Qty. (Base)" > 0) then
            if SerialNoInfo.Get(WarehouseJournalLine."Item No.", WarehouseJournalLine."Variant Code", WarehouseJournalLine."Serial No.") then
                if not CheckSalesAllowedSN(SerialNoInfo, true, false, 0D) then
                    Error(''); // Stopped by user. (Recommended).
    end;

    local procedure CheckSalesAllowed(LotNoInfo: Record "Lot No. Information"; ConfirmIfLotStatusNotTested: Boolean; CommingFromCreatePick: Boolean; PerDate: Date): Boolean
    var
        CompanyInformation: Record "Company Information";
        LotStatusNotTestedErr: Label '%1 %2 is not ready (%3 %4) and cannot be sold.', Comment = '%1 = FieldCaption("Lot No."), %2 = Lot No., %3 = FieldCaption("Lot Status"), %4 = Lot Status';
        InternalUseOnlyErr: Label '%1 %2 is only for Internal Use and cannot be sold.', Comment = '%1 = FieldCaption("Lot No."), %2 = Lot No.';
        ExpiredErr: Label '%1 %2 has expired (%3 %4) and cannot be sold.', Comment = '%1 = FieldCaption("Lot No."), %2 = Lot No., %3 = FieldCaption("Sales Expiration Date"), %4 = Sales Expiration Date';
        WarningMsg: Label 'WARNING:';
        ProceedMsg: Label 'Do you want to proceed anyway ?';
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if (ConfirmIfLotStatusNotTested) and (LotNoInfo."Lot Status PROF" = LotNoInfo."Lot Status PROF"::"Not Tested") then begin
            if CommingFromCreatePick then
                exit(false);
            if not GuiAllowed() then
                Error(LotStatusNotTestedErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.", LotNoInfo.FieldCaption("Lot Status PROF"), LotNoInfo."Lot Status PROF");
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(LotStatusNotTestedErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.", LotNoInfo.FieldCaption("Lot Status PROF"), LotNoInfo."Lot Status PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false)
            else
                exit(true); // only one warning
        end;

        if LotNoInfo."Internal Use Only PROF" then begin
            if CommingFromCreatePick then
                exit(false);
            Error(InternalUseOnlyErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.");
        end;

        if LotNoInfo."Sales Expiration Date PROF" < WorkDate() then begin
            if CommingFromCreatePick then
                exit(false);
            if (LotNoInfo."Expiration Date PROF" < WorkDate()) or (not GuiAllowed()) then
                Error(ExpiredErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.", LotNoInfo.FieldCaption("Sales Expiration Date PROF"), LotNoInfo."Sales Expiration Date PROF");
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(ExpiredErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.", LotNoInfo.FieldCaption("Sales Expiration Date PROF"), LotNoInfo."Sales Expiration Date PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false)
            else
                exit(true); // only one warning
        end;

        if (PerDate <> 0D) and (LotNoInfo."Sales Expiration Date PROF" < PerDate) and (LotNoInfo."Sales Expiration Date PROF" <> 0D) then begin
            if CommingFromCreatePick then
                exit(false);
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(ExpiredErr, LotNoInfo.FieldCaption("Lot No."), LotNoInfo."Lot No.", LotNoInfo.FieldCaption("Sales Expiration Date PROF"), LotNoInfo."Sales Expiration Date PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false);
        end;

        exit(true);
    end;



    local procedure CheckSalesAllowedSN(SerialNoInfo: Record "Serial No. Information"; ConfirmIfLotStatusNotTested: Boolean; CommingFromCreatePick: Boolean; PerDate: Date): Boolean

    var
        CompanyInformation: Record "Company Information";
        SerialStatusNotTestedErr: Label '%1 %2 is not ready (%3 %4) and cannot be sold.', Comment = '%1 = FieldCaption("Serial No."), %2 = Serial No., %3 = FieldCaption("Serial Status"), %4 = Serial Status';
        InternalUseOnlyErr: Label '%1 %2 is only for Internal Use and cannot be sold.', Comment = '%1 = FieldCaption("Serial No."), %2 = Serial No.';
        ExpiredErr: Label '%1 %2 has expired (%3 %4) and cannot be sold.', Comment = '%1 = FieldCaption("Serial No."), %2 = Serial No., %3 = FieldCaption("Sales Expiration Date"), %4 = Sales Expiration Date';
        WarningMsg: Label 'WARNING:';
        ProceedMsg: Label 'Do you want to proceed anyway ?';
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if (ConfirmIfLotStatusNotTested) and (SerialNoInfo."Serial Status PROF" = SerialNoInfo."Serial Status PROF"::"Not Tested") then begin
            if CommingFromCreatePick then
                exit(false);
            if not GuiAllowed() then
                Error(SerialStatusNotTestedErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.", SerialNoInfo.FieldCaption("Serial Status PROF"), SerialNoInfo."Serial Status PROF");
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(SerialStatusNotTestedErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.", SerialNoInfo.FieldCaption("Serial Status PROF"), SerialNoInfo."Serial Status PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false)
            else
                exit(true); // only one warning
        end;

        if SerialNoInfo."Internal Use Only PROF" then begin
            if CommingFromCreatePick then
                exit(false);
            Error(InternalUseOnlyErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.");
        end;

        if SerialNoInfo."Sales Expiration Date PROF" < WorkDate() then begin
            if CommingFromCreatePick then
                exit(false);
            if (SerialNoInfo."Expiration Date PROF" < WorkDate()) or (not GuiAllowed()) then
                Error(ExpiredErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.", SerialNoInfo.FieldCaption("Sales Expiration Date PROF"), SerialNoInfo."Sales Expiration Date PROF");
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(ExpiredErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.", SerialNoInfo.FieldCaption("Sales Expiration Date PROF"), SerialNoInfo."Sales Expiration Date PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false)
            else
                exit(true); // only one warning
        end;

        if (PerDate <> 0D) and (SerialNoInfo."Sales Expiration Date PROF" < PerDate) and (SerialNoInfo."Sales Expiration Date PROF" <> 0D) then begin
            if CommingFromCreatePick then
                exit(false);
            if not Confirm(WarningMsg + ' ' +
                           StrSubstNo(ExpiredErr, SerialNoInfo.FieldCaption("Serial No."), SerialNoInfo."Serial No.", SerialNoInfo.FieldCaption("Sales Expiration Date PROF"), SerialNoInfo."Sales Expiration Date PROF") +
                           ' ' + ProceedMsg, false) then
                exit(false);
        end;

        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeExistingExpirationDate', '', false, false)]
    local procedure OnBeforeExistingExpirationDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; TestMultiple: Boolean; var EntriesExist: Boolean; var ExpDate: Date; var IsHandled: Boolean)
    var
        CompanyInformation: Record "Company Information";
        LotNoInfo: Record "Lot No. Information";
        ReservationEntry: Record "Reservation Entry";
        UseLotNoInfo: Boolean;
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if LotNo <> '' then begin
            ReservationEntry.SetRange("Item No.", ItemNo);
            ReservationEntry.SetRange("Variant Code", Variant);
            ReservationEntry.SetRange("Lot No.", LotNo);
            ReservationEntry.SetFilter("Quantity (Base)", '>%1', 0);
            ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
            ReservationEntry.SetFilter("Expiration Date", '<>%1', 0D);
            ReservationEntry.SetRange("Source Type", Database::"Item Journal Line");
            ReservationEntry.SetRange("Source Subtype", 0);
            UseLotNoInfo := not ReservationEntry.IsEmpty();
            if not UseLotNoInfo then begin
                ReservationEntry.SetRange("Source Type", Database::"Prod. Order Line");
                ReservationEntry.SetRange("Source Subtype", 3);
                UseLotNoInfo := not ReservationEntry.IsEmpty();
            end;
            if UseLotNoInfo then
                if LotNoInfo.Get(ItemNo, Variant, LotNo) then begin
                    ExpDate := LotNoInfo."Expiration Date PROF";
                    EntriesExist := true;
                    IsHandled := true;
                end;
        end;
    end;


}