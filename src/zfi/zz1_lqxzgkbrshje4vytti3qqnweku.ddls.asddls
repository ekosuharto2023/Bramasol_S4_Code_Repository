@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_8657006EABA6'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_LQXZGKBRSHJE4VYTTI3QQNWEKU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_ATC
}
