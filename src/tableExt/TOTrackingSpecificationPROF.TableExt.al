/// <summary>
/// TableExtension TO Tracking Specification PROF (ID 6208507) extends Record Tracking Specification.
/// </summary>
tableextension 6208507 "TO Tracking Specification PROF" extends "Tracking Specification"
{

    fields
    {
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
            begin
                CheckLabelPrintedError(FieldCaption("Expiration Date"));

                if not Item.Get("Item No.") then
                    exit;

                if "Expiration Date" = 0D then begin
                    "Retest Date PROF" := 0D;
                    "Sales Expiration Date PROF" := 0D;
                end else
                    // Use CalculateTrackingInfo to ensure consistent calculation
                    TrackingAssignMgt.CalculateTrackingInfo(
                        "Serial No.",
                        "Lot No.",
                        "Expiration Date",
                        "Retest Date PROF",
                        "Sales Expiration Date PROF",
                        "Country/Region of Origin PROF",
                        Item);
            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                SetItemTrkg();
            end;
        }

        modify("Serial No.")
        {
            trigger OnAfterValidate()
            begin
                SetItemTrkgSerial();
            end;
        }
        modify("New Expiration Date")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if "New Expiration Date" = 0D then
                    "New Retest Date PROF" := 0D
                else
                    if Item.Get("Item No.") and (Format(Item."Retest Calculation PROF") <> '') then
                        "New Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", "New Expiration Date")
            end;
        }
        field(6208500; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;
        }
        field(6208501; "New Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'New Vendor Lot No.';
            DataClassification = SystemMetadata;
        }
        field(6208502; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208503; "New Retest Date PROF"; Date)
        {
            Caption = 'New Retest Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208504; "Tracking Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = SystemMetadata;

        }
        field(6208505; "Tracking Status (New) PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status (New)';
            BlankZero = true;
            DataClassification = SystemMetadata;

        }

        field(6208506; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;

        }
        field(6208507; "New Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'New Vendor Serial No.';
            DataClassification = SystemMetadata;

        }




        field(6208508; "Country/Region of Origin PROF"; Code[10])
        {
            Caption = 'Country/Region of Origin';
            TableRelation = "Country/Region".Code;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
                CityL: Text[30];
                PostCodeCodeL: Code[20];
                CountyL: Text[30];
            begin
                PostCode.ValidateCountryCode(CityL, PostCodeCodeL, CountyL, "Country/Region of Origin PROF");
            end;
        }
        field(6208509; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    local procedure SetItemTrkg()
    var
        ICPartner: Record "IC Partner";
        Item: Record Item;
        LotNoInfo: Record "Lot No. Information";
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        UsageDecision: Record "TO Usage Decision PROF";
        TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
        LotNoBlockedError: Boolean;
        BlockedUsageErr: Label 'Lot No. %1 is blocked for usage.', Comment = '%1 = Lot No.';
        BlockedLotErr: Label 'Lot No. %1 is blocked.', Comment = '%1 = Lot No.';
    begin
        if ("Lot No." = xRec."Lot No.") and ("Serial No." = xRec."Serial No.") and ("Item No." = xRec."Item No.") then
            exit;

        if not Item.Get("Item No.") then
            exit;

        Clear(LotNoInfo);
        if not LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then
            //     if not (Item."Bulk Item No." in ['', Item."No."]) then
            //       if not LotNoInfo.Get(Item."Bulk Item No.", "Variant Code", "Lot No.") then;
            if LotNoInfo."Item No." <> '' then begin
                if LotNoInfo."Block Usage PROF" then
                    Dialog.Error(BlockedUsageErr, LotNoInfo."Lot No.");

                if LotNoInfo."Usage Decision PROF" <> '' then
                    UsageDecision.Get(LotNoInfo."Usage Decision PROF");

                if Rec."Source Prod. Order Line" > 0 then begin
                    ProdOrderLine.SetRange("Prod. Order No.", Rec."Source ID");
                    ProdOrderLine.SetRange("Line No.", Rec."Source Prod. Order Line");
                    if ProdOrderLine.FindFirst() then begin
                        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
                        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                        ProdOrderComponent.SetRange("Line No.", Rec."Source Ref. No.");
                        if ProdOrderComponent.FindFirst() then
                            if LotNoInfo.Blocked then
                                // if not ProdOrderComponent."TO Consume Blocked Lot PROF" or not UsageDecision."Consume Blocked Lot" then
                                Dialog.Error(BlockedLotErr, LotNoInfo."Lot No.");
                    end;
                end;

                SalesLine.SetRange("Document No.", Rec."Source ID");
                SalesLine.SetRange("Line No.", Rec."Source Ref. No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                if SalesLine.FindFirst() then
                    if LotNoInfo.Blocked then begin
                        LotNoBlockedError := true;
                        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                            if SalesHeader."Sell-to IC Partner Code" <> '' then begin
                                ICPartner.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                                ICPartner.SetRange(Code, SalesHeader."Sell-to IC Partner Code");
                                if not ICPartner.IsEmpty then
                                    //  if UsageDecision."IC Sales Blocked Lot" and SalesLine."TO IC Sales Blocked Lot PROF" then
                                    LotNoBlockedError := false;
                            end;
                        if LotNoBlockedError then
                            Dialog.Error(BlockedLotErr, LotNoInfo."Lot No.");
                    end;

                "Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
                "Country/Region of Origin PROF" := LotNoInfo."Country/Region of Origin PROF";
                "Retest Date PROF" := LotNoInfo."Retest Date PROF";
                "Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";

                if (LotNoInfo."Expiration Date PROF" <> 0D) then
                    "Expiration Date" := LotNoInfo."Expiration Date PROF";

                "Tracking Status PROF" := LotNoInfo."Lot Status PROF";

                if IsReclass() then begin
                    "New Vendor Lot No. PROF" := "Vendor Lot No. PROF";
                    "New Retest Date PROF" := "Retest Date PROF";
                end;
            end else begin
                if "Lot No." <> '' then
                    TrackingAssignMgt.CalculateTrackingInfo("Serial No.", "Lot No.", "Expiration Date", "Retest Date PROF", "Sales Expiration Date PROF", "Country/Region of Origin PROF", Item);
                if not Item."QC Required PROF" then
                    "Tracking Status PROF" := "Tracking Status PROF"::Approved
                else
                    "Tracking Status PROF" := "Tracking Status PROF"::"Not Tested";
            end;
    end;

    local procedure SetItemTrkgSerial()
    var
        ICPartner: Record "IC Partner";
        Item: Record Item;
        SerialNoInfo: Record "Serial No. Information";
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        UsageDecision: Record "TO Usage Decision PROF";
        TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
        SerialNoBlockedError: Boolean;
        BlockedUsageErr: Label 'Serial No. %1 is blocked for usage.', Comment = '%1 = Serial No.';
        BlockedSerialNoErr: Label 'Serial No. %1 is blocked.', Comment = '%1 = Serial No.';
    begin
        if ("Lot No." = xRec."Lot No.") and ("Serial No." = xRec."Serial No.") and ("Item No." = xRec."Item No.") then
            exit;

        if not Item.Get("Item No.") then
            exit;

        Clear(SerialNoInfo);
        if not SerialNoInfo.Get("Item No.", "Variant Code", "Serial No.") then
            if SerialNoInfo."Item No." <> '' then begin
                if SerialNoInfo."Block Usage PROF" then
                    Dialog.Error(BlockedUsageErr, SerialNoInfo."Serial No.");

                if SerialNoInfo."Usage Decision PROF" <> '' then
                    UsageDecision.Get(SerialNoInfo."Usage Decision PROF");

                if Rec."Source Prod. Order Line" > 0 then begin
                    ProdOrderLine.SetRange("Prod. Order No.", Rec."Source ID");
                    ProdOrderLine.SetRange("Line No.", Rec."Source Prod. Order Line");
                    if ProdOrderLine.FindFirst() then begin
                        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
                        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                        ProdOrderComponent.SetRange("Line No.", Rec."Source Ref. No.");
                        if ProdOrderComponent.FindFirst() then
                            if SerialNoInfo.Blocked then
                                Dialog.Error(BlockedSerialNoErr, SerialNoInfo."Serial No.");
                    end;
                end;

                SalesLine.SetRange("Document No.", Rec."Source ID");
                SalesLine.SetRange("Line No.", Rec."Source Ref. No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                if SalesLine.FindFirst() then
                    if SerialNoInfo.Blocked then begin
                        SerialNoBlockedError := true;
                        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                            if SalesHeader."Sell-to IC Partner Code" <> '' then begin
                                ICPartner.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                                ICPartner.SetRange(Code, SalesHeader."Sell-to IC Partner Code");
                                if not ICPartner.IsEmpty then
                                    SerialNoBlockedError := false;
                            end;
                        if SerialNoBlockedError then
                            Dialog.Error(BlockedSerialNoErr, SerialNoInfo."Serial No.");
                    end;

                "Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                "Country/Region of Origin PROF" := SerialNoInfo."Country/Region of Origin PROF";
                "Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                "Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";

                if (SerialNoInfo."Expiration Date PROF" <> 0D) then
                    "Expiration Date" := SerialNoInfo."Expiration Date PROF";

                "Tracking Status PROF" := SerialNoInfo."Serial Status PROF";

                if IsReclass() then begin
                    "New Vendor Serial No. PROF" := "Vendor Serial No. PROF";
                    "New Retest Date PROF" := "Retest Date PROF";
                end;
            end else begin
                if "Serial No." <> '' then
                    TrackingAssignMgt.CalculateTrackingInfo("Serial No.", "Lot No.", "Expiration Date", "Retest Date PROF", "Sales Expiration Date PROF", "Country/Region of Origin PROF", Item);
                if not Item."QC Required PROF" then
                    "Tracking Status PROF" := "Tracking Status PROF"::Approved
                else
                    "Tracking Status PROF" := "Tracking Status PROF"::"Not Tested";
            end;
    end;

    local procedure CheckLabelPrintedError(FieldNameText: Text)
    var
        LotNoInfo: Record "Lot No. Information";
        TOSetup: Record "TO Setup PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
        YouCannotChangeExpirationDateLbl: Label 'You cannot change "%1" because label is already printed.', Comment = '%1 = field name';
    begin
        if LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then
            if TOLotManagement.LabelHasBeenPrinted(LotNoInfo) then
                if (not TOSetup.Get()) or (not TOSetup."Lot No. Omit Check Label Print") then
                    Error(YouCannotChangeExpirationDateLbl, FieldNameText);
    end;
}