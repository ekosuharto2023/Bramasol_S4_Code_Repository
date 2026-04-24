@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_0397F533398A'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_BDT5LHZJD5LNUYSKCCKV3KSC4Y
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_PAC
}
