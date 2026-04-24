@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_0F862D2CB505'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_WL2PG3XX2Y3MPPYUILJYXNLBKY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_ATC
}
