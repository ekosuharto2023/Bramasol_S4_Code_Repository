@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_5CDAA91F11C3'

extend view V_FGL_BCF_BS_EXT with ZZ1_4UVOVOG62UY7DSXBZ4LIQAMJIY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_BCC
}
