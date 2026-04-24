@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Supplier Permitted Alternative Payee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.publish: true
define view entity ZC_SuplrPmtdAltvPayee as select from I_SuplrPmtdAltvPayee
{
    key Supplier,
    key CompanyCode,
    key SupplierAlternativePayee,
    /* Associations */
    _CompanyCode,
    _Supplier,
    _SupplierCompany
}
