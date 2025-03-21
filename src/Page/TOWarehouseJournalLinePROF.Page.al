/// <summary>
/// Page TO Warehouse Journal Line PROF (ID 6208510).
/// </summary>
page 6208510 "TO Warehouse Journal Line PROF"
{
    // Warehouse - Whse. Phys. Invt. Journal - Insert Line
    ApplicationArea = TestOrderMgtPROF;
    PageType = StandardDialog;
    layout
    {
        area(Content)
        {
            group(Insert)
            {
                field("Item No."; ItemNo)
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                    TableRelation = Item;
                    ToolTip = 'Specifies the item number of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Item No.", ItemNo);
                    end;
                }
                field("Zone Code"; ZoneCode)
                {
                    Caption = 'Zone Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the zone code of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Zone Code", ZoneCode);
                        WarehouseJnlLine.Validate("To Zone Code", ZoneCode);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Zone: Record Zone;
                    begin
                        zone.Reset();
                        zone.SetRange("Location Code", WarehouseJnlLine."Location Code");
                        if Page.RunModal(0, Zone) = Action::LookupOK then begin
                            ZoneCode := Zone.Code;
                            WarehouseJnlLine.Validate("Zone Code", ZoneCode);
                            WarehouseJnlLine.Validate("To Zone Code", ZoneCode);
                        end;
                    end;
                }
                field("Bin Code"; BinCode)
                {
                    Caption = 'Bin Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin code of the warehouse journal line.';
                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        Bin.Get(WarehouseJnlLine."Location Code", BinCode);
                        if WarehouseJnlLine."Zone Code" = '' then begin
                            WarehouseJnlLine."Zone Code" := Bin."Zone Code";
                            WarehouseJnlLine.Validate("To Zone Code", Bin."Zone Code");
                            ZoneCode := WarehouseJnlLine."Zone Code";
                        end;
                        WarehouseJnlLine."Bin Code" := BinCode;
                        WarehouseJnlLine."To Bin Code" := BinCode;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Bin: Record Bin;
                    begin
                        Bin.Reset();
                        Bin.SetRange("Location Code", WarehouseJnlLine."Location Code");
                        if WarehouseJnlLine."Zone Code" <> '' then
                            Bin.SetRange("Zone Code", WarehouseJnlLine."Zone Code");
                        if Page.RunModal(0, Bin) = Action::LookupOK then begin
                            BinCode := Bin.Code;
                            if (WarehouseJnlLine."Zone Code" = '') and Bin.FindFirst() then begin
                                WarehouseJnlLine."Zone Code" := Bin."Zone Code";
                                WarehouseJnlLine.Validate("To Zone Code", Bin."Zone Code");
                                ZoneCode := WarehouseJnlLine."Zone Code";
                            end;
                            WarehouseJnlLine."Bin Code" := BinCode;
                            WarehouseJnlLine."To Bin Code" := BinCode;
                        end;
                    end;
                }
                field("Lot No."; LotNo)
                {
                    ApplicationArea = All;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies the lot number of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Lot No.", LotNo);
                        ExpirationDate := WarehouseJnlLine."Expiration Date";
                        RetestDate := WarehouseJnlLine."Retest Date PROF";
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInfo: Record "Lot No. Information";
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                        ItemTrackingType: Enum "Item Tracking Type";
                    begin
                        if LotNo = '' then begin
                            if ItemNo <> '' then
                                LotNoInfo.SetRange("Item No.", ItemNo);
                            if page.RunModal(0, LotNoInfo) = Action::LookupOK then
                                LotNo := LotNoInfo."Lot No.";
                        end else
                            ItemTrackingMgt.LookupTrackingNoInfo(WarehouseJnlLine."Item No.", WarehouseJnlLine."Variant Code", ItemTrackingType::"Lot No.", LotNo);
                        WarehouseJnlLine.Validate("Lot No.", LotNo);
                        ExpirationDate := WarehouseJnlLine."Expiration Date";
                        RetestDate := WarehouseJnlLine."Retest Date PROF";
                    end;
                }
                field("Serial No."; SerialNo)
                {
                    ApplicationArea = All;
                    Caption = 'Serial No.';
                    ToolTip = 'Specifies the serial number of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Serial No.", SerialNo);
                        ExpirationDate := WarehouseJnlLine."Expiration Date";
                        RetestDate := WarehouseJnlLine."Retest Date PROF";
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SerialNoInfo: Record "Serial No. Information";
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                        ItemTrackingType: Enum "Item Tracking Type";
                    begin
                        if SerialNo = '' then begin
                            if ItemNo <> '' then
                                SerialNoInfo.SetRange("Item No.", ItemNo);
                            if page.RunModal(0, SerialNoInfo) = Action::LookupOK then
                                SerialNo := SerialNoInfo."Serial No.";
                        end else
                            ItemTrackingMgt.LookupTrackingNoInfo(WarehouseJnlLine."Item No.", WarehouseJnlLine."Variant Code", ItemTrackingType::"Serial No.", SerialNo);
                        WarehouseJnlLine.Validate("Serial No.", SerialNo);
                        ExpirationDate := WarehouseJnlLine."Expiration Date";
                        RetestDate := WarehouseJnlLine."Retest Date PROF";
                    end;
                }
                field("Expiration Date"; ExpirationDate)
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                    ToolTip = 'Specifies the expiration date of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Expiration Date", ExpirationDate);
                    end;
                }
                field("Retest Date"; RetestDate)
                {
                    ApplicationArea = All;
                    Caption = 'Retest Date';
                    ToolTip = 'Specifies the retest date of the warehouse journal line.';
                    trigger OnValidate()
                    begin
                        WarehouseJnlLine.Validate("Retest Date PROF", RetestDate);
                    end;
                }
            }
        }
    }
    var
        WarehouseJnlLine: Record "Warehouse Journal Line";
        ItemNo: Code[20];
        ZoneCode: Code[10];
        BinCode: Code[20];
        LotNo: Code[50];
        SerialNo: Code[50];
        ExpirationDate: Date;
        RetestDate: Date;

    local procedure SetLine(var SetWarehouseJnlLine: Record "Warehouse Journal Line")
    begin
        WarehouseJnlLine := SetWarehouseJnlLine;
        WarehouseJnlLine."Phys. Inventory" := false;
        WarehouseJnlLine.Validate("Item No.", '');
        WarehouseJnlLine.Validate("Zone Code", '');
        WarehouseJnlLine.Validate("Bin Code", '');
        WarehouseJnlLine.Validate("Lot No.", '');
        WarehouseJnlLine.Validate("Expiration Date", 0D);
        WarehouseJnlLine.Validate("Retest Date PROF", 0D);
    end;

    local procedure GetLine(var GetWarehouseJnlLine: Record "Warehouse Journal Line")
    begin
        GetWarehouseJnlLine := WarehouseJnlLine;
        WarehouseJnlLine."Phys. Inventory" := true;
    end;
}