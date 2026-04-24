@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_6D801A4624C7'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_OPWOTEHAZ4RUSRS7YQED2JNVRE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_PAC
}
