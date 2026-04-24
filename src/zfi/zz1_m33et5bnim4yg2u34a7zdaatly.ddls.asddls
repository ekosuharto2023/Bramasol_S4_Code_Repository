@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_CEF53031CD7C'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_M33ET5BNIM4YG2U34A7ZDAATLY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_APC
}
