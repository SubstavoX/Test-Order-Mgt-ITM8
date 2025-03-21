/// <summary>
/// TableExtension TO Item Tracing Buffer PROF (ID 6208504) extends Record Item Tracing Buffer.
/// </summary>
tableextension 6208504 "TO Item Tracing Buffer PROF" extends "Item Tracing Buffer"
{

    fields
    {
        field(6208500; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Vendor Lot No. PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }

        field(6208501; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Serial No. Information"."Vendor Serial No. PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Serial No." = field("Serial No.")));

            Editable = false;
        }
        field(6208502; "Original Expiration Date PROF"; Date)
        {
            Caption = 'Original Expiration Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Original Expiration Date PROF" where("Item No." = field("Item No."),
                                                                                        "Variant Code" = field("Variant Code"),
                                                                                        "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208503; "Expiration Date PROF"; Date)
        {
            Caption = 'Expiration Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Expiration Date PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208504; "Creation Time PROF"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = SystemMetadata;

        }
        field(6208505; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Retest Date PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208506; "Blocked PROF"; Boolean)
        {
            Caption = 'Blocked';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information".Blocked where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208507; "Lot Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Lot Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Lot Status PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208508; "Original Lot No. PROF"; Code[50])
        {
            Caption = 'Original Lot No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Original Lot No. PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));

            Editable = false;
        }
        field(6208509; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208510; "Original Serial No. PROF"; Code[50])
        {
            Caption = 'Original Serial No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Serial No. Information"."Original Serial No. PROF" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Serial No." = field("Serial No.")));

            Editable = false;
        }
    }
}