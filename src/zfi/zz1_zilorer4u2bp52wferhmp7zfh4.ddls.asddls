@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_8F17276818E8'

extend view V_FGL_BCF_PL_EXT with ZZ1_ZILORER4U2BP52WFERHMP7ZFH4
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_PCC
}
