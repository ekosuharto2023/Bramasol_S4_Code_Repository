@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_0D09BD178807'

extend view V_FGL_BCF_PL_EXT with ZZ1_V3WSZDWQIBHCQQPELBD63TGQPU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_PCC
}
