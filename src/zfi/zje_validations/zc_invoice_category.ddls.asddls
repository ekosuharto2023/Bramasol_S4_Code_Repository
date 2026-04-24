@AbapCatalog.sqlViewName: 'ZINVVCAT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wrapper View for table ZINVOICE_CATEGRY data selection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.representativeKey: 'invoice_category'
define view ZC_INVOICE_CATEGORY
  as select from zfi_inv_category
{
  key invoice_category as InvoiceCategory,
  description as Description

}
