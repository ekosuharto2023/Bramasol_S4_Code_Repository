@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_2ADD7E1A87F8'

extend view V_FGL_BCF_PL_EXT with ZZ1_747XVU3PQSBJNG7Z5B6FO5E7GA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_PCC
}
