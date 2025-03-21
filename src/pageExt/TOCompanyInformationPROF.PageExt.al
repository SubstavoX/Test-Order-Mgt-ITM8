pageextension 6208507 "TO Company Information PROF" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            field("Test Order Mgt PROF"; Rec."Test Order Mgt PROF")
            {
                ApplicationArea = All;
                ToolTip = 'Enable or disable the Test Order Management extension for this company.';
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            group(TestOrderManagementPROF)
            {
                Caption = 'Test Order Management';
                Image = Setup;

                action(EnableTOFeaturePROF)
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
                        ApplicationAreaSetup: Record "Application Area Setup";
                        FeatureManagement: Codeunit "TO Feature Management PROF";
                        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
                        FeatureStatusQst: Label 'Do you want to enable the Test Order Management extension for this company?';
                        AppID: Text[36];
                    begin
                        // Check if license is approved before enabling the feature
                        AppID := GetAppId();
                        if not LicenseFunctions.IsLicenseApproved(AppID) then
                            Error('The Test Order Management extension cannot be enabled because the license is not approved.');

                        if Confirm(FeatureStatusQst, false) then begin
                            FeatureManagement.SetEnabled(true);
                            if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then begin
                                ApplicationAreaSetup."Test Order Mgt PROF" := true;
                                ApplicationAreaSetup.Modify();
                            end;
                            Message('The Test Order Management extension has been enabled for this company.');
                            UpdateFeatureStatus();
                            CurrPage.Update(false);
                        end;
                    end;
                }

                action(DisableTOFeaturePROF)
                {
                    ApplicationArea = All;
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
                            CurrPage.Update(false);
                        end;
                    end;
                }

                action(CheckTOLicensePROF)
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
                        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
                        AppID: Text[36];
                    begin
                        AppID := GetAppId();
                        LicenseFunctions.ImmediateLicenseCheckRequest(AppID);
                    end;
                }
            }
        }
    }

    // Add GetAppId procedure to get the App ID for license check
    procedure GetAppId(): Text[36]
    var
        AppID: Text[36];
        AppGuidTxt: Text[38];
        AppInfo: ModuleInfo;
        ModuleInfoNotFoundLbl: Label 'Module info not found.';
    begin
        if not NavApp.GetCurrentModuleInfo(AppInfo) then
            Error(ModuleInfoNotFoundLbl);
        Evaluate(AppGuidTxt, LowerCase(AppInfo.Id));
        AppID := CopyStr(CopyStr(AppGuidTxt, 2, StrLen(AppGuidTxt) - 1), 1, MaxStrLen(AppID));
        exit(AppID);
    end;

    trigger OnOpenPage()
    var
        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
        AppID: Text[36];
    begin
        AppID := GetAppId();
        if not LicenseFunctions.IsLicenseApproved(AppID) then
            LicenseFunctions.EnvironmentCheck(AppID);

        UpdateFeatureStatus();
    end;

    local procedure UpdateFeatureStatus()
    var
        FeatureManagement: Codeunit "TO Feature Management PROF";
    begin
        IsFeatureEnabled := FeatureManagement.IsEnabled();
    end;

    var
        IsFeatureEnabled: Boolean;
}