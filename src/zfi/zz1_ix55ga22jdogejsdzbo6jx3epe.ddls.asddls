@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_7D4691399215'

extend view V_FGL_BCF_PL_EXT with ZZ1_IX55GA22JDOGEJSDZBO6JX3EPE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when BCF.unionCode = '1'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when BCF.unionCode = '2'
      then  _Extension_acdoctemp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_PCC
}
