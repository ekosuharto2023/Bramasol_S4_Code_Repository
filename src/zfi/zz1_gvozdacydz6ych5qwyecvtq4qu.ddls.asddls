@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_621292B5EE16'

extend view V_FGL_BCF_BS_EXT with ZZ1_GVOZDACYDZ6YCH5QWYECVTQ4QU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_BCC
}
