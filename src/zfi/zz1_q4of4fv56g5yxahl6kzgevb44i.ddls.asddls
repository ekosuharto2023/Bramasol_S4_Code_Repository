@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_5EC3E21F4F43'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_Q4OF4FV56G5YXAHL6KZGEVB44I
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_PAC
}
