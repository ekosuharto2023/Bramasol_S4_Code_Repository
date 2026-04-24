@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_27B9718DDF43'

extend view V_FGL_BCF_PL_EXT with ZZ1_UQZMHSR3GZRIIH7X4R26CD5NWA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_PCC
}
