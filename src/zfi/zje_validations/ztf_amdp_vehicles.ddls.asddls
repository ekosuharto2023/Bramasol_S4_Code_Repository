@ClientHandling.type: #CLIENT_INDEPENDENT
@EndUserText.label: 'Get External Vehicle Data'
define table function ZTF_AMDP_VEHICLES
with parameters
    p_client: zz1_clientcode,
    p_vehicle: zz1_vehicleno,
    p_serial: zz1_serialno,
    p_icnno: zz1_icnno
returns {
  zz1_clientcode : zz1_clientcode;
  zz1_vehicleno : zz1_vehicleno;
  zz1_serialno : zz1_serialno;
  zz1_icnno : zz1_icnno; 
}
implemented by method zcl_amdp_vehicles=>get_vehicles;
