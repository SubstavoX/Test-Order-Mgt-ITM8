
pageextension 6208508 "TO Business Manager RC PROF" extends "Business Manager Role Center"
{

    actions
    {
        addlast(sections)
        {
            group(TestOrderManagementPROF)
            {
                Caption = 'Test Order Management';
                Image = Administration;


                action(TOFeatureTogglePROF)
                {
                    ApplicationArea = All;
                    Caption = 'Enable/Disable Test Order Management';
                    Image = Setup;
                    RunObject = Page "TO Setup Card PROF";
                    ToolTip = 'Enable or disable the Test Order Management extension for this company.';
                }
            }
        }
    }
}