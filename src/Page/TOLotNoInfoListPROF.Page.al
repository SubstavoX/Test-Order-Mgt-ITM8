/// <summary>
/// Page TO Lot No. Info List PROF (ID 6208501).
/// </summary>
page 6208501 "TO Lot No. Info List PROF"
{
    Caption = 'Lot No. List';
    CardPageID = "Lot No. Information Card";
    PageType = List;
    SourceTable = "Lot No. Information";
    DeleteAllowed = false;
    LinksAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Navigate,Lot No.';
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
                field("Lot No."; rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                    StyleExpr = FieldStyle;
                }
                field("Vendor Lot No."; rec."Vendor Lot No. PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor lot number of the lot number information record.';
                    StyleExpr = FieldStyle;
                }
                field("Original Lot No."; rec."Original Lot No. PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original lot number of the lot number information record.';
                    StyleExpr = FieldStyle;
                }
                field(LocationCode; LocationCode)
                {
                    ApplicationArea = All;
                    CaptionClass = WhseEmployee.FieldCaption("Location Code");
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the location code of the lot number information record.';
                }
                field(BinCode; BinCode)
                {
                    Caption = 'Bin Code';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the bin code of the lot number information record.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BinContent: Record "Bin Content";
                        BinContentFilter: Record "Bin Content";
                    begin
                        BinContent.Reset();
                        BinContent.SetCurrentkey("Item No.");
                        BinContent.SetRange("Item No.", rec."Item No.");
                        if rec."Lot No." <> '' then
                            BinContent.SetFilter("Lot No. Filter", rec."Lot No.");
                        BinContent.SetFilter("Location Code", BinContentFilter.GetFilter("Location Code"));
                        BinContent.SetFilter("Zone Code", BinContentFilter.GetFilter("Zone Code"));
                        BinContent.SetFilter("Bin Code", BinContentFilter.GetFilter("Bin Code"));
                        Page.RunModal(Page::"Bin Content", BinContent);
                    end;
                }
                field("Bin Content"; rec."Bin Content PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin content of the lot number information record.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a description of the lot no. information record.';
                    StyleExpr = FieldStyle;
                    Visible = false;
                }
                field("Certificate Number"; rec."Certificate Number")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the number provided by the supplier to indicate that the batch or lot meets the specified requirements.';
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
                    ToolTip = 'Specifies that if "Block Usage" is yes, lot no. is not suggested on pick and it is not possible to select lot no. on pick.';
                }
                field("Test Order No."; rec."Test Order No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the test order number of the lot number information record.';
                }
                field("Lot Status"; rec."Lot Status PROF")
                {
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the lot status of the lot number information record.';
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
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies if the lot number is only for internal use.';
                }
                field("Local Impact"; rec."Local Impact PROF")
                {
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the local impact of the lot number.';
                }
                field("Approved for Internal use"; rec."Approved for Internal use PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the lot number is approved for internal use.';
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies that a comment has been recorded for the lot number.';
                    StyleExpr = FieldStyle;
                }
                field(Inventory; rec.Inventory)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the inventory quantity of the specified lot number.';
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                }
                field(Correction; rec."Correction PROF")
                {
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the correction of the lot number.';
                    DecimalPlaces = 0 : 5;
                }
                field(ItemCostAmount; ItemCostAmount)
                {
                    Caption = 'Cost Amount';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the cost amount of the lot number.';
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
                    ToolTip = 'Specifies the comment description of the lot number information record.';
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
                    ToolTip = 'Specifies the inventory of the lot number with an expiration date before the posting date on the associated document.';
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
                    StyleExpr = FieldStyle;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity on component lines.';
                }

                field(ItemCategoryCode; Item."Item Category Code")
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Item Category Code");
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the item category code of the item.';
                }
                field(InventoryPostingGroup; Item."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    CaptionClass = Item.FieldCaption("Inventory Posting Group");
                    StyleExpr = FieldStyle;
                    ToolTip = 'Specifies the inventory posting group of the item.';
                }


            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Lot No.")
            {
                Caption = '&Lot No.';
                Image = Lot;
                Visible = true;
                action("Item &Tracking Entries")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View serial or lot numbers that are assigned to items.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.SetRange("Item No.", rec."Item No.");
                        ItemLedgerEntry.SetRange("Lot No.", rec."Lot No.");
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
                                  "Serial/Lot No." = field("Lot No.");
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
                    ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
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
                        ItemTracingBuffer.SetRange("Lot No.", rec."Lot No.");
                        ItemTracing.InitFilters(ItemTracingBuffer);
                        ItemTracing.FindRecords();
                        ItemTracing.Run();
                    end;
                }
                action("TO Tracking No. Status Entries")
                {
                    Caption = 'Tracking No. Status Entries';
                    ApplicationArea = ItemTracking;
                    Image = ItemTracing;
                    ToolTip = 'Specifies the Tracking No. Status Entries of the lot number information record.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    RunObject = page "TO Tracking No. Status PROF";
                    RunPageLink = "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code"),
                                  "Original Lot No." = field("Original Lot No. PROF");
                }

                action("Test Order Card")
                {
                    Caption = 'Test Order Card';
                    ApplicationArea = ItemTracking;
                    Image = TestReport;
                    ToolTip = 'Specifies the test order card of the lot number information record.';
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
                    RunPageLink = "Item No." = field("Item No."), "Lot No. Filter" = field("Lot No.");
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
                    ToolTip = 'Creates a retest order for the lot number information record.';
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        TOTestOrder: Record "TO Test Order PROF";
                    begin
                        if (rec."Item No." = '') or (rec."Lot No." = '') then
                            exit;

                        TOTestOrder.CreateRecord(Rec, 0, '', 0, 0, TOTestOrder."Order Type"::"Retest Order", true);
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
                    TempItemTrackingSetup."Lot No." := Rec."Lot No.";
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
        if (rec."Item No." = xRec."Item No.") and (rec."Variant Code" = xRec."Variant Code") and (rec."Lot No." = xRec."Lot No.") then // Performance improvement.
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
        LotMgt.SetBinFilterOnBinContent(Rec);
        if (rec."Sales Expiration Date PROF" >= Today()) and (not rec.Blocked) and (rec."Lot Status PROF" = rec."Lot Status PROF"::Approved) and (not rec."Internal Use Only PROF") then begin
            LotMgt.QtyAvailableToPick(Item, Rec, false, rec."Lot No.", ZoneCode, BinCode, QtyAvailableToPick); // Set ZoneCode, BinCode and QtyAvailableToPick.
            BinCodeIsCalculated := true;
        end;
        if (rec."Expiration Date PROF" >= Today()) and (not rec.Blocked) and ((rec."Lot Status PROF" = rec."Lot Status PROF"::Approved) or ((rec."Lot Status PROF" = rec."Lot Status PROF"::"Not Tested") and (Item."Approved for Internal use PROF"))) then begin
            LotMgt.QtyAvailableToPick(Item, Rec, true, rec."Lot No.", ZoneCode, BinCode, QtyAvailableToPickProd); // Set ZoneCode, BinCode and QtyAvailableToPickProd.
            BinCodeIsCalculated := true;
        end;
        if not BinCodeIsCalculated then begin
            LotMgt.QtyAvailableToPick(Item, Rec, false, rec."Lot No.", ZoneCode, BinCode, QtyAvailableToPick); // Set ZoneCode, BinCode and QtyAvailableToPick.
            QtyAvailableToPick := 0;
        end;

        LocationCode := LotMgt.GetLocationCode(CopyStr(UserId(), 1, 50), rec.GetFilter("Location Filter"), rec."Item No.", rec."Variant Code", rec."Lot No.", '', ZoneCode, true);
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

    trigger OnDeleteRecord(): Boolean
    begin
        Error(NotAllowedToDeleteErr);
    end;

    procedure GetRecFilters()
    begin
        if rec.GetFilter("Item No.") <> '' then
            ItemNoFilter := rec.GetFilter("Item No.");

        if rec.GetFilter("Lot No.") <> '' then
            LotNoFilter := rec.GetFilter("Lot No.");


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
        NotAllowedToDeleteErr: Label 'You are not allowed to delete this record';
        ItemNoFilter: Text;
        LotNoFilter: Text;
}