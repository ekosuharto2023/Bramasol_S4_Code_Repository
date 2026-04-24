@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B694C4CC5DA2'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_ZHR5BKS7VJAE2UNKAIED6OSFZQ
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_ATC
}
