@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B3AE63820FA6'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_SL5543R2PO6JIBTPGXOZ3QN3QM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_PAC
}
