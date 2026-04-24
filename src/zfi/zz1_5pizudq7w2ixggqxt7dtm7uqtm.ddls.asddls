@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_4CDC10828071'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_5PIZUDQ7W2IXGGQXT7DTM7UQTM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_ASF
}
