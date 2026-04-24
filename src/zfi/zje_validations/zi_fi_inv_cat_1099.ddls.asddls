@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Category for 1099 code'
@Metadata.ignorePropagatedAnnotations: true
//@OData.publish: true
@Search.searchable: true
define root view entity ZI_FI_INV_CAT_1099 as select from zfi_inv_cat_1099
 
{
      @UI.facet: [ { id: 'GeneralInfo',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'General Information' } ]
      @UI.identification: [ { position: 10, label: 'Company Code' } ]
      @UI.lineItem: [ { position: 10, label: 'Company Code' } ]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCode', element: 'CompanyCode' } }]
    key company_code, 

      @UI.identification: [ { position: 20, label: 'Invoice Category' } ]
      @UI.lineItem: [ { position: 20, label: 'Invoice Category' } ]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_INVOICE_CATEGORY', element: 'InvoiceCategory' } }]
   key invoice_category,

      @UI.identification: [ { position: 30, label: 'With Holding Tax Code' } ]
      @UI.lineItem: [ { position: 30, label: 'With Holding Tax Code' } ]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_WithholdingTaxCodeVH', element: 'WithholdingTaxCode' } }]
    witholding_tax_code,

      @UI.identification: [ { position: 40, label: 'With Holding Tax Type' } ]
      @UI.lineItem: [ { position: 40, label: 'With Holding Tax Type' } ]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_WithholdingTaxCodeVH', element: 'WithholdingTaxType' } }]
    witholding_tax_type

}
