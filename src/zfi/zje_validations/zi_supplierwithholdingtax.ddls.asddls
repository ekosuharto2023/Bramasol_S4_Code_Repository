@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wrapper for I_SupplierWithHoldingTax'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true

define view entity ZI_SupplierWithHoldingTax
  as select from I_SupplierWithHoldingTax

{
  key Supplier,
  key CompanyCode,
  key WithholdingTaxType,

      WithholdingTaxCode,
      IsWithholdingTaxSubject,

      /* Associations */
      _CompanyCode,
      _Supplier,
      _SupplierCompany
}
