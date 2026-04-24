@EndUserText.label: 'Maintain Custom table for Default to New'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_PAYTERM_BC_S
  provider contract transactional_query
  as projection on ZI_PAYTERM_BC_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _ZFI_PAYMENT_TERM_BC : redirected to composition child ZC_FI_PAYMENT_TERM_BC
  
}
