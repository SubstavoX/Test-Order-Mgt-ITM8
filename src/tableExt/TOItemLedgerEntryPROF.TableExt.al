
/// <summary>
/// TableExtension TO Item Ledger Entry PROF (ID 6208503) extends Record Item Ledger Entry.
/// </summary>
tableextension 6208503 "TO Item Ledger Entry PROF" extends "Item Ledger Entry"
{

    fields
    {
        field(6208500; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(6208501; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;
        }
        field(6208502; "Blocked Lot No. Info PROF"; Boolean)
        {
            Caption = 'Blocked';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information".Blocked where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
        field(6208503; "Tracking Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = SystemMetadata;
        }
        field(6208504; "Origin Document No. PROF"; Code[20])
        {
            Caption = 'Origin Document No.';
            DataClassification = SystemMetadata;
        }
        field(6208505; "Source Name PROF"; Text[100])
        {
            Caption = 'Source Name';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208506; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208507; "Bulk Item No. PROF"; Code[20])
        {
            Caption = 'Bulk Item No.';
            DataClassification = SystemMetadata;
            TableRelation = Item;
        }
        field(6208508; "EMCS Required PROF"; Option)
        {
            Caption = 'EMCS Required';
            OptionMembers = " ",EMCS,No;
            OptionCaption = ' ,EMCS,No';
            DataClassification = SystemMetadata;
        }
        field(6208509; "Reason Code PROF"; Code[10])
        {
            Caption = 'Reason Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Value Entry"."Reason Code" where("Item Ledger Entry No." = field("Entry No.")));
            Editable = false;
        }
        field(6208510; "Item Description PROF"; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }

        field(6208511; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;
        }
        field(6208512; "Original Serial No. PROF"; Code[50])
        {
            Caption = 'Original Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208513; "Usage Decision PROF"; Code[20])
        {
            Caption = 'Usage Decision';
            TableRelation = "TO Usage Decision PROF";
            DataClassification = SystemMetadata;
        }

        field(6208514; "Country/Region of Origin PROF"; Code[10])
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
        field(6208515; "Original Expiration Date PROF"; Date)
        {
            Caption = 'Original Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208516; "Creation Date Time PROF"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208517; "Test Order No. PROF"; Code[20])
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
        field(6208518; "Internal Use Only PROF"; Boolean)
        {
            Caption = 'Internal Use Only';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208519; "Local Impact PROF"; Boolean)
        {
            Caption = 'Local Impact';
            DataClassification = SystemMetadata;
            Editable = false;
        }


    }
    keys
    {
        key(Key21PROF; "Vendor Serial No. PROF")
        {
        }
    }
}