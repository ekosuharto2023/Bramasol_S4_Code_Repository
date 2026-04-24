@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WEX Docs for Release'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZC_WEX_DOCS_FOR_RELEASE
  as select from I_SupplierInvoiceAPI01 as si

  association [0..*] to E_SupplierInvoiceItemGLAcct as _ExtendItems
    on  si.SupplierInvoice = _ExtendItems.SupplierInvoice
    and si.FiscalYear      = _ExtendItems.FiscalYear

  association [0..1] to I_SupplierInvoice           as _Block
    on  si.SupplierInvoice = _Block.SupplierInvoice
    and si.FiscalYear      = _Block.FiscalYear

  association [0..*] to ZI_OPACCTGDOCITEM_WEX       as _OpAcctgDocItem
    on  si.SupplierInvoice = _OpAcctgDocItem.SupplierInvoiceRef
    and si.FiscalYear      = _OpAcctgDocItem.FiscalYear
    and si.CompanyCode     = _OpAcctgDocItem.CompanyCode

{
  key si.CompanyCode,
  key si.SupplierInvoice,
  key si.FiscalYear,

      si.SupplierInvoiceStatus,
      si.PostingDate,
      _ExtendItems.ZZ1_THIRDPARTYREF_COB    as WexUUID,
      si.ZZ1_InvoiceCategory_MIH            as WexCategory,
      si.DocumentCurrency,

      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      si.InvoiceGrossAmount,

      _Block.PaymentBlockingReason,
      _OpAcctgDocItem.PaymentBlockingReason as OpPaymentBlockingReason
}
