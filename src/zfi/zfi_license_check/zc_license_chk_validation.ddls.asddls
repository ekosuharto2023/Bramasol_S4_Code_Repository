@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'License check invoice validation'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true

define view entity ZC_LICENSE_CHK_VALIDATION
  as select from I_SupplierInvoiceAPI01 as si

{
      @ObjectModel.readOnly: true
  key SupplierInvoice,

      @ObjectModel.readOnly: true
  key FiscalYear,

      @ObjectModel.mandatory: true
      @ObjectModel.sapObjectNodeTypeReference: 'CompanyCode'
      CompanyCode,

      InvoicingParty,

      @ObjectModel.mandatory: true
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      InvoiceGrossAmount,

      @ObjectModel.mandatory: true
      DocumentCurrency,

      @ObjectModel.sapObjectNodeTypeReference: 'PaymentMethod'
      PaymentMethod,
      
      IsInvoice,
      
      si.ZZ1_INVOICENO_MIH
}
