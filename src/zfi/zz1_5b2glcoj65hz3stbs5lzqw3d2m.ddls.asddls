@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_3FB2CC3B5EA0'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_5B2GLCOJ65HZ3STBS5LZQW3D2M
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_ATC
}
