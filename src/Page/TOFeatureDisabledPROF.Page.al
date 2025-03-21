/// <summary>
/// Page TO Feature Disabled PROF (ID 6208506).
/// </summary>
page 6208511 "TO Feature Disabled PROF"
{
    Caption = 'Test Order Management';
    PageType = Card;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Feature Status';
                InstructionalText = 'Manage the Test Order Management extension for this company.';

                field(FeatureStatus; FeatureStatusText)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Specifies whether the Test Order Management extension is enabled or disabled.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EnableFeature)
            {
                ApplicationArea = All;
                Caption = 'Enable Feature';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Enable the Test Order Management extension for this company.';
                Enabled = not IsFeatureEnabled;

                trigger OnAction()
                var
                    FeatureManagement: Codeunit "TO Feature Management PROF";
                begin
                    FeatureManagement.CheckLicense(2); // Enable Feature.
                    UpdateFeatureStatus();
                end;
            }

            action(DisableFeature)
            {
                Caption = 'Disable Feature';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Disable the Test Order Management extension for this company.';
                Enabled = IsFeatureEnabled;

                trigger OnAction()
                var
                    ApplicationAreaSetup: Record "Application Area Setup";
                    FeatureManagement: Codeunit "TO Feature Management PROF";
                    ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                    FeatureStatusQst: Label 'Do you want to disable the Test Order Management extension for this company?';

                begin
                    if Confirm(FeatureStatusQst, false) then begin
                        FeatureManagement.SetEnabled(false);
                        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then begin
                            ApplicationAreaSetup."Test Order Mgt PROF" := false;
                            ApplicationAreaSetup.Modify();
                        end;
                        Message('The Test Order Management extension has been disabled for this company.');
                        UpdateFeatureStatus();
                    end;
                end;
            }

            action(CheckLicense)
            {
                ApplicationArea = All;
                Caption = 'Check License';
                Image = ApprovalSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Check the license status for the Test Order Management extension.';

                trigger OnAction()
                var
                    FeatureManagement: Codeunit "TO Feature Management PROF";
                begin
                    FeatureManagement.CheckLicense(0);  // Immediate License Check.
                    UpdateFeatureStatus();
                end;
            }
        }
    }
    // Add GetAppId procedure to get the App ID for license check
    trigger OnOpenPage()
    var
        FeatureManagement: Codeunit "TO Feature Management PROF";
    begin
        FeatureManagement.CheckLicense(1);  // Full Check.
        UpdateFeatureStatus();
    end;

    local procedure UpdateFeatureStatus()
    var
        FeatureManagement: Codeunit "TO Feature Management PROF";
    begin
        IsFeatureEnabled := FeatureManagement.IsEnabled();
        if IsFeatureEnabled then // TODO: change to enum.
            FeatureStatusText := 'Enabled'
        else
            FeatureStatusText := 'Disabled';
    end;

    var
        IsFeatureEnabled: Boolean;
        FeatureStatusText: Text;
}