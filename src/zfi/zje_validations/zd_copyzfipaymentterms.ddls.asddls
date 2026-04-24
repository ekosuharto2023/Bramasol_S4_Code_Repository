@EndUserText.label: 'Copy Custom table for Payment Term BC'
define abstract entity ZD_CopyZfiPaymentTerms
{
  @EndUserText.label: 'New Country/Reg.'
  Country : LAND1;
  @EndUserText.label: 'New DefaultTermsCode'
  DefaultTermsCode : abap.char( 5 );
  @EndUserText.label: 'New Pyt Terms'
  NewTerm : DZTERM;
  
}
