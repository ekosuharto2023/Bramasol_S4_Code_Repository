@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Payment Run Mapping'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true

define root view entity ZI_FI_INV_PYMT_RUN
  as select from zfi_inv_pymt_run

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

      @UI.identification: [ { position: 20, label: 'Payment Run ID' } ]
      @UI.lineItem: [ { position: 20, label: 'Payment Run ID' } ]
  key payment_run_id,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_PaymentMethodInCountryVH', element: 'PaymentMethod' } } ]
      @Search.defaultSearchElement: true
      @UI.identification: [ { position: 30, label: 'Payment Method' } ]
      @UI.lineItem: [ { position: 30, label: 'Payment Method' } ]
  key payment_method,

      @UI.identification: [ { position: 40, label: 'Invoice Category' } ]
      @UI.lineItem: [ { position: 40, label: 'Invoice Category' } ]
  key cast(lpad(invoice_category, 3, '0') as abap.char(3)) as InvoiceCategory,

      @UI.identification: [ { position: 50, label: 'Description' } ]
      @UI.lineItem: [ { position: 50, label: 'Description' } ]
      description
}
