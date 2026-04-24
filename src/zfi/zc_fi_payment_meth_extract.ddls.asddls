@AccessControl.authorizationCheck: #NOT_REQUIRED

@Analytics.dataCategory: #DIMENSION

@Analytics.dataExtraction: { enabled: true,
                             delta.changeDataCapture.mapping: [ { table: 'ZFI_PAYMENT_METH',
                                                                  role: #MAIN,
                                                                  viewElement: [ 'Country',
                                                                                 'PaymentType',
                                                                                 'InvoiceCategory',
                                                                                 'PaymentMethod'
                                                                                  ],
                                                                  tableElement: [ 'COUNTRY',
                                                                                  'PAYMENT_TYPE',
                                                                                  'INVOICE_CATEGORY',
                                                                                  'PAYMENT_METHOD'
                                                                                   ] } ] }

@EndUserText.label: 'CDS view for Payment Method (CDC)'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API

define view entity ZC_FI_PAYMENT_METH_EXTRACT
  as select from zfi_payment_meth

{
  key country             as Country,
  key payment_type        as PaymentType,
  key invoice_category    as InvoiceCategory,
  key payment_method      as PaymentMethod,
      payment_method_name as PaymentMethodName
}
