@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_00AE75E9EB57'

extend view V_FGL_BCF_BS_EXT with ZZ1_7KSFSBBQVZGVZ2ZC3P43OVWHZ4
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_BCC
}
