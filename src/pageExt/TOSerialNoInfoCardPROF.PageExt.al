/// <summary>
/// PageExtension TO Serial No. Info Card PROF (ID 6208502) extends Record Serial No. Information Card.
/// </summary>
pageextension 6208505 "TO Serial No. Info Card PROF" extends "Serial No. Information Card"
{
    layout
    {
        addafter(Description)
        {
            field("Expiration Date PROF"; Rec."Expiration Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the expiration date for the serial number.';
                Caption = 'Expiration Date';
            }
            field("Retest Date PROF"; Rec."Retest Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the retest date for the serial number.';
                Caption = 'Retest Date';
            }
            field("Sales Expiration Date PROF"; Rec."Sales Expiration Date PROF")
            {
                Caption = 'Sales Expiration Date';
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the sales expiration date for the serial number.';
            }
            field("Country/Region of Origin PROF"; Rec."Country/Region of Origin PROF")
            {
                Caption = 'Country/Region of Origin';
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the country/region of origin for the serial number.';
            }
            field("Original Serial No. PROF"; Rec."Original Serial No. PROF")
            {
                Caption = 'Original Serial No.';
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the original serial number.';
            }
            field("Original Expiration Date PROF"; Rec."Original Expiration Date PROF")
            {
                Caption = 'Original Expiration Date';
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the original expiration date for the serial number.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CheckItemQCRequired();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CheckItemQCRequired();
    end;

    var
        ItemQCRequired: Boolean;
        QCRequiredMsg: Label 'When QC Required is enabled for this item, you cannot directly modify the Blocked field. You must use the Test Order page to change this status.';

    local procedure CheckItemQCRequired()
    var
        Item: Record Item;
    begin
        ItemQCRequired := false;
        if Rec."Item No." <> '' then
            if Item.Get(Rec."Item No.") then
                ItemQCRequired := Item."QC Required PROF";
    end;
}