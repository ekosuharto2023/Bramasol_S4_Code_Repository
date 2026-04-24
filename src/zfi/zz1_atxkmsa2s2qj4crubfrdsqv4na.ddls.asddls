@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_9D32101413F4'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_ATXKMSA2S2QJ4CRUBFRDSQV4NA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_APC
}
