@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_9F3F32F5639F'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_UVNUQEYOV4ZK3IBYNUYARSO23Y
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_APC
}
