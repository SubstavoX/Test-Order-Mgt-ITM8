/// <summary>
/// Table TO Setup PROF (ID 6208502).
/// </summary>
table 6208502 "TO Setup PROF"
{
    Caption = 'TO Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }


        field(20; "Test Order Nos."; Code[20])
        {
            Caption = 'Test Order Nos.';
            TableRelation = "No. Series";
        }
        field(23; "Lot Nos."; Code[20])
        {
            Caption = 'Lot Nos.';
            Description = '001:';
            TableRelation = "No. Series";
        }

        field(25; "Supplier Order Nos."; Code[20])
        {
            Caption = 'Supplier Order Nos.';
            TableRelation = "No. Series";
        }


        field(28; "Auto Create Lot No. Purchase"; Boolean)
        {
            Caption = 'Auto Create Lot No. Purchase';
        }
        field(29; "Serial Nos."; Code[20])
        {
            Caption = 'Serial Nos.';
            Description = '001:';
            TableRelation = "No. Series";
        }
        field(30; "Auto Create Serial No. Purch"; Boolean)
        {
            Caption = 'Auto Create Serial No. Purchase';
        }
        field(31; "Test Order Source Code"; Code[10])
        {
            Caption = 'Test Order Source Code';
            TableRelation = "Source Code";
        }
        field(32; "Test Order Open Page"; Option)
        {
            Caption = 'Test Order Open Page';
            OptionCaption = ' ,Retest Order,Manual Order,Both';
            OptionMembers = " ","Retest Order","Manual Order",Both;
        }
        field(39; "Lot No. Omit Check Label Print"; Boolean)
        {
            Caption = 'Tracking No. Omit Check Label Printed';
        }
        field(40; "Reclass Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Warehouse Journal Template";
        }
        field(41; "Reclass Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("Reclass Journal Template Name"));
        }
        field(42; "Warehouse Jnl. Template Name"; Code[10])
        {
            Caption = 'Warehouse Journal Template Name';
            TableRelation = "Warehouse Journal Template";

            trigger OnValidate()
            begin
                if "Warehouse Jnl. Template Name" = '' then begin
                    "Warehouse Journal Batch Name" := '';
                    if "Require Warehouse Pick" then
                        FieldError("Warehouse Jnl. Template Name", 'cannot be blank when warehouse pick is required');
                end;
            end;
        }
        field(43; "Warehouse Journal Batch Name"; Code[10])
        {
            Caption = 'Warehouse Journal Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("Warehouse Jnl. Template Name"));

            trigger OnValidate()
            begin
                if "Warehouse Journal Batch Name" <> '' then
                    TestField("Warehouse Jnl. Template Name");
                if ("Warehouse Journal Batch Name" = '') and "Require Warehouse Pick" then
                    FieldError("Warehouse Journal Batch Name", 'cannot be blank when warehouse pick is required');
            end;
        }
        field(44; "Require Warehouse Pick"; Boolean)
        {
            Caption = 'Require Warehouse Pick';

            trigger OnValidate()
            begin
                if "Require Warehouse Pick" then begin
                    TestField("Warehouse Jnl. Template Name");
                    TestField("Warehouse Journal Batch Name");
                end;
            end;
        }
        field(50; "Additional Currency (ACY)"; Code[10])
        {
            Caption = 'Additional Currency (ACY)';
            TableRelation = Currency;
        }

        field(73; "Commit Counter"; Integer)
        {
            Caption = 'Commit counter';
            MinValue = 0;
        }


        field(90; "Prepone Due Date SO Demand"; DateFormula)
        {
            Caption = 'Prepone Due Date Sales Order Demand';

            trigger OnValidate()
            var
                FirstChar: Text[1];
                WrongFirstCharErr: Label 'The date formula in the field must start with the character - (minus).';
            begin
                if Format(Rec."Prepone Due Date SO Demand") <> '' then begin
                    FirstChar := CopyStr(Format(Rec."Prepone Due Date SO Demand"), 1, 1);
                    if FirstChar <> '-' then
                        Dialog.Error(WrongFirstCharErr);
                end;
            end;
        }

        field(120; "Shipm. Method Price Letter"; Code[10])
        {
            Caption = 'Shipment Method for Price Letter';
            TableRelation = "Shipment Method";
        }
        field(150; "Stop Phys. Invt. Posting"; Boolean)
        {
            Caption = 'Stop Phys. Invt. Posting';
            Description = 'PF1.14';
        }
        field(200; "CRM Path"; Text[200])
        {
            Caption = 'CRM Path';

            trigger OnValidate()
            begin
                if "CRM Path" <> '' then
                    if CopyStr("CRM Path", StrLen("CRM Path"), 1) <> '\' then
                        "CRM Path" := CopyStr("CRM Path" + '\', 1, MaxStrLen("CRM Path"));
            end;
        }

        field(400; "Use Calc Low-Level Queue"; Boolean)
        {
            Caption = 'Use Calc Low-Level Queue';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if not "Use Calc Low-Level Queue" then
                    if "Immediate Calc Low-Level Queue" then
                        "Immediate Calc Low-Level Queue" := false;
            end;
        }
        field(401; "Immediate Calc Low-Level Queue"; Boolean)
        {
            Caption = 'Immediate Calc Low-Level Queue';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if "Immediate Calc Low-Level Queue" then
                    if not "Use Calc Low-Level Queue" then
                        "Use Calc Low-Level Queue" := true;
            end;
        }




    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    local procedure DebugDialog(DebugText: Text)
    var
        DebuggingContinueProcessQst: Label '(Debugging) Continue process ?';
        DebuggingProcessStoppedErr: Label '(Debugging) Process stopped.';
    begin
        if GuiAllowed then begin
            if not Confirm(DebuggingContinueProcessQst + ' \' + DebugText, false) then
                error(DebuggingProcessStoppedErr);
        end else
            Message(DebugText);
    end;

    var
}
