/// <summary>
/// Page TO Test Order Card PROF (ID 6208506).
/// </summary>
page 6208506 "TO Test Order Card PROF"
{
    Caption = 'Test Order Card';
    PageType = Card;
    SourceTable = "TO Test Order PROF";
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = TestOrderMgtPROF;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Test Order No."; Rec."Test Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the test order number of the test order.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number of the test order.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item description of the test order.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant code of the test order.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number of the test order.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Serial No. for item tracking.';
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type of the test order.';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number of the test order.';
                    Visible = false;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document line number of the test order.';
                    Visible = false;
                }
                field("Creation Date Time"; Rec."Creation Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creation date time of the test order.';
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last modified date time of the test order.';
                }
                field("Tracking Status"; Rec."Tracking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tracking status of the test order.';
                    Visible = (Rec."Test Order Status" = Rec."Test Order Status"::Posted);
                }
                field("COA Received"; Rec."COA Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a Certificate of Analysis has been received for this item.';
                    Editable = (Rec."Test Order Status" = Rec."Test Order Status"::Open);
                    Visible = COARequiredVisible;

                    trigger OnValidate()
                    var
                        IsHandled: Boolean;
                    begin
                        OnValidateCOAReceived(Rec, IsHandled);
                    end;
                }
                field("Original Lot No."; Rec."Original Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original lot number of the test order.';
                }
                group(GroupItemExpirationCalculation)
                {
                    ShowCaption = false;
                    field(ItemExpirationCalculation; ItemExpirationCalculation)
                    {
                        Caption = 'Expiration Calculation';
                        ApplicationArea = All;
                        Importance = Additional;
                        Editable = false;
                        ToolTip = 'Specifies the expiration calculation of the test order.';
                    }
                    field(ItemRetestCalculation; ItemRetestCalculation)
                    {
                        Caption = 'Retest Calculation';
                        ApplicationArea = All;
                        Importance = Additional;
                        Editable = false;
                        ToolTip = 'Specifies the retest calculation of the test order.';
                    }
                    field(ItemSalesExpirationCalculation; ItemSalesExpirationCalculation)
                    {
                        Caption = 'Sales Expiration Calculation';
                        ApplicationArea = All;
                        Importance = Additional;
                        Editable = false;
                        ToolTip = 'Specifies the sales expiration calculation of the test order.';
                    }
                    field(ItemPropertyShelfLife; ItemPropertyShelfLife)
                    {
                        Caption = 'Shelf Life';
                        ApplicationArea = All;
                        Importance = Additional;
                        Editable = false;
                        ToolTip = 'Specifies the shelf life of the test order.';
                    }
                }
                field("Vendor Lot No."; Rec."Vendor Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor lot number of the test order.';
                }
                field("New Lot No."; Rec."New Lot No.")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeRetestOrderOrManualOrderFieldsVisible;
                    Editable = OrderTypeManualOrderFieldsVisible;
                    ToolTip = 'Specifies the new lot number of the test order.';
                }
                field("New Vendor Lot No."; Rec."New Vendor Lot No.")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeManualOrderFieldsVisible;
                    ToolTip = 'Specifies the new vendor lot number of the test order.';
                }
                field("Retest Date"; Rec."Retest Date")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeManualOrderFieldsVisible;
                    ToolTip = 'Specifies the retest date of the test order.';
                }
                field("Sales Expiration Date"; Rec."Sales Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales expiration date of the test order.';
                }
                field("Original Expiration Date"; Rec."Original Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original expiration date of the test order.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiration date of the test order.';
                }
                field("New Expiration Date"; Rec."New Expiration Date")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeRetestOrderOrManualOrderFieldsVisible;
                    ToolTip = 'Specifies the new expiration date of the test order.';
                }
                field("Country/Region of Origin"; Rec."Country/Region of Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of origin of the test order.';
                }
                field("New Country/Region of Origin"; Rec."New Country/Region of Origin")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeManualOrderFieldsVisible;
                    ToolTip = 'Specifies the new country/region of origin of the test order.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code of the test order.';
                }
                field("Internal Use Only"; Rec."Internal Use Only")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the test order is internal use only.';
                }
                field("Local Impact"; Rec."Local Impact")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeRetestOrderOrManualOrderFieldsVisible;
                    ToolTip = 'Specifies the local impact of the test order.';
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeTestOrderFieldsVisible;
                    ToolTip = 'Specifies the location code of the test order.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Visible = OrderTypeTestOrderFieldsVisible;
                    ToolTip = 'Specifies the bin code of the test order.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Visible = OrderTypeTestOrderFieldsVisible;
                    ToolTip = 'Specifies the quantity of the test order.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned user ID of the test order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the test order.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the posted by of the test order.';
                }
                field("Usage Decision"; Rec."Usage Decision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Spefifies the value of the field "Usage Decision".';
                }
            }
        }
    }
    actions
    {
        /*
        area(Creation)
        {
            action(CreateManualTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Create Manual Test Order';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
                PromotedIsBig = false;
                Enabled = (not PageNotEditable);

                trigger OnAction()
                var
                    TOTestOrder: Record "TO Test Order PROF";
                begin
                    TOTestOrder.CreateRecord(); // Create Manual Test Order.
                    CurrPage.Update(false);
                end;
            }
        }
        */
        area(Processing)
        {
            action(ApproveTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Approve the test order.';
                Enabled = (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") and (not PageNotEditable);
                Visible = true;

                trigger OnAction()
                var
                    UsageDecision: Record "TO Usage Decision PROF";
                    NoApproveUsageDecisionErr: Label 'No Usage Decision with Tracking Status = Approved and Show On Test or Manual Orders = Yes was found.';
                    IsSerialTracking: Boolean;
                    IsHandled: Boolean;
                begin
                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    // Find Usage Decision with Tracking Status = Approved and Show On Test or Manual Orders = Yes
                    UsageDecision.Reset();
                    UsageDecision.SetRange("Tracking Status", UsageDecision."Tracking Status"::Approved);

                    if Rec."Order Type" = Rec."Order Type"::"Retest Order" then
                        UsageDecision.SetRange("Show On Retest Order", true)
                    else
                        UsageDecision.SetRange("Show On Test or Manual Orders", true);

                    if not UsageDecision.FindFirst() then
                        Error(NoApproveUsageDecisionErr);

                    // Trigger event for CoA validation
                    OnBeforeApproveTestOrder(Rec, UsageDecision, IsHandled);
                    if IsHandled then
                        exit;

                    // Set the Usage Decision and post
                    Rec.Validate("Usage Decision", UsageDecision.Code);
                    Rec.Modify(true);

                    // Call the appropriate function based on tracking type
                    if IsSerialTracking then
                        Rec.SetLotStatusSN(UsageDecision.Code)
                    else
                        Rec.SetLotStatus(UsageDecision.Code);

                    CurrPage.Update(false);
                    CurrPage.Close();
                end;
            }
            action(RejectTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Reject the test order.';
                Enabled = (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") and (not PageNotEditable);
                Visible = true;

                trigger OnAction()
                var
                    UsageDecision: Record "TO Usage Decision PROF";
                    NoRejectUsageDecisionErr: Label 'No Usage Decision with Tracking Status = Rejected and Show On Test or Manual Orders = Yes was found.';
                    IsSerialTracking: Boolean;
                    IsHandled: Boolean;
                begin
                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    // Find Usage Decision with Tracking Status = Rejected and Show On Test or Manual Orders = Yes
                    UsageDecision.Reset();
                    UsageDecision.SetRange("Tracking Status", UsageDecision."Tracking Status"::Rejected);

                    if Rec."Order Type" = Rec."Order Type"::"Retest Order" then
                        UsageDecision.SetRange("Show On Retest Order", true)
                    else
                        UsageDecision.SetRange("Show On Test or Manual Orders", true);

                    if not UsageDecision.FindFirst() then
                        Error(NoRejectUsageDecisionErr);

                    // Trigger event for CoA validation
                    OnBeforeRejectTestOrder(Rec, UsageDecision, IsHandled);
                    if IsHandled then
                        exit;

                    // Set the Usage Decision and post
                    Rec.Validate("Usage Decision", UsageDecision.Code);
                    Rec.Modify(true);

                    // Call the appropriate function based on tracking type
                    if IsSerialTracking then
                        Rec.SetLotStatusSN(UsageDecision.Code)
                    else
                        Rec.SetLotStatus(UsageDecision.Code);

                    CurrPage.Update(false);
                    CurrPage.Close();
                end;
            }
            action(PostTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = false;
                ToolTip = 'Post the test order.';
                Enabled = (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") and (not PageNotEditable);
                Visible = (not Rec."Internal Use Only");
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    LotNoInfo: Record "Lot No. Information";
                    SerialNoInfo: Record "Serial No. Information";
                    UsageDecision: Record "TO Usage Decision PROF";
                    NewLotNoErr: Label '"New Lot No." must be empty.';
                    NewSerialNoErr: Label '"New Serial No." must be empty.';
                    NewExpirationDateErr: Label '"New Expiration Date" must be empty.';
                    NewLotNoMissingErr: Label '"New Lot No." must not be empty.';
                    NewSerialNoMissingErr: Label '"New Serial No." must not be empty.';
                    NewExpirationDateMissingErr: Label '"New Expiration Date" must not be empty.';
                    NewTestOrderCreatedMsg: Label 'A new test order has been created for item no. %1 lot no. %2.', Comment = '%1=Item No. %2=Lot No.';
                    NewTestOrderCreatedSNMsg: Label 'A new test order has been created for item no. %1 serial no. %2.', Comment = '%1=Item No. %2=Serial No.';
                    UsageDecisiontionErr: Label 'The field "Usage Decision" must not be empty. Please fill in the field and try again.';
                    IsSerialTracking: Boolean;
                    IsHandled: Boolean;
                begin
                    if Rec."Usage Decision" = '' then
                        Dialog.Error(UsageDecisiontionErr);

                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    if UsageDecision.Get(Rec."Usage Decision") then begin
                        UsageDecision.TestField("Tracking Status");

                        // Trigger event for CoA validation
                        OnBeforePostTestOrder(Rec, UsageDecision, IsHandled);
                        if IsHandled then
                            exit;

                        if Rec."Order Type" <> Rec."Order Type"::"Test Order" then
                            if UsageDecision."Not Update Lot No & Expir Date" then begin
                                if IsSerialTracking then begin
                                    if Rec."New Serial No." <> '' then
                                        Dialog.Error(NewSerialNoErr);
                                end else
                                    if Rec."New Lot No." <> '' then
                                        Dialog.Error(NewLotNoErr);

                                if Rec."New Expiration Date" <> 0D then
                                    Dialog.Error(NewExpirationDateErr);
                            end else begin
                                if IsSerialTracking then begin
                                    if (Rec."New Serial No." = '') and (Rec."New Expiration Date" <> 0D) then
                                        Dialog.Error(NewSerialNoMissingErr);
                                end else
                                    if (Rec."New Lot No." = '') and (Rec."New Expiration Date" <> 0D) then
                                        Dialog.Error(NewLotNoMissingErr);

                                if Rec."New Expiration Date" = 0D then
                                    Dialog.Error(NewExpirationDateMissingErr);
                            end;


                        if IsSerialTracking then begin
                            if (Rec."New Serial No." <> '') and (Rec."New Expiration Date" = 0D) then
                                Dialog.Error(NewExpirationDateMissingErr);

                            if (Rec."New Serial No." = '') and (Rec."New Expiration Date" <> 0D) then
                                Dialog.Error(NewSerialNoMissingErr);
                        end else begin
                            if (Rec."New Lot No." <> '') and (Rec."New Expiration Date" = 0D) then
                                Dialog.Error(NewExpirationDateMissingErr);

                            if (Rec."New Lot No." = '') and (Rec."New Expiration Date" <> 0D) then
                                Dialog.Error(NewLotNoMissingErr);
                        end;

                        // Call the appropriate function based on tracking type
                        if IsSerialTracking then
                            Rec.SetLotStatusSN(UsageDecision.Code)
                        else
                            Rec.SetLotStatus(UsageDecision.Code);

                        if IsSerialTracking then begin
                            if SerialNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Serial No.") then
                                if UsageDecision.Get(SerialNoInfo."Usage Decision PROF") and (UsageDecision."New Test Order") then begin
                                    Rec.CreateRecordSN(SerialNoInfo, 0, '', 0, 0, Rec."Order Type"::"Manual Order", false);
                                    Dialog.Message(NewTestOrderCreatedSNMsg, Rec."Item No.", Rec."Serial No.");
                                end;
                        end else
                            if LotNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
                                if UsageDecision.Get(LotNoInfo."Usage Decision PROF") and (UsageDecision."New Test Order") then begin
                                    Rec.CreateRecord(LotNoInfo, 0, '', 0, 0, Rec."Order Type"::"Manual Order", false);
                                    Dialog.Message(NewTestOrderCreatedMsg, Rec."Item No.", Rec."Lot No.");

                                end;
                    end;

                    CurrPage.Update(false);
                    CurrPage.Close();
                end;
            }
            action(InternalUseTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = false;
                ToolTip = 'Change Lot Status to Approved';
                Enabled = (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") and (not PageNotEditable);
                Visible = Rec."Internal Use Only";
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    UsageDecision: Record "TO Usage Decision PROF";
                    UsageDecisiontionErr: Label 'The field "Usage Decision" must not be empty. Please fill in the field and try again.';
                    IsSerialTracking: Boolean;
                    IsHandled: Boolean;
                begin
                    if Rec."Usage Decision" = '' then
                        Dialog.Error(UsageDecisiontionErr);

                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    if UsageDecision.Get(Rec."Usage Decision") then begin
                        UsageDecision.TestField("Tracking Status");

                        // Trigger event for CoA validation
                        OnBeforeInternalUseTestOrder(Rec, UsageDecision, IsHandled);
                        if IsHandled then
                            exit;

                        // Call the appropriate function based on tracking type
                        if IsSerialTracking then
                            Rec.SetLotStatusSN(UsageDecision.Code)
                        else
                            Rec.SetLotStatus(UsageDecision.Code);

                        CurrPage.Update(false);
                        CurrPage.Close();
                    end;
                end;
            }
            action(UploadCOADocument)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Upload CoA Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Upload a Certificate of Analysis document.';
                Enabled = Rec."COA Received" and (Rec."Test Order Status" = Rec."Test Order Status"::Open) and COARequiredVisible;
                Visible = COARequiredVisible;

                trigger OnAction()
                var
                    COAManagement: Codeunit "TO COA Management PROF";
                begin
                    COAManagement.UploadCOADocument(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ViewCOADocument)
            {
                ApplicationArea = ItemTracking;
                Caption = 'View CoA Document';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'View the Certificate of Analysis document.';
                Enabled = Rec."COA Received" and (Rec."COA File Name" <> '') and COARequiredVisible;
                Visible = COARequiredVisible;

                trigger OnAction()
                var
                    TestOrder: Record "TO Test Order PROF";
                    COAManagement: Codeunit "TO COA Management PROF";

                begin
                    TestOrder := Rec;
                    if TestOrder.Get(TestOrder."Test Order No.") then begin
                        // CALCFIELDS is required for BLOB fields
                        TestOrder.CALCFIELDS("COA Document");
                        COAManagement.DownloadCOADocument(TestOrder);
                    end;
                end;
            }
            action(DeleteTestOrder)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Regret the creation of the Retest Order (Delete).';
                Enabled = (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") and (not PageNotEditable);

                trigger OnAction()
                var
                    ConfirmDeleteQst: Label 'Do you want to delete the %1 %2 (%3 %4)', Comment = '%1=TableCaption %2=Test Order No. %3=FieldCaption Order Type %4=Order Type';
                    ConfirmWarningDeleteQst: Label 'Warning! Are you sure you will delete the %1 %2 (%3 %4)', Comment = '%1=TableCaption %2=Test Order No. %3=FieldCaption Order Type %4=Order Type';
                    IsSerialTracking: Boolean;
                begin
                    if Rec."Tracking Status" <> Rec."Tracking Status"::"Not Tested" then
                        exit;

                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    if not Confirm(ConfirmDeleteQst, false, rec.TableCaption(), Rec."Test Order No.", rec.FieldCaption(rec."Order Type"), Rec."Order Type") then
                        exit;
                    if Rec."Order Type" = Rec."Order Type"::"Test Order" then begin
                        if not Confirm(ConfirmWarningDeleteQst, false, rec.TableCaption(), Rec."Test Order No.", rec.FieldCaption(Rec."Order Type"), Rec."Order Type") then
                            exit;
                        rec.FilterGroup(5); // FilterTrick to Allow Deletion of "Order Type"::"Test Order".
                        rec.SetRange("Test Order No.", Rec."Test Order No."); // FilterTrick to Allow Deletion of "Order Type"::"Test Order".
                    end;

                    // Clear the Test Order No. reference in Lot/Serial No. Information if needed
                    if IsSerialTracking then
                        ClearTestOrderNoInSerialNoInfo(Rec)
                    else
                        ClearTestOrderNoInLotNoInfo(Rec);


                    rec.Delete(true);
                    rec.FilterGroup(0); // Back to normal.
                    CurrPage.Close();
                end;
            }
            action(SpecialModifyAction)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Set missing Item Tracking information';
                Image = DueDate;
                ToolTip = 'Special modify if the Item Tracking information was not filled fully while creating the Test Order.';
                Visible = ShowSpecialModifyAction;

                trigger OnAction()
                var
                    LotNoInfo: Record "Lot No. Information";
                    SerialNoInfo: Record "Serial No. Information";
                    LotManagement: Codeunit "TO Lot Management PROF";
                    DialogFieldCaptionText: Text;
                    IsSerialTracking: Boolean;
                begin
                    if Rec."Test Order Status" <> Rec."Test Order Status"::Open then
                        exit;

                    // Determine if we're dealing with serial number tracking
                    IsSerialTracking := (Rec."Serial No." <> '');

                    if IsSerialTracking then begin
                        if (Rec."Item No." = '') or (Rec."Serial No." = '') then
                            exit;
                        SerialNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Serial No.");

                        case true of
                            Rec."Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Expiration Date");
                            Rec."Sales Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Sales Expiration Date");
                            Rec."Retest Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Retest Date");
                            Rec."Country/Region of Origin" = '':
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Country/Region of Origin");
                            Rec."Original Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Original Expiration Date");
                            Rec."Original Serial No." = '':
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Original Serial No.");
                            else
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Expiration Date");
                        end;
                        if not LotManagement.SerialInfoSetMissingItemTrackingInfo(SerialNoInfo, DialogFieldCaptionText) then
                            exit;

                        Rec."Vendor Serial No." := SerialNoInfo."Vendor Serial No. PROF";
                        Rec."Expiration Date" := SerialNoInfo."Expiration Date PROF";
                        Rec."Retest Date" := SerialNoInfo."Retest Date PROF";
                        Rec."Sales Expiration Date" := SerialNoInfo."Sales Expiration Date PROF";
                        Rec."Country/Region of Origin" := SerialNoInfo."Country/Region of Origin PROF";
                        Rec."Original Expiration Date" := SerialNoInfo."Original Expiration Date PROF";
                        Rec."Original Serial No." := SerialNoInfo."Original Serial No. PROF";
                    end else begin
                        if (Rec."Item No." = '') or (Rec."Lot No." = '') then
                            exit;
                        LotNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");

                        case true of
                            Rec."Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Expiration Date");
                            Rec."Sales Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Sales Expiration Date");
                            Rec."Retest Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Retest Date");
                            Rec."Country/Region of Origin" = '':
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Country/Region of Origin");
                            Rec."Original Expiration Date" = 0D:
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Original Expiration Date");
                            Rec."Original Lot No." = '':
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Original Lot No.");
                            else
                                DialogFieldCaptionText := rec.FieldCaption(Rec."Expiration Date");
                        end;
                        if not LotManagement.LotNoInfoSetMissingItemTrackingInfo(LotNoInfo, DialogFieldCaptionText) then
                            exit;

                        Rec."Vendor Lot No." := LotNoInfo."Vendor Lot No. PROF";
                        Rec."Expiration Date" := LotNoInfo."Expiration Date PROF";
                        Rec."Retest Date" := LotNoInfo."Retest Date PROF";
                        Rec."Sales Expiration Date" := LotNoInfo."Sales Expiration Date PROF";
                        Rec."Country/Region of Origin" := LotNoInfo."Country/Region of Origin PROF";
                        Rec."Original Expiration Date" := LotNoInfo."Original Expiration Date PROF";
                        Rec."Original Lot No." := LotNoInfo."Original Lot No. PROF";
                    end;

                    CurrPage.Update(true);
                end;
            }
        }
    }

    trigger OnOpenPage();
    var
        LicenseFunctions: Codeunit "LicenseFunctions_Prof";
        AppID: Text[36];
    begin
        AppID := GetAppId();
        if not LicenseFunctions.IsLicenseApproved(AppID) then
            LicenseFunctions.EnvironmentCheck(AppID);

        if not ShowTemporaryRecord then
            if rec.Find('=<>') then;
        SetEditable();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if not ShowTemporaryRecord then
            exit(rec.Find(Which));
        rec := TempTOTestOrder;
        exit(true);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        if not ShowTemporaryRecord then
            exit(rec.Next(Steps));
        exit(0);
    end;

    trigger OnAfterGetRecord();
    var
        UsageDecision: Record "TO Usage Decision PROF";
    begin
        SetVisible();
        if Rec."Usage Decision" = '' then begin
            UsageDecision.SetRange("Default Usage Decision", true);
            if UsageDecision.FindFirst() then
                Rec.Validate("Usage Decision", UsageDecision.Code);
        end;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        SetEditable();
        SetVisible();
        ShowCOANotification();
    end;

    local procedure SetEditable()
    begin
        if PageNotEditable then
            CurrPage.Editable(false)
        else
            if CurrPage.Editable() <> (Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested") then begin
                CurrPage.Editable(Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested");
                if CurrentClientType() = ClientType::Windows then
                    if Rec."Tracking Status" = Rec."Tracking Status"::"Not Tested" then
                        TOUtilitiesPROF.SendKeys('^+(E)') // Edit Mode (Ctrl+Shift+E) (Edit)
                    else
                        TOUtilitiesPROF.SendKeys('^+(R)'); // View Mode (Ctrl+Shift+R) (Read only)
            end;
        SetVisible();
    end;

    local procedure GetAppId(): Text[36]
    var
        AppID: Text[36];
        AppGuidTxt: Text[38];
        AppInfo: ModuleInfo;
        ModuleInfoNotFoundLbl: Label 'Module info not found.';
    begin
        if not NavApp.GetCurrentModuleInfo(AppInfo) then
            Error(ModuleInfoNotFoundLbl);
        Evaluate(AppGuidTxt, LowerCase(AppInfo.Id));
        AppID := CopyStr(CopyStr(AppGuidTxt, 2, StrLen(AppGuidTxt) - 1), 1, MaxStrLen(AppID));
        exit(AppID);
    end;

    local procedure SetVisible()
    var
        Item: Record Item;
    begin
        ShowSpecialModifyAction := (Rec."Test Order Status" = Rec."Test Order Status"::Open) and ((Rec."Expiration Date" = 0D) or (Rec."Retest Date" = 0D) or (Rec."Sales Expiration Date" = 0D) or (Rec."Country/Region of Origin" = '') or (Rec."Original Expiration Date" = 0D) or (Rec."Original Lot No." = '')) and (not PageNotEditable);
        OrderTypeTestOrderFieldsVisible := (Rec."Order Type" = Rec."Order Type"::"Test Order") and (not Rec."Internal Use Only") and (Rec."Document Type" <> Rec."Document Type"::Production);
        OrderTypeRetestOrderFieldsVisible := (Rec."Order Type" = Rec."Order Type"::"Retest Order");
        OrderTypeManualOrderFieldsVisible := (Rec."Order Type" = Rec."Order Type"::"Manual Order");
        OrderTypeRetestOrderOrManualOrderFieldsVisible := OrderTypeRetestOrderFieldsVisible or OrderTypeManualOrderFieldsVisible;

        // Set COA visibility based on item requirement
        COARequiredVisible := false;
        if Rec."Item No." <> '' then begin
            COARequiredVisible := COAManagement.IsCoARequired(Rec."Item No.");
            if Item.Get(Rec."Item No.") then begin
                ItemExpirationCalculation := Item."Expiration Calculation";
                ItemRetestCalculation := Item."Retest Calculation PROF";
                ItemSalesExpirationCalculation := Item."Sales Expiration Calc. PROF";
            end;
        end;
    end;

    local procedure SetShowTemporaryRecord(var TempTOTestOrderP: Record "TO Test Order PROF" temporary; FromCompanyName: Text[30])
    begin
        ShowTemporaryRecord := true;
        SetNotEditable();
        TempTOTestOrder := TempTOTestOrderP;
        if FromCompanyName <> '' then begin
            CurrPage.Caption := CurrPage.Caption + ' ( ' + FromCompanyName + ' )';
            TemporaryRecordFromCompanyName := FromCompanyName;
        end;
    end;

    local procedure SetNotEditable()
    begin
        PageNotEditable := true;
    end;

    local procedure ClearTestOrderNoInLotNoInfo(TestOrder: Record "TO Test Order PROF")
    var
        LotNoInfo: Record "Lot No. Information";
    begin
        if (TestOrder."Item No." = '') or (TestOrder."Lot No." = '') then
            exit;

        if LotNoInfo.Get(TestOrder."Item No.", TestOrder."Variant Code", TestOrder."Lot No.") then
            if LotNoInfo."Test Order No. PROF" = TestOrder."Test Order No." then begin
                LotNoInfo."Test Order No. PROF" := '';
                LotNoInfo.Modify(false);
            end;
    end;

    local procedure ClearTestOrderNoInSerialNoInfo(TestOrder: Record "TO Test Order PROF")
    var
        SerialNoInfo: Record "Serial No. Information";
    begin
        if (TestOrder."Item No." = '') or (TestOrder."Serial No." = '') then
            exit;

        if SerialNoInfo.Get(TestOrder."Item No.", TestOrder."Variant Code", TestOrder."Serial No.") then
            if SerialNoInfo."Test Order No. PROF" = TestOrder."Test Order No." then begin
                SerialNoInfo."Test Order No. PROF" := '';
                SerialNoInfo.Modify(false);
            end;
    end;

    local procedure ShowCOANotification()
    var
        TestOrder: Record "TO Test Order PROF";
        COANotification: Notification;
        COANotificationMsg: Label 'Certificate of Analysis document is available for this test order.';
        ViewDocumentLbl: Label 'View Document';
        InStream: InStream;
        HasContent: Boolean;
    begin
        if not COARequiredVisible or not Rec."COA Received" or (Rec."COA File Name" = '') then
            exit;

        // Get a fresh copy of the record
        if not TestOrder.Get(Rec."Test Order No.") then
            exit;

        // CALCFIELDS is required for BLOB fields
        TestOrder.CALCFIELDS("COA Document");

        // Check if the BLOB field has content
        HasContent := false;
        TestOrder."COA Document".CreateInStream(InStream);
        HasContent := InStream.Length > 0;

        if not HasContent then
            exit;

        COANotification.Message := COANotificationMsg;
        COANotification.SetData('TestOrderNo', TestOrder."Test Order No.");
        COANotification.AddAction(ViewDocumentLbl, Codeunit::"TO COA Management PROF", 'HandleViewCOADocumentNotification');
        COANotification.Send();
    end;

    var
        TempTOTestOrder: Record "TO Test Order PROF" temporary;
        TOUtilitiesPROF: Codeunit "TO Utilities PROF";
        COAManagement: Codeunit "TO COA Management PROF";
        ItemExpirationCalculation: DateFormula;
        ItemRetestCalculation: DateFormula;
        ItemSalesExpirationCalculation: DateFormula;
        ItemPropertyShelfLife: Text[250];
        ShowTemporaryRecord: Boolean;
        TemporaryRecordFromCompanyName: Text[30];
        PageNotEditable: Boolean;
        ShowSpecialModifyAction: Boolean;
        OrderTypeTestOrderFieldsVisible: Boolean;
        OrderTypeRetestOrderFieldsVisible: Boolean;
        OrderTypeManualOrderFieldsVisible: Boolean;
        OrderTypeRetestOrderOrManualOrderFieldsVisible: Boolean;
        COARequiredVisible: Boolean;


    [IntegrationEvent(false, false)]
    local procedure OnBeforePostTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApproveTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRejectTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInternalUseTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateCOAReceived(var TestOrder: Record "TO Test Order PROF"; var IsHandled: Boolean)
    begin
    end;
}
