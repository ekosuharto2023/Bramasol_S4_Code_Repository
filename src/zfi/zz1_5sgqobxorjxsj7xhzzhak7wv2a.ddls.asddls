@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_86D72C3120C4'

extend view I_ACTUALPLANJOURNALENTRYITEM with ZZ1_5SGQOBXORJXSJ7XHZZHAK7WV2A
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when ActualPlanJournalEntryItem.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when ActualPlanJournalEntryItem.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_PAC
}
