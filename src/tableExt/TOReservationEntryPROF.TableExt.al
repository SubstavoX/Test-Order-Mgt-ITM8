/// <summary>
/// TableExtension TO Reservation Entry PROF (ID 6208506) extends Record Reservation Entry.
/// </summary>
tableextension 6208506 "TO Reservation Entry PROF" extends "Reservation Entry"
{
    fields
    {
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

        }
        field(6208504; "Blocked PROF"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = SystemMetadata;

        }
        field(6208505; "New Blocked PROF"; Boolean)
        {
            Caption = 'New Blocked';
            DataClassification = SystemMetadata;

        }
        field(6208506; "Tracking Status PROF"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = SystemMetadata;

        }

        field(6208507; "Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;

        }
        field(6208508; "New Vendor Serial No. PROF"; Code[50])
        {
            Caption = 'New Vendor Serial No.';
            DataClassification = SystemMetadata;

        }




        field(6208509; "Country/Region of Origin PROF"; Code[10])
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
        field(6208510; "Sales Expiration Date PROF"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}