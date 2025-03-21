/// <summary>
/// TableExtension TO Lot No. Information PROF (ID 6208505) extends Record Lot No. Information.
/// </summary>
tableextension 6208505 "TO Lot No. Information PROF" extends "Lot No. Information"
{
    fields
    {
        modify(Comment)
        {
            Caption = 'Comment Exists';
        }
        field(6208500; "Original Lot No. PROF"; Code[50])
        {
            Caption = 'Original Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208501; "Block Usage PROF"; Boolean)
        {
            Caption = 'Block Usage';
            DataClassification = SystemMetadata;
        }
        field(6208502; "Creation Date Time PROF"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208503; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208504; "Expiration Date PROF"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208505; "Original Expiration Date PROF"; Date)
        {
            Caption = 'Original Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208506; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208507; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;
            Editable = false;
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
        field(6208509; "Test Order No. PROF"; Code[20])
        {
            Caption = 'Test Order No.';
            TableRelation = "TO Test Order PROF";
            ValidateTableRelation = false;
            DataClassification = SystemMetadata;
            Editable = false;

            trigger OnLookup()
            var
                TOTestOrder: Record "TO Test Order PROF";
            begin
                if "Test Order No. PROF" = '' then
                    exit;
                if TOTestOrder.Get("Test Order No. PROF") then begin
                    TOTestOrder.FilterGroup(4);
                    TOTestOrder.SetRange("Test Order No.", TOTestOrder."Test Order No.");
                    TOTestOrder.FilterGroup(0);
                    Page.Run(Page::"TO Test Order Card PROF", TOTestOrder);
                end;
            end;
        }
        field(6208510; "Internal Use Only PROF"; Boolean)
        {
            Caption = 'Internal Use Only';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208511; "Local Impact PROF"; Boolean)
        {
            Caption = 'Local Impact';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208512; "Lot Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Lot Status';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208513; "No. Printed PROF"; Integer)
        {
            Caption = 'No. Printed';
            DataClassification = SystemMetadata;
            BlankZero = true;
            Editable = false;
        }
        field(6208514; "Last Printed Date PROF"; Date)
        {
            Caption = 'Last Printed Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208515; "Approved for Internal use PROF"; Boolean)
        {
            Caption = 'Approved for Internal use';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Approved for Internal use PROF" where("No." = field("Item No.")));
            Editable = false;
        }
        field(6208516; "From Company Name PROF"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            ValidateTableRelation = false;
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(6208517; "Bin Content PROF"; Decimal)
        {
            Caption = 'Bin Content';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry"."Qty. (Base)" where("Location Code" = field("Location Filter"),
                                                                     "Item No." = field("Item No."),
                                                                     "Lot No." = field("Lot No."),
                                                                     "Zone Code" = field("Zone Filter PROF"),
                                                                     "Bin Code" = field("Bin Filter")));
            DecimalPlaces = 0 : 5;
            Description = '003:';
            Editable = false;
        }
        field(6208518; "Correction PROF"; Decimal)
        {
            Caption = 'Correction';
            FieldClass = FlowField;
            CalcFormula = - sum("Warehouse Entry"."Qty. (Base)" where("Item No." = field("Item No."),
                                                                      "Lot No." = field("Lot No."),
                                                                      "Bin Code" = field("Adjustment Bin Filter PROF")));
            DecimalPlaces = 0 : 5;
            Description = 'PF1.03,002:';
            Editable = false;
        }
        field(6208519; "Qty. on Component Lines PROF"; Decimal)
        {
            Caption = 'Qty. on Component Lines';
            FieldClass = FlowField;
            CalcFormula = sum("Prod. Order Component"."Remaining Qty. (Base)" where(Status = filter(Planned .. Released), "Item No." = field("Item No."), "Location Code" = field("Location Filter"), "Variant Code" = field("Variant Code")));
            Editable = false;
        }
        field(6208520; "Comment Description PROF"; Text[80])
        {
            Caption = 'Comment First Line';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Tracking Comment".Comment where(Type = const("Lot No."),
                                                                       "Item No." = field("Item No."),
                                                                       "Variant Code" = field("Variant Code"),
                                                                       "Serial/Lot No." = field("Lot No.")));
            Editable = false;

            trigger OnLookup()
            var
                ItemTrackingComment: Record "Item Tracking Comment";
                ItemTrackingCommentsPage: Page "Item Tracking Comments";
            begin
                if ("Item No." = '') or ("Lot No." = '') then
                    exit;
                ItemTrackingComment.FilterGroup(2);
                ItemTrackingComment.SetRange(Type, ItemTrackingComment.Type::"Lot No.");
                ItemTrackingComment.SetRange("Item No.", "Item No.");
                ItemTrackingComment.SetRange("Variant Code", "Variant Code");
                ItemTrackingComment.SetRange("Serial/Lot No.", "Lot No.");
                ItemTrackingComment.FilterGroup(0);
                Clear(ItemTrackingCommentsPage);
                ItemTrackingCommentsPage.SetTableView(ItemTrackingComment);
                ItemTrackingCommentsPage.RunModal();
                CalcFields(Comment, "Comment Description PROF");
            end;
        }
        field(6208521; "Adjustment Bin Filter PROF"; Code[20])
        {
            Caption = 'Adjustment Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code where("Location Code" = field("Location Filter"));
            Description = '002:';
        }
        field(6208522; "Zone Filter PROF"; Code[10])
        {
            Caption = 'Zone Filter';
            FieldClass = FlowFilter;
            TableRelation = Zone.Code where("Location Code" = field("Location Filter"));
            Description = '002:';
        }
        field(6208523; "Usage Decision PROF"; Code[20])
        {
            Caption = 'Usage Decision';
            TableRelation = "TO Usage Decision PROF";
            DataClassification = SystemMetadata;
        }

        modify(Blocked)
        {
            trigger OnBeforeValidate()
            var
                Item: Record Item;
                ErrorMsg: Label 'You cannot directly modify the Blocked field for items with QC Required enabled. Use the Test Order page instead.';
            begin
                if "Item No." <> '' then
                    if xRec.Blocked <> Rec.Blocked then
                        if Item.Get("Item No.") then
                            if Item."QC Required PROF" then
                                Error(ErrorMsg);
            end;
        }
    }

    trigger OnBeforeInsert()
    begin
        "Creation Date Time PROF" := CurrentDateTime();
        "No. Printed PROF" := 0;
        "Last Printed Date PROF" := 0D;
        if "Original Lot No. PROF" = '' then
            "Original Lot No. PROF" := "Lot No.";
        if "Original Expiration Date PROF" = 0D then
            "Original Expiration Date PROF" := "Expiration Date PROF";
    end;

    trigger OnDelete()
    var
        DeleteNotAllowedErr: Label 'You are not allowed to delete Lot No. Information records.';
    begin
        Error(DeleteNotAllowedErr);
    end;

    trigger OnBeforeModify()
    var
        Item: Record Item;
        ErrorMsg: Label 'You cannot directly modify the Blocked field for items with QC Required enabled. Use the Test Order page instead.';
    begin
        if "Item No." <> '' then
            if xRec.Blocked <> Rec.Blocked then
                if Item.Get("Item No.") then
                    if Item."QC Required PROF" then
                        Error(ErrorMsg);
    end;
}