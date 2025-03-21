/// <summary>
/// Page TO Item Tracing PROF (ID 6208500).
/// </summary>
page 6208500 "TO Item Tracing PROF"
{
    AdditionalSearchTerms = 'serial number,lot number,expiration,fefo,item tracking,fda,defect';
    ApplicationArea = TestOrderMgtPROF;
    Caption = 'TO Item Tracing';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Line,Item';
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SerialNoFilter; SerialNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Serial No. Filter';
                    ToolTip = 'Specifies the serial number or a filter on the serial numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SerialNoInfo: Record "Serial No. Information";
                        SerialNoList: Page "Serial No. Information List";
                    begin
                        SerialNoInfo.Reset();

                        Clear(SerialNoList);
                        SerialNoList.SetTableView(SerialNoInfo);
                        if SerialNoList.RunModal() = Action::LookupOK then
                            SerialNoFilter := SerialNoList.GetSelectionFilter();
                    end;
                }
                field(LotNoFilter; LotNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Lot No. Filter';
                    ToolTip = 'Specifies the lot number or a filter on the lot numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInfo: Record "Lot No. Information";
                        LotNoList: Page "Lot No. Information List";
                    begin
                        LotNoInfo.Reset();

                        Clear(LotNoList);
                        LotNoList.SetTableView(LotNoInfo);
                        if LotNoList.RunModal() = Action::LookupOK then
                            LotNoFilter := LotNoList.GetSelectionFilter();
                    end;
                }
                field(VendorLotNoFilter; VendorLotNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Vendor Lot No. Filter';
                    ToolTip = 'Specifies the Vendor lot number or a filter on the Vendor lot numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInfo: Record "Lot No. Information";
                        LotNoList: Page "Lot No. Information List";
                    begin
                        LotNoInfo.Reset();

                        Clear(LotNoList);
                        LotNoList.SetTableView(LotNoInfo);
                        if LotNoList.RunModal() = Action::LookupOK then
                            VendorLotNoFilter := LotNoList.GetSelectionFilter();
                    end;
                }
                field(ItemNoFilter; ItemNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies the item number or a filter on the item numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        Item.Reset();

                        Clear(ItemList);
                        ItemList.SetTableView(Item);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then
                            ItemNoFilter := ItemList.GetSelectionFilter();
                    end;

                    trigger OnValidate()
                    begin
                        if ItemNoFilter = '' then
                            VariantFilter := '';
                    end;
                }
                field(VariantFilter; VariantFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Variant Filter';
                    ToolTip = 'Specifies the variant code or a filter on the variant codes that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemVariant: Record "Item Variant";
                        ItemVariants: Page "Item Variants";
                    begin
                        if ItemNoFilter = '' then
                            Error(Text001Err);

                        ItemVariant.Reset();

                        Clear(ItemVariants);
                        ItemVariant.SetFilter("Item No.", ItemNoFilter);
                        ItemVariants.SetTableView(ItemVariant);
                        ItemVariants.LookupMode(true);
                        if ItemVariants.RunModal() = Action::LookupOK then begin
                            ItemVariants.GetRecord(ItemVariant);
                            VariantFilter := ItemVariant.Code;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if ItemNoFilter = '' then
                            Error(Text001Err);
                    end;
                }
                field(ShowComponents; ShowComponents)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Show Components';
                    OptionCaption = 'No,Item-tracked Only,All';
                    ToolTip = 'Specifies if you would like to see the components of the item that you are tracing.';
                }
                field(TraceMethod; TraceMethod)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Trace Method';
                    OptionCaption = 'Origin -> Usage,Usage -> Origin';
                    ToolTip = 'Specifies posted serial/lot numbers that can be traced either forward or backward in a supply chain.';
                }
                field(RetestDate; rec."Retest Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the retest date of the traced item.';
                }
                field(OriginalExpirationDate; rec."Original Expiration Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original expiration date of the traced item.';
                }
                field(ExpirationDate; rec."Expiration Date PROF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiration date of the traced item.';
                }
            }
            repeater(Lines)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowAsTree = true;
                field(Description; rec.Description)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a description of the traced Item.';
                }
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the type of the traced entry.';
                    Visible = false;
                }
                field("Serial No."; rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the serial number to be traced.';
                    Visible = false;
                }
                field("Lot No."; rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the traced lot number.';
                }
                field("Original Lot No."; rec."Original Lot No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the traced lot number.';
                }
                field("Vendor Lot No."; rec."Vendor Lot No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the vendor lot number of the traced item.';
                }
                /*
                field("Lot Status"; "Lot Status")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                }
                */
                field(Blocked; rec."Blocked PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies if the traced item is blocked.';
                }
                field("Original Expiration Date"; rec."Original Expiration Date PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the original expiration date of the traced item.';
                }
                field("Retest Date"; rec."Retest Date PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the retest date of the traced item.';
                }
                field("Expiration Date"; rec."Expiration Date PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the expiration date of the traced item.';
                }
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the number of the traced Item.';
                }
                field("Item Description"; rec."Item Description")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies a description of the Item.';
                }
                field("Variant Code"; rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the number of the traced document.';
                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the date when the traced item was posted.';
                    Visible = false;
                }
                field("Source Type"; rec."Source Type")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the type of record, such as Sales Header, that the item is traced from.';
                    Visible = false;
                }
                field("Source No."; rec."Source No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                    Visible = false;
                }
                field("Source Name"; rec."Source Name")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the name of the record that the item is traced from.';
                    Visible = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the location of the traced Item.';
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the quantity of the traced item in the line.';

                    trigger OnDrillDown()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Entry No.", rec."Item Ledger Entry No.");
                        Page.RunModal(0, ItemLedgerEntry);
                    end;
                }
                field("Remaining Quantity"; rec."Remaining Quantity")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                }
                field("Created By"; rec."Created By")
                {
                    ApplicationArea = ItemTracking;
                    Lookup = true;
                    ToolTip = 'Specifies the user who created the traced record.';
                    Visible = false;
                }
                field("Created on"; rec."Created on")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the date when the traced record was created.';
                    Visible = false;
                }
                field("Already Traced"; rec."Already Traced")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies if additional transaction history under this line has already been traced by other lines above it.';
                }
                field("Item Ledger Entry No."; rec."Item Ledger Entry No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the number of the traced item ledger entry.';
                    Visible = false;
                }
                field("Parent Item Ledger Entry No."; rec."Parent Item Ledger Entry No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the parent of the traced item ledger entry.';
                    Visible = false;
                }
                field("Original Serial No."; rec."Original Serial No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the original serial number of the traced item.';
                }
                field("Vendor Serial No."; rec."Vendor Serial No. PROF")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the vendor serial number of the traced item.';
                }


            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    begin
                        ItemTracingMgt.ShowDocument(rec."Record Identifier");
                    end;
                }
                action("Tracking No. Status Entries")
                {
                    Caption = 'Tracking No. Status Entries';
                    ApplicationArea = ItemTracking;
                    Image = ItemTracing;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    RunObject = page "TO Tracking No. Status PROF";
                    RunPageLink = "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code"),
                                  "Original Lot No." = field("Original Lot No. PROF");
                    ToolTip = 'View the status of the Tracking numbers for the item.';
                }
            }
            group(Item)
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("Item No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = page "Item Ledger Entries";
                    RunPageLink = "Item No." = field("Item No.");
                    RunPageView = sorting("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(TraceOppositeFromLine)
                {
                    ApplicationArea = ItemTracking;
                    Caption = '&Trace Opposite - from Line';
                    Enabled = FunctionsEnable;
                    Image = TraceOppositeLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Repeat the previous trace, but going the opposite direction.';

                    trigger OnAction()
                    begin
                        if TraceMethod = Tracemethod::"Origin->Usage" then
                            TraceMethod := Tracemethod::"Usage->Origin"
                        else
                            TraceMethod := Tracemethod::"Origin->Usage";
                        OppositeTraceFromLine();
                    end;
                }
                action(SetFiltersWithLineValues)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Set &Filters with Line Values';
                    Enabled = FunctionsEnable;
                    Image = FilterLines;
                    ToolTip = 'Insert the values of the selected line in the respective filter fields on the header and executes a new trace. This function is useful, for example, when the origin of the defective item is found and that particular trace line must form the basis of additional tracking with the same trace method.';

                    trigger OnAction()
                    var
                        LocationFilter: Text;
                    begin
                        ItemTracingMgt.InitSearchParm(Rec, SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter, LocationFilter);
                    end;
                }

                action("Go to Already-Traced History")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Go to Already-Traced History';
                    Enabled = FunctionsEnable;
                    Image = MoveUp;
                    ToolTip = 'View the item tracing history.';

                    trigger OnAction()
                    begin
                        SetFocus(rec."Item Ledger Entry No.");
                    end;
                }
                action(NextTraceResult)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Next Trace Result';
                    Image = NextRecord;
                    ToolTip = 'View the next item transaction in the tracing direction. ';

                    trigger OnAction()
                    begin
                        RecallHistory(1);
                    end;
                }
                action(PreviousTraceResult)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Previous Trace Result';
                    Image = PreviousRecord;
                    ToolTip = 'View the previous item transaction in the tracing direction.';

                    trigger OnAction()
                    begin
                        RecallHistory(-1);
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Print';
                Ellipsis = true;
                Enabled = PrintEnable;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    xItemTracingBuffer: Record "Item Tracing Buffer";
                    PrintTracking: Report "Item Tracing Specification";
                begin
                    Clear(PrintTracking);
                    xItemTracingBuffer.Copy(Rec);
                    PrintTracking.TransferEntries(Rec);
                    rec.Copy(xItemTracingBuffer);
                    PrintTracking.Run();
                end;
            }
            action(Navigate)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Navigate';
                Enabled = NavigateEnable;
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
            action(Trace)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Trace';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';

                trigger OnAction()
                begin
                    FindRecords();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        ItemTracingMgt.SetExpansionStatus(Rec, TempTrackEntry, Rec, ActualExpansionStatus);
        DescriptionOnFormat();
    end;

    trigger OnInit()
    begin
        NavigateEnable := true;
        PrintEnable := true;
        FunctionsEnable := true;
    end;

    trigger OnOpenPage()
    begin
        InitButtons();
        TraceMethod := Tracemethod::"Usage->Origin";
        ShowComponents := Showcomponents::"Item-tracked Only";

    end;




    var
        TempTrackEntry: Record "Item Tracing Buffer" temporary;
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
        TraceMethod: Option "Origin->Usage","Usage->Origin";
        ShowComponents: Option No,"Item-tracked Only",All;
        ActualExpansionStatus: Option "Has Children",Expanded,"No Children";
        SerialNoFilter: Text;
        LotNoFilter: Text;
        ItemNoFilter: Text;
        VariantFilter: Text;
        VendorLotNoFilter: Text;
        Text001Err: Label 'Item No. Filter is required.';
        PreviousExists: Boolean;
        NextExists: Boolean;
        DescriptionIndent: Integer;
        FunctionsEnable: Boolean;
        PrintEnable: Boolean;
        NavigateEnable: Boolean;

    internal procedure FindRecords()
    var
        OrgLotNoFilter: Text;
        PackageNoFilter: Text;  // Add this missing parameter
    begin
        PackageNoFilter := Rec."Package No.";

        OrgLotNoFilter := LotNoFilter;
        CreateLotNoFilter();

        ItemTracingMgt.FindRecords(TempTrackEntry, Rec,
            SerialNoFilter, LotNoFilter, PackageNoFilter, ItemNoFilter, VariantFilter,
            TraceMethod, ShowComponents); // Now all parameters match

        InitButtons();
        LotNoFilter := OrgLotNoFilter;
        ItemTracingMgt.GetHistoryStatus(PreviousExists, NextExists);

        //UpdateTraceText();
        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
        CurrPage.Update(false);
    end;

    local procedure OppositeTraceFromLine()
    var
        LocationFilter: Text;

    begin
        ItemTracingMgt.InitSearchParm(Rec, SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter, LocationFilter);
        FindRecords();
    end;

    local procedure InitButtons()
    begin
        if not TempTrackEntry.FindFirst() then begin
            FunctionsEnable := false;
            PrintEnable := false;
            NavigateEnable := false;
        end else begin
            FunctionsEnable := true;
            PrintEnable := true;
            NavigateEnable := true;
        end;
    end;

    internal procedure InitFilters(var ItemTrackingEntry: Record "Item Tracing Buffer")
    begin
        SerialNoFilter := ItemTrackingEntry.GetFilter("Serial No.");
        LotNoFilter := ItemTrackingEntry.GetFilter("Lot No.");
        ItemNoFilter := ItemTrackingEntry.GetFilter("Item No.");
        VariantFilter := ItemTrackingEntry.GetFilter("Variant Code");
        TraceMethod := Tracemethod::"Usage->Origin";
        ShowComponents := Showcomponents::"Item-tracked Only";
    end;


    local procedure RecallHistory(Steps: Integer)
    var
        PackageNoFilter: Text; // Declare missing parameter
    begin
        PackageNoFilter := Rec."Package No.";
        ItemTracingMgt.RecallHistory(Steps, TempTrackEntry, Rec, SerialNoFilter,
            LotNoFilter, PackageNoFilter, ItemNoFilter, VariantFilter, TraceMethod, ShowComponents);

        // Update UI elements
        InitButtons();
        ItemTracingMgt.GetHistoryStatus(PreviousExists, NextExists);
        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
        CurrPage.Update(false);
    end;


    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := rec.Level;
    end;

    local procedure SetFocus(ItemLedgerEntryNo: Integer)
    begin
        if rec."Already Traced" then begin
            TempTrackEntry.SetCurrentkey("Item Ledger Entry No.");
            TempTrackEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
            TempTrackEntry.FindFirst();
            CurrPage.SetRecord(TempTrackEntry);
        end;
    end;

    local procedure CreateLotNoFilter()
    var
        LotNoInfo: Record "Lot No. Information";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if VendorLotNoFilter <> '' then begin
            LotNoFilter := '|';

            LotNoInfo.SetCurrentKey("Vendor Lot No. PROF");
            LotNoInfo.SetFilter("Vendor Lot No. PROF", VendorLotNoFilter);
            LotNoInfo.SetFilter("Lot No.", '<>%1', '');
            if LotNoInfo.FindSet() then
                repeat
                    if StrPos(LotNoFilter, '|' + LotNoInfo."Lot No." + '|') = 0 then
                        LotNoFilter := LotNoFilter + LotNoInfo."Lot No." + '|';
                until LotNoInfo.Next() = 0;

            ItemLedgerEntry.SetCurrentKey("Vendor Lot No. PROF");
            ItemLedgerEntry.SetFilter("Vendor Lot No. PROF", VendorLotNoFilter);
            ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            if ItemLedgerEntry.FindSet() then
                repeat
                    if StrPos(LotNoFilter, '|' + ItemLedgerEntry."Lot No." + '|') = 0 then
                        LotNoFilter := LotNoFilter + ItemLedgerEntry."Lot No." + '|';
                until ItemLedgerEntry.Next() = 0;

            LotNoFilter := DelChr(LotNoFilter, '<>', '|');
        end;
    end;
}

