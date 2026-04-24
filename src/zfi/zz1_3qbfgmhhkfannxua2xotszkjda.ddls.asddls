@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_A5B1C4A8328C'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_3QBFGMHHKFANNXUA2XOTSZKJDA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_APC
}
