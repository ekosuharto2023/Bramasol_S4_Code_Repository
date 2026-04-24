@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_027C99F216C3'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_T63W2YQ4HFDXWWONBL5NVMFNLU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_ASF
}
