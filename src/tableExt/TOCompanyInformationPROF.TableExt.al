/// <summary>
/// TableExtension TO Company Information PROF (ID 6208500) extends Record Company Information.
/// </summary>
tableextension 6208500 "TO Company Information PROF" extends "Company Information"
{
    fields
    {
        field(6208500; "TO Language Code PROF"; Code[10])
        {
            Caption = 'Langauge Code';
            DataClassification = SystemMetadata;
            TableRelation = Language;
        }
        field(6208501; "Restricted access value PROF"; Text[100])
        {
            Caption = 'Restricted access value';
            DataClassification = SystemMetadata;
        }
        field(6208502; "GS1 Company Prefix PROF"; Text[7])
        {
            Caption = 'GS1 Company Prefix';
            DataClassification = SystemMetadata;
        }
        field(6208503; "GS1-128 Nos. PROF"; Code[20])
        {
            Caption = 'GS1-128 Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series".Code;
        }
        field(6208504; "Company Type PROF"; Option)
        {
            Caption = 'Company Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Consolidation,Master,Test;
            OptionCaption = ' ,Consolidation,Master,Test';
        }
        field(6208505; "Test Order Mgt PROF"; Boolean)
        {
            Caption = 'Test Order Mgt';
            DataClassification = SystemMetadata;
        }
    }
}