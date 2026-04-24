@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_00BF7530BFC0'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_FPICTW2CL7HGQMOQ7WP6KB3NHM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_PAC
}
