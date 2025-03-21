/// <summary>
/// TableExtension TO Whse Item Track. Line PROF (ID 6208511) extends Record Whse. Item Tracking Line.
/// </summary>
tableextension 6208511 "TO Whse Item Track. Line PROF" extends "Whse. Item Tracking Line"
{

    fields
    {

        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                CheckLabelPrintedError(FieldCaption("Expiration Date"));

                if "Expiration Date" = 0D then begin
                    "Retest Date PROF" := 0D;
                    "Sales Expiration Date PROF" := 0D;
                end else
                    if Item.Get("Item No.") then begin
                        if Format(Item."Retest Calculation PROF") <> '' then
                            "Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", "Expiration Date");
                        if Format(Item."Sales Expiration Calc. PROF") <> '' then
                            "Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", "Expiration Date");
                    end;
            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                LotNoInfo: Record "Lot No. Information";
                TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
                BlockedUsageErr: Label 'Lot No. %1 is blocked for usage.', Comment = '%1 = Lot No.';
            begin
                if ("Lot No." = xRec."Lot No.") and ("Serial No." = xRec."Serial No.") and ("Item No." = xRec."Item No.") then
                    exit;

                if not Item.Get("Item No.") then
                    exit;

                Clear(LotNoInfo);
                if not LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then
                    //  if not (Item."Bulk Item No." in ['', Item."No."]) then
                    //    if not LotNoInfo.Get(Item."Bulk Item No.", "Variant Code", "Lot No.") then;
                    if LotNoInfo."Item No." <> '' then begin
                        if LotNoInfo."Block Usage PROF" then
                            Dialog.Error(BlockedUsageErr, LotNoInfo."Lot No.");

                        "Vendor Lot No. PROF" := LotNoInfo."Vendor Lot No. PROF";
                        "Country/Region of Origin PROF" := LotNoInfo."Country/Region of Origin PROF";
                        "Retest Date PROF" := LotNoInfo."Retest Date PROF";
                        "Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";

                        if ("Expiration Date" = 0D) and (LotNoInfo."Expiration Date PROF" <> 0D) then
                            if ("Source Type" = Database::"Item Journal Line") and ("Source Subtype" = 5) then
                                "Expiration Date" := LotNoInfo."Expiration Date PROF"
                            else
                                if ("Source Type" = Database::"Prod. Order Line") and ("Source Subtype" = 3) then
                                    "Expiration Date" := LotNoInfo."Expiration Date PROF";
                        "Tracking Status PROF" := LotNoInfo."Lot Status PROF";
                    end else begin
                        if "Lot No." <> '' then
                            TrackingAssignMgt.CalculateTrackingInfo("Serial No.", "Lot No.", "Expiration Date", "Retest Date PROF", "Sales Expiration Date PROF", "Country/Region of Origin PROF", Item);
                        if not Item."QC Required PROF" then
                            "Tracking Status PROF" := "Tracking Status PROF"::Approved
                        else
                            "Tracking Status PROF" := "Tracking Status PROF"::"Not Tested";
                    end;
            end;
        }
        modify("Serial No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                SerialNoInfo: Record "Serial No. Information";
                TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
                BlockedUsageErr: Label 'Serial No. %1 is blocked for usage.', Comment = '%1 = Serial No.';
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

                        "Vendor Serial No. PROF" := SerialNoInfo."Vendor Serial No. PROF";
                        "Country/Region of Origin PROF" := SerialNoInfo."Country/Region of Origin PROF";
                        "Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                        "Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";

                        if ("Expiration Date" = 0D) and (SerialNoInfo."Expiration Date PROF" <> 0D) then
                            if ("Source Type" = Database::"Item Journal Line") and ("Source Subtype" = 5) then
                                "Expiration Date" := SerialNoInfo."Expiration Date PROF"
                            else
                                if ("Source Type" = Database::"Prod. Order Line") and ("Source Subtype" = 3) then
                                    "Expiration Date" := SerialNoInfo."Expiration Date PROF";
                        "Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
                    end else begin
                        if "Serial No." <> '' then
                            TrackingAssignMgt.CalculateTrackingInfo("Serial No.", "Lot No.", "Expiration Date", "Retest Date PROF", "Sales Expiration Date PROF", "Country/Region of Origin PROF", Item);
                        if not Item."QC Required PROF" then
                            "Tracking Status PROF" := "Tracking Status PROF"::Approved
                        else
                            "Tracking Status PROF" := "Tracking Status PROF"::"Not Tested";
                    end;
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
        field(6208501; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208502; "New Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'New Vendor Lot No.';
            DataClassification = SystemMetadata;

        }
        field(6208503; "New Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'New Vendor Serial No.';
            DataClassification = SystemMetadata;
        }
        field(6208504; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;

            Editable = false;
        }
        field(6208505; "New Retest Date PROF"; Date)
        {
            Caption = 'New Retest Date';
            DataClassification = SystemMetadata;

            Editable = false;
        }
        field(6208506; "Tracking Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Lot Status';
            DataClassification = SystemMetadata;

        }
        field(6208507; "Lot Status (New) PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Lot Status (New)';
            BlankZero = true;
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