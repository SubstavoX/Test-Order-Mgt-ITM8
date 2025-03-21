
codeunit 6208507 "TO Install Management PROF"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        CompanyInformation: Record "Company Information";
        FeatureManagement: Codeunit "TO Feature Management PROF";

    begin
        // Enable the feature by default for all companies
        CompanyInformation.Get();


        if (FeatureManagement.IsExampleApplicationAreaEnabled()) then
            exit;

        FeatureManagement.SetEnabled(false);
        FeatureManagement.EnableExampleExtension();
    end;


}