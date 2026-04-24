@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B928160DA693'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_ECJNZ4WKS5UXZ6H6NQCPBRRSAE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_PAC
}
