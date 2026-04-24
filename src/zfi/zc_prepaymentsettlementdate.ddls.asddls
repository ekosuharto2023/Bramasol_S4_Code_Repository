@AbapCatalog.sqlViewName: 'ZVPPMTSTLDT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Prepayment Settlement Date ODQ'
//@Metadata.ignorePropagatedAnnotations: true

@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel :{ usageType.dataClass     : #TRANSACTIONAL,
                usageType.sizeCategory  : #L,
                usageType.serviceQuality: #D,
                supportedCapabilities   : #EXTRACTION_DATA_SOURCE
              }

@VDM.viewType                           : #CONSUMPTION

@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@Analytics: {
    dataCategory: #FACT,
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture: { automatic: true
        }
    }
}
define view ZC_PrepaymentSettlementDate as select from I_PrepaymentSettlementDate
{
    key PaymentRunDate,
    key PaymentRunID,
    key PaymentRunIsProposal,
    key PayingCompanyCode,
    key Supplier,
    key Customer,
    key PaymentRecipient,
    key PaymentDocument,
    SettlementPostingDate
}
