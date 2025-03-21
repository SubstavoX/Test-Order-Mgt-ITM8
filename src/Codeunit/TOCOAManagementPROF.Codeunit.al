/// <summary>
/// Codeunit TO COA Management PROF (ID 6208510).
/// </summary>
codeunit 6208510 "TO COA Management PROF"
{
    /// <summary>
    /// Validates if a Certificate of Analysis is required and has been received for an item.
    /// </summary>
    /// <param name="ItemNo">The item number to check.</param>
    /// <param name="COAReceived">Whether the CoA has been received.</param>
    /// <param name="TrackingStatus">The tracking status to check against.</param>
    /// <returns>True if validation passes, false otherwise.</returns>
    Internal procedure ValidateCOARequirement(ItemNo: Code[20]; COAReceived: Boolean; TrackingStatus: Enum "TO Lot Status PROF"): Boolean
    var
        Item: Record Item;
        COARequiredErr: Label 'Certificate of Analysis is required for this item but has not been received. Please mark the CoA as received before posting.';
    begin
        if Item.Get(ItemNo) then
            if Item."Require COA PROF" and not COAReceived and (TrackingStatus = TrackingStatus::Approved) then
                Error(COARequiredErr);

        exit(true);
    end;

    /// <summary>
    /// Checks if an item requires a Certificate of Analysis.
    /// </summary>
    /// <param name="ItemNo">The item number to check.</param>
    /// <returns>True if the item requires a CoA, false otherwise.</returns>
    Internal procedure IsCoARequired(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit(Item."Require COA PROF");

        exit(false);
    end;

    /// <summary>
    /// Opens a file dialog to upload a COA document and stores it in the test order record.
    /// </summary>
    /// <param name="TestOrder">The test order record to store the document in.</param>
    /// <returns>True if a document was uploaded successfully, false otherwise.</returns>
    Internal procedure UploadCOADocument(var TestOrder: Record "TO Test Order PROF"): Boolean
    var
        FileName: Text;
        InStream: InStream;
        OutStream: OutStream;
        UploadMsg: Label 'Upload Certificate of Analysis document';
        NoFileSelectedMsg: Label 'No file was selected.';
        UploadSuccessMsg: Label 'Certificate of Analysis document uploaded successfully.';
    begin
        // Ensure we have the latest record
        if TestOrder.Get(TestOrder."Test Order No.") then;

        // Make sure COA Received is set to true
        if not TestOrder."COA Received" then begin
            TestOrder.Validate("COA Received", true);
            TestOrder.Modify(true);
        end;

        if UploadIntoStream(UploadMsg, '', '', FileName, InStream) then begin
            // CALCFIELDS is required for BLOB fields
            TestOrder.CALCFIELDS("COA Document");

            TestOrder."COA File Name" := CopyStr(FileName, 1, 250);
            TestOrder."COA Document".CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            TestOrder.Modify(true);

            // Verify the upload was successful
            TestOrder.Get(TestOrder."Test Order No.");
            TestOrder.CALCFIELDS("COA Document");
            TestOrder."COA Document".CreateInStream(InStream);
            if InStream.Length > 0 then begin
                Message(UploadSuccessMsg);
                exit(true);
            end;
        end else
            Message(NoFileSelectedMsg);

        exit(false);
    end;

    /// <summary>
    /// Downloads the COA document from the test order record.
    /// </summary>
    /// <param name="TestOrder">The test order record containing the document.</param>
    /// <returns>True if a document was downloaded successfully, false otherwise.</returns>
    Internal procedure DownloadCOADocument(var TestOrder: Record "TO Test Order PROF"): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        InStream: InStream;
        OutStream: OutStream;
        NoDocumentErr: Label 'No Certificate of Analysis document found.';
    begin
        if not TestOrder."COA Received" then
            exit(false);

        if TestOrder."COA File Name" = '' then begin
            Message(NoDocumentErr);
            exit(false);
        end;

        // Refresh the record to ensure we have the latest data
        if TestOrder.Get(TestOrder."Test Order No.") then;

        // CALCFIELDS is required for BLOB fields
        TestOrder.CALCFIELDS("COA Document");

        TestOrder."COA Document".CreateInStream(InStream);
        if InStream.Length = 0 then begin
            Message(NoDocumentErr);
            exit(false);
        end;

        TempBlob.CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        TempBlob.CreateInStream(InStream);

        FileName := TestOrder."COA File Name";
        exit(DownloadFromStream(InStream, 'Download', '', '', FileName));
    end;

    /// <summary>
    /// Event subscriber for handling the OnValidateCOAReceived event from the test order card page.
    /// This event is triggered when the COA Received field is changed to true.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"TO Test Order Card PROF", 'OnValidateCOAReceived', '', false, false)]
    local procedure OnValidateCOAReceived(var TestOrder: Record "TO Test Order PROF"; var IsHandled: Boolean)
    var
        UploadDocumentQst: Label 'Do you want to upload a Certificate of Analysis document?';
        COARequiredNoDocumentErr: Label 'A Certificate of Analysis document is required for this item. Please upload a document.';
    begin
        if not TestOrder."COA Received" then
            exit;

        IsHandled := true;

        if Confirm(UploadDocumentQst, true) then begin
            if not UploadCOADocument(TestOrder) and IsCoARequired(TestOrder."Item No.") then begin
                TestOrder.Validate("COA Received", false);
                TestOrder.Modify(true);
                Error(COARequiredNoDocumentErr);
            end;
        end else
            if IsCoARequired(TestOrder."Item No.") then begin
                TestOrder.Validate("COA Received", false);
                TestOrder.Modify(true);
                Error(COARequiredNoDocumentErr);
            end;
    end;

    /// <summary>
    /// Event subscriber to validate CoA requirements before posting a test order.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"TO Test Order Card PROF", 'OnBeforePostTestOrder', '', false, false)]
    local procedure OnBeforePostTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if not IsHandled then
            ValidateCOARequirement(TestOrder."Item No.", TestOrder."COA Received", UsageDecision."Tracking Status");
    end;

    /// <summary>
    /// Event subscriber to validate CoA requirements before approving a test order.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"TO Test Order Card PROF", 'OnBeforeApproveTestOrder', '', false, false)]
    local procedure OnBeforeApproveTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if not IsHandled then
            ValidateCOARequirement(TestOrder."Item No.", TestOrder."COA Received", UsageDecision."Tracking Status");
    end;

    /// <summary>
    /// Event subscriber to validate CoA requirements before rejecting a test order.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"TO Test Order Card PROF", 'OnBeforeRejectTestOrder', '', false, false)]
    local procedure OnBeforeRejectTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if not IsHandled then
            ValidateCOARequirement(TestOrder."Item No.", TestOrder."COA Received", UsageDecision."Tracking Status");
    end;

    /// <summary>
    /// Event subscriber to validate CoA requirements before posting an internal use test order.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"TO Test Order Card PROF", 'OnBeforeInternalUseTestOrder', '', false, false)]
    local procedure OnBeforeInternalUseTestOrder(var TestOrder: Record "TO Test Order PROF"; var UsageDecision: Record "TO Usage Decision PROF"; var IsHandled: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get() then
            if not CompanyInformation."Test Order Mgt PROF" then
                exit;
        if not IsHandled then
            ValidateCOARequirement(TestOrder."Item No.", TestOrder."COA Received", UsageDecision."Tracking Status");
    end;


}