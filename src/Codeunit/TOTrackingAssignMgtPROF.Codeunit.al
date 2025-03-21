/// <summary>
/// Codeunit TO Tracking Assign Mgt. PROF (ID 6208504).
/// </summary>
codeunit 6208504 "TO Tracking Assign Mgt. PROF"
{
    Permissions = TableData "Whse. Item Tracking Line" = rimd; // Due to Page6550_DeleteRecord().


    internal procedure CalculateTrackingInfo(var SerialNo: Code[50]; var LotNo: Code[50]; var CalcExpirationDate: Date; var RetestDate: Date; var SalesExpirationDate: Date; var CountryOfOrigin: Code[10]; Item: Record Item)
    var
        ItemTrackingCode: Record "Item Tracking Code";
        TOSetup: Record "TO Setup PROF";
        NoSeries: Codeunit "No. Series";
    begin
        if ItemTrackingCode.Get(Item."Item Tracking Code") then begin
            if (ItemTrackingCode."SN Specific Tracking") and (SerialNo = '') then begin
                TOSetup.Get();
                if TOSetup."Auto Create Serial No. Purch" then
                    SerialNo := NoSeries.GetNextNo(TOSetup."Serial Nos.", WorkDate(), true)
                else
                    if Item."Serial Nos." <> '' then
                        SerialNo := NoSeries.GetNextNo(Item."Serial Nos.", WorkDate(), true);
            end;

            if (ItemTrackingCode."Lot Specific Tracking") and (LotNo = '') then begin
                TOSetup.Get();
                if TOSetup."Auto Create Lot No. Purchase" then
                    LotNo := NoSeries.GetNextNo(TOSetup."Lot Nos.", WorkDate(), true)
                else
                    if Item."Lot Nos." <> '' then
                        LotNo := NoSeries.GetNextNo(Item."Lot Nos.", WorkDate(), true);
            end;
        end;

        if CalcExpirationDate = 0D then
            if Format(Item."Expiration Calculation") <> '' then
                CalcExpirationDate := CalcDate(Item."Expiration Calculation", Today)
            else
                Clear(CalcExpirationDate);

        if (Format(Item."Retest Calculation PROF") <> '') and (CalcExpirationDate <> 0D) then
            RetestDate := CalcDate(Item."Retest Calculation PROF", CalcExpirationDate)
        else
            Clear(RetestDate);

        if (Format(Item."Sales Expiration Calc. PROF") <> '') and (CalcExpirationDate <> 0D) then
            SalesExpirationDate := CalcDate(Item."Sales Expiration Calc. PROF", CalcExpirationDate)
        else
            Clear(SalesExpirationDate);

        CountryOfOrigin := Item."Country/Region of Origin Code";
    end;





    internal procedure SyncronizeLotTracking(var NewItemJournalLine: Record "Item Journal Line"; var OldItemJournalLine: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemJournalLine: Record "Item Journal Line";
        ItemTrackingCode: Record "Item Tracking Code";
        TempItemTrackingSetup: Record "Item Tracking Setup" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingLines: Page "Item Tracking Lines";
        TrackedQty: Decimal;
        QtyToTrack: Decimal;
        ReduceByQty: Decimal;
        NoOfLotNos: Integer;
        LotRequired: Boolean;
        Inbound: Boolean;
        EntryType: Enum "Item Ledger Entry Type";
        MultipleLotsMsg: Label 'This line covers %1 different lots; maintain item tracking manually!', Comment = '%1 = No. of Lots';
    begin
        QtyToTrack := NewItemJournalLine."Quantity (Base)";
        if QtyToTrack = 0 then
            exit;
        if NewItemJournalLine."Line No." = OldItemJournalLine."Line No." then
            if NewItemJournalLine."Quantity (Base)" = OldItemJournalLine."Quantity (Base)" then
                exit;
        if NewItemJournalLine."Line No." = 0 then
            if not ItemJournalLine.Get(NewItemJournalLine."Journal Template Name", NewItemJournalLine."Journal Batch Name", NewItemJournalLine."Line No.")
            then
                exit;
        if not Item.Get(NewItemJournalLine."Item No.") then
            exit;
        if Item."Item Tracking Code" = '' then
            exit;

        Clear(ItemTrackingMgt);
        ItemTrackingCode.Code := Item."Item Tracking Code";
        Inbound := true;
        EntryType := "Item Ledger Entry Type"::Output;
        // Get the item tracking setup
        ItemTrackingMgt.GetItemTrackingSetup(ItemTrackingCode, EntryType, Inbound, TempItemTrackingSetup);

        // Check if Lot tracking is required
        LotRequired := TempItemTrackingSetup."Lot No. Required";

        if not LotRequired then
            exit;

        ItemTrackingMgt.RetrieveItemTracking(NewItemJournalLine, TempTrackingSpecification);
        if TempTrackingSpecification.FindSet() then begin
            repeat
                TrackedQty += TempTrackingSpecification."Quantity (Base)" - TempTrackingSpecification."Quantity Handled (Base)";
                NoOfLotNos += 1;
            until TempTrackingSpecification.Next() = 0;
            if TrackedQty < QtyToTrack then begin
                // Increase.
                if NoOfLotNos > 1 then begin
                    Message(MultipleLotsMsg, NoOfLotNos);
                    exit;
                end else begin
                    TempTrackingSpecification.Validate("Quantity (Base)", QtyToTrack);
                    TempTrackingSpecification.Modify();
                end;
            end else
                if TempTrackingSpecification.FindSet() then
                    repeat
                        // Decrease.
                        if (TempTrackingSpecification."Quantity (Base)" - TempTrackingSpecification."Quantity Handled (Base)") < QtyToTrack then
                            ReduceByQty := TempTrackingSpecification."Quantity (Base)" - TempTrackingSpecification."Quantity Handled (Base)"
                        else
                            ReduceByQty := QtyToTrack;
                        TempTrackingSpecification.Validate("Quantity (Base)", ReduceByQty);
                        TempTrackingSpecification.Modify();
                        if ReduceByQty < QtyToTrack then
                            QtyToTrack -= ReduceByQty
                        else
                            QtyToTrack := 0;
                    until TempTrackingSpecification.Next() = 0;

            ItemTrackingLines.SetBlockCommit(true);
            ItemTrackingLines.RegisterItemTrackingLines(
              TempTrackingSpecification, ItemJournalLine."Posting Date", TempTrackingSpecification);
        end;
    end;

    internal procedure ReservationEntrySetItemTrkgFromTrackingSpecification(var ReservationEntry: Record "Reservation Entry"; var TrkgSpec: Record "Tracking Specification")
    begin
        ReservationEntry."Vendor Lot No. PROF" := TrkgSpec."Vendor Lot No. PROF";
        ReservationEntry."New Vendor Lot No. PROF" := TrkgSpec."New Vendor Lot No. PROF";
        ReservationEntry."Retest Date PROF" := TrkgSpec."Retest Date PROF";
        ReservationEntry."New Retest Date PROF" := TrkgSpec."New Retest Date PROF";
        ReservationEntry."Sales Expiration Date PROF" := TrkgSpec."Sales Expiration Date PROF";
        ReservationEntry."Country/Region of Origin PROF" := TrkgSpec."Country/Region of Origin PROF";
    end;

}