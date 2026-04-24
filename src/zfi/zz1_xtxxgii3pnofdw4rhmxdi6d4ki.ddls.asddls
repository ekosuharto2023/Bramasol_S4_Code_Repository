@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_D4C6D4E22055'

extend view V_FGL_BCF_PL_EXT with ZZ1_XTXXGII3PNOFDW4RHMXDI6D4KI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_PCC
}
