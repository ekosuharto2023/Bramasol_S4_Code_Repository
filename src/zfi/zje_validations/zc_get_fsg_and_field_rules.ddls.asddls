@AbapCatalog.sqlViewName: 'ZVRULE'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get Field Rules for FSG using CompCode and GL'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_GET_FSG_AND_FIELD_RULES
  with parameters
    p_bukrs : bukrs,
    p_saknr : saknr
as select from skb1 as a
  inner join zfi_field_rules as b
    on a.fstag = b.fsg_code
{
    key a.bukrs,
    key a.saknr,
    a.fstag,
    b.field_name,
    b.required,
    b.lookup_validated
}
where a.bukrs = $parameters.p_bukrs
  and a.saknr = $parameters.p_saknr
