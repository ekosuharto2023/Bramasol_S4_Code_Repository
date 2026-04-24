@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_65698457CA47'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_VWSEM6U7BURVY6FBKVFOXEN2RQ
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_ATC
}
