@AbapCatalog.sqlViewName: 'ZVOUTGOINGCHECK'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom CDS View for Outgoing Check'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType                           : #CONSUMPTION
//@Metadata.ignorePropagatedAnnotations   : true

@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@Analytics: {
  dataCategory: #FACT,
  dataExtraction: {
    enabled: true,
    delta.changeDataCapture: {
      mapping: [
        {
          table: 'PAYR',
          role: #MAIN,
          viewElement: [
            'PaymentCompanyCode',
            'HouseBank',
            'HouseBankAccount',
            'PaymentMethod',
            'OutgoingCheque'
          ],
          tableElement: [
            'ZBUKR',
            'HBKID',
            'HKTID',
            'RZAWE',
            'CHECT'
          ]
        }
      ]
    }
  }
}

define view ZC_OutgoingCheck as select from I_OutgoingCheck
{
    key PaymentCompanyCode,
    key HouseBank,
    key HouseBankAccount,
    key PaymentMethod,
    key OutgoingCheque,
    IsIntercompanyPayment,
    ChequeIsManuallyIssued,
    ChequebookFirstCheque,
    PaymentDocument,
    ChequePaymentDate,
    PaymentCurrency,
    PaidAmountInPaytCurrency,
    Supplier,
    PaymentDocPrintDate,
    PaymentDocPrintTime,
    ChequePrintDateTime,
    PaymentDocPrintedByUser,
    ChequeEncashmentDate,
    ChequeLastExtractDate,
    ChequeLastExtractDateTime,
    PayeeTitle,
    PayeeName,
    PayeeAdditionalName,
    PayeePostalCode,
    PayeeCityName,
    PayeeStreet,
    PayeePOBox,
    PayeePOBoxPostalCode,
    PayeePOBoxCityName,
    Country,
    Region,
    ChequeVoidReason,
    ChequeVoidedDate,
    ChequeVoidedByUser,
    ChequeIsCashed,
    CashDiscountAmount,
    FiscalYear,
    ChequeType,
    VoidedChequeUsage,
    ChequeStatus,
    ChequeIssuingType,
    BankName,
    CompanyCodeCountry,
    CompanyCodeName,
    /* Associations */
    _Company,
    _Country,
    _HouseBank,
    _Supplier,
    _VoidReason
}
