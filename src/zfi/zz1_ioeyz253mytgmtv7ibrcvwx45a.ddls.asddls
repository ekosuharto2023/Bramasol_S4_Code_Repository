@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_4F353EBCFB04'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_IOEYZ253MYTGMTV7IBRCVWX45A
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_APC
}
