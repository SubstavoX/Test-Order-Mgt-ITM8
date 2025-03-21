/// <summary>
/// Table TO Test Order PROF (ID 6208503).
/// </summary>
table 6208503 "TO Test Order PROF"
{
    Permissions = TableData "Item Ledger Entry" = rimd;
    Caption = 'Test Order';
    DataCaptionFields = "Item No.", "Variant Code", "Lot No.", "Test Order Status", "Order Type";
    DrillDownPageID = "TO Test Order List PROF";
    LookupPageID = "TO Test Order List PROF";

    fields
    {
        field(1; "Test Order No."; Code[20])
        {
            Caption = 'Test Order No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                TOSetup: Record "TO Setup PROF";
                NoSeries: Codeunit "No. Series";
            begin
                if "Test Order No." <> xRec."Test Order No." then begin
                    TOSetup.Get();
                    NoSeries.TestManual(TOSetup."Test Order Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ItemFunctions: Codeunit "TO Item Functions PROF";
            begin
                ItemFunctions.ShowItemCard("Item No.", true);
            end;
        }
        field(3; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"));
            NotBlank = true;
            Editable = false;
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                TOLotManagement: Codeunit "TO Lot Management PROF";
            begin
                if Rec.IsTemporary() then
                    exit;
                if "Lot No." = '' then
                    exit;
                TOLotManagement.ShowLotNoInformationCard("Item No.", "Variant Code", "Lot No.", false);
            end;
        }
        field(333; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            TableRelation = "Serial No. Information"."Serial No." where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"));
            NotBlank = true;
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TOLotManagement: Codeunit "TO Lot Management PROF";
            begin
                if Rec.IsTemporary() then
                    exit;
                if "Lot No." = '' then
                    exit;
                TOLotManagement.ShowSerialNoInformationCard("Item No.", "Variant Code", "Serial No.", false);
            end;
        }
        field(5; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
            NotBlank = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ',Purchase,Production';
            OptionMembers = ,Purchase,Production;
            Editable = false;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(8; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "Creation Date Time"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(10; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
        field(20; "Order Type"; Option)
        {
            Caption = 'Order Type';
            OptionCaption = 'Test Order,Retest Order,Manual Order';
            OptionMembers = "Test Order","Retest Order","Manual Order";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(21; "Test Order Status"; Option)
        {
            Caption = 'Test Order Status';
            OptionCaption = 'Open,Posted';
            OptionMembers = Open,Posted;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(22; "Tracking Status"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(30; "Original Lot No."; Code[50])
        {
            Caption = 'Original Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(334; "Original Serial No."; Code[50])
        {
            Caption = 'Original Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(31; "Vendor Lot No."; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(335; "Vendor Serial No."; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(32; "New Lot No."; Code[50])
        {
            Caption = 'New Lot No.';
            DataClassification = SystemMetadata;
        }
        field(336; "New Serial No."; Code[50])
        {
            Caption = 'New Serial No.';
            DataClassification = SystemMetadata;
        }
        field(33; "New Vendor Lot No."; Code[50])
        {
            Caption = 'New Vendor Lot No.';
            DataClassification = SystemMetadata;
        }
        field(337; "New Vendor Serial No."; Code[50])
        {
            Caption = 'New Vendor Serial No.';
            DataClassification = SystemMetadata;
        }
        field(40; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(41; "Original Expiration Date"; Date)
        {
            Caption = 'Original Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(42; "New Expiration Date"; Date)
        {
            Caption = 'New Expiration Date';
            DataClassification = SystemMetadata;
        }
        field(43; "Sales Expiration Date"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50; "Retest Date"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(90; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(91; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(100; "Country/Region of Origin"; Code[10])
        {
            Caption = 'Country/Region of Origin';
            TableRelation = "Country/Region".Code;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(101; "New Country/Region of Origin"; Code[10])
        {
            Caption = 'New Country/Region of Origin';
            TableRelation = "Country/Region".Code;
            DataClassification = SystemMetadata;
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
                CityL: Text[30];
                PostCodeCodeL: Code[20];
                CountyL: Text[30];
            begin
                PostCode.ValidateCountryCode(CityL, PostCodeCodeL, CountyL, "New Country/Region of Origin");
            end;
        }
        field(110; "Bulk Item No."; Code[20])
        {
            Caption = 'Bulk Item No.';
            DataClassification = SystemMetadata;
            TableRelation = Item;
            Editable = false;

            trigger OnLookup()
            var
                ItemFunctions: Codeunit "TO Item Functions PROF";
            begin
                ItemFunctions.ShowItemCard("Bulk Item No.", true);
            end;
        }
        field(112; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(120; "Internal Use Only"; Boolean)
        {
            Caption = 'Internal Use Only';
            DataClassification = SystemMetadata;
        }
        field(130; "Local Impact"; Boolean)
        {
            Caption = 'Local Impact';
            DataClassification = SystemMetadata;
        }


        field(200; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(201; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = "Bin Content"."Bin Code" where("Location Code" = field("Location Code"),
                                                           "Item No." = field("Item No."),
                                                           "Variant Code" = field("Variant Code"),
                                                           "Lot No. Filter" = field("Lot No."),
                                                           "Serial No. Filter" = field("Serial No."),
                                                           Quantity = Filter('>0'));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                TempWarehouseEntry: Record "Warehouse Entry" temporary;
                TOLotManagement: Codeunit "TO Lot Management PROF";
            begin
                if "Bin Code" = '' then
                    exit;
                if ("Test Order No." = '') or ("Item No." = '') or (("Lot No." = '') and ("Serial No." = '')) then
                    exit;
                if "Test Order Status" = "Test Order Status"::Posted then
                    exit;
                if "Location Code" = '' then
                    FieldError("Location Code");

                TOLotManagement.CreateTempBinContent(TempWarehouseEntry, "Item No.", "Variant Code", "Lot No.", "Serial No.", "Location Code", 0);

                TempWarehouseEntry.Reset();
                TempWarehouseEntry.SetRange("Bin Code", "Bin Code");
                if TempWarehouseEntry.IsEmpty() then
                    FieldError("Bin Code");
            end;

            trigger OnLookup()
            var
                TempWarehouseEntry: Record "Warehouse Entry" temporary;
                ObjTransl: Record "Object Translation";
                TOLotManagement: Codeunit "TO Lot Management PROF";
                BinContentPage: Page "TO Lot Warehouse Entries PROF";
                PageCaption: Text;
            begin
                if ("Test Order No." = '') or ("Item No." = '') or (("Lot No." = '') and ("Serial No." = '')) then
                    exit;
                if "Test Order Status" = "Test Order Status"::Posted then
                    exit;
                if "Location Code" = '' then
                    FieldError("Location Code");

                TOLotManagement.CreateTempBinContent(TempWarehouseEntry, "Item No.", "Variant Code", "Lot No.", "Serial No.", "Location Code", 0);

                TempWarehouseEntry.Reset();

                PageCaption := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, Database::"Bin Content") + ' ' + "Location Code";
                if "Variant Code" <> '' then
                    PageCaption := PageCaption + ' ' + "Variant Code";
                PageCaption := PageCaption + ' ' + "Item No." + ' ' + "Lot No." + ' ' + "Serial No.";
                BinContentPage.SetPageCaption(PageCaption);
                BinContentPage.FillPageRec(TempWarehouseEntry);
                BinContentPage.LookupMode(true);
                if BinContentPage.RunModal() = Action::LookupOK then begin
                    BinContentPage.GetRecord(TempWarehouseEntry);
                    Validate("Bin Code", TempWarehouseEntry."Bin Code");
                end;
            end;
        }
        field(310; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            BlankZero = true;
            DataClassification = CustomerContent;
        }
        field(320; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                UserSettings: Record "User Setup";
                UserLookup: Page "User Lookup";
            begin
                UserLookup.LookupMode(true);
                if UserLookup.RunModal() = Action::LookupOK then begin
                    UserLookup.GetRecord(UserSettings);
                    Validate("Assigned User ID", UserSettings."User ID");
                end;
            end;
        }
        field(321; Priority; enum "TO Priority PROF")
        {
            Caption = 'Priority';
            InitValue = 3;
            DataClassification = CustomerContent;
        }
        field(322; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            TableRelation = User."User Name";
            DataClassification = CustomerContent;
        }
        field(323; "Usage Decision"; Code[20])
        {
            Caption = 'Usage Decision';
            TableRelation = if ("Order Type" = filter("Retest Order")) "TO Usage Decision PROF" where("Show On Retest Order" = const(true))
            else
            if ("Order Type" = filter("Test Order" | "Manual Order")) "TO Usage Decision PROF" where("Show On Test or Manual Orders" = const(true));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Item: Record Item;
                LotNoInfo: Record "Lot No. Information";
                SerialNoInfo: Record "Serial No. Information";
                UsageDecision: Record "TO Usage Decision PROF";
                NoSeries: Codeunit "No. Series";
            begin
                Rec."New Lot No." := '';
                Rec."New Vendor Lot No." := '';
                Rec."New Serial No." := '';
                Rec."New Vendor Serial No." := '';
                Rec."New Country/Region of Origin" := '';

                if Rec."Order Type" <> Rec."Order Type"::"Test Order" then begin
                    // Handle Lot No. Information
                    if (Rec."Lot No." <> '') and LotNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
                        if LotNoInfo."Lot Status PROF" <> LotNoInfo."Lot Status PROF"::"Not Tested" then
                            if UsageDecision.Get(Rec."Usage Decision") then
                                if not UsageDecision."Not Update Lot No & Expir Date" then
                                    if Item.Get(Rec."Item No.") then begin
                                        Rec."New Lot No." := NoSeries.GetNextNo(Item."Lot Nos.", WorkDate(), true);
                                        Rec."New Vendor Lot No." := LotNoInfo."Vendor Lot No. PROF";
                                        Rec."New Country/Region of Origin" := LotNoInfo."Country/Region of Origin PROF";
                                    end;

                    // Handle Serial No. Information
                    if (Rec."Serial No." <> '') and SerialNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Serial No.") then
                        if SerialNoInfo."Serial Status PROF" <> SerialNoInfo."Serial Status PROF"::"Not Tested" then
                            if UsageDecision.Get(Rec."Usage Decision") then
                                if not UsageDecision."Not Update Lot No & Expir Date" then
                                    if Item.Get(Rec."Item No.") then begin
                                        Rec."New Serial No." := NoSeries.GetNextNo(Item."Serial Nos.", WorkDate(), true);
                                        Rec."New Vendor Serial No." := SerialNoInfo."Vendor Serial No. PROF";
                                        Rec."New Country/Region of Origin" := SerialNoInfo."Country/Region of Origin PROF";
                                    end;
                end;
            end;
        }
        field(324; "TO Test Order Internal Use"; Boolean)
        {
            Caption = 'Default Test Order to Internal Use Only';
            DataClassification = CustomerContent;
        }

        field(325; "COA Received"; Boolean)
        {
            Caption = 'COA Received';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Test Order Status", "Test Order Status"::Open);

                if not "COA Received" then begin
                    Clear("COA Document");
                    "COA File Name" := '';
                end;
            end;
        }
        field(326; "COA Document"; Blob)
        {
            Caption = 'COA Document';
            DataClassification = CustomerContent;
        }
        field(327; "COA File Name"; Text[250])
        {
            Caption = 'COA File Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Test Order No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Lot No.")
        {
        }
        key(Key3; "Lot No.")
        {
            Enabled = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TOSetup: Record "TO Setup PROF";
        UsageDecision: Record "TO Usage Decision PROF";
        NoSeries: Codeunit "No. Series";
    begin
        TestField("Document Type");
        if "Test Order No." = '' then begin
            TOSetup.Get();
            TOSetup.TestField("Test Order Nos.");
            "Test Order No." := NoSeries.GetNextNo(TOSetup."Test Order Nos.", WorkDate(), true);
            "No. Series" := TOSetup."Test Order Nos.";
            TestField("Test Order No.");
        end;
        "Creation Date Time" := RoundDateTime(CurrentDateTime);
        "Record ID" := RecordId();

        UsageDecision.SetRange("Default Usage Decision", true);
        if UsageDecision.FindFirst() then
            Rec.Validate("Usage Decision", UsageDecision.Code);
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := RoundDateTime(CurrentDateTime);
    end;

    trigger OnDelete()
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
    begin
        if ("Tracking Status" <> "Tracking Status"::"Not Tested") then
            FieldError("Tracking Status");
        if "Order Type" = "Order Type"::"Test Order" then begin
            FilterGroup(5);
            if GetFilter("Test Order No.") <> "Test Order No." then begin
                FilterGroup(0);
                FieldError("Order Type");
            end;
            FilterGroup(0);
        end;

        // Handle Lot No Information
        if ("Lot No." <> '') and LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then
            if LotNoInfo."Test Order No. PROF" <> '' then begin
                LotNoInfo."Test Order No. PROF" := ''; // "Test Order No." was temporary set on the LotNoInfo while the Test Order was ongoing.
                LotNoInfo.Modify(false);
            end;

        // Handle Serial No Information
        if ("Serial No." <> '') and SerialNoInfo.Get("Item No.", "Variant Code", "Serial No.") then
            if SerialNoInfo."Test Order No. PROF" <> '' then begin
                SerialNoInfo."Test Order No. PROF" := ''; // "Test Order No." was temporary set on the SerialNoInfo while the Test Order was ongoing.
                SerialNoInfo.Modify(false);
            end;

        if "Order Type" <> "Order Type"::"Test Order" then begin
            // Handle Lot No Status Entries
            if "Lot No." <> '' then begin
                TrackingNoStatusEntry.Reset();
                TrackingNoStatusEntry.SetRange("Item No.", "Item No.");
                TrackingNoStatusEntry.SetRange("Variant Code", "Variant Code");
                TrackingNoStatusEntry.SetRange("Lot No.", "Lot No.");
                TrackingNoStatusEntry.SetRange("Test Order No.", "Test Order No.");
                if not TrackingNoStatusEntry.IsEmpty() then
                    TrackingNoStatusEntry.DeleteAll(true);
            end;

            // Handle Serial No Status Entries
            if "Serial No." <> '' then begin
                TrackingNoStatusEntry.Reset();
                TrackingNoStatusEntry.SetRange("Item No.", "Item No.");
                TrackingNoStatusEntry.SetRange("Variant Code", "Variant Code");
                TrackingNoStatusEntry.SetRange("Serial No.", "Serial No.");
                TrackingNoStatusEntry.SetRange("Test Order No.", "Test Order No.");
                if not TrackingNoStatusEntry.IsEmpty() then
                    TrackingNoStatusEntry.DeleteAll(true);
            end;
        end;
    end;

    trigger OnRename()
    begin
        "Record ID" := RecordId();
    end;

    internal procedure CreateRecord()
    var
        LotNoInfo: Record "Lot No. Information";
        LotNoInfoPage: Page "TO Lot No. Info List PROF";
        OrderType: Option;
    begin
        LotNoInfoPage.SetTableView(LotNoInfo);
        LotNoInfoPage.LookupMode(true);
        OrderType := "Order Type"::"Manual Order";
        "Order Type" := OrderType;
        LotNoInfoPage.Caption := LotNoInfoPage.Caption + ' ' + Format("Order Type");

        if LotNoInfoPage.RunModal() = Action::LookupOK then begin
            LotNoInfoPage.GetRecord(LotNoInfo);
            CreateRecord(LotNoInfo, 0, '', 0, 0, OrderType, true);
        end;
    end;

    internal procedure CreateRecordSN()
    var
        SerialNoInfo: Record "Serial No. Information";
        SerialNoInfoPage: Page "TO Serial No. Info List PROF";
        OrderType: Option;
    begin
        SerialNoInfoPage.SetTableView(SerialNoInfo);
        SerialNoInfoPage.LookupMode(true);
        OrderType := "Order Type"::"Manual Order";
        "Order Type" := OrderType;
        SerialNoInfoPage.Caption := SerialNoInfoPage.Caption + ' ' + Format("Order Type");

        if SerialNoInfoPage.RunModal() = Action::LookupOK then begin
            SerialNoInfoPage.GetRecord(SerialNoInfo);
            CreateRecordSN(SerialNoInfo, 0, '', 0, 0, OrderType, true);
        end;
    end;


    internal procedure CreateRecord(LotNoInfo: Record "Lot No. Information"; DocumentType: Option; DocumentNo: Code[20]; DocumentLineNo: Integer; DimensionSetID: Integer; OrderType: Option; OpenPage: Boolean)
    var
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        TOTestOrder: Record "TO Test Order PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
        LocationCode: Code[10];
    begin
        LotNoInfo.TestField("Item No.");
        LotNoInfo.TestField("Lot No.");

        LocationCode := TOLotManagement.GetLocationCode(CopyStr(UserId(), 1, 50), '', LotNoInfo."Item No.", LotNoInfo."Variant Code", LotNoInfo."Lot No.", '', '', true);

        if OrderType <> "Order Type"::"Test Order" then begin
            LotNoInfo.SetFilter("Location Filter", LocationCode);
            LotNoInfo.CalcFields(Inventory);
            if LotNoInfo.Inventory <= 0 then
                LotNoInfo.FieldError(Inventory);
        end;

        if DocumentType = 0 then begin
            TOTestOrder.Reset();
            TOTestOrder.SetCurrentKey("Item No.", "Variant Code", "Lot No.");
            TOTestOrder.SetRange("Item No.", LotNoInfo."Item No.");
            TOTestOrder.SetRange("Variant Code", LotNoInfo."Variant Code");
            TOTestOrder.SetRange("Lot No.", LotNoInfo."Original Lot No. PROF");
            TOTestOrder.SetFilter("Test Order No.", '<>%1', "Test Order No.");
            if TOTestOrder.IsEmpty() then begin
                TOTestOrder.SetRange("Lot No."); // Reset.
                TOTestOrder.SetRange("Original Lot No.", LotNoInfo."Original Lot No. PROF");
            end;
            if TOTestOrder.FindLast() then begin
                DocumentType := TOTestOrder."Document Type";
                DocumentNo := TOTestOrder."Document No.";
                DocumentLineNo := TOTestOrder."Document Line No.";
                DimensionSetID := TOTestOrder."Dimension Set ID";
            end;
        end;

        TrackingNoStatusEntry.SetRange("Item No.", LotNoInfo."Item No.");
        TrackingNoStatusEntry.SetRange("Variant Code", LotNoInfo."Variant Code");
        TrackingNoStatusEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        if not TrackingNoStatusEntry.FindLast() then begin
            TrackingNoStatusEntry.Init();
            TrackingNoStatusEntry."Item No." := LotNoInfo."Item No.";
            TrackingNoStatusEntry."Variant Code" := LotNoInfo."Variant Code";
            TrackingNoStatusEntry."Lot No." := LotNoInfo."Lot No.";
            TrackingNoStatusEntry."Entry No." := 0;
            TrackingNoStatusEntry."Internal Use Only" := LotNoInfo."Internal Use Only PROF";
            TrackingNoStatusEntry."Local Impact" := LotNoInfo."Local Impact PROF";
        end;
        TrackingNoStatusEntry."Order Type" := OrderType + 1;
        TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::"Not Tested";

        if DocumentType = 0 then // Due to historical data is missing the "Document Type" (2021-04-01)
            DocumentType := TOTestOrder."Document Type"::Purchase;
        CreateRecord(LotNoInfo, TrackingNoStatusEntry, LocationCode, DocumentType, DocumentNo, DocumentLineNo, DimensionSetID, OrderType, OpenPage);
    end;

    internal procedure CreateRecordSN(SerialNoInfo: Record "Serial No. Information"; DocumentType: Option; DocumentNo: Code[20]; DocumentLineNo: Integer; DimensionSetID: Integer; OrderType: Option; OpenPage: Boolean)
    var
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        TOTestOrder: Record "TO Test Order PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
        LocationCode: Code[10];
    begin
        SerialNoInfo.TestField("Item No.");
        SerialNoInfo.TestField("Serial No.");

        LocationCode := TOLotManagement.GetLocationCode(CopyStr(UserId(), 1, 50), '', SerialNoInfo."Item No.", SerialNoInfo."Variant Code", '', SerialNoInfo."Serial No.", '', true);

        if OrderType <> "Order Type"::"Test Order" then begin
            SerialNoInfo.SetFilter("Location Filter", LocationCode);
            SerialNoInfo.CalcFields(Inventory);
            if SerialNoInfo.Inventory <= 0 then
                SerialNoInfo.FieldError(Inventory);
        end;

        if DocumentType = 0 then begin
            TOTestOrder.Reset();
            TOTestOrder.SetCurrentKey("Item No.", "Variant Code", "Serial No.");
            TOTestOrder.SetRange("Item No.", SerialNoInfo."Item No.");
            TOTestOrder.SetRange("Variant Code", SerialNoInfo."Variant Code");
            TOTestOrder.SetRange("Serial No.", SerialNoInfo."Serial No.");
            TOTestOrder.SetFilter("Test Order No.", '<>%1', "Test Order No.");
            if TOTestOrder.IsEmpty() then begin
                TOTestOrder.SetRange("Serial No."); // Reset.
                TOTestOrder.SetRange("Original Serial No.", SerialNoInfo."Original Serial No. PROF");
            end;
            if TOTestOrder.FindLast() then begin
                DocumentType := TOTestOrder."Document Type";
                DocumentNo := TOTestOrder."Document No.";
                DocumentLineNo := TOTestOrder."Document Line No.";
                DimensionSetID := TOTestOrder."Dimension Set ID";
            end;
        end;

        TrackingNoStatusEntry.SetRange("Item No.", SerialNoInfo."Item No.");
        TrackingNoStatusEntry.SetRange("Variant Code", SerialNoInfo."Variant Code");
        TrackingNoStatusEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
        if not TrackingNoStatusEntry.FindLast() then begin
            TrackingNoStatusEntry.Init();
            TrackingNoStatusEntry."Item No." := SerialNoInfo."Item No.";
            TrackingNoStatusEntry."Variant Code" := SerialNoInfo."Variant Code";
            TrackingNoStatusEntry."Serial No." := SerialNoInfo."Serial No.";
            TrackingNoStatusEntry."Entry No." := 0;
            TrackingNoStatusEntry."Internal Use Only" := SerialNoInfo."Internal Use Only PROF";
            TrackingNoStatusEntry."Local Impact" := SerialNoInfo."Local Impact PROF";
        end;
        TrackingNoStatusEntry."Order Type" := OrderType + 1;
        TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::"Not Tested";

        if DocumentType = 0 then // Due to historical data is missing the "Document Type" (2021-04-01)
            DocumentType := TOTestOrder."Document Type"::Purchase;
        CreateRecordSN(SerialNoInfo, TrackingNoStatusEntry, LocationCode, DocumentType, DocumentNo, DocumentLineNo, DimensionSetID, OrderType, OpenPage);
    end;


    internal procedure CreateRecord(var ItemLedgerEntry: Record "Item Ledger Entry"; Item: Record Item)
    var
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        TrackingNoStatusEntry2: Record "TO Tracking No. Status PROF";
        TOTestOrder: Record "TO Test Order PROF";
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";

    begin
        if (ItemLedgerEntry.Positive) and (ItemLedgerEntry."Lot No." <> '') then
            if ItemLedgerEntry."Entry Type" in [ItemLedgerEntry."Entry Type"::Purchase, ItemLedgerEntry."Entry Type"::Output] then begin
                case ItemLedgerEntry."Entry Type" of
                    ItemLedgerEntry."Entry Type"::Purchase:
                        TOTestOrder."Document Type" := TOTestOrder."Document Type"::Purchase;
                    ItemLedgerEntry."Entry Type"::Output:
                        TOTestOrder."Document Type" := TOTestOrder."Document Type"::Production;
                end;
                TrackingNoStatusEntry.Init();
                TrackingNoStatusEntry."Item No." := ItemLedgerEntry."Item No.";
                TrackingNoStatusEntry."Variant Code" := ItemLedgerEntry."Variant Code";
                TrackingNoStatusEntry."Lot No." := ItemLedgerEntry."Lot No.";
                TrackingNoStatusEntry."Entry No." := 0;
                TrackingNoStatusEntry."Document Type" := TOTestOrder."Document Type";
                TrackingNoStatusEntry."Document No." := ItemLedgerEntry."Document No.";
                TrackingNoStatusEntry."Document Line No." := ItemLedgerEntry."Document Line No.";
                TrackingNoStatusEntry."Vendor Lot No." := ItemLedgerEntry."Vendor Lot No. PROF";
                TrackingNoStatusEntry."Order Type" := TrackingNoStatusEntry."Order Type"::" ";
                TrackingNoStatusEntry."Internal Use Only" := Item."Internal Use Only PROF";
                if not Item."QC Required PROF" then begin
                    Clear(LotNoInfo);

                    if LotNoInfo."Item No." = '' then
                        TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::Approved
                    else
                        TrackingNoStatusEntry."Tracking Status" := LotNoInfo."Lot Status PROF";
                end else
                    TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::"Not Tested";
                ItemLedgerEntry."Tracking Status PROF" := TrackingNoStatusEntry."Tracking Status";

                if (Item."QC Required PROF") and (TrackingNoStatusEntry."Tracking Status" = TrackingNoStatusEntry."Tracking Status"::"Not Tested") then begin
                    LotNoInfo.Get(TrackingNoStatusEntry."Item No.", TrackingNoStatusEntry."Variant Code", TrackingNoStatusEntry."Lot No.");
                    CreateRecord(LotNoInfo, TrackingNoStatusEntry, ItemLedgerEntry."Location Code", TOTestOrder."Document Type", ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.", ItemLedgerEntry."Dimension Set ID", TOTestOrder."Order Type"::"Test Order", true);
                    TrackingNoStatusEntry.DoInsert("Test Order No.", false, true);
                end else begin
                    TrackingNoStatusEntry2.SetRange("Item No.", TrackingNoStatusEntry."Item No.");
                    TrackingNoStatusEntry2.SetRange("Variant Code", TrackingNoStatusEntry."Variant Code");
                    TrackingNoStatusEntry2.SetRange("Lot No.", TrackingNoStatusEntry."Lot No.");
                    TrackingNoStatusEntry2.SetRange("Tracking Status", TrackingNoStatusEntry."Tracking Status");
                    TrackingNoStatusEntry2.SetRange("Vendor Lot No.", TrackingNoStatusEntry."Vendor Lot No.");
                    if TrackingNoStatusEntry2.IsEmpty() then
                        TrackingNoStatusEntry.DoInsert('', false, true);
                end;
            end;


        if (ItemLedgerEntry.Positive) and (ItemLedgerEntry."Serial No." <> '') then
            if ItemLedgerEntry."Entry Type" in [ItemLedgerEntry."Entry Type"::Purchase, ItemLedgerEntry."Entry Type"::Output] then begin
                case ItemLedgerEntry."Entry Type" of
                    ItemLedgerEntry."Entry Type"::Purchase:
                        TOTestOrder."Document Type" := TOTestOrder."Document Type"::Purchase;
                    ItemLedgerEntry."Entry Type"::Output:
                        TOTestOrder."Document Type" := TOTestOrder."Document Type"::Production;
                end;
                TrackingNoStatusEntry.Init();
                TrackingNoStatusEntry."Item No." := ItemLedgerEntry."Item No.";
                TrackingNoStatusEntry."Variant Code" := ItemLedgerEntry."Variant Code";
                TrackingNoStatusEntry."Serial No." := ItemLedgerEntry."Serial No.";
                TrackingNoStatusEntry."Entry No." := 0;
                TrackingNoStatusEntry."Document Type" := TOTestOrder."Document Type";
                TrackingNoStatusEntry."Document No." := ItemLedgerEntry."Document No.";
                TrackingNoStatusEntry."Document Line No." := ItemLedgerEntry."Document Line No.";
                TrackingNoStatusEntry."Vendor Serial No." := ItemLedgerEntry."Vendor Serial No. PROF";
                TrackingNoStatusEntry."Order Type" := TrackingNoStatusEntry."Order Type"::" ";
                TrackingNoStatusEntry."Internal Use Only" := Item."Internal Use Only PROF";
                if not Item."QC Required PROF" then begin
                    Clear(SerialNoInfo);

                    if SerialNoInfo."Item No." = '' then
                        TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::Approved
                    else
                        TrackingNoStatusEntry."Tracking Status" := SerialNoInfo."Serial Status PROF";
                end else
                    TrackingNoStatusEntry."Tracking Status" := TrackingNoStatusEntry."Tracking Status"::"Not Tested";
                ItemLedgerEntry."Tracking Status PROF" := TrackingNoStatusEntry."Tracking Status";

                if (Item."QC Required PROF") and (TrackingNoStatusEntry."Tracking Status" = TrackingNoStatusEntry."Tracking Status"::"Not Tested") then begin
                    SerialNoInfo.Get(TrackingNoStatusEntry."Item No.", TrackingNoStatusEntry."Variant Code", TrackingNoStatusEntry."Serial No.");
                    CreateRecordSN(SerialNoInfo, TrackingNoStatusEntry, ItemLedgerEntry."Location Code", TOTestOrder."Document Type", ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.", ItemLedgerEntry."Dimension Set ID", TOTestOrder."Order Type"::"Test Order", true);
                    TrackingNoStatusEntry.DoInsert("Test Order No.", false, true);
                end else begin
                    TrackingNoStatusEntry2.SetRange("Item No.", TrackingNoStatusEntry."Item No.");
                    TrackingNoStatusEntry2.SetRange("Variant Code", TrackingNoStatusEntry."Variant Code");
                    TrackingNoStatusEntry2.SetRange("Serial No.", TrackingNoStatusEntry."Serial No.");
                    TrackingNoStatusEntry2.SetRange("Tracking Status", TrackingNoStatusEntry."Tracking Status");
                    TrackingNoStatusEntry2.SetRange("Vendor Serial No.", TrackingNoStatusEntry."Vendor Serial No.");
                    if TrackingNoStatusEntry2.IsEmpty() then
                        TrackingNoStatusEntry.DoInsert('', false, true);
                end;
            end;

    end;

    internal procedure CreateManuelTestOrder(var ItemLedgerEntry: Record "Item Ledger Entry"; Item: Record Item)
    var
        TOTestOrder: Record "TO Test Order PROF";
        LotNoInfo: Record "Lot No. Information";
    begin
        if (ItemLedgerEntry.Positive) and (ItemLedgerEntry."Lot No." <> '') then
            if (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") then begin
                TOTestOrder."Order Type" := "Order Type"::"Manual Order";
                if LotNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then
                    CreateRecord(LotNoInfo, 0, '', 0, 0, TOTestOrder."Order Type", false);
            end;
    end;

    internal procedure CreateManuelTestOrderSN(var ItemLedgerEntry: Record "Item Ledger Entry"; Item: Record Item)
    var
        TOTestOrder: Record "TO Test Order PROF";
        SerialNoInfo: Record "Serial No. Information";
    begin
        if (ItemLedgerEntry.Positive) and (ItemLedgerEntry."Serial No." <> '') then
            if (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") then begin
                TOTestOrder."Order Type" := "Order Type"::"Manual Order";
                if SerialNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") then
                    CreateRecordSN(SerialNoInfo, 0, '', 0, 0, TOTestOrder."Order Type", false);
            end;
    end;

    local procedure CreateRecord(LotNoInfo: Record "Lot No. Information"; var TrackingNoStatusEntry: Record "TO Tracking No. Status PROF"; LocationCode: Code[10]; DocumentType: Option; DocumentNo: Code[20]; DocumentLineNo: Integer; DimensionSetID: Integer; OrderType: Option; OpenPage: Boolean)
    var
        Company: Record Company;
        TOSetup: Record "TO Setup PROF";
        TOTestOrder: Record "TO Test Order PROF";
        Item: Record Item;
        ItemTrackingComment: Record "Item Tracking Comment";
        //  NoSeriesMgt: Codeunit NoSeriesManagement;
        DoNotCreateRecord: Boolean;
        OnGoingTestOrderExistsInAnOtherCompanyErr: Label '%1 %2 %3 %4 exists in %5 %6. Please finish the %1 before creating a new.', Comment = '%1 = TOTestOrder.TableCaption(), %2 = TOTestOrder."Test Order No.", %3 = TOTestOrder.FieldCaption("Test Order Status"), %4 = TOTestOrder."Test Order Status", %5 =Company.TableCaption, %6 = Company.Name';
    begin
        if OrderType <> "Order Type"::"Test Order" then begin // Avoid having multible ongoing Test Orders.
            Company.SetFilter(Name, '<>%1', CompanyName());
            if Company.FindSet() then begin
                TOTestOrder.Reset();
                TOTestOrder.SetRange("Item No.", TrackingNoStatusEntry."Item No.");
                TOTestOrder.SetRange("Variant Code", TrackingNoStatusEntry."Variant Code");
                TOTestOrder.SetRange("Lot No.", TrackingNoStatusEntry."Lot No.");
                TOTestOrder.SetRange("Test Order Status", TOTestOrder."Test Order Status"::Open);
                repeat
                    TOTestOrder.ChangeCompany(Company.Name);
                    if TOTestOrder.FindFirst() then
                        Error(OnGoingTestOrderExistsInAnOtherCompanyErr, TOTestOrder.TableCaption(), TOTestOrder."Test Order No.", TOTestOrder.FieldCaption("Test Order Status"), TOTestOrder."Test Order Status", Company.TableCaption, Company.Name);
                until (Company.Next() = 0);
            end;
            Clear(TOTestOrder);
        end;

        if LotNoInfo."Test Order No. PROF" <> '' then
            if (TOTestOrder.Get(LotNoInfo."Test Order No. PROF")) and (TOTestOrder."Tracking Status" = TOTestOrder."Tracking Status"::"Not Tested") then begin
                DoNotCreateRecord := true;
                Rec := TOTestOrder;
                if (OrderType = "Order Type"::"Retest Order") and ("Order Type" = "Order Type"::"Manual Order") then begin
                    "Document Type" := DocumentType;
                    "Document No." := DocumentNo;
                    "Document Line No." := DocumentLineNo;
                    "Dimension Set ID" := DimensionSetID;
                    "Order Type" := OrderType;
                    Modify(false);
                end;
                TestField("Item No.", TrackingNoStatusEntry."Item No.");
                TestField("Variant Code", TrackingNoStatusEntry."Variant Code");
                TestField("Lot No.", TrackingNoStatusEntry."Lot No.");
            end;

        Item.Get(TrackingNoStatusEntry."Item No.");

        if not DoNotCreateRecord then begin
            "Test Order No." := '';
            Init();
            "Item No." := TrackingNoStatusEntry."Item No.";
            "Variant Code" := TrackingNoStatusEntry."Variant Code";
            "Lot No." := TrackingNoStatusEntry."Lot No.";
            "Document Type" := DocumentType;
            "Document No." := DocumentNo;
            "Document Line No." := DocumentLineNo;
            "Dimension Set ID" := DimensionSetID;
            "Order Type" := OrderType;
            "Location Code" := LocationCode;
            "Unit of Measure Code" := Item."Base Unit of Measure";
            //"Internal Use Only" := Item."Internal Use Only"; // P.t. is "Internal Use Only" initiated from Item."Internal Use Only" instead of LotNoInfo."Internal Use Only"
            if "Order Type" = "Order Type"::"Test Order" then
                "Internal Use Only" := Item."TO Test Order Intern Use PROF";
            "Vendor Lot No." := LotNoInfo."Vendor Lot No. PROF";
            "Original Lot No." := LotNoInfo."Original Lot No. PROF";
            "Retest Date" := LotNoInfo."Retest Date PROF";
            "Expiration Date" := LotNoInfo."Expiration Date PROF";
            "Original Expiration Date" := LotNoInfo."Original Expiration Date PROF";
            "Sales Expiration Date" := LotNoInfo."Sales Expiration Date PROF";
            "Country/Region of Origin" := LotNoInfo."Country/Region of Origin PROF";

            if "Order Type" = "Order Type"::"Test Order" then
                Quantity := Item."Reference Sample PROF";

            Insert(true);


            LotNoInfo."Test Order No. PROF" := "Test Order No.";
            LotNoInfo.Modify(false);
        end;

        TrackingNoStatusEntry."Test Order No." := "Test Order No.";
        TrackingNoStatusEntry."Order Type" := "Order Type" + 1;

        if ("Order Type" <> "Order Type"::"Test Order") and OpenPage then begin
            if "Tracking Status" <> "Tracking Status"::"Not Tested" then begin
                TrackingNoStatusEntry."Entry No." := 0;
                TrackingNoStatusEntry.DoInsert('', false, true);
            end;
            TOSetup.Get();
            if (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::Both) or
               (("Order Type" = "Order Type"::"Retest Order") and (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::"Retest Order")) or
               (("Order Type" = "Order Type"::"Manual Order") and (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::"Manual Order")) then
                Page.Run(Page::"TO Test Order Card PROF", Rec);
        end;
    end;


    local procedure CreateRecordSN(SerialNoInfo: Record "Serial No. Information"; var TrackingNoStatusEntry: Record "TO Tracking No. Status PROF"; LocationCode: Code[10]; DocumentType: Option; DocumentNo: Code[20]; DocumentLineNo: Integer; DimensionSetID: Integer; OrderType: Option; OpenPage: Boolean)
    var
        Company: Record Company;
        TOSetup: Record "TO Setup PROF";
        TOTestOrder: Record "TO Test Order PROF";
        Item: Record Item;
        ItemTrackingComment: Record "Item Tracking Comment";
        //  NoSeriesMgt: Codeunit NoSeriesManagement;
        DoNotCreateRecord: Boolean;
        OnGoingTestOrderExistsInAnOtherCompanyErr: Label '%1 %2 %3 %4 exists in %5 %6. Please finish the %1 before creating a new.', Comment = '%1 = TOTestOrder.TableCaption(), %2 = TOTestOrder."Test Order No.", %3 = TOTestOrder.FieldCaption("Test Order Status"), %4 = TOTestOrder."Test Order Status", %5 =Company.TableCaption, %6 = Company.Name';
    begin
        if OrderType <> "Order Type"::"Test Order" then begin // Avoid having multible ongoing Test Orders.
            Company.SetFilter(Name, '<>%1', CompanyName());
            if Company.FindSet() then begin
                TOTestOrder.Reset();
                TOTestOrder.SetRange("Item No.", TrackingNoStatusEntry."Item No.");
                TOTestOrder.SetRange("Variant Code", TrackingNoStatusEntry."Variant Code");
                TOTestOrder.SetRange("Serial No.", TrackingNoStatusEntry."Serial No.");
                TOTestOrder.SetRange("Test Order Status", TOTestOrder."Test Order Status"::Open);
                repeat
                    TOTestOrder.ChangeCompany(Company.Name);
                    if TOTestOrder.FindFirst() then
                        Error(OnGoingTestOrderExistsInAnOtherCompanyErr, TOTestOrder.TableCaption(), TOTestOrder."Test Order No.", TOTestOrder.FieldCaption("Test Order Status"), TOTestOrder."Test Order Status", Company.TableCaption, Company.Name);
                until (Company.Next() = 0);
            end;
            Clear(TOTestOrder);
        end;

        if SerialNoInfo."Test Order No. PROF" <> '' then
            if (TOTestOrder.Get(SerialNoInfo."Test Order No. PROF")) and (TOTestOrder."Tracking Status" = TOTestOrder."Tracking Status"::"Not Tested") then begin
                DoNotCreateRecord := true;
                Rec := TOTestOrder;
                if (OrderType = "Order Type"::"Retest Order") and ("Order Type" = "Order Type"::"Manual Order") then begin
                    "Document Type" := DocumentType;
                    "Document No." := DocumentNo;
                    "Document Line No." := DocumentLineNo;
                    "Dimension Set ID" := DimensionSetID;
                    "Order Type" := OrderType;
                    Modify(false);
                end;
                TestField("Item No.", TrackingNoStatusEntry."Item No.");
                TestField("Variant Code", TrackingNoStatusEntry."Variant Code");
                TestField("Serial No.", TrackingNoStatusEntry."Serial No.");
            end;

        Item.Get(TrackingNoStatusEntry."Item No.");

        if not DoNotCreateRecord then begin
            "Test Order No." := '';
            Init();
            "Item No." := TrackingNoStatusEntry."Item No.";
            "Variant Code" := TrackingNoStatusEntry."Variant Code";
            "Serial No." := TrackingNoStatusEntry."Serial No.";
            "Document Type" := DocumentType;
            "Document No." := DocumentNo;
            "Document Line No." := DocumentLineNo;
            "Dimension Set ID" := DimensionSetID;
            "Order Type" := OrderType;
            "Location Code" := LocationCode;
            "Unit of Measure Code" := Item."Base Unit of Measure";
            //"Internal Use Only" := Item."Internal Use Only"; // P.t. is "Internal Use Only" initiated from Item."Internal Use Only" instead of LotNoInfo."Internal Use Only"
            if "Order Type" = "Order Type"::"Test Order" then
                "Internal Use Only" := Item."TO Test Order Intern Use PROF";
            "Vendor Serial No." := SerialNoInfo."Vendor Serial No. PROF";
            "Original Serial No." := SerialNoInfo."Original Serial No. PROF";
            "Retest Date" := SerialNoInfo."Retest Date PROF";
            "Expiration Date" := SerialNoInfo."Expiration Date PROF";
            "Original Expiration Date" := SerialNoInfo."Original Expiration Date PROF";
            "Sales Expiration Date" := SerialNoInfo."Sales Expiration Date PROF";
            "Country/Region of Origin" := SerialNoInfo."Country/Region of Origin PROF";

            if "Order Type" = "Order Type"::"Test Order" then
                Quantity := Item."Reference Sample PROF";

            Insert(true);


            SerialNoInfo."Test Order No. PROF" := "Test Order No.";
            SerialNoInfo.Modify(false);
        end;

        TrackingNoStatusEntry."Test Order No." := "Test Order No.";
        TrackingNoStatusEntry."Order Type" := "Order Type" + 1;

        if ("Order Type" <> "Order Type"::"Test Order") and OpenPage then begin
            if "Tracking Status" <> "Tracking Status"::"Not Tested" then begin
                TrackingNoStatusEntry."Entry No." := 0;
                TrackingNoStatusEntry.DoInsert('', false, true);
            end;
            TOSetup.Get();
            if (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::Both) or
               (("Order Type" = "Order Type"::"Retest Order") and (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::"Retest Order")) or
               (("Order Type" = "Order Type"::"Manual Order") and (TOSetup."Test Order Open Page" = TOSetup."Test Order Open Page"::"Manual Order")) then
                Page.Run(Page::"TO Test Order Card PROF", Rec);
        end;
    end;


    internal procedure SetLotStatus(UsageDecisionCode: Code[20])
    var
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        LotNoInfo: Record "Lot No. Information";
        Item: Record Item;
        UsageDecision: Record "TO Usage Decision PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
        LotStatusBefore: Enum "TO Lot Status PROF";
        LotStatusText: Text;
        CountryRegionOfOrigin: Code[10];
        RetestDate: Date;
        SalesExpirationDate: Date;
        ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo: Boolean;
        ConfirmLotStatusChangeQst: Label '%1 %2\\Do you want to %3 ?\\', Comment = '%1 = TableCaption, %2 = Test Order No.. %3 = Tracking Status';
        ApproveLbl: Label 'approve';
        RejectLbl: Label 'reject';
        RestrictedLbl: Label 'restrict';
    begin
        if ("Test Order No." = '') or ("Item No." = '') or ("Lot No." = '') then
            exit;
        if "Test Order Status" <> "Test Order Status"::Open then
            exit;
        if "Tracking Status" <> "Tracking Status"::"Not Tested" then
            exit;

        UsageDecision.Get(UsageDecisionCode);

        case UsageDecision."Tracking Status" of
            "Tracking Status"::Approved:
                begin
                    LotStatusText := ApproveLbl;
                    if "Internal Use Only" then
                        LotStatusText := LotStatusText + ' (' + FieldCaption("Internal Use Only") + ')';
                end;
            "Tracking Status"::Rejected:
                LotStatusText := RejectLbl;

            "Tracking Status"::Restricted:
                LotStatusText := RestrictedLbl;
            else
                exit;
        end;

        if not Confirm(ConfirmLotStatusChangeQst, true, TableCaption(), "Test Order No.", LotStatusText) then
            exit;

        "Test Order Status" := "Test Order Status"::Posted;
        LotStatusBefore := "Tracking Status";
        "Tracking Status" := UsageDecision."Tracking Status";
        "Posted By" := CopyStr(UserId, 1, MaxStrLen("Posted By"));
        Modify(true);

        Item.Get("Item No.");

        TrackingNoStatusEntry.Init();
        TrackingNoStatusEntry."Item No." := "Item No.";
        TrackingNoStatusEntry."Variant Code" := "Variant Code";
        TrackingNoStatusEntry."Lot No." := "Lot No.";
        TrackingNoStatusEntry."Entry No." := 0;
        TrackingNoStatusEntry."Document Type" := "Document Type";
        TrackingNoStatusEntry."Document No." := "Document No.";
        TrackingNoStatusEntry."Document Line No." := "Document Line No.";
        TrackingNoStatusEntry."Order Type" := "Order Type" + 1;
        TrackingNoStatusEntry."Tracking Status" := "Tracking Status";
        TrackingNoStatusEntry."Usage Decision" := UsageDecisionCode;
        TrackingNoStatusEntry."Internal Use Only" := "Internal Use Only";
        TrackingNoStatusEntry.Blocked := UsageDecision."Block Tracking No.";
        TrackingNoStatusEntry."Local Impact" := "Local Impact";
        TrackingNoStatusEntry."Test Order No." := "Test Order No.";
        // TrackingNoStatusEntry is inserted after the LotNoInfo is updated, as the TrackingNoStatusEntry insert is generating the LotNoSynchEntry.CreateSynchRecords.

        ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
        LotNoInfo.Get("Item No.", "Variant Code", "Lot No.");
        if PostLotNo() <> "Lot No." then begin
            if LotNoInfo."Test Order No. PROF" <> '' then begin
                LotNoInfo."Test Order No. PROF" := ''; // "Test Order No." was temporary set on the LotNoInfo while the Test Order was ongoing.
                LotNoInfo.Modify(false);
            end;
            if not LotNoInfo.Get("Item No.", "Variant Code", "New Lot No.") then begin // Create and Get the "New Lot No.".
                if "Order Type" <> "Order Type"::"Manual Order" then
                    CountryRegionOfOrigin := "Country/Region of Origin"
                else
                    CountryRegionOfOrigin := "New Country/Region of Origin";
                RetestDate := "Retest Date";
                SalesExpirationDate := "Sales Expiration Date";
                if not ("New Expiration Date" in [0D, "Expiration Date"]) then begin
                    if Format(Item."Retest Calculation PROF") <> '' then
                        RetestDate := CalcDate(Item."Retest Calculation PROF", "New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        SalesExpirationDate := CalcDate(Item."Sales Expiration Calc. PROF", "New Expiration Date");
                end;
                TOLotManagement.CreateLotNoInfo(Rec, "New Lot No.", RetestDate, CreateDateTime(WorkDate(), Time()), SalesExpirationDate, CountryRegionOfOrigin, LotNoInfo."Original Lot No. PROF", LotNoInfo."Original Expiration Date PROF");
                LotNoInfo.Get("Item No.", "Variant Code", "New Lot No.");
            end;
        end;
        if (LotNoInfo.Blocked) or ("Tracking Status" <> LotNoInfo."Lot Status PROF") or ("Internal Use Only" <> LotNoInfo."Internal Use Only PROF") or ("Local Impact" <> LotNoInfo."Local Impact PROF") or (LotNoInfo."Test Order No. PROF" <> '') then begin
            if (PostLotNo() = "Lot No.") and ("Order Type" = "Order Type"::"Manual Order") then begin
                ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := true;
                if "New Vendor Lot No." <> LotNoInfo."Vendor Lot No. PROF" then begin
                    ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
                    LotNoInfo."Vendor Lot No. PROF" := "New Vendor Lot No.";
                end;
                LotNoInfo."Country/Region of Origin PROF" := "New Country/Region of Origin";
                if not ("New Expiration Date" in [0D, "Expiration Date"]) then begin
                    ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
                    LotNoInfo."Expiration Date PROF" := "New Expiration Date";
                    if Format(Item."Retest Calculation PROF") <> '' then
                        LotNoInfo."Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", "New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        LotNoInfo."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", "New Expiration Date");
                end;
            end;

            LotNoInfo.Blocked := UsageDecision."Block Tracking No.";
            LotNoInfo."Lot Status PROF" := "Tracking Status";
            LotNoInfo."Usage Decision PROF" := UsageDecisionCode;
            LotNoInfo."Internal Use Only PROF" := "Internal Use Only";
            LotNoInfo."Local Impact PROF" := "Local Impact";
            LotNoInfo."Test Order No. PROF" := '';
            LotNoInfo.Modify(false);
        end;

        if ("New Lot No." in ['', "Lot No."]) then
            TrackingNoStatusEntry.DoInsert("Test Order No.", false, true) // Generating the LotNoSynchEntry.CreateSynchRecords.
        else
            if InternalUseOnlyAndSameExpirationDate() then // Add TrackingNoStatusEntry for the "Internal Use Only" change on the existing Lot.
                TrackingNoStatusEntry.DoInsert("Test Order No.", false, true); // Generating the LotNoSynchEntry.CreateSynchRecords.


        if "Tracking Status" <> LotStatusBefore then
            TOLotManagement.PostTestOrder(Rec, LotStatusBefore, ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo);
    end;



    internal procedure SetLotStatusSN(UsageDecisionCode: Code[20])
    var
        TrackingNoStatusEntry: Record "TO Tracking No. Status PROF";
        SerialNoInfo: Record "Serial No. Information";
        Item: Record Item;
        UsageDecision: Record "TO Usage Decision PROF";
        TOLotManagement: Codeunit "TO Lot Management PROF";
        LotStatusBefore: Enum "TO Lot Status PROF";
        LotStatusText: Text;
        CountryRegionOfOrigin: Code[10];
        RetestDate: Date;
        SalesExpirationDate: Date;
        ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo: Boolean;
        ConfirmLotStatusChangeQst: Label '%1 %2\\Do you want to %3 ?\\', Comment = '%1 = TableCaption, %2 = Test Order No.. %3 = Tracking Status';
        ApproveLbl: Label 'approve';
        RejectLbl: Label 'reject';
        RestrictedLbl: Label 'restrict';
    begin
        if ("Test Order No." = '') or ("Item No." = '') or ("Serial No." = '') then
            exit;
        if "Test Order Status" <> "Test Order Status"::Open then
            exit;
        if "Tracking Status" <> "Tracking Status"::"Not Tested" then
            exit;

        UsageDecision.Get(UsageDecisionCode);

        case UsageDecision."Tracking Status" of
            "Tracking Status"::Approved:
                begin
                    LotStatusText := ApproveLbl;
                    if "Internal Use Only" then
                        LotStatusText := LotStatusText + ' (' + FieldCaption("Internal Use Only") + ')';
                end;
            "Tracking Status"::Rejected:
                LotStatusText := RejectLbl;

            "Tracking Status"::Restricted:
                LotStatusText := RestrictedLbl;
            else
                exit;
        end;

        if not Confirm(ConfirmLotStatusChangeQst, true, TableCaption(), "Test Order No.", LotStatusText) then
            exit;

        "Test Order Status" := "Test Order Status"::Posted;
        LotStatusBefore := "Tracking Status";
        "Tracking Status" := UsageDecision."Tracking Status";
        "Posted By" := CopyStr(UserId, 1, MaxStrLen("Posted By"));
        Modify(true);

        Item.Get("Item No.");

        TrackingNoStatusEntry.Init();
        TrackingNoStatusEntry."Item No." := "Item No.";
        TrackingNoStatusEntry."Variant Code" := "Variant Code";
        TrackingNoStatusEntry."Serial No." := "Serial No.";
        TrackingNoStatusEntry."Entry No." := 0;
        TrackingNoStatusEntry."Document Type" := "Document Type";
        TrackingNoStatusEntry."Document No." := "Document No.";
        TrackingNoStatusEntry."Document Line No." := "Document Line No.";
        TrackingNoStatusEntry."Order Type" := "Order Type" + 1;
        TrackingNoStatusEntry."Tracking Status" := "Tracking Status";
        TrackingNoStatusEntry."Usage Decision" := UsageDecisionCode;
        TrackingNoStatusEntry."Internal Use Only" := "Internal Use Only";
        TrackingNoStatusEntry.Blocked := UsageDecision."Block Tracking No.";
        TrackingNoStatusEntry."Local Impact" := "Local Impact";
        TrackingNoStatusEntry."Test Order No." := "Test Order No.";
        // TrackingNoStatusEntry is inserted after the LotNoInfo is updated, as the TrackingNoStatusEntry insert is generating the LotNoSynchEntry.CreateSynchRecords.

        ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
        SerialNoInfo.Get("Item No.", "Variant Code", "Serial No.");
        if PostSerialNo() <> "Serial No." then begin
            if SerialNoInfo."Test Order No. PROF" <> '' then begin
                SerialNoInfo."Test Order No. PROF" := ''; // "Test Order No." was temporary set on the LotNoInfo while the Test Order was ongoing.
                SerialNoInfo.Modify(false);
            end;
            if not SerialNoInfo.Get("Item No.", "Variant Code", "New Serial No.") then begin // Create and Get the "New Lot No.".
                if "Order Type" <> "Order Type"::"Manual Order" then
                    CountryRegionOfOrigin := "Country/Region of Origin"
                else
                    CountryRegionOfOrigin := "New Country/Region of Origin";
                RetestDate := "Retest Date";
                SalesExpirationDate := "Sales Expiration Date";
                if not ("New Expiration Date" in [0D, "Expiration Date"]) then begin
                    if Format(Item."Retest Calculation PROF") <> '' then
                        RetestDate := CalcDate(Item."Retest Calculation PROF", "New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        SalesExpirationDate := CalcDate(Item."Sales Expiration Calc. PROF", "New Expiration Date");
                end;
                TOLotManagement.CreateSerialNoInfo(Rec, "New Serial No.", RetestDate, CreateDateTime(WorkDate(), Time()), SalesExpirationDate, CountryRegionOfOrigin, SerialNoInfo."Original Serial No. PROF", SerialNoInfo."Original Expiration Date PROF");
                SerialNoInfo.Get("Item No.", "Variant Code", "New Serial No.");
            end;
        end;
        if (SerialNoInfo.Blocked) or ("Tracking Status" <> SerialNoInfo."Serial Status PROF") or ("Internal Use Only" <> SerialNoInfo."Internal Use Only PROF") or ("Local Impact" <> SerialNoInfo."Local Impact PROF") or (SerialNoInfo."Test Order No. PROF" <> '') then begin
            if (PostSerialNo() = "Serial No.") and ("Order Type" = "Order Type"::"Manual Order") then begin
                ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := true;
                if "New Vendor Serial No." <> SerialNoInfo."Vendor Serial No. PROF" then begin
                    ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
                    SerialNoInfo."Vendor Serial No. PROF" := "New Vendor Serial No.";
                end;
                SerialNoInfo."Country/Region of Origin PROF" := "New Country/Region of Origin";
                if not ("New Expiration Date" in [0D, "Expiration Date"]) then begin
                    ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo := false;
                    SerialNoInfo."Expiration Date PROF" := "New Expiration Date";
                    if Format(Item."Retest Calculation PROF") <> '' then
                        SerialNoInfo."Retest Date PROF" := CalcDate(Item."Retest Calculation PROF", "New Expiration Date");
                    if Format(Item."Sales Expiration Calc. PROF") <> '' then
                        SerialNoInfo."Sales Expiration Date PROF" := CalcDate(Item."Sales Expiration Calc. PROF", "New Expiration Date");
                end;
            end;

            SerialNoInfo.Blocked := UsageDecision."Block Tracking No.";
            SerialNoInfo."Serial Status PROF" := "Tracking Status";
            SerialNoInfo."Usage Decision PROF" := UsageDecisionCode;
            SerialNoInfo."Internal Use Only PROF" := "Internal Use Only";
            SerialNoInfo."Local Impact PROF" := "Local Impact";
            SerialNoInfo."Test Order No. PROF" := '';
            SerialNoInfo.Modify(false);
        end;

        if ("New Serial No." in ['', "Serial No."]) then
            TrackingNoStatusEntry.DoInsert("Test Order No.", false, true) // Generating the LotNoSynchEntry.CreateSynchRecords.
        else
            if InternalUseOnlyAndSameExpirationDate() then // Add TrackingNoStatusEntry for the "Internal Use Only" change on the existing Lot.
                TrackingNoStatusEntry.DoInsert("Test Order No.", false, true); // Generating the LotNoSynchEntry.CreateSynchRecords.


        if "Tracking Status" <> LotStatusBefore then
            TOLotManagement.PostTestOrderSN(Rec, LotStatusBefore, ManualOrderWithSameLotNoAndExpirationDatesAndVendorLotNo);
    end;

    internal procedure InternalUseOnlyAndSameExpirationDate(): Boolean
    begin
        exit(("Internal Use Only") and ("New Expiration Date" in [0D, "Expiration Date"]));
    end;

    internal procedure PostLotNo(): Code[50];
    var
        UsageDecision: Record "TO Usage Decision PROF";
    begin
        UsageDecision.Get(Rec."Usage Decision");
        if ("New Lot No." <> '') and (not InternalUseOnlyAndSameExpirationDate()) then
            exit("New Lot No.");
        exit("Lot No.");
    end;

    internal procedure PostSerialNo(): Code[50];
    var
        UsageDecision: Record "TO Usage Decision PROF";
    begin
        UsageDecision.Get(Rec."Usage Decision");
        if ("New Serial No." <> '') and (not InternalUseOnlyAndSameExpirationDate()) then
            exit("New Serial No.");
        exit("Serial No.");
    end;
}