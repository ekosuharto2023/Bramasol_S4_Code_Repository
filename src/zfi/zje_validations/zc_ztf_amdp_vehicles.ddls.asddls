@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get Vehicle Data from external system'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_ztf_amdp_vehicles 
       with parameters p_client : zz1_clientcode,
                       p_vehicle : zz1_vehicleno,
                       p_serial : zz1_serialno,
                       p_icnno : zz1_icnno
as select from ZTF_AMDP_VEHICLES( p_client: $parameters.p_client, 
                                  p_vehicle: $parameters.p_vehicle,
                                  p_serial: $parameters.p_serial,
                                  p_icnno : $parameters.p_icnno ) 
{
    zz1_clientcode as ZZ1_CLIENTCODE_COB,
    zz1_vehicleno  as ZZ1_VEHICLENO_COB,
    zz1_serialno   as ZZ1_SERIALNO_COB,
    zz1_icnno      as ZZ1_ICNNO_COB
}
