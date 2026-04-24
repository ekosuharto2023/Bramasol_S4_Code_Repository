@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_81DBEDD96BCC'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_OR3JCTIZETA3QY5BOLUDIFI7GU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_ATC
}
