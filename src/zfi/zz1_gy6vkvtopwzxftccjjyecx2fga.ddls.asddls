@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_C410DC24240D'

extend view C_SUPPLIERINVOICELISTCALC with ZZ1_GY6VKVTOPWZXFTCCJJYECX2FGA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when invoice.IsActiveEntity = ''
      then  _HeaderDraftExtension.ZZ1_INVOICECATEGORY_MIH
    when invoice.IsActiveEntity = 'X'
      then  _HeaderExtension.ZZ1_INVOICECATEGORY_MIH
  end as ZZ1_InvoiceCategory_INV
}
