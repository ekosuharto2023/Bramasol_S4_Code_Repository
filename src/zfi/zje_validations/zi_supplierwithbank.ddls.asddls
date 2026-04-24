@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier with BP Bank Details'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true

define view entity ZI_SupplierWithBank
  as select from I_SupplierCompany as SC

  association [1..1] to I_Supplier            as _Supplier on _Supplier.Supplier = SC.Supplier
  association [0..*] to I_BusinessPartnerBank as _Bank     on _Bank.BusinessPartner = SC.Supplier

{
  key SC.Supplier,
  key SC.CompanyCode,

      _Supplier.SupplierName,

      // BP bank details (one supplier can have multiple)
      _Bank.BankIdentification,
      _Bank.BankCountryKey,
      _Bank.BankNumber,
      _Bank.BankAccount,
      _Bank.SWIFTCode
// _Bank.IBAN            "add if it exists in your release/view
}
