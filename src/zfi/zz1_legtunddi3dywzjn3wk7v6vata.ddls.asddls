@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_647CFF81BED3'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_LEGTUNDDI3DYWZJN3WK7V6VATA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_ASF
}
