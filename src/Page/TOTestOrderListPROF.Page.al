/// <summary>
/// Page TO Test Order List PROF (ID 6208507).
/// </summary>
page 6208507 "TO Test Order List PROF"
{
    ApplicationArea = TestOrderMgtPROF;
    Caption = 'Test Orders';
    PageType = List;
    SourceTable = "TO Test Order PROF";
    UsageCategory = Lists;
    CardPageId = "TO Test Order Card PROF";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Test Order No."; Rec."Test Order No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                    ToolTip = 'Specifies the test order number of the test order.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number of the test order.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant code of the test order.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number of the test order.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the test order.';
                }
                field("Test Order Status"; Rec."Test Order Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the test order.';
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the test order.';
                }
                field("Tracking Status"; Rec."Tracking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tracking status of the test order.';
                }

                field("Usage Decision"; Rec."Usage Decision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the usage decision of the test order.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Card)
            {
                ApplicationArea = All;
                Caption = 'Card';
                Image = EditLines;
                RunObject = Page "TO Test Order Card PROF";
                RunPageLink = "Test Order No." = field("Test Order No.");
                ShortcutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the test order.';
            }
        }
    }

    var
        StyleText: Text;

    trigger OnAfterGetRecord()
    var
        Utils: Codeunit "TO Utilities PROF";
    begin
        StyleText := Utils.GetStyle(Enum::"TO ColorStyles PROF"::Standard);
    end;

    trigger OnOpenPage()
    var
        LicenseInfoProf: Record "License Information_Prof";
        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
        AppID: Text[36];
    begin
        // Get the App ID
        AppID := GetAppId();

        // Create or update the license information record
        LicenseInfoProf.Reset();
        LicenseInfoProf.SetRange("Licensed App ID", AppID);
        if not LicenseInfoProf.FindFirst() then begin
            LicenseInfoProf.Init();
            LicenseInfoProf."Licensed App ID" := AppID;
            LicenseInfoProf.Insert();
        end;

        // Perform license check
        if not LicenseFunctions.IsLicenseApproved(AppID) then
            LicenseFunctions.EnvironmentCheck(AppID);
    end;

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
}