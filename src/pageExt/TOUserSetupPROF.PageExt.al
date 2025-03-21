/// <summary>
/// PageExtension TO User Setup PROF (ID 6208502) extends Record User Setup.
/// </summary>
pageextension 6208502 "TO User Setup PROF" extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Location Code PROF"; Rec."Location Code PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the default location code for this user.';
                Caption = 'Location Code';
            }
            field("Edit COA Item PROF"; Rec."Edit COA Item PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies if the user has permission to edit the Certificate of Analysis requirement on items.';
                Caption = 'Edit COA Item';
            }
        }
    }
}