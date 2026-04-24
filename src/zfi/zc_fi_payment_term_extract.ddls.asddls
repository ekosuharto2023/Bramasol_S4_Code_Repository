@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@EndUserText.label: 'CDS view for Payment term (CDC)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@Analytics: {
  dataCategory: #DIMENSION,
  dataExtraction: {
    enabled: true,
    delta.changeDataCapture: {
      mapping: [
        {
          table: 'ZFI_PAYMENT_TERM',
          role: #MAIN,
          viewElement: [ 'Country', 'DefaultTermsCode', 'NewTerm' ],
          tableElement: [ 'COUNTRY', 'DEFAULT_TERMS_CODE', 'NEW_TERM' ]
        }
      ]
    }
  }
}
define view entity ZC_FI_PAYMENT_TERM_EXTRACT   as select from zfi_payment_term
{
  key country            as Country,
  key default_terms_code as DefaultTermsCode,
  key new_term           as NewTerm
  }
