@ClientHandling.type: #CLIENT_INDEPENDENT
@EndUserText.label: 'Get Pricing Element from Virtual Table'
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
define table function ZTF_AMDP_GET_PRICING_ELEMENT
returns {
    PRICING_ELEMENT_CODE   : zz1_pricingelement;
}
implemented by method
  zcl_amdp_get_pricing_element=>get_pricing_element;
