@EndUserText.label: 'Supplier Invoice Header by Reversal Document'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity ZI_RBKP_BY_STBLG
//  with parameters
//    p_stblg : belnr_d
as select from rbkp
{
  /* 🔑 Primary key */
  key belnr,        // Invoice Document
  key gjahr,        // Fiscal Year

  /* Commonly required fields */
  bukrs,            // Company Code
  lifnr,            // Supplier
  blart,            // Document Type
  budat,            // Posting Date
  bldat,            // Document Date
  
  /* Reversal references */
  stblg,            // Reversal Document
  stjah             // Reversal Fiscal Year
}
//where stblg = $parameters.p_stblg;
