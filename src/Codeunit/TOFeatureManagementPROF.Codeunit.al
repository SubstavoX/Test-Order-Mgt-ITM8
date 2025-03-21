
codeunit 6208506 "TO Feature Management PROF"
{

    internal procedure CheckLicense(CheckMode: Option)
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
        AppID: Text[36];
        FeatureStatusQst: Label 'Do you want to enable the Test Order Management extension for this company?';
    begin
        // Check if license is approved before enabling the feature
        AppID := GetAppId();
        case CheckMode of
            0: // Immediate License Check.
                LicenseFunctions.ImmediateLicenseCheckRequest(AppID);
            1: // Full Check.
                if not LicenseFunctions.IsLicenseApproved(AppID) then
                    LicenseFunctions.EnvironmentCheck(AppID);
            2: // Enable Feature.
                begin
                    if not LicenseFunctions.IsLicenseApproved(AppID) then
                        Error('The Test Order Management extension cannot be enabled because the license is not approved.');

                    if Confirm(FeatureStatusQst, false) then begin
                        SetEnabled(true);
                        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then begin
                            ApplicationAreaSetup."Test Order Mgt PROF" := true;
                            ApplicationAreaSetup.Modify();
                        end;
                        Message('The Test Order Management extension has been enabled for this company.');
                    end;
                end;
        end;
    end;

    local procedure GetAppId(): Text[36]
    var
        AppInfo: ModuleInfo;
        AppID: Text[36];
        AppGuidTxt: Text[38];
        ModuleInfoNotFoundLbl: Label 'Module info not found.';
    begin
        if not NavApp.GetCurrentModuleInfo(AppInfo) then
            Error(ModuleInfoNotFoundLbl);
        Evaluate(AppGuidTxt, LowerCase(AppInfo.Id));
        AppID := CopyStr(CopyStr(AppGuidTxt, 2, StrLen(AppGuidTxt) - 1), 1, MaxStrLen(AppID));
        exit(AppID);
    end;


    /// <summary>
    /// Checks if the Test Order Management extension is enabled for the current company.
    /// </summary>
    /// <returns>True if the extension is enabled, false otherwise.</returns>
    internal procedure IsEnabled(): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            exit(CompanyInformation."Test Order Mgt PROF");
    end;

    /// <summary>
    /// Throws an error if the Test Order Management extension is not enabled for the current company.
    /// </summary>
    internal procedure CheckEnabled()
    var
        FeatureDisabledErr: Label 'The Test Order Management extension is not enabled for this company. Please contact your administrator to enable it.';
    begin
        if not IsEnabled() then
            Error(FeatureDisabledErr);
    end;

    /// <summary>
    /// Sets the enabled status of the Test Order Management extension for the current company.
    /// </summary>
    /// <param name="Enabled">The new enabled status.</param>
    internal procedure SetEnabled(Enabled: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if CompanyInformation."Test Order Mgt PROF" <> Enabled then begin
                CompanyInformation."Test Order Mgt PROF" := Enabled;
                CompanyInformation.Modify();
            end;
    end;




    // Helpers ................................................................
    internal procedure IsExampleApplicationAreaEnabled(): Boolean
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then
            exit(ApplicationAreaSetup."Test Order Mgt PROF");
    end;

    internal procedure EnableExampleExtension()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        CompanyInformation: Record "Company Information";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";

    begin
        if CompanyInformation.Get() then
            if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then begin
                ApplicationAreaSetup."Test Order Mgt PROF" := CompanyInformation."Test Order Mgt PROF";
                ApplicationAreaSetup.Modify();
            end;

        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure RegisterExampleExtensionOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            TempApplicationAreaSetup."Test Order Mgt PROF" := CompanyInformation."Test Order Mgt PROF"
        else
            TempApplicationAreaSetup."Test Order Mgt PROF" := false;
        // Modify other application areas here
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpenCompleted', '', false, false)]
    local procedure OnCompanyOpenCompleted()
    begin

        // if not IsEnabled() then
        //     Error('The Test Order Management extension is not enabled for this company. Please contact your administrator to enable it.');
    end;

}