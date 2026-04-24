@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extraction CDS for table ZFI_GLACCOUNT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Analytics: {
  dataCategory: #DIMENSION,
  dataExtraction: {
    enabled: true,
    delta.changeDataCapture: {
      mapping: [
        {
          table: 'ZFI_GLACCOUNT',
          role: #MAIN,
          viewElement: [ 'InfiniumGl', 'SapGl' ],
          tableElement: [ 'INFINIUM_GL', 'SAP_GL' ]   // <-- adjust to your actual column names
        } ]
        }
        }
        }

define view entity ZC_FI_GLACCOUNT_EXTRACT 
  as select from zfi_glaccount
{
  key infinium_gl as InfiniumGl,
  key sap_gl      as SapGl
}
