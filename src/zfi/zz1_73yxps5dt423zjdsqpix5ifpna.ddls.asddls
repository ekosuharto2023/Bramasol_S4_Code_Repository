@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_B5ED7CD1204E'

extend view V_FGL_BCF_PL_EXT with ZZ1_73YXPS5DT423ZJDSQPIX5IFPNA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_TRANSACTIONKEY_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_TRANSACTIONKEY_COB
  end as ZZ1_TRANSACTIONKEY_PCC
}
