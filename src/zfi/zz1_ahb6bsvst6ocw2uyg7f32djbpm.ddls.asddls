@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_20E5AB298554'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_AHB6BSVST6OCW2UYG7F32DJBPM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_ATC
}
