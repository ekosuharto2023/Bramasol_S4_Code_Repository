  @AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Payment term'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZI_FI_PAYMENT_TERM as select from zfi_payment_term
{
    key country as Country,
    key default_terms_code as DefaultTermsCode,
    key new_term as NewTerm
}
