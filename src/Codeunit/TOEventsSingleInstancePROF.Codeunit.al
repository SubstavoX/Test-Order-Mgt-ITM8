/// <summary>
/// Codeunit TO Events Single Instance PROF (ID 60004).
/// </summary>
codeunit 6208500 "TO Events Single Instance PROF"
{
    // Single Instance Codeunit - Exchanging global variable values.
    SingleInstance = true;


    var
        TempLotNoInformation: Record "Lot No. Information" temporary;
        TempNewLotNoInformation: Record "Lot No. Information" temporary;
        TempSerialNoInformation: Record "Serial No. Information" temporary;
        TempNewSerialNoInformation: Record "Serial No. Information" temporary;
        RetestDate: Date;
        NewRetestDate: Date;
        SalesExpirationDate: Date;
        VendorTrackingNo: Code[50];
        NewVendorTrackingNo: Code[50];
        CountryOfOrigin: Code[10];





    /// <summary>
    /// SetTempLotNoInformation.
    /// </summary>
    /// <param name="LotNoInformation">Temporary Record "Lot No. Information".</param>
    internal procedure SetTempLotNoInformation(LotNoInformation: Record "Lot No. Information" temporary)
    begin
        TempLotNoInformation := LotNoInformation;
    end;



    /// <summary>
    /// GetTempLotNoInformation.
    /// </summary>
    /// <param name="LotNoInformation">Temporary VAR Record "Lot No. Information".</param>
    internal procedure GetTempLotNoInformation(var LotNoInformation: Record "Lot No. Information" temporary)
    begin
        LotNoInformation := TempLotNoInformation;
    end;

    /// <summary>
    /// SetTempNewLotNoInformation.
    /// </summary>
    /// <param name="NewLotNoInformation">Temporary Record "Lot No. Information".</param>
    internal procedure SetTempNewLotNoInformation(NewLotNoInformation: Record "Lot No. Information" temporary)
    begin
        TempNewLotNoInformation := NewLotNoInformation;
    end;


    /// <summary>
    /// GetTempNewLotNoInformation.
    /// </summary>
    /// <param name="NewLotNoInformation">Temporary VAR Record "Lot No. Information".</param>
    internal procedure GetTempNewLotNoInformation(var NewLotNoInformation: Record "Lot No. Information" temporary)
    begin
        NewLotNoInformation := TempNewLotNoInformation;
    end;

    internal procedure SetTempSerialNoInformation(SerialNoInformation: Record "Serial No. Information" temporary)
    begin
        TempSerialNoInformation := SerialNoInformation;
    end;

    internal procedure GetTempSerialNoInformation(var SerialNoInformation: Record "Serial No. Information" temporary)
    begin
        SerialNoInformation := TempSerialNoInformation;
    end;

    internal procedure SetTempNewSerialNoInformation(NewSerialNoInformation: Record "Serial No. Information" temporary)
    begin
        TempNewSerialNoInformation := NewSerialNoInformation;
    end;

    internal procedure GetTempNewSerialNoInformation(var NewSerialNoInformation: Record "Serial No. Information" temporary)
    begin
        NewSerialNoInformation := TempNewSerialNoInformation;
    end;

    /// <summary>
    /// SetAdditionalTrackingInfo.
    /// </summary>
    /// <param name="RetestDateP">Date.</param>
    /// <param name="NewRetestDateP">Date.</param>
    /// <param name="SalesExpirationDateP">Date.</param>
    /// <param name="VendorLotNoP">Code[50].</param>
    /// <param name="NewVendorLotNoP">Code[50].</param>
    /// <param name="CountryOfOriginP">Code[10].</param>
    internal procedure SetAdditionalTrackingInfo(RetestDateP: Date; NewRetestDateP: Date; SalesExpirationDateP: Date; VendorTrackingNoP: Code[50]; NewVendorTrackingNoP: Code[50]; CountryOfOriginP: Code[10])
    begin
        RetestDate := RetestDateP;
        NewRetestDate := NewRetestDateP;
        SalesExpirationDate := SalesExpirationDateP;
        VendorTrackingNo := VendorTrackingNoP;
        NewVendorTrackingNo := NewVendorTrackingNoP;
        CountryOfOrigin := CountryOfOriginP;
    end;


    /// <summary>
    /// GetAdditionalTrackingInfo.
    /// </summary>
    /// <param name="RetestDateP">VAR Date.</param>
    /// <param name="NewRetestDateP">VAR Date.</param>
    /// <param name="SalesExpirationDateP">VAR Date.</param>
    /// <param name="VendorLotNoP">VAR Code[50].</param>
    /// <param name="NewVendorLotNoP">VAR Code[50].</param>
    /// <param name="CountryOfOriginP">VAR Code[10].</param>
    /// <param name="LotNoP">VAR Code[50].</param>
    internal procedure GetAdditionalTrackingInfo(var RetestDateP: Date; var NewRetestDateP: Date; var SalesExpirationDateP: Date; var VendorTrackingNoP: Code[50]; var NewVendorTrackingNoP: Code[50]; var CountryOfOriginP: Code[10])
    begin
        RetestDateP := RetestDate;
        NewRetestDateP := NewRetestDate;
        SalesExpirationDateP := SalesExpirationDate;
        VendorTrackingNoP := VendorTrackingNo;
        NewVendorTrackingNoP := NewVendorTrackingNo;
        CountryOfOriginP := CountryOfOrigin;
    end;









}
