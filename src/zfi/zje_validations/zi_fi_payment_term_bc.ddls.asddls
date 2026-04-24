@EndUserText.label: 'Custom table for Payment Term BC'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_FI_PAYMENT_TERM_BC
  as select from ZFI_PAYMENT_TERM
  association to parent ZI_PAYTERM_BC_S as _ZFI_PAYTERM_BC_S on $projection.SingletonID = _ZFI_PAYTERM_BC_S.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key COUNTRY as Country,
  key DEFAULT_TERMS_CODE as DefaultTermsCode,
  key NEW_TERM as NewTerm,
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _ZFI_PAYTERM_BC_S,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
