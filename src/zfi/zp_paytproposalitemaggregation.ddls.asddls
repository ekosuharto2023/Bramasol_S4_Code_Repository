@AbapCatalog.sqlViewName: 'ZPPAYTITMAGGRGN'
@AbapCatalog.compiler.compareFilter: true
@EndUserText.label: 'Wrapper for P_PaytProposalItemAggregation to get Fiscal Year'

//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@Metadata.ignorePropagatedAnnotations: true

// Below view code is referenced from p_PaytProposalItemAggregation
define view ZP_PaytProposalItemAggregation as select from reguh

association [1..*] to P_PaymentProposalItem as _PaymentProposalItem 
    on $projection.PaymentRunDate = _PaymentProposalItem.PaymentRunDate
   and $projection.PaymentRunID        = _PaymentProposalItem.PaymentRunID
   and $projection.PaymentRunIsProposal = _PaymentProposalItem.PaymentRunIsProposal
   and $projection.PayingCompanyCode = _PaymentProposalItem.PayingCompanyCode
   and $projection.Supplier = _PaymentProposalItem.Supplier
   and $projection.Customer = _PaymentProposalItem.Customer
   and $projection.PaymentRecipient = _PaymentProposalItem.PaymentRecipient
   and $projection.PaymentDocument = _PaymentProposalItem.PaymentDocument
{   
 key  laufd as PaymentRunDate,
 key  laufi as PaymentRunID,    
 key  xvorl as PaymentRunIsProposal,    
 key  zbukr as PayingCompanyCode,
 key  lifnr as Supplier,
 key  kunnr as Customer,     
 key  empfg as PaymentRecipient,     
 key  vblnr as PaymentDocument,
    
    waers as PaymentCurrency,
    
     cast ( sum(_PaymentProposalItem.AmountInTransactionCurrency) as abap.curr(23,2)) as AmountInTransactionCurrency,     
     cast ( sum(_PaymentProposalItem.AmountInCompanyCodeCurrency) as abap.curr(23,2)) as HeaderAmtInCoCodeCurrency,    
     cast ( sum(_PaymentProposalItem.WhldgTaxAmtInTransacCrcy) as abap.curr(23,2)) as WhldgTaxAmtInTransacCrcy,
     cast ( sum(_PaymentProposalItem.WhldgTaxAmtInCoCodeCrcy) as abap.curr(23,2)) as WhldgTaxAmtInCoCodeCrcy,
     cast ( sum(_PaymentProposalItem.TotDeductionAmtInTransacCrcy) as abap.curr(23,2)) as TotDeductionAmtInTransacCrcy,
     cast ( sum(_PaymentProposalItem.TotDeductionAmtInCoCodeCrcy) as abap.curr(23,2)) as TotDeductionAmtInCoCodeCrcy,
     cast ( sum(_PaymentProposalItem.NetAmountInTransacCurrency) as abap.curr(23,2)) as NetAmountInTransacCurrency,
     cast ( sum(_PaymentProposalItem.NetAmountInCoCodeCurrency) as abap.curr(23,2)) as NetAmountInCoCodeCurrency,
//     sum(_PaymentProposalItem.AccountingDocumentItem ) as ItemIncluded,

    _PaymentProposalItem.FiscalYear,
    
    _PaymentProposalItem
}
group by laufd,
         laufi,
         xvorl,
         zbukr,
         lifnr,
         kunnr,
         empfg,
         vblnr,
         waers,
         _PaymentProposalItem.FiscalYear
