@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B9CFC379A3F6'

extend view V_FGL_BCF_PL_EXT with ZZ1_4CTX37DMGAA3DAQ3Z7DFRWJ4TY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_PCC
}
