@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_728F5519358B'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_6WQ3YYEENGSKQOS4WHRCHBWTEU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_APC
}
