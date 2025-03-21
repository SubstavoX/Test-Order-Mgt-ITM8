/// <summary>
/// Page TO Serial No. Info List PROF (ID 6208502).
/// </summary>
page 6208512 "TO Serial No. Info List PROF"
{
    Caption = 'Serial No. List';
    CardPageID = "Serial No. Information Card";
    PageType = List;
    SourceTable = "Serial No. Information";
    DeleteAllowed = false;
    LinksAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Navigate,Serial No.';
    UsageCategory = Lists;
    ApplicationArea = TestOrderMgtPROF;

    layout
    {

        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                    Visible = true; // Visible = ListEditable;
                    Lookup = false;
                    StyleExpr = FieldStyle;

                    trigger OnDrillDown()
                    begin
                        ItemFunctions.ShowItemCard(rec."Item No.", true);
                    end;
                }
                field("Item Description"; Item.Description)
                {
                    Caption = 'Item Description';
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Displaying description fetched from the Item Card. This field can not be used for filtering and sorting.';
                    StyleExpr = FieldStyle;
                }
                field("Variant Code"; rec."Variant Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                    StyleExpr = FieldStyle;
                }
                field("Serial No."; rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a Serial number information record is created.';
                    StyleExpr = FieldStyle;
                }
                field("Vendor Serial No."; rec."Vendor Serial No. PROF")
                {
                    ToolTip = 'Specifies the serial number from the vendor.';
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                }
                field("Original Serial No."; rec."Original Serial No. PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original serial number.';
                    StyleExpr = FieldStyle;
                }
                field(LocationCode; LocationCode)
                {
                    ApplicationArea = All;
                    CaptionClass = WhseEmployee.FieldCaption("Location Code");
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the location code.';
                }
                field(BinCode; BinCode)
                {
                    Caption = 'Bin Code';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the bin code.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BinContent: Record "Bin Content";
                        BinContentFilter: Record "Bin Content";
                    begin
                        BinContent.Reset();
                        BinContent.SetCurrentkey("Item No.");
                        BinContent.SetRange("Item No.", rec."Item No.");
                        if rec."Serial No." <> '' then
                            BinContent.SetFilter("Serial No. Filter", rec."Serial No.");
                        BinContent.SetFilter("Location Code", BinContentFilter.GetFilter("Location Code"));
                        BinContent.SetFilter("Zone Code", BinContentFilter.GetFilter("Zone Code"));
                        BinContent.SetFilter("Bin Code", BinContentFilter.GetFilter("Bin Code"));
                        Page.RunModal(Page::"Bin Content", BinContent);
                    end;
                }
                field("Bin Content"; rec."Bin Content PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin content.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a description of the serial no. information record.';
                    StyleExpr = FieldStyle;
                    Visible = false;
                }
                field("Certificate Number"; rec."Certificate Number PROF")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the number provided by the supplier to indicate that the batch or Serial No. meets the specified requirements.';
                    StyleExpr = FieldStyle;
                    Visible = false;
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                    StyleExpr = FieldStyle;
                }
                field("Block Usage"; Rec."Block Usage PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that if "Block Usage" is yes, Serial no. is not suggested on pick and it is not possible to select Serial no. on pick.';
                }
                field("Test Order No."; rec."Test Order No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the test order number.';
                    StyleExpr = FieldStyle;
                }
                field("Serial Status"; rec."Serial Status PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial status.';
                    StyleExpr = FieldStyle;
                }
                field("Usage Decision"; Rec."Usage Decision PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Spefifies the value of the field "Usage Decision".';
                    StyleExpr = FieldStyle;
                }
                field("Internal Use Only"; rec."Internal Use Only PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the serial number is only for internal use.';
                    StyleExpr = FieldStyle;
                }
                field("Local Impact"; rec."Local Impact PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the local impact.';
                    StyleExpr = FieldStyle;
                }
                field("Approved for Internal use"; rec."Approved for Internal use PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the serial number is approved for internal use.';
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies that a comment has been recorded for the Serial number.';
                    StyleExpr = FieldStyle;
                }
                field(Inventory; rec.Inventory)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the inventory quantity of the specified Serial number.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(Correction; rec."Correction PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the correction quantity of the specified Serial number.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(ItemCostAmount; ItemCostAmount)
                {
                    Caption = 'Cost Amount';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the cost amount of the specified Serial number.';
                }
                field(AvailableBinQty; QtyAvailableToPick)
                {
                    Caption = 'Qty. Available to Pick (Sale)';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the quantity available to pick for sale.';
                    DecimalPlaces = 0 : 5;
                }
                field(AvailableBinQtyProd; QtyAvailableToPickProd)
                {
                    Caption = 'Qty. Available to Pick (Production)';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the quantity available to pick for production.';
                    DecimalPlaces = 0 : 5;
                }
                field("Comment Description"; rec."Comment Description PROF")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the comment description.';
                }
                field("Retest Date"; rec."Retest Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next retest date.';
                    StyleExpr = FieldStyle;
                }
                field("Sales Expiration Date"; rec."Sales Expiration Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales expiration date.';
                    StyleExpr = FieldStyle;
                }
                field("Expiration Date"; rec."Expiration Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest expiration date.';
                    StyleExpr = FieldStyle;
                }
                field("Expired Inventory"; rec."Expired Inventory")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the inventory of the Serial number with an expiration date before the posting date on the associated document.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(QtyOnPurchOrder; QtyOnPurchOrder)
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Qty. on Purch. Order");
                    ToolTip = 'Specifies the quantity on purchase orders.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PurchaseLine: Record "Purchase Line";
                    begin
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SetRange("No.", Item."No.");
                        PurchaseLine.SetRange("Location Code", LocationCode);
                        Page.RunModal(Page::"Purchase Lines", PurchaseLine);
                    end;
                }
                field(QtyOnSalesOrder; QtyOnSalesOrder)
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Qty. on Sales Order");
                    ToolTip = 'Specifies the quantity on sales orders.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        SalesLine.SetRange("No.", Item."No.");
                        SalesLine.SetRange("Location Code", LocationCode);
                        Page.RunModal(Page::"Sales Lines", SalesLine);
                    end;
                }
                field("Qty. on Component Lines"; rec."Qty. on Component Lines PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity on component lines.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }

                field(ItemCategoryCode; Item."Item Category Code")
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Item Category Code");
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the item category code.';
                }
                field(InventoryPostingGroup; Item."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Inventory Posting Group");
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the inventory posting group.';
                }


            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Serial No.")
            {
                Caption = '&Serial No.';
                Image = SerialNo;
                Visible = true;
                action("Item &Tracking Entries")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View serial or Serial numbers that are assigned to items.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.SetRange("Item No.", rec."Item No.");
                        ItemLedgerEntry.SetRange("Serial No.", rec."Serial No.");
                        if rec."Variant Code" <> '' then
                            ItemLedgerEntry.SetRange("Variant Code", rec."Variant Code");
                        Page.Run(Page::"Item Tracking Entries", ItemLedgerEntry);
                    end;

                }
                action(CommentAction)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Comment';
                    Image = ViewComments;
                    RunObject = page "Item Tracking Comments";
                    RunPageLink = Type = const("Lot No."),
                                  "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code"),
                                  "Serial/Lot No." = field("Serial No.");
                    ToolTip = 'View or add comments for the record.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;
                }
                action(ItemTracing)
                {
                    ApplicationArea = ItemTracking;
                    Caption = '&Item Tracing';
                    Image = ItemTracing;
                    ToolTip = 'Trace where a serial number assigned to the item was used, for example, to find which Serial number a defective component came from or to find all the customers that have received items containing the defective component.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ItemTracingBuffer: Record "Item Tracing Buffer";
                        ItemTracing: Page "TO Item Tracing PROF";
                    begin
                        Clear(ItemTracing);
                        ItemTracingBuffer.SetRange("Item No.", rec."Item No.");
                        if rec."Variant Code" <> '' then
                            ItemTracingBuffer.SetRange("Variant Code", rec."Variant Code");
                        ItemTracingBuffer.SetRange("Serial No.", rec."Serial No.");
                        ItemTracing.InitFilters(ItemTracingBuffer);
                        ItemTracing.FindRecords();
                        ItemTracing.Run();
                    end;
                }
                action("TO Serial No. Status Entries")
                {
                    Caption = 'Serial No. Status Entries';
                    ApplicationArea = ItemTracking;
                    Image = ItemTracing;
                    ToolTip = 'View the status entries for the serial number.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    RunObject = page "TO Tracking No. Status PROF";
                    RunPageLink = "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code"),
                                  "Original Serial No." = field("Original Serial No. PROF");
                }

                action("Test Order Card")
                {
                    Caption = 'Test Order Card';
                    ApplicationArea = ItemTracking;
                    Image = TestReport;
                    ToolTip = 'View the test order card for the serial number.';
                    RunObject = page "TO Test Order Card PROF";
                    RunPageLink = "Test Order No." = field("Test Order No. PROF");
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    Enabled = (rec."Test Order No. PROF" <> '');
                }
                action(BinContents)
                {
                    ApplicationArea = All;
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    ToolTip = 'Shows the bin contents for the Item.';
                    RunObject = page "Bin Contents";
                    RunPageView = sorting("Item No.");
                    RunPageLink = "Item No." = field("Item No."), "Serial No. Filter" = field("Serial No.");
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;
                }
                action(CreateRetestOrder)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Create Retest Order';
                    Image = TestReport;
                    ToolTip = 'Create a retest order for the serial number.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        TOTestOrder: Record "TO Test Order PROF";
                    begin
                        if (rec."Item No." = '') or (rec."Serial No." = '') then
                            exit;

                        TOTestOrder.CreateRecordSN(Rec, 0, '', 0, 0, TOTestOrder."Order Type"::"Retest Order", true);
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                var
                    TempItemTrackingSetup: Record "Item Tracking Setup" temporary;
                    Navigate: Page Navigate;
                begin
                    TempItemTrackingSetup.Init();
                    TempItemTrackingSetup."Serial No." := Rec."Serial No.";
                    Navigate.SetTracking(TempItemTrackingSetup);
                    Navigate.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Location: Record Location;
    begin
        if rec.GetFilters() = '' then begin // Keep filters when page called with filters

            if rec.IsEmpty() then
                rec.Reset();

            Location.Reset();
            Location.SetFilter("Adjustment Bin Code", '<>%1', '');
            if Location.FindFirst() then
                rec.SetFilter("Adjustment Bin Filter PROF", Location."Adjustment Bin Code");
            Location.Reset();
            rec.SetRange("Location Filter");
            rec.SetRange("Zone Filter PROF");
            rec.SetRange("Bin Filter");
            rec.SetFilter("Date Filter", '..%1', WorkDate());
            rec.SetFilter(Inventory, '<>0');
            GetRecFilters();

            if not rec.FindFirst() then
                rec.Reset();

        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if (rec."Item No." = xRec."Item No.") and (rec."Variant Code" = xRec."Variant Code") and (rec."Serial No." = xRec."Serial No.") then // Performance improvement.
            if (CurrentDateTime() - LastRefresh) < 15000 then // Do not refresh if it has been refreshed less than 15 seconds ago.
                exit;

        if rec."Item No." <> Item."No." then begin
            if not Item.Get(rec."Item No.") then
                Clear(Item)
            else
                Item.Calcfields("Qty. on Purch. Order", "Qty. on Sales Order");
            QtyOnPurchOrder := Item."Qty. on Purch. Order";
            QtyOnSalesOrder := Item."Qty. on Sales Order";
        end;

        LastRefresh := CurrentDateTime();

        rec.Calcfields(Inventory, "Qty. on Component Lines PROF");

        ItemCostAmount := rec.Inventory * Item."Unit Cost";

        ZoneCode := '';
        BinCode := '';
        QtyAvailableToPick := 0;
        QtyAvailableToPickProd := 0;

        BinCodeIsCalculated := false;
        LotMgt.SetBinFilterOnBinContentSN(Rec);
        if (rec."Sales Expiration Date PROF" >= Today()) and (not rec.Blocked) and (rec."Serial Status PROF" = rec."Serial Status PROF"::Approved) and (not rec."Internal Use Only PROF") then begin
            LotMgt.QtyAvailableToPickSN(Item, Rec, false, rec."Serial No.", ZoneCode, BinCode, QtyAvailableToPick); // Set ZoneCode, BinCode and QtyAvailableToPick.
            BinCodeIsCalculated := true;
        end;
        if (rec."Expiration Date PROF" >= Today()) and (not rec.Blocked) and ((rec."Serial Status PROF" = rec."Serial Status PROF"::Approved) or ((rec."Serial Status PROF" = rec."Serial Status PROF"::"Not Tested") and (Item."Approved for Internal use PROF"))) then begin
            LotMgt.QtyAvailableToPickSN(Item, Rec, true, rec."Serial No.", ZoneCode, BinCode, QtyAvailableToPickProd); // Set ZoneCode, BinCode and QtyAvailableToPickProd.
            BinCodeIsCalculated := true;
        end;
        if not BinCodeIsCalculated then begin
            LotMgt.QtyAvailableToPickSN(Item, Rec, false, rec."Serial No.", ZoneCode, BinCode, QtyAvailableToPick); // Set ZoneCode, BinCode and QtyAvailableToPick.
            QtyAvailableToPick := 0;
        end;

        LocationCode := LotMgt.GetLocationCode(CopyStr(UserId(), 1, 50), rec.GetFilter("Location Filter"), rec."Item No.", rec."Variant Code", '', rec."Serial No.", ZoneCode, true);
        SetStyle();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Item);
        QtyOnPurchOrder := 0;
        QtyOnSalesOrder := 0;
        rec.Inventory := 0;
        rec."Qty. on Component Lines PROF" := 0;
        ItemCostAmount := 0;
        ZoneCode := '';
        BinCode := '';
        QtyAvailableToPick := 0;
        QtyAvailableToPickProd := 0;
    end;



    local procedure GetRecFilters()
    begin
        if rec.GetFilter("Item No.") <> '' then
            ItemNoFilter := rec.GetFilter("Item No.");

        if rec.GetFilter("Serial No.") <> '' then
            SerialNoFilter := rec.GetFilter("Serial No.");


    end;


    local procedure SetStyle()
    begin
        if rec.Blocked or (rec."Expiration Date PROF" < Today()) then
            FieldStyle := TOUtilitiesPROF.GetStyle(ColorStyles::Unfavorable)
        else
            if rec."Retest Date PROF" < Today() then
                FieldStyle := TOUtilitiesPROF.GetStyle(ColorStyles::StrongAccent)
            else
                if rec."Sales Expiration Date PROF" < Today() then
                    FieldStyle := TOUtilitiesPROF.GetStyle(ColorStyles::Attention)
                else
                    FieldStyle := TOUtilitiesPROF.GetStyle(ColorStyles::Standard);
    end;

    var
        WhseEmployee: Record "Warehouse Employee";
        Item: Record Item;
        LotMgt: Codeunit "TO Lot Management PROF";
        ItemFunctions: Codeunit "TO Item Functions PROF";
        TOUtilitiesPROF: Codeunit "TO Utilities PROF";
        ColorStyles: enum "TO ColorStyles PROF";
        FieldStyle: Text;
        LastRefresh: DateTime;
        ZoneCode: Code[10];
        BinCode: Code[20];
        LocationCode: Code[10];
        QtyAvailableToPick: Decimal;
        QtyAvailableToPickProd: Decimal;
        BinCodeIsCalculated: Boolean;
        QtyOnPurchOrder: Decimal;
        QtyOnSalesOrder: Decimal;
        ItemCostAmount: Decimal;
        ItemNoFilter: Text;
        SerialNoFilter: Text;
}