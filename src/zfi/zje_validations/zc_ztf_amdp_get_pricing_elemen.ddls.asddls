@AbapCatalog.sqlViewName: 'ZVPRELMN'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wrapper CDS to get data from ZTF_AMDP_GET_PRICING_ELEMEN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.representativeKey: 'PRICING_ELEMEN'
define view ZC_ZTF_AMDP_GET_PRICING_ELEMEN
  as select from ZTF_AMDP_GET_PRICING_ELEMENT
{
  PRICING_ELEMENT_CODE as zz1_pricingelement_cob
}
