/// <summary>
/// Table TO Lot No. Status Entry PROF (ID 6208500).
/// </summary>
table 6208500 "TO Tracking No. Status PROF"
{
    Caption = 'Tracking No. Status Entry';
    DataCaptionFields = "Item No.", "Variant Code", "Lot No.";
    DrillDownPageID = "TO Tracking No. Status PROF";
    LookupPageID = "TO Tracking No. Status PROF";

    fields
    {
        field(1; "Item No."; Code[20])
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
        field(2; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Lot No."; Code[50])
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
                if "Lot No." = '' then
                    exit;
                TOLotManagement.ShowLotNoInformationCard("Item No.", "Variant Code", "Lot No.", false);
            end;
        }
        field(4; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Serial No."; Code[50])
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
                if "Serial No." = '' then
                    exit;
                TOLotManagement.ShowSerialNoInformationCard("Item No.", "Variant Code", "Serial No.", false);
            end;

        }
        field(10; "Original Lot No."; Code[50])
        {
            Caption = 'Original Lot No.';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnLookup()
            var
                TOLotManagement: Codeunit "TO Lot Management PROF";
            begin
                if "Original Lot No." = '' then
                    exit;
                TOLotManagement.ShowLotNoInformationCard("Item No.", "Variant Code", "Original Lot No.", false);
            end;
        }
        field(11; "Original Serial No."; Code[50])
        {
            Caption = 'Original Serial No.';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnLookup()
            var
                TOLotManagement: Codeunit "TO Lot Management PROF";
            begin
                if "Original Serial No." = '' then
                    exit;
                TOLotManagement.ShowSerialNoInformationCard("Item No.", "Variant Code", "Original Serial No.", false);
            end;
        }
        field(13; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;

            trigger OnLookup()
            var
                UserSettings: Record "User Setup";
                UserLookup: Page "User Lookup";
            begin
                UserLookup.LookupMode(true);
            end;
        }
        field(21; "Creation Date Time"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(22; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate();
            begin
                "Last Date Modified" := DT2Date("Last Modified Date Time");
            end;
        }
        field(23; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Purchase,Production';
            OptionMembers = " ",Purchase,Production;
            Editable = false;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(31; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(32; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(40; "Vendor Lot No."; Code[50])
        {
            Caption = 'Vendor Lot No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(41; "Vendor Serial No."; Code[50])
        {
            Caption = 'Vendor Serial No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(51; "Original Expiration Date"; Date)
        {
            Caption = 'Original Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(52; "Sales Expiration Date"; Date)
        {
            Caption = 'Sales Expiration Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(53; "Retest Date"; Date)
        {
            Caption = 'Retest Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(60; "Country/Region of Origin"; Code[10])
        {
            Caption = 'Country/Region of Origin';
            TableRelation = "Country/Region".Code;
            DataClassification = SystemMetadata;
            Editable = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
                CityL: Text[30];
                PostCodeCodeL: Code[20];
                CountyL: Text[30];
            begin
                PostCode.ValidateCountryCode(CityL, PostCodeCodeL, CountyL, "Country/Region of Origin");
            end;
        }
        field(100; "Test Order No."; Code[20])
        {
            Caption = 'Test Order No.';
            TableRelation = "TO Test Order PROF";
            ValidateTableRelation = false;
            DataClassification = SystemMetadata;
            Editable = false;

            trigger OnValidate()
            var
                TOTestOrder: Record "TO Test Order PROF";
            begin
                if "Test Order No." <> '' then begin
                    TOTestOrder.Get("Test Order No.");
                    "Document Type" := TOTestOrder."Document Type";
                    "Document No." := TOTestOrder."Document No.";
                    "Document Line No." := TOTestOrder."Document Line No.";
                    "Order Type" := TOTestOrder."Order Type" + 1;
                end else begin
                    "Document Type" := 0;
                    "Document No." := '';
                    "Document Line No." := 0;
                    "Order Type" := "Order Type"::" ";
                end;
            end;

            trigger OnLookup()
            var
                TOTestOrder: Record "TO Test Order PROF";
            begin
                if "Test Order No." = '' then
                    exit;
                if TOTestOrder.Get("Test Order No.") then begin
                    TOTestOrder.FilterGroup(4);
                    TOTestOrder.SetRange("Test Order No.", TOTestOrder."Test Order No.");
                    TOTestOrder.FilterGroup(0);
                    Page.Run(Page::"TO Test Order Card PROF", TOTestOrder);
                end;
            end;
        }
        field(101; "Order Type"; Option)
        {
            Caption = 'Order Type';
            OptionCaption = ' ,Test Order,Retest Order,Manual Order';
            OptionMembers = " ","Test Order","Retest Order","Manual Order";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(102; "QC Required"; Boolean)
        {
            Caption = 'QC Required';
            DataClassification = SystemMetadata;
            Editable = false;
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
        field(120; "Internal Use Only"; Boolean)
        {
            Caption = 'Internal Use Only';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(130; "Local Impact"; Boolean)
        {
            Caption = 'Local Impact';
            DataClassification = SystemMetadata;
        }
        field(200; "Tracking Status"; enum "TO Lot Status PROF")
        {
            Caption = 'Tracking Status';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(300; "From Company Name"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            ValidateTableRelation = false;
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(60610; "Usage Decision"; Code[20])
        {
            Caption = 'Usage Decision';
            TableRelation = "TO Usage Decision PROF";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Variant Code", "Lot No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry No.")
        {

        }
        key(Key3; "Original Lot No.", "Lot No.", "Bulk Item No.", "Item No.", "Variant Code")
        {

        }
        key(Key4; "Item No.", "Variant Code", "Lot No.", "Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        OnInsertErr: Label 'trigger OnInsert cannot be called directly';
    begin
        if not TriggerOnInsertOk then
            error(OnInsertErr);
        TriggerOnInsertOk := false;
    end;

    trigger OnModify()
    begin
        Validate("Last Modified Date Time", RoundDateTime(CurrentDateTime));
    end;

    internal Procedure DoInsert(TestOrderNo: Code[20]; CompanySynch: Boolean; InsertTrigger: Boolean)
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        if LotNoInfo.Get("Item No.", "Variant Code", "Lot No.") then
            DoTheInsert(LotNoInfo, TestOrderNo, false, CompanySynch, InsertTrigger)
        else
            if SerialNoInfo.Get("Item No.", "Variant Code", "Serial No.") then
                DoTheInsertSN(SerialNoInfo, TestOrderNo, false, CompanySynch, InsertTrigger);


    end;


    internal Procedure DoInsert(var LotNoInfo: Record "Lot No. Information"; TestOrderNo: Code[20]; UserIDCode: Code[50]; BlockFromSalesReturnOrder: Boolean; CompanySynch: Boolean; InsertTrigger: Boolean)
    var
    begin
        Init();
        "Item No." := LotNoInfo."Item No.";
        "Variant Code" := LotNoInfo."Variant Code";
        "Lot No." := LotNoInfo."Lot No.";
        "Entry No." := 0;
        "Tracking Status" := LotNoInfo."Lot Status PROF";
        "Internal Use Only" := LotNoInfo."Internal Use Only PROF";
        "Local Impact" := LotNoInfo."Local Impact PROF";
        if TestOrderNo <> '' then
            Validate("Test Order No.", TestOrderNo);
        "User ID" := UserIDCode;
        DoTheInsert(LotNoInfo, TestOrderNo, BlockFromSalesReturnOrder, CompanySynch, InsertTrigger);
    end;

    internal Procedure DoInsertSN(var SerialNoInfo: Record "Serial No. Information"; TestOrderNo: Code[20]; UserIDCode: Code[50]; BlockFromSalesReturnOrder: Boolean; CompanySynch: Boolean; InsertTrigger: Boolean)
    var
    begin
        Init();
        "Item No." := SerialNoInfo."Item No.";
        "Variant Code" := SerialNoInfo."Variant Code";
        "Serial No." := SerialNoInfo."Serial No.";
        "Entry No." := 0;
        "Tracking Status" := SerialNoInfo."Serial Status PROF";
        "Internal Use Only" := SerialNoInfo."Internal Use Only PROF";
        "Local Impact" := SerialNoInfo."Local Impact PROF";
        if TestOrderNo <> '' then
            Validate("Test Order No.", TestOrderNo);
        "User ID" := UserIDCode;
        DoTheInsertSN(SerialNoInfo, TestOrderNo, BlockFromSalesReturnOrder, CompanySynch, InsertTrigger);
    end;



    local Procedure DoTheInsert(var LotNoInfo: Record "Lot No. Information"; TestOrderNo: Code[20]; BlockFromSalesReturnOrder: Boolean; CompanySynch: Boolean; InsertTrigger: Boolean)
    var
        Item: Record Item;
    begin
        TestField("Item No."); // Just in case
        if ("Lot No." = '') then
            exit;

        Validate("Last Modified Date Time", RoundDateTime(CurrentDateTime));
        if "User ID" = '' then // "User ID" is set elsewhere if the record is created from LotNoInfoCompanySynch
            "User ID" := CopyStr(UserId, 1, MaxStrLen("User ID"));

        Item.Get("Item No.");


        "QC Required" := Item."QC Required PROF";
        "Vendor Lot No." := LotNoInfo."Vendor Lot No. PROF";
        "Original Lot No." := LotNoInfo."Original Lot No. PROF";
        "Creation Date Time" := LotNoInfo."Creation Date Time PROF";
        "Retest Date" := LotNoInfo."Retest Date PROF";
        "Expiration Date" := LotNoInfo."Expiration Date PROF";
        Blocked := LotNoInfo."Blocked";
        "Usage Decision" := LotNoInfo."Usage Decision PROF";
        "Original Expiration Date" := LotNoInfo."Original Expiration Date PROF";
        "Sales Expiration Date" := LotNoInfo."Sales Expiration Date PROF";
        "Country/Region of Origin" := LotNoInfo."Country/Region of Origin PROF";
        if (TestOrderNo <> '') and not CompanySynch then
            Validate("Test Order No.", TestOrderNo);
        if ("Test Order No." = '') and (LotNoInfo."Test Order No. PROF" <> '') then
            Validate("Test Order No.", LotNoInfo."Test Order No. PROF");


        if ("Tracking Status" = "Tracking Status"::Approved) and ("Test Order No." = '') and ("Tracking Status" <> LotNoInfo."Lot Status PROF") then begin
            LotNoInfo."Lot Status PROF" := "Tracking Status";
            LotNoInfo.Modify(false);
        end;

    end;

    local Procedure DoTheInsertSN(var SerialNoInfo: Record "Serial No. Information"; TestOrderNo: Code[20]; BlockFromSalesReturnOrder: Boolean; CompanySynch: Boolean; InsertTrigger: Boolean)
    var
        Item: Record Item;
    begin
        TestField("Item No."); // Just in case
        if ("Serial No." = '') then
            exit;

        Validate("Last Modified Date Time", RoundDateTime(CurrentDateTime));
        if "User ID" = '' then // "User ID" is set elsewhere if the record is created from LotNoInfoCompanySynch
            "User ID" := CopyStr(UserId, 1, MaxStrLen("User ID"));

        Item.Get("Item No.");


        "QC Required" := Item."QC Required PROF";
        "Vendor Serial No." := SerialNoInfo."Vendor Serial No. PROF";
        "Original Serial No." := SerialNoInfo."Original Serial No. PROF";
        "Creation Date Time" := SerialNoInfo."Creation Date Time PROF";
        "Retest Date" := SerialNoInfo."Retest Date PROF";
        "Expiration Date" := SerialNoInfo."Expiration Date PROF";
        Blocked := SerialNoInfo.Blocked;
        "Usage Decision" := SerialNoInfo."Usage Decision PROF";
        "Original Expiration Date" := SerialNoInfo."Original Expiration Date PROF";
        "Sales Expiration Date" := SerialNoInfo."Sales Expiration Date PROF";
        "Country/Region of Origin" := SerialNoInfo."Country/Region of Origin PROF";
        if (TestOrderNo <> '') and not CompanySynch then
            Validate("Test Order No.", TestOrderNo);
        if ("Test Order No." = '') and (SerialNoInfo."Test Order No. PROF" <> '') then
            Validate("Test Order No.", SerialNoInfo."Test Order No. PROF");


        if ("Tracking Status" = "Tracking Status"::Approved) and ("Test Order No." = '') and ("Tracking Status" <> SerialNoInfo."Serial Status PROF") then begin
            SerialNoInfo."Serial Status PROF" := "Tracking Status";
            SerialNoInfo.Modify(false);
        end;

    end;



    var
        TriggerOnInsertOk: Boolean;
}