@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice category mapping to house bank'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
@Search.searchable: true

define root view entity ZI_FI_INV_CAT_BANK
  as select from zfi_inv_cat_bank

{
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCode', element: 'CompanyCode' } } ]
      @Search.defaultSearchElement: true
      @UI.facet: [ { id: 'GeneralInfo',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'General Information' } ]
      @UI.identification: [ { position: 10, label: 'Company Code' } ]
      @UI.lineItem: [ { position: 10, label: 'Company Code' } ]
  key company_code,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZC_INVOICE_CATEGORY', element: 'InvoiceCategory' } } ]
      @Search.defaultSearchElement: true
      @UI.identification: [ { position: 20, label: 'Invoice Category' } ]
      @UI.lineItem: [ { position: 20, label: 'Invoice Category' } ]
  key cast(lpad(invoice_category, 3, '0') as abap.char(3)) as InvoiceCategory,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_PaymentMethodInCountryVH', element: 'PaymentMethod' } } ]
      @Search.defaultSearchElement: true
      @UI.identification: [ { position: 30, label: 'Payment Method' } ]
      @UI.lineItem: [ { position: 30, label: 'Payment Method' } ]
  key payment_method,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_HouseBankVH', element: 'HouseBank' } } ]
      @Search.defaultSearchElement: true
      @UI.identification: [ { position: 40, label: 'House Bank' } ]
      @UI.lineItem: [ { position: 40, label: 'House Bank' } ]
      house_bank,

      @Search.defaultSearchElement: true
      @UI.identification: [ { position: 50, label: 'House Bank Account ID' } ]
      @UI.lineItem: [ { position: 50, label: 'House Bank Account ID' } ]
      house_bank_account
}
