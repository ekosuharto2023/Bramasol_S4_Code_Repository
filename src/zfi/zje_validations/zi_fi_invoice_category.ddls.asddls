@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Invoice Category CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_FI_INVOICE_CATEGORY
  as select from zfi_inv_category
{
      @UI.facet: [ { id: 'GeneralInfo',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'General Information' } ]
      @UI.identification: [ { position: 10, label: 'Invoice Category' } ]
      @UI.lineItem: [ { position: 10, label: 'Invoice Category' } ]
 // key invoice_category as InvoiceCategory,
 key cast(lpad(invoice_category, 3, '0') as abap.char(3)) as InvoiceCategory,
 
      @UI.identification: [ { position: 20, label: 'Description' } ]
      @UI.lineItem: [ { position: 20, label: 'Description' } ]
      description      as Description

}
