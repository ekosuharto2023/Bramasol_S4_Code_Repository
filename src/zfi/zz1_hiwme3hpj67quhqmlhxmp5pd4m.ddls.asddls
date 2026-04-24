@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_42D33F83B6A1'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_HIWME3HPJ67QUHQMLHXMP5PD4M
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_ATC
}
