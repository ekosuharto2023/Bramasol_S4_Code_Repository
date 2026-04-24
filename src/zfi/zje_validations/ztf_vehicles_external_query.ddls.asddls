@ClientHandling.type: #CLIENT_INDEPENDENT
@EndUserText.label: 'Table function to return external data'
define table function ZTF_VEHICLES_EXTERNAL_QUERY
returns {

  zz1_clientcode : zz1_clientcode;
  zz1_vehicleno : zz1_vehicleno;
  zz1_serialno : zz1_serialno;
  zz1_icnno : zz1_icnno;
  
}
implemented by method zcl_vehicles_external_query=>get_vehicles;

