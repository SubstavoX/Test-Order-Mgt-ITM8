/// <summary>
/// TableExtension TO ItemJournalLine PROF (ID 6208502) extends Record Item Journal Line.
/// </summary>
tableextension 6208502 "TO ItemJournalLine PROF" extends "Item Journal Line"
{
    fields
    {
        field(6208500; "Vendor Lot No. PROF"; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;

            Editable = false;
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
        field(6208510; "Origin Document No. PROF"; Code[20])
        {
            Caption = 'Origin Document No.';
            DataClassification = SystemMetadata;
        }

        field(6208511; "Country/Region of Origin PROF"; Code[10])
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
        field(6208512; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208513; "EMCS Required PROF"; Option)
        {
            Caption = 'EMCS Required';
            OptionMembers = " ",EMCS,No;
            OptionCaption = ' ,EMCS,No';
            DataClassification = SystemMetadata;
            Editable = false;
        }

    }

    local procedure SyncronizeLotTracking()
    var
        TrackingAssignMgt: Codeunit "TO Tracking Assign Mgt. PROF";
    begin
        TrackingAssignMgt.SyncronizeLotTracking(Rec, xRec);
    end;
}