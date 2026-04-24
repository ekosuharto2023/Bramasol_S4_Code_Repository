@ClientHandling.type: #CLIENT_INDEPENDENT
@EndUserText.label: 'Get Product Code from Virtual Table'
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
define table function ZTF_AMDP_GET_PRODUCT_CODE
returns {
    PRODUCT_CODE   : zz1_productcode;
}
implemented by method
  zcl_amdp_get_product_code=>GET_PRODUCT_CODE;
