/// <summary>
/// Page TO Usage Decision List PROF (ID 6208509).
/// </summary>
page 6208509 "TO Usage Decision List PROF"
{
    ApplicationArea = TestOrderMgtPROF;
    Caption = 'Usage Decisions';
    PageType = List;
    SourceTable = "TO Usage Decision PROF";
    UsageCategory = Lists;
    CardPageId = "TO Usage Decision Card PROF";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the usage decision.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the usage decision.';
                }
                field("Tracking Status"; Rec."Tracking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tracking status for this usage decision.';
                }
                field("Block Tracking No."; Rec."Block Tracking No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the lot number should be blocked.';
                }
                field("New Test Order"; Rec."New Test Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if a new test order should be created.';
                }
                field("Default Usage Decision"; Rec."Default Usage Decision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this is the default usage decision.';
                }
                field("Show On Test or Manual Orders"; Rec."Show On Test or Manual Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this decision should be shown on test or manual orders.';
                }
                field("Show On Retest Order"; Rec."Show On Retest Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this decision should be shown on retest orders.';
                }
                field("Not Update Lot No & Expir Date"; Rec."Not Update Lot No & Expir Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if lot number and extion date should not be updated.';
                }
            }
        }
    }


}