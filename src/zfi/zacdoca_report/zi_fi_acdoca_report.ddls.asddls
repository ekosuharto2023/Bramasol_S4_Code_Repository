@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Analyzer (ACDOCA, Supplier, Invoice)'
@Analytics.dataCategory: #FACT
@UI.headerInfo: {
  typeName: 'Journal Entry',
  typeNamePlural: 'Journal Entries',
  title: { type: #STANDARD, value: 'AccountingDocument' },
  description: { value: 'CompanyCode' }
}

@UI.presentationVariant: [{
  sortOrder: [
    { by: 'CompanyCode',            direction: #ASC },
    { by: 'AccountingDocument',     direction: #ASC },
    { by: 'AccountingDocumentItem', direction: #ASC }
  ]
}]

define root view entity ZI_FI_ACDOCA_REPORT
  as select from    I_JournalEntryItem        as JE

    left outer join I_OperationalAcctgDocItem as _AccItem on  JE.CompanyCode            = _AccItem.CompanyCode
                                                          and JE.FiscalYear             = _AccItem.FiscalYear
                                                          and JE.AccountingDocument     = _AccItem.AccountingDocument
                                                          and JE.AccountingDocumentItem = _AccItem.AccountingDocumentItem

  association [0..1] to I_SupplierInvoiceAPI01   as _SupplierInv on  JE.ReferenceDocument = _SupplierInv.SupplierInvoice
                                                                 and JE.FiscalYear        = _SupplierInv.FiscalYear

  association [0..1] to I_Supplier               as _Supplier    on  JE.Supplier = _Supplier.Supplier

  association [0..1] to I_PurchasingDocumentItem as _PO          on  _AccItem.PurchasingDocument     = _PO.PurchasingDocument
                                                                 and _AccItem.PurchasingDocumentItem = _PO.PurchasingDocumentItem
  association [0..1] to I_PaymentProposalPayment as _Pay         on  JE.AccountingDocument = _Pay.PaymentDocument
                                                                 and JE.CompanyCode        = _Pay.SendingCompanyCode
{
      /* ============================================================
         FACETS (OBJECT PAGE TABS)
         ============================================================ */
      @UI.facet: [
        {
          id      : 'GeneralInfo',
          type    : #IDENTIFICATION_REFERENCE,
          label   : 'Journal Entry Information',
          position: 10
        },
        {
          id              : 'SupplierInfo',
          type            : #FIELDGROUP_REFERENCE,
          targetQualifier : 'SupplierFields',
          label           : 'Supplier Details',
          position        : 20
        },
        {
          id              : 'InvoiceInfo',
          type            : #FIELDGROUP_REFERENCE,
          targetQualifier : 'InvoiceFields',
          label           : 'Supplier Invoice Details',
          position        : 30
        },
        {
          id              : 'POInfo',
          type            : #FIELDGROUP_REFERENCE,
          targetQualifier : 'POFields',
          label           : 'Purchase Order Details',
          position        : 40
        },
        {
          id: 'PaymentProposal',
          type: #FIELDGROUP_REFERENCE,
          label: 'Payment Proposal Details',
          targetQualifier: 'PaymentProposalFields',
          position: 50
        }
      ]

      /* ============================================================
         I_JournalEntryItem — MAIN LIST + JE TAB
         (Labels added only where names commonly duplicate/confuse)
         ============================================================ */

      @UI.lineItem       : [{ position: 10, importance: #HIGH }]
      @UI.identification : [{ position: 20 }]
      @UI.selectionField : [{ position: 20 }]
  key JE.CompanyCode,

      @UI.lineItem       : [{ position: 20, importance: #HIGH }]
      @UI.identification : [{ position: 30 }]
      @UI.selectionField : [{ position: 30 }]
      @EndUserText.label : 'Journal entry fiscal year'
  key JE.FiscalYear,

      @UI.lineItem       : [{ position: 30, importance: #HIGH }]
      @UI.identification : [{ position: 40 }]
      @UI.selectionField : [{ position: 40 }]
  key JE.AccountingDocument,

      @UI.lineItem       : [{ position: 50 }]
      @UI.identification : [{ position: 50 }]
  key JE.LedgerGLLineItem,

      @UI.lineItem       : [{ position: 60 }]
      @UI.identification : [{ position: 60 }]
      @UI.selectionField : [{ position: 80 }]
  key JE.Ledger,
  
      @UI.lineItem       : [{ position: 65 }]
      @UI.identification : [{ position: 85 }]
      JE.SourceLedger,
  

      @UI.identification : [{ position: 70 }]
      @EndUserText.label : 'Ledger fiscal year'
      JE.LedgerFiscalYear,

      @UI.identification : [{ position: 80 }]
      @UI.selectionField : [{ position: 90 }]
      JE.ReferenceDocumentContext,

      @UI.lineItem       : [{ position: 100 }]
      @UI.identification : [{ position: 100 }]
      @UI.selectionField : [{ position: 70 }]
      JE.GLAccount,

      @UI.identification : [{ position: 110 }]
      JE.CostCenter,

      @UI.identification : [{ position: 120 }]
      JE.ProfitCenter,

       @UI.identification : [{ position: 125 }]
       @UI.selectionField : [{ position: 90 }]
       @EndUserText.label : 'Journal Created By'
      JE.AccountingDocCreatedByUser,
      
      @UI.lineItem       : [{ position: 130 }]
      @UI.identification : [{ position: 130 }]
      @EndUserText.label : 'Journal entry transaction currency'
      JE.TransactionCurrency,

      @UI.lineItem       : [{ position: 140 }]
      @UI.identification : [{ position: 140 }]
      JE.AmountInTransactionCurrency,

      @UI.lineItem       : [{ position: 150 }]
      @UI.identification : [{ position: 150 }]
      @EndUserText.label : 'Journal entry company code currency'
      JE.CompanyCodeCurrency,

      @UI.lineItem       : [{ position: 160 }]
      @UI.identification : [{ position: 160 }]
      JE.AmountInCompanyCodeCurrency,

      @UI.identification : [{ position: 170 }]
      @EndUserText.label : 'Journal entry global currency'
      JE.GlobalCurrency,

      @UI.identification : [{ position: 180 }]
      JE.DebitCreditCode,

      @UI.lineItem       : [{ position: 190 }]
      @UI.identification : [{ position: 190 }]
      @UI.selectionField : [{ position: 90 }]
      JE.FiscalPeriod,

      @UI.identification : [{ position: 200 }]
      JE.FiscalYearVariant,

      @UI.identification : [{ position: 210 }]
      JE.FiscalYearPeriod,

      @UI.lineItem       : [{ position: 220 }]
      @UI.identification : [{ position: 220 }]
      @UI.selectionField : [{ position: 110 }]
      @EndUserText.label : 'Journal entry posting date'
      JE.PostingDate,

      @UI.lineItem       : [{ position: 230 }]
      @UI.identification : [{ position: 230, label: 'Journal Document Date' }]
      @UI.selectionField : [{ position: 100 }]
      @EndUserText.label : 'Journal entry document date'
      JE.DocumentDate,

      @UI.identification : [{ position: 240 }]
      JE.AccountingDocumentType,

      @UI.identification : [{ position: 250 }]
      JE.AccountingDocumentItem,

      @UI.identification : [{ position: 260 }]
      JE.AssignmentReference,

      @UI.lineItem       : [{ position: 270 }]
      @UI.identification : [{ position: 270 }]
      JE.PostingKey,

      @UI.identification : [{ position: 280 }]
      JE.TransactionTypeDetermination,

      @UI.lineItem       : [{ position: 290 }]
      @UI.identification : [{ position: 290 }]
      @UI.selectionField : [{ position: 50 }]
      JE.Supplier,

      @UI.identification : [{ position: 300 }]
      JE.FinancialAccountType,

      @UI.identification : [{ position: 310 }]
      JE.SpecialGLCode,

      @UI.lineItem       : [{ position: 320 }]
      @UI.identification : [{ position: 320 }]
      JE.TaxCode,

      @UI.identification : [{ position: 330 }]
      JE.TaxCountry,

      @UI.identification : [{ position: 340 }]
      JE.HouseBank,

      @UI.identification : [{ position: 350 }]
      JE.HouseBankAccount,

      @UI.identification : [{ position: 360 }]
      JE.IsOpenItemManaged,

      @UI.lineItem       : [{ position: 370 }]
      @UI.identification : [{ position: 370 }]
      @EndUserText.label : 'Journal entry clearing date'
      JE.ClearingDate,

      @UI.lineItem       : [{ position: 380 }]
      @UI.identification : [{ position: 380 }]
      @EndUserText.label : 'Clearing document fiscal year'
      JE.ClearingDocFiscalYear,

      @UI.identification : [{ position: 390 }]
      JE.ClearingAccountingDocument,

      @UI.identification : [{ position: 400 }]
      @EndUserText.label : 'Clearing journal entry fiscal year'
      JE.ClearingJournalEntryFiscalYear,

      @UI.identification : [{ position: 410 }]
      JE.ClearingJournalEntry,

      @UI.identification : [{ position: 420 }]
      JE.OffsettingAccount,

      @UI.identification : [{ position: 430 }]
      JE.OffsettingAccountType,

      @UI.identification : [{ position: 440 }]
      JE.OffsettingChartOfAccounts,

      @UI.lineItem       : [{ position: 450 }]
      @UI.identification : [{ position: 450 }]
      @EndUserText.label : 'Journal entry net due date'
      JE.NetDueDate,

      @UI.lineItem       : [{ position: 460 }]
      @UI.identification : [{ position: 460 }]
      JE.ZZ1_HOLMANPO_COB,

      @UI.lineItem       : [{ position: 470 }]
      @UI.identification : [{ position: 470 }]
      JE.ZZ1_TRANSACTIONKEY_COB,

      @UI.lineItem       : [{ position: 480 }]
      @UI.identification : [{ position: 480 }]
      JE.ZZ1_THIRDPARTYREF_COB,

      @UI.lineItem       : [{ position: 490 }]
      @UI.identification : [{ position: 490 }]
      JE.ZZ1_PRODUCTCODE_COB,

      @UI.lineItem       : [{ position: 500 }]
      @UI.identification : [{ position: 500 }]
      JE.ZZ1_SERIALNO_COB,

      @UI.lineItem       : [{ position: 510 }]
      @UI.identification : [{ position: 510 }]
      JE.ZZ1_SOURCE_COB,

      @UI.lineItem       : [{ position: 520 }]
      @UI.identification : [{ position: 520 }]
      JE.ZZ1_ICNNO_COB,

      @UI.lineItem       : [{ position: 530 }]
      @UI.identification : [{ position: 530 }]
      JE.ZZ1_PRICINGELEMENT_COB,

      @UI.lineItem       : [{ position: 540 }]
      @UI.identification : [{ position: 540 }]
      JE.ZZ1_CLIENTCODE_COB,

      @UI.lineItem       : [{ position: 550 }]
      @UI.identification : [{ position: 550 }]
      @EndUserText.label: 'Invoice on GL Line item'
      JE.ZZ1_InvoiceNumber_COB,

      @UI.lineItem       : [{ position: 560 }]
      @UI.identification : [{ position: 560 }]
      JE.ZZ1_VEHICLENO_COB,

      /* ============================================================
         I_SupplierInvoiceAPI01 — Invoice tab (field group)
         (Labels only where names commonly duplicate/confuse)
         ============================================================ */
      @UI.identification: [{ position: 610 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 610 }]
      @EndUserText.label: 'Supplier invoice number'
      _SupplierInv.SupplierInvoice,

      @UI.identification: [{ position: 660 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 660 }]
      _SupplierInv.SupplierInvoiceIDByInvcgParty,

      @UI.identification: [{ position: 670 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 670 }]
      @EndUserText.label: 'Indicator :Post Invoice'
      _SupplierInv.IsInvoice,
      @UI.identification: [{ position: 680, label: 'Invoice currency' }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 680 }]
      @EndUserText.label: 'Supplier invoice document currency'
      _SupplierInv.DocumentCurrency,

      @Aggregation.default: #SUM
      @UI.identification: [{ position: 690 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 690 }]
      _SupplierInv.InvoiceGrossAmount,

      @UI.identification: [{ position: 720 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 720 }]
      _SupplierInv.SupplierInvoiceStatus,

      @UI.identification: [{ position: 730 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 730 }]
      _SupplierInv.SupplierInvoiceOrigin,

      @UI.identification: [{ position: 740, label: 'Invoices created by' }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 740 }]
      @EndUserText.label: 'Invoice Entered By'
      _SupplierInv.CreatedByUser,

      @UI.identification: [{ position: 750 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 750 }]
      @EndUserText.label: 'Invoice UserName'
      _SupplierInv.LastChangedByUser,

      @UI.identification: [{ position: 760 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 760 }]
      _SupplierInv.InvoiceReference,

      @UI.identification: [{ position: 790 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 790 }]
      _SupplierInv.TaxIsCalculatedAutomatically,

      @UI.identification: [{ position: 800, label: 'Invoices created time' }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 800 }]
      @EndUserText.label: 'Supplier invoice creation date'
      _SupplierInv.CreationDate,

      @UI.identification: [{ position: 810 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 810 }]
      _SupplierInv.UnplannedDeliveryCost,

      @UI.identification: [{ position: 820 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 820 }]
      _SupplierInv.UnplannedDeliveryCostTaxCode,

      @UI.identification: [{ position: 830 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 830 }]
      _SupplierInv.UnplndDelivCostTaxJurisdiction,

      @UI.identification: [{ position: 840 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 840 }]
      _SupplierInv.DocumentHeaderText,

      @UI.identification: [{ position: 850 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 850 }]
      _SupplierInv.SupplierPostingLineItemText,

      @UI.identification: [{ position: 860 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 860 }]
      _SupplierInv.PaymentTerms,

      @UI.identification: [{ position: 870 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 870 }]
      @EndUserText.label: 'Supplier invoice due calculation base date'
      _SupplierInv.DueCalculationBaseDate,

      @UI.identification: [{ position: 880 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 880 }]
      _SupplierInv.CashDiscount1Percent,

      @UI.identification: [{ position: 890 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 890 }]
      _SupplierInv.CashDiscount1Days,

      @UI.identification: [{ position: 900 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 900 }]
      _SupplierInv.CashDiscount2Percent,

      @UI.identification: [{ position: 910 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 910 }]
      _SupplierInv.CashDiscount2Days,

      @UI.identification: [{ position: 920 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 920 }]
      _SupplierInv.NetPaymentDays,

      @UI.identification: [{ position: 930 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 930 }]
      _SupplierInv.ManualCashDiscount,

      @UI.identification: [{ position: 940 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 940 }]
      _SupplierInv.FixedCashDiscount,

      @UI.identification: [{ position: 950 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 950 }]
      _SupplierInv.StateCentralBankPaymentReason,

      @UI.identification: [{ position: 960 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 960 }]
      _SupplierInv.SupplyingCountry,

      @UI.identification: [{ position: 970 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 970 }]
      _SupplierInv.BPBankAccountInternalID,

      @UI.identification: [{ position: 980 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 980 }]
      _SupplierInv.PaymentMethod,

      @UI.identification: [{ position: 990 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 990 }]
      _SupplierInv.PaymentReference,

      @UI.identification: [{ position: 1000 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1000 }]
      _SupplierInv.PaymentReason,

      @UI.identification: [{ position: 1010 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1010 }]
      @EndUserText.label: 'Supplier invoice reversal document'
      _SupplierInv.ReverseDocument,

      @UI.identification: [{ position: 1020 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1020 }]
      @EndUserText.label: 'Supplier invoice reversal fiscal year'
      _SupplierInv.ReverseDocumentFiscalYear,

      @UI.identification: [{ position: 1030 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1030 }]
      _SupplierInv.SuplrInvcManuallyReducedAmount,

      @UI.identification: [{ position: 1040 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1040 }]
      _SupplierInv.SuplrInvcAutomReducedAmount,

      @UI.identification: [{ position: 1050 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1050 }]
      @EndUserText.label: 'Supplier invoice tax determination date'
      _SupplierInv.TaxDeterminationDate,

      @UI.identification: [{ position: 1060 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1060 }]
      @EndUserText.label: 'Supplier invoice tax reporting date'
      _SupplierInv.TaxReportingDate,

      @UI.identification: [{ position: 1070 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1070 }]
      @EndUserText.label: 'Supplier invoice tax fulfillment date'
      _SupplierInv.TaxFulfillmentDate,

      @UI.identification: [{ position: 1090 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1090 }]
      _SupplierInv.JrnlEntryCntrySpecificRef1,

      @UI.identification: [{ position: 1100 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1100 }]
      @EndUserText.label: 'Supplier invoice country specific date'
      _SupplierInv.JrnlEntryCntrySpecificDate1,

      @UI.identification: [{ position: 1110 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1110 }]
      _SupplierInv.ZZ1_InvoiceCategory_MIH,

      @UI.identification: [{ position: 1120 }]
      @UI.fieldGroup    : [{ qualifier:'InvoiceFields', position: 1120 }]
      @EndUserText.label: 'Supplier Invoice Number'
      _SupplierInv.ZZ1_INVOICENO_MIH,

      /* ============================================================
         I_Supplier — Supplier tab (field group)
         (Labels only where names commonly duplicate/confuse)
         ============================================================ */

      @UI.identification: [{ position: 1140 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1140 }]
      _Supplier.SupplierAccountGroup,

      @UI.identification: [{ position: 1150, label: 'Supplier Name' }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1150 }]
      @EndUserText.label: 'Supplier name'
      _Supplier.SupplierName,

      @UI.identification: [{ position: 1160, label: 'Supplier Full Name' }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1160 }]
      @EndUserText.label: 'Supplier full name'
      _Supplier.SupplierFullName,

      @UI.identification: [{ position: 1170 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1170 }]
      @EndUserText.label: 'Supplier business partner name'
      _Supplier.BPSupplierName,

      @UI.identification: [{ position: 1180 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1180 }]
      @EndUserText.label: 'Supplier business partner full name'
      _Supplier.BPSupplierFullName,

      @UI.identification: [{ position: 1190 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1190 }]
      @EndUserText.label: 'Supplier business partner name 1'
      _Supplier.BusinessPartnerName1,

      @UI.identification: [{ position: 1230 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1230 }]
      @EndUserText.label: 'Supplier address city'
      _Supplier.BPAddrCityName,

      @UI.identification: [{ position: 1240 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1240 }]
      @EndUserText.label: 'Supplier address street'
      _Supplier.BPAddrStreetName,

      @UI.identification: [{ position: 1250 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1250 }]
      _Supplier.AddressSearchTerm1,

      @UI.identification: [{ position: 1260 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1260 }]
      _Supplier.AddressSearchTerm2,

      @UI.identification: [{ position: 1270 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1270 }]
      @EndUserText.label: 'Supplier address district'
      _Supplier.DistrictName,

      @UI.identification: [{ position: 1280 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1280 }]
      @EndUserText.label: 'Supplier address PO box city'
      _Supplier.POBoxDeviatingCityName,

      @UI.identification: [{ position: 1290 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1290 }]
      _Supplier.BusinessPartnerFormOfAddress,

      @UI.identification: [{ position: 1300 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1300 }]
      _Supplier.IsBusinessPurposeCompleted,

      @UI.identification: [{ position: 1330 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1330 }]
      _Supplier.IsOneTimeAccount,

      @UI.identification: [{ position: 1340 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1340 }]
      _Supplier.PostingIsBlocked,

      @UI.identification: [{ position: 1350 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1350 }]
      _Supplier.PurchasingIsBlocked,

      @UI.identification: [{ position: 1360 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1360 }]
      @EndUserText.label: 'Supplier address identifier'
      _Supplier.AddressID,

      @UI.identification: [{ position: 1370 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1370 }]
      @EndUserText.label: 'Supplier address region'
      _Supplier.Region,

      @UI.identification: [{ position: 1380 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1380 }]
      _Supplier.OrganizationBPName1,

      @UI.identification: [{ position: 1390 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1390 }]
      _Supplier.OrganizationBPName2,

      @UI.identification: [{ position: 1400 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1400 }]
      @EndUserText.label: 'Supplier city'
      _Supplier.CityName,

      @UI.identification: [{ position: 1410 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1410 }]
      @EndUserText.label: 'Supplier postal code'
      _Supplier.PostalCode,

      @UI.identification: [{ position: 1420 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1420 }]
      @EndUserText.label: 'Supplier street'
      _Supplier.StreetName,

      @UI.identification: [{ position: 1430 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1430 }]
      @EndUserText.label: 'Supplier country'
      _Supplier.Country,

      @UI.identification: [{ position: 1440 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1440 }]
      _Supplier.SupplierLanguage,

      @UI.identification: [{ position: 1450 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1450 }]
      _Supplier.AlternativePayeeAccountNumber,

      @UI.identification: [{ position: 1460 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1460 }]
      _Supplier.PhoneNumber1,

      @UI.identification: [{ position: 1470 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1470 }]
      _Supplier.FaxNumber,

      @UI.identification: [{ position: 1480 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1480 }]
      _Supplier.IsNaturalPerson,

      @UI.identification: [{ position: 1490 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1490 }]
      _Supplier.BirthDate,

      @UI.identification: [{ position: 1500 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1500 }]
      _Supplier.PaymentIsBlockedForSupplier,

      @UI.identification: [{ position: 1510 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1510 }]
      _Supplier.SortField,

      @UI.identification: [{ position: 1520 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1520 }]
      _Supplier.PhoneNumber2,

      @UI.identification: [{ position: 1530 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1530 }]
      _Supplier.TradingPartner,

      @UI.identification: [{ position: 1540 }]
      @UI.fieldGroup    : [{ qualifier:'SupplierFields', position: 1540 }]
      _Supplier.AlternativePayeeIsAllowed,

      /* ============================================================
         I_PurchasingDocumentItem — PO tab (field group)
         (All fields kept; no label changes needed for duplicates here)
         ============================================================ */
      @UI.identification : [{ position: 1550 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1550 }]
      _PO.PurchasingDocument,

      @UI.identification : [{ position: 1560 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1560 }]
      _PO.PurchasingDocumentItem,

      @UI.identification : [{ position: 1600 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1600 }]
      _PO.PurchasingDocumentDeletionCode,

      @UI.identification : [{ position: 1620 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1620 }]
      _PO.MaterialGroup,

      @UI.identification : [{ position: 1630 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1630 }]
      _PO.Material,

      @UI.identification : [{ position: 1640 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1640 }]
      _PO.MaterialType,

      @UI.identification : [{ position: 1650 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1650 }]
      _PO.SupplierMaterialNumber,

      @UI.identification : [{ position: 1660 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1660 }]
      _PO.SupplierSubrange,

      @UI.identification : [{ position: 1680 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1680 }]
      _PO.ProductType,

      @UI.identification : [{ position: 1700 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1700 }]
      _PO.Plant,

      @UI.identification : [{ position: 1710 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1710 }]
      _PO.ManualDeliveryAddressID,

      @UI.identification : [{ position: 1720 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1720 }]
      _PO.ReferenceDeliveryAddressID,

      @UI.identification : [{ position: 1730 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1730 }]
      _PO.Customer,

      @UI.identification : [{ position: 1740 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1740 }]
       @EndUserText.label: 'Purchasing Supplier'
      _PO.Subcontractor,

      @UI.identification : [{ position: 1750 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1750 }]
      _PO.SupplierIsSubcontractor,

      @UI.identification : [{ position: 1760 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1760 }]
      _PO.CrossPlantConfigurableProduct,

      @UI.identification : [{ position: 1770 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1770 }]
      _PO.ArticleCategory,

      @UI.identification : [{ position: 1780 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1780 }]
      _PO.PlndOrderReplnmtElmntType,

      @UI.identification : [{ position: 1790 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1790 }]
      _PO.ProductPurchasePointsQtyUnit,

      @UI.identification : [{ position: 1800 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1800 }]
      _PO.ProductPurchasePointsQty,

      @UI.identification : [{ position: 1810 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1810 }]
      _PO.StorageLocation,

      @UI.identification : [{ position: 1830 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1830 }]
      _PO.OrderItemQtyToBaseQtyNmrtr,

      @UI.identification : [{ position: 1840 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1840 }]
      _PO.OrderItemQtyToBaseQtyDnmntr,

      @UI.identification : [{ position: 1850 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1850 }]
      _PO.NetPriceQuantity,

      @UI.identification : [{ position: 1860 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1860 }]
      _PO.IsFinallyInvoiced,

      @UI.identification : [{ position: 1870 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1870 }]
      _PO.GoodsReceiptIsExpected,

      @UI.identification : [{ position: 1880 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1880 }]
      _PO.InvoiceIsExpected,

      @UI.identification : [{ position: 1890 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1890 }]
      _PO.InvoiceIsGoodsReceiptBased,

      @UI.identification : [{ position: 1900 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1900 }]
      _PO.PurchaseContractItem,

      @UI.identification : [{ position: 1910 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1910 }]
      _PO.PurchaseContract,

      @UI.identification : [{ position: 1920 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1920 }]
      _PO.PurchaseRequisition,

      @UI.identification : [{ position: 1930 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1930 }]
      _PO.RequirementTracking,

      @UI.identification : [{ position: 1940 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1940 }]
      _PO.PurchaseRequisitionItem,

      @UI.identification : [{ position: 1950 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1950 }]
      _PO.ConsumptionPosting,

      @UI.identification : [{ position: 1980 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 1980 }]
      _PO.OrderPriceUnit,

      @UI.identification : [{ position: 2010 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2010 }]
      _PO.PricingDateControl,

      @UI.identification : [{ position: 2020 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2020 }]
      _PO.IncotermsClassification,

      @UI.identification : [{ position: 2030 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2030 }]
      _PO.PriceIsToBePrinted,

      @UI.identification : [{ position: 2040 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2040 }]
      _PO.AccountAssignmentCategory,

      @UI.identification : [{ position: 2050 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2050 }]
      _PO.PurchasingInfoRecord,

      @UI.identification : [{ position: 2060 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2060 }]
      _PO.NetAmount,

      @UI.identification : [{ position: 2070 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2070 }]
      _PO.GrossAmount,

      @UI.identification : [{ position: 2080 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2080 }]
      _PO.EffectiveAmount,

      @UI.identification : [{ position: 2100 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2100 }]
      _PO.NetPriceAmount,

      @UI.identification : [{ position: 2140 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2140 }]
      _PO.GoodsReceiptIsNonValuated,

      @UI.identification : [{ position: 2160 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2160 }]
      _PO.ItemIsRejectedBySupplier,

      @UI.identification : [{ position: 2170 }]
      @UI.fieldGroup     : [{ qualifier:'POFields', position: 2170 }]
      _PO.PurgDocPriceDate,

      /* ============================================================
         I_PaymentProposalPayment — Payment Proposal tab (field group)
         (Labels only where names commonly duplicate/confuse)
         ============================================================ */

      @UI.identification: [{ position: 2180 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2180 }]
      @EndUserText.label: 'Payment run date'
      _Pay.PaymentRunDate,

      @UI.identification: [{ position: 2190 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2190 }]
      _Pay.PaymentRunID,

      @UI.identification: [{ position: 2200 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2200 }]
      _Pay.PaymentRunIsProposal,

      @UI.identification: [{ position: 2210 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2210 }]
      _Pay.PayingCompanyCode,

      @UI.identification: [{ position: 2240 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2240 }]
      _Pay.PaymentRecipient,

      @UI.identification: [{ position: 2270 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2270 }]
      _Pay.SendingCompanyCode,

      @UI.identification: [{ position: 2280 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2280 }]
      _Pay.BusinessArea,

      @UI.identification: [{ position: 2300 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2300 }]
      _Pay.BranchCode,

      @UI.identification: [{ position: 2310 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2310 }]
      _Pay.DirectDebitType,

      @UI.identification: [{ position: 2320 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2320 }]
      @EndUserText.label: 'Payment due date'
      _Pay.PaymentDueDate,

      @UI.identification: [{ position: 2330 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2330 }]
      _Pay.PaymentRequestPaymentGroup,

      @UI.identification: [{ position: 2340 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2340 }]
      _Pay.NumberOfTextLines,

      @UI.identification: [{ position: 2350 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2350 }]
      _Pay.NumberOfPaidItems,

      @UI.identification: [{ position: 2360 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2360 }]
      _Pay.CompanyCodeCountry,

      @UI.identification: [{ position: 2380 }]
      @UI.fieldGroup: [{ qualifier: 'PaymentProposalFields', position: 2380 }]
      _Pay.PaymentMethodSupplement
}
