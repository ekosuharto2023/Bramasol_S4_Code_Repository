@AbapCatalog.sqlViewAppendName: 'ZEFIGLACCTLIR'
@EndUserText.label: 'Ext View for GL Account Line Item Raw'
extend view I_GLAccountLineItemRawData with ZE_GLAccountLineItemRawData
{
    _JournalEntry.AccountingDocumentHeaderText,
    _JournalEntry.ReversalReason
    
}
