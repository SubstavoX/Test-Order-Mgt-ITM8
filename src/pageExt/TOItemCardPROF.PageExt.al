/// <summary>
/// PageExtension TO Item Card PROF (ID 6208500) extends Record Item Card.
/// </summary>
pageextension 6208506 "TO Item Card PROF" extends "Item Card"
{
    layout
    {
        addafter("Item Tracking Code")
        {
            group(TestOrderSetupPROF)
            {
                Caption = 'Test Order Setup';

                field("QC Required PROF"; Rec."QC Required PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies if quality control is required for this item.';
                    Caption = 'QC Required';
                }
                field("Retest Calculation PROF"; Rec."Retest Calculation PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies the formula for calculating the retest date.';
                    Caption = 'Retest Calculation';
                }
                field("Sales Expiration Calculation PROF"; Rec."Sales Expiration Calc. PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies the formula for calculating the sales expiration date.';
                    Caption = 'Sales Expiration Calculation';
                }
                field("Require COA PROF"; Rec."Require COA PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies if a Certificate of Analysis is required for this item.';
                    Caption = 'Require COA';
                }
                field("TO Test Order Internal Use PROF"; Rec."TO Test Order Intern Use PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies if this item is for internal test order use.';
                    Caption = 'Test Order Internal Use';
                }
                field("Internal Use Only PROF"; Rec."Internal Use Only PROF")
                {
                    ApplicationArea = TestOrderMgtPROF;
                    ToolTip = 'Specifies if this item is for internal use only.';
                    Caption = 'Internal Use Only';
                }
            }
        }
    }
}