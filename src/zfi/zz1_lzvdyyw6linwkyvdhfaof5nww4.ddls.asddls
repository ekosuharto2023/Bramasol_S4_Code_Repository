@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_A7FAE876E71A'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_LZVDYYW6LINWKYVDHFAOF5NWW4
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_PAC
}
