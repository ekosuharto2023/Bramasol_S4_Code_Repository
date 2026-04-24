@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_0F84214DA4E7'

extend view V_FGL_BCF_BS_EXT with ZZ1_UA3QOBJTMENQPSNFS6DLJNHP5U
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_BCC
}
