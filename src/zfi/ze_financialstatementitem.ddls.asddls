@AbapCatalog.sqlViewAppendName: 'ZEFISTATITEM'
@EndUserText.label: 'Extension for Desc in FI Statement Item'
extend view I_FinancialStatementItem with ZE_FinancialStatementItem
{
    _Text[1: Language = $session.system_language].FinStatementItemDescription as FinStatementItemDescription
}
