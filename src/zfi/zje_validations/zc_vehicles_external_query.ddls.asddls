@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Get external vehicle data'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZC_VEHICLES_EXTERNAL_QUERY
  as select from ZTF_VEHICLES_EXTERNAL_QUERY

{
  zz1_clientcode as ZZ1_CLIENTCODE_COB,
  zz1_vehicleno  as ZZ1_VEHICLENO_COB,
  zz1_serialno   as ZZ1_SERIALNO_COB,
  zz1_icnno      as ZZ1_ICNNO_COB
}
