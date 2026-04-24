@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_F83AF903C479'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_LJAVA4UXK7BEXXW6KMXGAMDXV4
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_ASF
}
