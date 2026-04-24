@AbapCatalog.sqlViewName: 'ZVACCCLRHIST'
@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Accounting Doc Item Clearing History'
@VDM.viewType: #BASIC
@ObjectModel: { usageType: { sizeCategory: #L,
                             dataClass:  #MIXED,
                             serviceQuality: #B },
                supportedCapabilities: [#ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #EXTRACTION_DATA_SOURCE, #ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET],
                modelingPattern: #ANALYTICAL_DIMENSION }
@Metadata: { ignorePropagatedAnnotations: true,
             allowExtensions:true }
@Analytics:{
    dataCategory: #CUBE,
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture: {
          mapping:
            [
              {
                table: 'BSE_CLR',
                role: #MAIN,
                viewElement: ['ClearingCompanyCode', 'ClearingAccountingDocument', 'ClearingFiscalYear', 'ClearingIndex'],
                tableElement: ['bukrs_clr', 'belnr_clr', 'gjahr_clr', 'index_clr']
              },
              { 
                table: 'T001', 
                role: #LEFT_OUTER_TO_ONE_JOIN,
                viewElement: ['ClearingCompanyCode'],
                tableElement: ['bukrs']
              }
            ]
         }
      },
    internalName:#LOCAL   
}

//@Metadata.ignorePropagatedAnnotations: true
define view ZC_AccDocItmClrHist as select from I_OplAcctgDocItemClrgHist
{
    key ClearingCompanyCode,
    key ClearingAccountingDocument,
    key ClearingFiscalYear,
    key ClearingIndex,
    ClearedCompanyCode,
    ClearedAccountingDocument,
    ClearedFiscalYear,
    ClearedAccountingDocumentItem,
    ClearingItem,
    ClearingDownPaymentItem,
    ClearingType,
    ClearingTransactionCurrency,
    ClearingCompanyCodeCurrency,
    FinancialAccountType,
    AmountInCompanyCodeCurrency,
    AmountInInClrgTransCrcy,
    DifferenceAmtInCoCodeCrcy,
    DifferenceAmtInClrgTransCrcy,
    CashDiscountAmtInCoCodeCrcy,
    CashDiscountAmtInClrgTransCrcy,
    ExchRateDiffAmtInCoCodeCrcy,
    /* Associations */
    _ClearedAccountingDocument,
    _ClearedCompanyCode,
    _ClearedFiscalYear,
    _ClearedItem,
    _ClearingCompanyCode,
    _ClearingCompanyCodeCurrency,
    _ClearingDocument,
    _ClearingFiscalYear,
    _ClearingTransactionCurrency,
    _ClearingType,
    _FinancialAccountType
}
