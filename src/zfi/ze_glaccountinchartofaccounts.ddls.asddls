@AbapCatalog.sqlViewAppendName: 'ZEGLACCCHART'
@EndUserText.label: 'Extention View to add GL Account Description'
extend view I_GLAccountInChartOfAccounts with ZE_GLACCOUNTINCHARTOFACCOUNTS
{
    _Text[1: Language = $session.system_language].GLAccountLongName as GLAccountLongName
}
