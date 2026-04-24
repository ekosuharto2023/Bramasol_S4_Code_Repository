@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_4E20E94B1B4D'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_WR5ICBRR47BDRRUOFKVDQYVOYM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_PAC
}
