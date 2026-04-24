@AbapCatalog.sqlViewName: 'ZCTRANTYPEVH'
@EndUserText.label: 'Value Help for FI Transaction Type'
@ObjectModel.representativeKey: 'TransType'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_INDEPENDENT          // 👈 disables client repetition
define view ZC_TransType_VH
  as
  select from t000 {
    key cast( 'BK' as abap.char(2) ) as TransType,
        cast( 'Journal Entry (BKPF)' as abap.char(40) ) as TransTypeText
  }
  where mandt = '000'                 // 👈 limits to one client

  union all

  select from t000 {
    key cast( 'RB' as abap.char(2) ) as TransType,
        cast( 'Supplier Invoice (RBKP)' as abap.char(40) ) as TransTypeText
  }
  where mandt = '000';                // 👈 same here
