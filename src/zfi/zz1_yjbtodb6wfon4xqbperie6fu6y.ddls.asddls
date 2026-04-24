@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_1CE5DDFB4793'

extend view V_FGL_BCF_PL_EXT with ZZ1_YJBTODB6WFON4XQBPERIE6FU6Y
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_PCC
}
