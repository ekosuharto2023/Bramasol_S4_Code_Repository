@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_A38514D5F8B2'

extend view V_FGL_BCF_PL_EXT with ZZ1_RPXYYR27CNOXG5QDU6QXKGPOSE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_PCC
}
