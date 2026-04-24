@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_9FD3B5EE3F6D'

extend view V_FGL_BCF_BS_EXT with ZZ1_TUEZYIJWWEAGGZCXBHOAFOKNTA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_BCC
}
