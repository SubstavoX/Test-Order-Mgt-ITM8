/// <summary>
/// Codeunit TO Item Functions PROF (ID 6208501).
/// </summary>
codeunit 6208501 "TO Item Functions PROF"
{
    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemUnitOfMeasureOnAfterInsert(var Rec: Record "Item Unit of Measure"; RunTrigger: Boolean)
    begin
        AssignBarCode(Rec."Item No.", Rec.Code);
    end;

    local procedure AssignBarCode(ItemNo: Code[20]; UOM: Code[10])
    var
        CompanyInformation: Record "Company Information";
        ItemReference: Record "Item Reference";
        ItemReference2: Record "Item Reference";
        NoSeries: Codeunit "No. Series";
        CheckSum: Integer;
        GS1Number: Text[30];
    begin
        CompanyInformation.Get();
        if CompanyInformation."GS1 Company Prefix PROF" = '' then
            exit;

        if (ItemNo = '') or (UOM = '') then
            exit;

        ItemReference.Reset();
        ItemReference.SetRange("Item No.", ItemNo);
        ItemReference.SetRange("Unit of Measure", UOM);
        ItemReference.SetRange("Variant Code", '');
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        if ItemReference.IsEmpty() then begin
            ItemReference2.Init();
            ItemReference2."Item No." := ItemNo;
            ItemReference2."Unit of Measure" := UOM;
            ItemReference2."Reference Type" := ItemReference2."Reference Type"::"Bar Code";
            GS1Number :=
              CompanyInformation."GS1 Company Prefix PROF" +
              NoSeries.GetNextNo(CompanyInformation."GS1-128 Nos. PROF", Today(), true);
            CheckSum := StrCheckSum(Format(GS1Number), '131313131313');
            ItemReference2."Reference No." := CopyStr('0' + GS1Number + Format(CheckSum), 1, MaxStrLen(ItemReference2."Reference No."));
            ItemReference2.Insert();
        end else
            exit;
    end;

    internal procedure ShowItemCard(ItemNo: Code[20]; RunModal: Boolean)
    var
        Item: Record Item;
    begin
        Item."No." := ItemNo;
        Item.TestField("No.");
        Item.Get(Item."No.");
        Item.FilterGroup(2);
        Item.SetRange("No.", Item."No.");
        Item.FilterGroup(0);
        if RunModal then
            Page.RunModal(Page::"Item Card", Item)
        else
            Page.Run(Page::"Item Card", Item);
    end;
}