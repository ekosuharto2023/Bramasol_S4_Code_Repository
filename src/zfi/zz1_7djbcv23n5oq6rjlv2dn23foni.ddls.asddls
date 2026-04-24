@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_78B1FA16F5E9'

extend view V_FGL_BCF_BS_EXT with ZZ1_7DJBCV23N5OQ6RJLV2DN23FONI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_BCC
}
