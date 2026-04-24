@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_766A0651C879'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_T254GEDYJP7AZ7Y4WAZBNXJ2LU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_APC
}
