@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_1F5BB272555F'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_5NPJC6BELR6GVAA6OEBYQ35DCQ
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_APC
}
