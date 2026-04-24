@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unblock Payment Supplier Invoice'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_WEX_INVOICE_PAYMENT_UNBLOCK
  as select from I_SupplierInvoiceAPI01

{
  key SupplierInvoice,
  key FiscalYear
}
