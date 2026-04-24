@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_E98D451F350A'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_7EDGUD66XQ2YOXQI5O3CKDDRDA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_ASC
}
