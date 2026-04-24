@EndUserText.label: 'Maintain Custom table for Payment Term B'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_FI_PAYMENT_TERM_BC
  as projection on ZI_FI_PAYMENT_TERM_BC
{
  key Country,
  key DefaultTermsCode,
  key NewTerm,
  @ObjectModel.text.element: [ 'ConfigurationDeprecation_Text' ]
  ConfigDeprecationCode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _ZFI_PAYTERM_BC_S : redirected to parent ZC_PAYTERM_BC_S,
  ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText.ConfignDeprecationCodeName as ConfigurationDeprecation_Text : localized
  
}
