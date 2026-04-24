@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_88735BA6BA89'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_5DIACWVZ6CV47T4DAN44W3EVP4
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_PAC
}
