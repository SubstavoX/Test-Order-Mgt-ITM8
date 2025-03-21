/// <summary>
/// Table TO Usage Decision PROF (ID 6208504).
/// </summary>
table 6208504 "TO Usage Decision PROF"
{
    Caption = 'Usage Decision';
    LookupPageId = "TO Usage Decision List PROF";
    DrillDownPageId = "TO Usage Decision List PROF";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "New Test Order"; Boolean)
        {
            Caption = 'New Test Order';
            DataClassification = CustomerContent;
        }
        field(12; "Block Tracking No."; Boolean)
        {
            Caption = 'Block Tracking No.';
            DataClassification = CustomerContent;
        }

        field(13; "Tracking Status"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = CustomerContent;
        }
        field(20; "Show On Retest Order"; Boolean)
        {
            Caption = 'Show On Retest Order';
            DataClassification = CustomerContent;
        }
        field(21; "Show On Test or Manual Orders"; Boolean)
        {
            Caption = 'Show On Test or Manual Orders';
            DataClassification = CustomerContent;
        }
        field(30; "Not Update Lot No & Expir Date"; Boolean)
        {
            Caption = 'Not Update Lot No. and Expiration Date';
            DataClassification = CustomerContent;
        }
        field(31; "Not Upd. SerialNo & Expir Date"; Boolean)
        {
            Caption = 'Not Update Serial No. and Expiration Date';
            DataClassification = CustomerContent;
        }
        field(40; "Consume Blocked Lot"; Boolean)
        {
            Caption = 'Consume Blocked Lot';
            DataClassification = CustomerContent;
        }
        field(41; "Consume Blocked Serial No."; Boolean)
        {
            Caption = 'Consume Blocked Serial No.';
            DataClassification = CustomerContent;
        }


        field(42; "Default Usage Decision"; Boolean)
        {
            Caption = 'Default Usage Decision';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                UsageDecision: Record "TO Usage Decision PROF";
                DefaultAlreadyMarkedErr: Label 'You cannot mark this field because "Default Decision" is already marked on %1.', Comment = '%1=UsageDecision.Code';
            begin
                if Rec."Default Usage Decision" then begin
                    UsageDecision.SetRange("Default Usage Decision", true);
                    UsageDecision.SetFilter(Code, '<>%1', Rec.Code);
                    if UsageDecision.FindFirst() then
                        Dialog.Error(DefaultAlreadyMarkedErr, UsageDecision.Code);
                end;
            end;
        }
    }
    keys
    {
        key(PK; Code)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description, "Block Tracking No.", "Tracking Status", "New Test Order", "Not Update Lot No & Expir Date", "Not Upd. SerialNo & Expir Date")
        {
        }

    }
}