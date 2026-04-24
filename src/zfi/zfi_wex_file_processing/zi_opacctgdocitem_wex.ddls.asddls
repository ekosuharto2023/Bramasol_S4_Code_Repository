@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_OPACCTDOCITEM helper'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_OPACCTGDOCITEM_WEX
  as select from I_OperationalAcctgDocItem

{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,

      Supplier,
      PaymentBlockingReason,
      OriginalReferenceDocument,
      substring(OriginalReferenceDocument, 1, 10) as SupplierInvoiceRef
}

where Supplier is not initial
