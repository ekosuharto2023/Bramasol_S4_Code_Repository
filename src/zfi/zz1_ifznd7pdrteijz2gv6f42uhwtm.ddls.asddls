@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_44A6C0204C07'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_IFZND7PDRTEIJZ2GV6F42UHWTM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_APC
}
