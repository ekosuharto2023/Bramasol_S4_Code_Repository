@EndUserText.label: 'Custom table for Default to New Payment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_PAYTERM_BC_S
  as select from I_Language
    left outer join ZFI_PAYMENT_TERM on 0 = 0
  composition [0..*] of ZI_FI_PAYMENT_TERM_BC as _ZFI_PAYMENT_TERM_BC
{
  key 1 as SingletonID,
  _ZFI_PAYMENT_TERM_BC,
  max( ZFI_PAYMENT_TERM.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
