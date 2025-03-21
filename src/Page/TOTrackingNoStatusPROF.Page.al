/// <summary>
/// Page TO Tracking No. Status Entries PROF (ID 6208502).
/// </summary>
page 6208502 "TO Tracking No. Status PROF"
{
    Caption = 'Tracking No. Status Entries';
    PageType = List;
    SourceTable = "TO Tracking No. Status PROF";
    SourceTableView = sorting("Original Lot No.", "Lot No.", "Bulk Item No.", "Item No.", "Variant Code");
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = TestOrderMgtPROF;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number of the tracking no. status entry.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant code of the tracking no. status entry.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number of the tracking no. status entry.';
                }
                field("Bulk Item No."; Rec."Bulk Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bulk item number of the tracking no. status entry.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the entry number of the tracking no. status entry.';
                }
                field("Original Lot No."; Rec."Original Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original lot number of the tracking no. status entry.';
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the order type of the tracking no. status entry.';
                }
                field("Test Order No."; rec."Test Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the test order number of the tracking no. status entry.';
                }
                field("From Company Name"; Rec."From Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the from company name of the tracking no. status entry.';
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last modified date time of the tracking no. status entry.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date modified of the tracking no. status entry.';
                }
                field("Tracking Status"; Rec."Tracking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tracking status of the tracking no. status entry.';
                }
                field("Internal Use Only"; Rec."Internal Use Only")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the tracking no. status entry is internal use only.';
                }
                field("Local Impact"; Rec."Local Impact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the local impact of the tracking no. status entry.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the tracking no. status entry is blocked.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user ID of the tracking no. status entry.';
                }
                field("Vendor Lot No."; Rec."Vendor Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor lot number of the tracking no. status entry.';
                }
                field("QC Required"; Rec."QC Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the QC is required for the tracking no. status entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type of the tracking no. status entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number of the tracking no. status entry.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document line number of the tracking no. status entry.';
                }
                field("Creation Date Time"; Rec."Creation Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creation date time of the tracking no. status entry.';
                }
                field("Retest Date"; Rec."Retest Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the retest date of the tracking no. status entry.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiration date of the tracking no. status entry.';
                }
                field("Sales Expiration Date"; Rec."Sales Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales expiration date of the tracking no. status entry.';
                }
                field("Original Expiration Date"; Rec."Original Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original expiration date of the tracking no. status entry.';
                }
                field("Country/Region of Origin"; Rec."Country/Region of Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of origin of the tracking no. status entry.';
                }
                field("Usage Decision"; Rec."Usage Decision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Spefifies the value of the field "Usage Decision".';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Test Order Card")
            {
                Caption = 'Test Order Card';
                ApplicationArea = ItemTracking;
                Image = TestReport;
                ToolTip = 'View the test order card for the tracking no. status entry.';
                RunObject = page "TO Test Order Card PROF";
                RunPageLink = "Test Order No." = field("Test Order No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Enabled = (rec."Test Order No." <> '');
            }
        }
    }
}