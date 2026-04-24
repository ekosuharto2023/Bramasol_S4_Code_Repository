@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_6D8DF576E887'

extend view V_FGL_BCF_BS_EXT with ZZ1_PVB6UHGA7YKTI3F5FB4QL6TT24
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_BCC
}
