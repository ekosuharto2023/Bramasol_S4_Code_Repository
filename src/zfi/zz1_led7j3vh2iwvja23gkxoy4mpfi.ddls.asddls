@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_9822F89F957C'

extend view V_FGL_BCF_BS_EXT with ZZ1_LED7J3VH2IWVJA23GKXOY4MPFI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_BCC
}
