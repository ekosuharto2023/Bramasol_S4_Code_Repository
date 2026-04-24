@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Map Cost Of Sales Rules'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZI_FI_MAP_COS_RULES 
  as select from zmap_cos_rules
{
    /* ===== Facets ===== */
    @UI.facet: [
      { id: 'GeneralInfo',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        label: 'General Information' },
      { id: 'AuditInfo',
        purpose: #STANDARD,
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'Audit',
        label: 'Audit Information' }
    ]
//    key guid as Guid,

    /* ===== Main Fields ===== */
    @UI.identification: [ { position: 10, label: 'Product Code' } ]
    @UI.lineItem:       [ { position: 10, label: 'Product Code' } ]
    @UI.selectionField: [{ position: 10 }]
    @Search.defaultSearchElement: true
//    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_ZTF_AMDP_GET_PRODUCT_CODE', element: 'PRODUCT_CODE' } }]
    key productcode as ProductCode,
    
    @UI.identification: [ { position: 20, label: 'Source G/L' } ]
    @UI.lineItem:       [ { position: 20, label: 'Source G/L' } ]
    @UI.selectionField: [{ position: 20 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountStdVH', element: 'GLAccount' } }]
    key source_gl as SourceGl,

    @UI.identification: [ { position: 30, label: 'Markup G/L' } ]
    @UI.lineItem:       [ { position: 30, label: 'Markup G/L' } ]
    @UI.selectionField: [{ position: 30 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountStdVH', element: 'GLAccount' } }]
    key markup_gl as MarkupGl,    

    @UI.identification: [ { position: 40, label: 'Sales G/L' } ]
    @UI.lineItem:       [ { position: 40, label: 'Sales G/L' } ]
    @UI.selectionField: [{ position: 40 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountStdVH', element: 'GLAccount' } }]
    key sales_gl as SalesGl,

    @UI.identification: [ { position: 50, label: 'COS G/L' } ]
    @UI.lineItem:       [ { position: 50, label: 'COS G/L' } ]
    @UI.selectionField: [{ position: 50 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountStdVH', element: 'GLAccount' } }]
    key cos_gl as CosGl,

    @UI.identification: [ { position: 60, label: 'Valid From' } ]
    @UI.lineItem:       [ { position: 60, label: 'Valid From' } ]
    @UI.selectionField: [{ position: 60 }]
    key validfrom as ValidFrom,

    @UI.identification: [ { position: 70, label: 'Valid To' } ]
    @UI.lineItem:       [ { position: 70, label: 'Valid To' } ]
    @UI.selectionField: [{ position: 70 }]
    key validto as ValidTo
}
