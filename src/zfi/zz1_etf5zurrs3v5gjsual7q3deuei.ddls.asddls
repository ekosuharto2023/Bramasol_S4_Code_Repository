@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_C2946EA43369'

extend view V_FGL_BCF_BS_EXT with ZZ1_ETF5ZURRS3V5GJSUAL7Q3DEUEI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_BCC
}
