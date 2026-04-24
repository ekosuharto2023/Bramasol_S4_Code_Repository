@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Account Payable Payment Limit for NACHA'

@Metadata.allowExtensions: true

define root view entity ZI_APPAYLIMIT
  as select from ztb_appaylimit

{
      @UI.facet: [ { id: 'GeneralInfo',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'General Information' } ]
      @UI.identification: [ { position: 10, label: 'Company Code' } ]
      @UI.lineItem: [ { position: 10, label: 'Company Code' } ]
  key bukrs           as CompanyCode,

      @UI.identification: [ { position: 20, label: 'Payment Method' } ]
      @UI.lineItem: [ { position: 20, label: 'Payment Method' } ]
  key zlsch           as PaymentMethod,

      @UI.identification: [ { position: 30, label: 'Invoice Limit' } ]
      @UI.lineItem: [ { position: 30, label: 'Invoice Limit' } ]
      invoice_limit   as InvoiceLimit,

      @UI.lineItem: [ { position: 50, label: 'Created By' } ]
      created_by      as CreatedBy,

      @UI.lineItem: [ { position: 40, label: 'Created On' } ]
      created_on      as CreationDate,

      @UI.lineItem: [ { position: 70, label: 'Changed By' } ]
      last_changed_by as LastChangedBy,

      @UI.lineItem: [ { position: 60, label: 'Changed On' } ]
      last_changed_on as LastChangedDate
}
