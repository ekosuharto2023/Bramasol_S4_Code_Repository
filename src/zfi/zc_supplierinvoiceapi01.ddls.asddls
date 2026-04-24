@AbapCatalog.sqlViewName: 'ZVSUPPLIERINV'
@AbapCatalog.compiler.compareFilter     : true
//@AbapCatalog.preserveKey                : true
@AccessControl:{ authorizationCheck     : #CHECK,
                 personalData.blocking  : #BLOCKED_DATA_EXCLUDED
               }
@EndUserText.label                      : 'Data Extraction for Supplier Invoice'
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel :{ usageType.dataClass     : #TRANSACTIONAL,
                usageType.sizeCategory  : #L,
                usageType.serviceQuality: #D,
                supportedCapabilities   : #EXTRACTION_DATA_SOURCE
              }

@VDM.viewType                           : #CONSUMPTION
//@ObjectModel.representativeKey          : [ 'SupplierInvoice' ]
//@Metadata.ignorePropagatedAnnotations   : true

@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@Analytics: {
    dataCategory: #FACT,
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture: {
            mapping:[ {
                        table           : 'rbkp', role: #MAIN,
                        viewElement     : ['SupplierInvoice', 'FiscalYear'],
                        tableElement    : ['belnr', 'gjahr']
                      }
                    ]
        }
    }
}
define view ZC_SupplierInvoiceAPI01 as select from I_SupplierInvoiceAPI01
{
key SupplierInvoice,
key FiscalYear,
SupplierInvoiceWthnFiscalYear,
CompanyCode,
DocumentDate,
PostingDate,
SupplierInvoiceIDByInvcgParty,
InvoicingParty,
IsInvoice,
DocumentCurrency,
InvoiceGrossAmount,
ExchangeRate,
AccountingDocumentType,
SupplierInvoiceStatus,
SupplierInvoiceOrigin,
CreatedByUser,
LastChangedByUser,
InvoiceReference,
InvoiceReferenceFiscalYear,
AssignmentReference,
TaxIsCalculatedAutomatically,
BusinessPlace,
CreationDate,
UnplannedDeliveryCost,
UnplannedDeliveryCostTaxCode,
UnplndDelivCostTaxJurisdiction,
DocumentHeaderText,
SupplierPostingLineItemText,
PaymentTerms,
DueCalculationBaseDate,
CashDiscount1Percent,
CashDiscount1Days,
CashDiscount2Percent,
CashDiscount2Days,
NetPaymentDays,
ManualCashDiscount,
FixedCashDiscount,
StateCentralBankPaymentReason,
SupplyingCountry,
BPBankAccountInternalID,
PaymentMethod,
PaymentReference,
PaytSlipWthRefSubscriber,
PaytSlipWthRefCheckDigit,
PaytSlipWthRefReference,
PaymentReason,
ReverseDocument,
ReverseDocumentFiscalYear,
SuplrInvcManuallyReducedAmount,
SuplrInvcAutomReducedAmount,
TaxDeterminationDate,
TaxReportingDate,
TaxFulfillmentDate,
TaxCountry,
UnplndDeliveryCostTaxCountry,
DeliveryOfGoodsReportingCntry,
SupplierVATRegistration,
IsEUTriangularDeal,
SuplrInvcDebitCrdtCodeDelivery,
SuplrInvcDebitCrdtCodeReturns,
ElectronicInvoiceUUID,
JrnlEntryCntrySpecificRef1,
JrnlEntryCntrySpecificDate1,
JrnlEntryCntrySpecificRef2,
JrnlEntryCntrySpecificDate2,
JrnlEntryCntrySpecificRef3,
JrnlEntryCntrySpecificDate3,
JrnlEntryCntrySpecificRef4,
JrnlEntryCntrySpecificDate4,
JrnlEntryCntrySpecificRef5,
JrnlEntryCntrySpecificDate5,
JrnlEntryCntrySpecificBP1,
JrnlEntryCntrySpecificBP2,
ZZ1_InvoiceCategory_MIH,
ZZ1_INVOICENO_MIH,
/* Associations */
_CompanyCode,
_Currency,
_SuplrInvcHeaderWhldgTaxAPI01,
_SuplrInvcItemPurOrdRefAPI01,
_SuplrInvcSeldDelivNoteAPI01,
_SuplrInvcSeldInbBOLAPI01,
_SuplrInvcSeldPurgDocAPI01,
_SuplrInvcSeldSESLeanAPI01,
_SuplrInvoiceItemGLAcctAPI01,
_SupplierInvoiceBlockAPI01,
_SupplierInvoiceTaxAPI01
}
