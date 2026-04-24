@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for parking log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define root view entity ZI_FI_PARKING_LOG
  as select from zfi_parklog
{
  key belnr           as AccountingDoc,
  key bukrs           as CompanyCode,
  key gjahr           as FiscalYear,
  key trans_type      as IsJeOrSupplInv,
  key transaction_key as TransactionKey,
  key msgid           as MessageId,
  key msgno           as MessageNumber,
      msgv1           as Msgv1,
      msgv2           as Msgv2,
      msgv3           as Msgv3,
      msgv4           as Msgv4,
      msg_text        as MessageText,
      erdat           as CreatedDate,
      erzet           as CreatedTime,
      ernam           as CreatedBy
}
