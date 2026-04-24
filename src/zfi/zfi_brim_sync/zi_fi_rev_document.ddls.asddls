@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Reversal Document Reference and Integration Tracking'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_FI_REV_DOCUMENT
  as select from zfi_rev_doc_ref
{
  @UI.facet: [
    {
      id: 'GeneralInfo',
      purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      label: 'General Information'
    }
  ]

      @UI.lineItem:        [{ position: 10 }]
      @UI.identification:  [{ position: 10 }]
  key bukrs                      as Bukrs,

      @UI.lineItem:        [{ position: 20 }]
      @UI.identification:  [{ position: 20 }]
  key belnr                      as Belnr,

      @UI.lineItem:        [{ position: 30 }]
      @UI.identification:  [{ position: 30 }]
  key gjahr                      as Gjahr,

      @UI.lineItem:        [{ position: 35 }]
      @UI.identification:  [{ position: 35 }]
  key docln                      as Docln,

      @UI.lineItem:        [{ position: 40 }]
      @UI.identification:  [{ position: 40 }]
      blart                      as Blart,

      @UI.lineItem:        [{ position: 50 }]
      @UI.identification:  [{ position: 50 }]
      zz1_transactionkey_cob     as Zz1TransactionkeyCob,

      @UI.lineItem:        [{ position: 60 }]
      @UI.identification:  [{ position: 60 }]
      zz1_clientcode_cob         as Zz1ClientcodeCob,

      @UI.lineItem:        [{ position: 70 }]
      @UI.identification:  [{ position: 70 }]
      zz1_vehicleno_cob          as Zz1VehiclenoCob,

      @UI.lineItem:        [{ position: 80 }]
      @UI.identification:  [{ position: 80 }]
      zz1_invoicenumber_cob      as Zz1InvoicenumberCob,

      @UI.lineItem:        [{ position: 90 }]
      @UI.identification:  [{ position: 90 }]
      lifnr                      as Lifnr,

      @UI.lineItem:        [{ position: 100 }]
      @UI.identification:  [{ position: 100 }]
      waers                      as Waers,

      @UI.lineItem:        [{ position: 110 }]
      @UI.identification:  [{ position: 110 }]
      @Semantics.amount.currencyCode: 'Waers'
      wrbtr                      as Wrbtr,

      @UI.lineItem:        [{ position: 120 }]
      @UI.identification:  [{ position: 120 }]
      augbl                      as Augbl,

      @UI.lineItem:        [{ position: 130 }]
      @UI.identification:  [{ position: 130 }]
      augdt                      as Augdt,
      
      @UI.lineItem:        [{ position: 135 }]
      @UI.identification:  [{ position: 135 }]
      @EndUserText.label: 'Document Type'
      doc_type as doc_type,

      @UI.lineItem:        [{ position: 140 }]
      @UI.identification:  [{ position: 140 }]
      @EndUserText.label: 'Processing Status'
      status as Status,

      @UI.lineItem:        [{ position: 150 }]
      @UI.identification:  [{ position: 150 }]
      @EndUserText.label: 'Manual Correction Message'
      manually_corrected_message as ManuallyCorrectedMessage,

      @UI.lineItem:        [{ position: 160 }]
      @UI.identification:  [{ position: 160 }]
      @EndUserText.label: 'BRIM Error Message'
      brim_error_message as BrimErrorMessage,

      @UI.lineItem:        [{ position: 170 }]
      @UI.identification:  [{ position: 170 }]
      sent_to_brim_ts            as SentToBrimTs,

      @UI.lineItem:        [{ position: 180 }]
      @UI.identification:  [{ position: 180 }]
      last_status_update_ts      as LastStatusUpdateTs,

      @UI.lineItem:        [{ position: 190 }]
      @UI.identification:  [{ position: 190 }]
      created_ts                 as CreatedTs
}
