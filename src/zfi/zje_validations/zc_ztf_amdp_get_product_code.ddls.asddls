@AbapCatalog.sqlViewName: 'ZVPRDCD'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wrapper CDS for ZTF_AMDP_GET_PRODUCT_CODE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.representativeKey: 'Product_Code'
define view ZC_ZTF_AMDP_GET_PRODUCT_CODE
  as select from ZTF_AMDP_GET_PRODUCT_CODE
{
  PRODUCT_CODE as zz1_productcode_cob
}
