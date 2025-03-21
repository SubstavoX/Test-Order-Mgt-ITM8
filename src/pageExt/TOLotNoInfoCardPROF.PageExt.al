/// <summary>
/// PageExtension TO Lot No. Info Card PROF (ID 6208501) extends Record Lot No. Information Card.
/// </summary>
pageextension 6208501 "TO Lot No. Info Card PROF" extends "Lot No. Information Card"
{
    layout
    {
        addafter(Description)
        {
            field("Expiration Date PROF"; Rec."Expiration Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the expiration date for the lot.';
                Caption = 'Expiration Date';
            }
            field("Retest Date PROF"; Rec."Retest Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the retest date for the lot.';
                Caption = 'Retest Date';
            }
            field("Sales Expiration Date PROF"; Rec."Sales Expiration Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the sales expiration date for the lot.';
                Caption = 'Sales Expiration Date';
            }
            field("Country/Region of Origin PROF"; Rec."Country/Region of Origin PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the country/region of origin for the lot.';
                Caption = 'Country/Region of Origin';
            }
            field("Original Lot No. PROF"; Rec."Original Lot No. PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the original lot number.';
                Caption = 'Original Lot No.';
            }
            field("Original Expiration Date PROF"; Rec."Original Expiration Date PROF")
            {
                ApplicationArea = TestOrderMgtPROF;
                ToolTip = 'Specifies the original expiration date for the lot.';
                Caption = 'Original Expiration Date';
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