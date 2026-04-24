@AbapCatalog.sqlViewAppendName: 'ZEFSVHIERCOCD'
@EndUserText.label: 'Extend I_FsvHierarchyInCOCD for Desc'
extend view I_FsvHierarchyInCOCD with ZE_FsvHierarchyInCOCD
{
    _FinancialStatementItem.FinStatementItemDescription as FinStatementItemDescription
}
