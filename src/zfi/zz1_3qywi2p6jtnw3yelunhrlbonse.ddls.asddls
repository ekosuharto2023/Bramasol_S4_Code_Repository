@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_12D949735D03'

extend view V_FGL_BCF_BS_EXT with ZZ1_3QYWI2P6JTNW3YELUNHRLBONSE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_BCC
}
