@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_EF9680D056FB'

extend view C_SUPINVLISTHEADERINT with ZZ1_Z3MUHODLRLPIJ6KDHVY77SZ2FM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when invoiceall.IsActiveEntity = ''
      then  _HeaderDraftExtension.ZZ1_INVOICENO_MIH
    when invoiceall.IsActiveEntity = 'X'
      then  _HeaderExtension.ZZ1_INVOICENO_MIH
  end as ZZ1_INVOICENO_MIH
}
