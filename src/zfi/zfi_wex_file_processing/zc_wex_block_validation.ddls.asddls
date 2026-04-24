@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Validation for WEX payment block remove'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.publish: true
define view entity ZC_WEX_BLOCK_VALIDATION as select from I_OperationalAcctgDocItem
{
    key CompanyCode,
    key AccountingDocument,
    key FiscalYear,
    key AccountingDocumentItem,
    ChartOfAccounts,
    Supplier,
    PaymentMethod,
    PaymentBlockingReason,
    OriginalReferenceDocument
}
