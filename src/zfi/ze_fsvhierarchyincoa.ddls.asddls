@AbapCatalog.sqlViewAppendName: 'ZEFSVHIECOA'
@EndUserText.label: 'Extend for Desc in I_FsvHierarchyInCoa'
extend view I_FsvHierarchyInCoa with ZE_FsvHierarchyInCoa
{
    _FinancialStatementItem.FinStatementItemDescription as FinStatementItemDescription
}
