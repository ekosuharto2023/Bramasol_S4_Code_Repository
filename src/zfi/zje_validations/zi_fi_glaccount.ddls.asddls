@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for GLAccount'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZI_FI_GLACCOUNT as select from zfi_glaccount
{
    key infinium_gl as InfiniumGl,
    key sap_gl as SapGl

}
