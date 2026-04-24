@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_CEDD1D15B06E'

extend view C_SUPINVLISTHEADERINT with ZZ1_Q7CKWRVS7GMRUVQSAKL5AA7AIE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when invoiceall.IsActiveEntity = ''
      then  _HeaderDraftExtension.ZZ1_INVOICECATEGORY_MIH
    when invoiceall.IsActiveEntity = 'X'
      then  _HeaderExtension.ZZ1_INVOICECATEGORY_MIH
  end as ZZ1_InvoiceCategory_MIH
}
