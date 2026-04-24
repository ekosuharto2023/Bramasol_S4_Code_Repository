@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B4F885ABD90E'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_ZSJT35J3YUA3I7QY4LFXTX6GIY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_ASF
}
