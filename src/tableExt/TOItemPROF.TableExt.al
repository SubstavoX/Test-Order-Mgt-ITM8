/// <summary>
/// TableExtension TO Item PROF (ID 6208501) extends Record Item.
/// </summary>
tableextension 6208501 "TO Item PROF" extends Item
{

    fields
    {

        modify(Description)
        {
            trigger OnBeforeValidate()
            var
                StringLength: Integer;
                StringLengthErr: Label 'The Description field contains a value larger than 50 characters.';
            begin
                StringLength := StrLen(Rec.Description);
                if StringLength > 50 then
                    Dialog.Error(StringLengthErr);
            end;
        }
        modify("Description 2")
        {
            trigger OnBeforeValidate()
            var
                StringLength: Integer;
                StringLengthErr: Label 'The "Description 2" field contains a value larger than 50 characters.';
            begin
                StringLength := StrLen(Rec."Description 2");
                if StringLength > 50 then
                    Dialog.Error(StringLengthErr);
            end;
        }

        field(6208502; "Require COA PROF"; Boolean)
        {
            Caption = 'Require COA';
            DataClassification = CustomerContent;


            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                ChangeCOAPermissionErr: Label 'You do not have the permissions for changing the settings for "Require COA".';
            begin
                if xRec."Require COA PROF" and (not Rec."Require COA PROF") then
                    if UserSetup.Get(CopyStr(UpperCase(UserId), 1, MaxStrLen(UserSetup."User ID"))) then begin
                        if not UserSetup."Edit COA Item PROF" then
                            Dialog.Error(ChangeCOAPermissionErr);
                    end else
                        Dialog.Error(ChangeCOAPermissionErr);
            end;
        }

        field(6208503; "Retest Calculation PROF"; DateFormula)
        {
            Caption = 'Retest Calculation';
            DataClassification = SystemMetadata;
        }
        field(6208504; "Sales Expiration Calc. PROF"; DateFormula)
        {
            Caption = 'Sales Expiration Calculation';
            DataClassification = SystemMetadata;
        }
        field(6208505; "QC Required PROF"; Boolean)
        {
            Caption = 'QC Required';
            DataClassification = SystemMetadata;
        }
        field(6208506; "Approved for Internal use PROF"; Boolean)
        {
            Caption = 'Approved for Internal use';
            DataClassification = SystemMetadata;
        }
        field(6208507; "Internal Use Only PROF"; Boolean)
        {
            Caption = 'Internal Use Only';
            DataClassification = SystemMetadata;
        }
        field(6208508; "Reference Sample PROF"; Decimal)
        {
            Caption = 'Reference Sample';
            DataClassification = SystemMetadata;
            DecimalPlaces = 0 : 5;
        }
        field(6208509; "No. of components PROF"; Integer)
        {
            Caption = 'No. of Components';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6208510; "Last Dir. Cost incl. Disc PROF"; Decimal)
        {
            Caption = 'Last Dir. Cost incl. Discount';
            DataClassification = SystemMetadata;
            MinValue = 0;
        }

        field(6208511; "Item No. Filter PROF"; Code[20])
        {
            Caption = 'Item No. Filter';
            FieldClass = FlowFilter;
        }
        field(6208512; "Bulk Qty. on Purch. Order PROF"; Decimal)
        {
            Caption = 'Bulk Qty. on Purch. Order';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                               Type = const(Item),
                                                                               "No." = field("Item No. Filter PROF"),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter")));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(6208513; "TO Test Order Intern Use PROF"; Boolean)
        {
            Caption = 'Default Test Order to Internal Use Only';
            DataClassification = CustomerContent;
        }
    }


    local procedure CalcQtyReleasedToProd(): Decimal
    begin
        if "No." = '' then
            exit(0);
        Clear(LotManagement);
        exit(LotManagement.CalcQtyReleasedForProduction("No."));
    end;

    local procedure QtyAvailableToPickProd(): Decimal
    begin
        if "No." = '' then
            exit(0);
        Clear(LotManagement);
        exit(LotManagement.QtyAvailableToPickItem(Rec, true));
    end;


    var
        LotManagement: Codeunit "TO Lot Management PROF";
}