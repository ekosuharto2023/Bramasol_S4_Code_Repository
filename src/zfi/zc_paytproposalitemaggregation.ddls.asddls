@AbapCatalog.sqlViewName: 'ZVPAYTITMAGGRGN'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@Metadata.ignorePropagatedAnnotations: true

@EndUserText.label: 'Payment Proposal Item Aggregation with FisacalYear'

@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #MIXED 
@ObjectModel.supportedCapabilities   : #EXTRACTION_DATA_SOURCE

@VDM.viewType   : #CONSUMPTION
@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API

@Analytics: {
    dataCategory: #FACT,
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture: {
            automatic: false,
            mapping: [
                {
                    table       : 'REGUH',
                    role        : #MAIN,
                    viewElement : ['PaymentRunDate','PaymentRunID','PaymentRunIsProposal',
                                   'PayingCompanyCode','Supplier','Customer','PaymentRecipient','PaymentDocument'],
                    tableElement: ['LAUFD','LAUFI','XVORL','ZBUKR','LIFNR','KUNNR','EMPFG','VBLNR']
                }
            ]
        }
    }
}

define view ZC_PaytProposalItemAggregation as select from ZP_PaytProposalItemAggregation
  association [0..1] to I_CompanyCode                 as _CompanyCode                 on  $projection.PayingCompanyCode = _CompanyCode.CompanyCode
//  association [0..1] to I_PaymentProposalHeader       as _PaymentProposalHeader       on  $projection.PaymentRunID         = _PaymentProposalHeader.PaymentRunID
//                                                                                      and $projection.PaymentRunDate       = _PaymentProposalHeader.PaymentRunDate
//                                                                                      and $projection.PaymentDocument      = _PaymentProposalHeader.PaymentDocument
//                                                                                      and $projection.PaymentRunIsProposal = _PaymentProposalHeader.PaymentRunIsProposal
//                                                                                      and $projection.PayingCompanyCode    = _PaymentProposalHeader.PayingCompanyCode
//                                                                                      and $projection.Supplier             = _PaymentProposalHeader.Supplier
//                                                                                      and $projection.Customer             = _PaymentProposalHeader.Customer
//                                                                                      and $projection.PaymentRecipient     = _PaymentProposalHeader.PaymentRecipient  
  association [0..1] to I_Currency                    as _PaymentCurrency             on  $projection.PaymentCurrency = _PaymentCurrency.Currency
  association [0..1] to I_Currency                    as _CompanyCodeCurrency         on  $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency
{
  key PaymentRunDate,
  key PaymentRunID,
  key PaymentRunIsProposal,
  key PayingCompanyCode,
  key Supplier,
  key Customer,
  key PaymentRecipient,
  key PaymentDocument,
      @Semantics.amount.currencyCode: 'PaymentCurrency' 
      AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'     
      HeaderAmtInCoCodeCurrency,
      @Semantics.amount.currencyCode: 'PaymentCurrency'       
      WhldgTaxAmtInTransacCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'     
      WhldgTaxAmtInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'PaymentCurrency' 
      TotDeductionAmtInTransacCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'   
      TotDeductionAmtInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'PaymentCurrency'   
      NetAmountInTransacCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'     
      NetAmountInCoCodeCurrency, 
      
      @Semantics.currencyCode:true
      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency' 
      _CompanyCode.Currency as CompanyCodeCurrency,
      @Semantics.currencyCode:true
      @ObjectModel.foreignKey.association: '_PaymentCurrency' 
      PaymentCurrency as PaymentCurrency,
      FiscalYear,
//       ZP_PaytProposalItemAggregation.FiscalYear,
      _CompanyCodeCurrency,
      _PaymentCurrency
} 
