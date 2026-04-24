@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B60361F49B1B'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_44OQERXZVKUW7K2BMKY7Q4OI6M
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_ASF
}
