/// <summary>
/// Page TO Setup Card PROF (ID 6208505).
/// </summary>
page 6208505 "TO Setup Card PROF"
{
    Caption = 'Test Order Setup';
    PageType = Card;
    SourceTable = "TO Setup PROF";
    UsageCategory = Administration;
    ApplicationArea = TestOrderMgtPROF;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';


                field("Test Order Source Code"; Rec."Test Order Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code for the test order.';
                }
                field("Test Order Open Page"; Rec."Test Order Open Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the page to open when the test order is created.';
                }


            }
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Lot Nos."; Rec."Lot Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code to use for assigning Lot Numbers.';
                }
                field("Serial Nos."; Rec."Serial Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code to use for assigning Serial Numbers.';
                }
                field("Supplier Order Nos."; Rec."Supplier Order Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code to use for assigning Supplier Orders.';
                }
                field("Test Order Nos."; Rec."Test Order Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code to use for assigning Test Orders.';
                }
            }
            group(DefaultJournals)
            {
                Caption = 'Default Journals';
                group(WhseReclassificationJournal)
                {
                    Caption = 'Whse. Reclassification Journal';
                    field("Reclass Journal Template Name"; Rec."Reclass Journal Template Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the template name for the Warehouse Reclassification Journal.';
                    }
                    field("Reclass Journal Batch Name"; Rec."Reclass Journal Batch Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the batch name for the Warehouse Reclassification Journal.';
                    }
                }
                group(WhseItemJournal)
                {
                    Caption = 'Whse. Item Journal';
                    field("Warehouse Jnl. Template Name"; Rec."Warehouse Jnl. Template Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the template name for the Warehouse Item Journal.';
                    }
                    field("Warehouse Journal Batch Name"; Rec."Warehouse Journal Batch Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the batch name for the Warehouse Item Journal.';
                    }
                }
                group(AllJournals)
                {
                    Caption = 'Whse. Journals';
                    field("Stop Phys. Invt. Posting"; Rec."Stop Phys. Invt. Posting")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies if the physical inventory posting should be stopped.';
                    }
                }
            }


            group(Sales)
            {
                Caption = 'Sales';
                field("Shipm. Method Price Letter"; Rec."Shipm. Method Price Letter")
                {
                    ApplicationArea = All;
                    ToolTip = 'This Shipment Method is used on the price letter if not specific Shipment Method for Priceletter is filled in on the customer.';
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                field("Auto Create Lot No. Purchase"; Rec."Auto Create Lot No. Purchase")
                {
                    ApplicationArea = All;
                    ToolTip = 'If this field is marked, a lot no. is created automatically when creating a Warehouse Receipt Line.';
                }
                field("Auto Create Serial No. Purchase"; Rec."Auto Create Serial No. Purch")
                {
                    ApplicationArea = All;
                    ToolTip = 'If this field is marked, a serial number is created automatically when creating a Warehouse Receipt Line.';
                }

            }

        }
    }


    trigger OnOpenPage()
    var
        LicenseFunctions: Codeunit "LicenseFunctions_Prof";

        AppID: Text[36];
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        // Get the App ID
        AppID := GetAppId();
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

    var
}