@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for email address'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define view entity ZC_companycode as select from I_CompanyCode
{
    key CompanyCode,
    CompanyCodeName,
    CityName,
    AddressID,
    _Address._DefaultEmailAddress.EmailAddress,
    /* Associations */
    _Address,
    _CompanyCodeHierNode,
    _OrgAddressDefaultRprstn
}
