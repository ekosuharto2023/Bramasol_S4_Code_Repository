@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_08FCAED942B7'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_LS34K6EMC4R7ZXXUZ2QHPN5VKU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_APC
}
