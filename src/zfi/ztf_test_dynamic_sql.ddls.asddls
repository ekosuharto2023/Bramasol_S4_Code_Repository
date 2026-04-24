@ClientHandling.type: #CLIENT_INDEPENDENT
@EndUserText.label: 'Get Client Number from Virtual Table'
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
define table function ZTF_TEST_DYNAMIC_SQL
  with parameters
    p_zzclient_number : abap.char(10)
returns {
    client_id   : abap.char(10);
}
implemented by method
  zcl_test_amdp=>get_zzclient;
