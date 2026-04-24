@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_98258AB775E3'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_VUTGHWAG52OFF4QBOMG2SUI3NY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_PAC
}
