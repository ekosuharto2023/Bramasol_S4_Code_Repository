@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_79B866232787'

extend view V_FGL_BCF_BS_EXT with ZZ1_PHMLKH6E6YA36GHK4NYQDX6L2Y
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_BCC
}
