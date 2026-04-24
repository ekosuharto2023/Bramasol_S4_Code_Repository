@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS view for Payment method'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZI_FI_PAYMENT_METH
  as select from zfi_payment_meth
{
  key country                                              as Country,
  key payment_type                                         as PaymentType,
  key cast(lpad(invoice_category, 3, '0') as abap.char(3)) as InvoiceCategory,
  key payment_method                                       as PaymentMethod,
      payment_method_name                                  as PaymentMethodName
}
