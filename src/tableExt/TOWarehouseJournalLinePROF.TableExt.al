/// <summary>
/// TableExtension TO Warehouse Journal Line PROF (ID 6208510) extends Record Warehouse Journal Line.
/// </summary>
tableextension 6208510 "TO Warehouse Journal Line PROF" extends "Warehouse Journal Line"
{

    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                LotNoInfo: Record "Lot No. Information";
            begin
                if LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then begin
                    "Expiration Date" := LotNoInfo."Expiration Date PROF";
                    "Retest Date PROF" := LotNoInfo."Retest Date PROF";
                    "Sales Expiration Date PROF" := LotNoInfo."Sales Expiration Date PROF";
                    "Blocked PROF" := LotNoInfo.Blocked;
                    "Tracking Status PROF" := LotNoInfo."Lot Status PROF";
                end;
            end;
        }
        modify("Serial No.")
        {
            trigger OnAfterValidate()
            var
                SerialNoInfo: Record "Serial No. Information";
            begin
                if SerialNoInfo.Get("Item No.", "Variant Code", "Serial No.") then begin
                    "Expiration Date" := SerialNoInfo."Expiration Date PROF";
                    "Retest Date PROF" := SerialNoInfo."Retest Date PROF";
                    "Sales Expiration Date PROF" := SerialNoInfo."Sales Expiration Date PROF";
                    "Blocked PROF" := SerialNoInfo."Blocked";
                    "Tracking Status PROF" := SerialNoInfo."Serial Status PROF";
                end;
            end;
        }
        field(6208500; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;

            Editable = false;
        }

        field(6208501; "New Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'New Vendor Lot No.';
            DataClassification = SystemMetadata;

            Editable = false;
        }
        field(6208502; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;

            Editable = false;
        }
        field(6208503; "New Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'New Vendor Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(6208504; "Retest Date PROF"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;

        }
        field(6208505; "New Retest Date PROF"; Date)
        {
            Caption = 'New Retest Date';
            DataClassification = SystemMetadata;

        }
        field(6208506; "Blocked PROF"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = SystemMetadata;

        }
        field(6208507; "New Blocked PROF"; Boolean)
        {
            Caption = 'New Blocked';
            DataClassification = SystemMetadata;

        }
        field(6208508; "Tracking Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = SystemMetadata;

        }
        field(6208509; "Tracking Status (New) PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status (New)';
            BlankZero = true;
            DataClassification = SystemMetadata;

        }
        field(6208510; "Manual Adjustment PROF"; Boolean)
        {
            Caption = 'Manual Adjustment';
            DataClassification = SystemMetadata;
        }
        field(6208511; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208512; "New Location Code PROF"; Code[10])
        {
            Caption = 'New Location Code';
            DataClassification = SystemMetadata;
            TableRelation = Location;
        }
        field(6208513; "Value PROF"; Decimal)
        {
            DataClassification = SystemMetadata;
        }

    }
}