/// <summary>
/// TableExtension TO User Setup PROF (ID 6208508) extends Record User Setup.
/// </summary>
tableextension 6208508 "TO User Setup PROF" extends "User Setup"
{
    fields
    {
        field(6208500; "Location Code PROF"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(6208501; "Edit COA Item PROF"; Boolean)
        {
            Caption = 'Edit COA Item';
            DataClassification = CustomerContent;
        }
    }
}