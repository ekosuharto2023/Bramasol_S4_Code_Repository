@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_12A251CC2B69'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_CDG6W2CKMOKY56HYMEFJPYKCLQ
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_ATC
}
