/// <summary>
/// Page TO Lot Warehouse Entries PROF (ID 6208504).
/// </summary>
page 6208504 "TO Lot Warehouse Entries PROF"
{
    Caption = 'Lot Warehouse Entries';
    ApplicationArea = TestOrderMgtPROF;
    PageType = Worksheet;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    ShowFilter = false;
    SourceTableView = Sorting("Entry No.")
                      Order(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code of the location to which the entry is linked.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                    Visible = false;
                }
                field("Zone Code"; rec."Zone Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the code of the zone to which the entry is linked.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field("Bin Code"; rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field("Lot No."; rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the lot number assigned to the warehouse entry.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                    Visible = false;
                }
                field("Expiration Date"; rec."Expiration Date")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the expiration date of the serial number.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                    Visible = false;
                }
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of the item in the entry.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a description of the warehouse entry.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of units of the item in the warehouse entry.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                }
                field("Qty. per Unit of Measure"; rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.';
                    Editable = false; // Due to "PageType = Worksheet" despite the page property "Editable = false".
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }




    internal procedure SetPageCaption(NewPageCaption: Text): Text
    begin
        TOPageCaption := NewPageCaption;
    end;

    internal procedure FillPageRec(var TempWhseEntry: Record "Warehouse Entry" temporary)
    begin
        if not rec.IsTemporary() then
            Error('Internal Error'); // This should never happen.
        rec.Reset();
        if not rec.IsEmpty() then
            rec.DeleteAll();

        Rec.CopyFilters(TempWhseEntry);

        if TempWhseEntry.FindSet() then
            repeat
                Rec := TempWhseEntry;
                rec.Insert();
            until TempWhseEntry.Next() = 0;
    end;

    var
        TOPageCaption: Text;
}

