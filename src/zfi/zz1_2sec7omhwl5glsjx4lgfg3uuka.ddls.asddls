@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_7D8372DE657E'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_2SEC7OMHWL5GLSJX4LGFG3UUKA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_ASF
}
