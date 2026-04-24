@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_347A388D0F0F'

extend view C_SUPPLIERINVOICELISTCALC with ZZ1_E5EUEVMGKO2A7U6DRFOKOPFJDM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when invoice.IsActiveEntity = ''
      then  _HeaderDraftExtension.ZZ1_INVOICENO_MIH
    when invoice.IsActiveEntity = 'X'
      then  _HeaderExtension.ZZ1_INVOICENO_MIH
  end as ZZ1_INVOICENO_INV
}
