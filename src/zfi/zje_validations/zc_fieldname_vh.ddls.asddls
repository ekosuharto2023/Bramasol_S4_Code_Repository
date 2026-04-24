@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for Field rules'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
    @UI: {
  headerInfo: {
    typeNamePlural: 'Field Names',
    typeName: 'Field name',
    title: { value: 'FieldName' }
  }
}
define root view entity zc_fieldname_vh as select from zfi_cob_val_tab
{

    @UI.facet: [
    {
      id:       'Overview',
      purpose:  #STANDARD,
      type:     #IDENTIFICATION_REFERENCE,
      label:    'Overview',
      position: 10
    },
    {
      id:       'Details',
      purpose:  #STANDARD,
      type:     #COLLECTION,
      label:    'Details',
      position: 20
    }
  ]

  ///////////////////////////////////////////////////////////////////////////
  // Elements with UI annotations, lineItems, identification and fieldGroups
  // NOTE: use semicolons inside annotation objects and terminate annotation
  // blocks with a semicolon.
  ///////////////////////////////////////////////////////////////////////////



  @UI: {
    lineItem:      [ { position: 10 } ],
    identification:[ { label: 'Field Name',   position: 10 } ],
    fieldGroup:    [ { label: 'Key : Field Name', qualifier: 'FN:Header', position: 10 } ]
  }
    key field_name as FieldName
}
