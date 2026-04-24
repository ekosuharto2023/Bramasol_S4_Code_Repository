@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_3EC3A9DC30C5'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_KX3KXFXKEHNADLTQ3LSLCNFMHI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_ATC
}
