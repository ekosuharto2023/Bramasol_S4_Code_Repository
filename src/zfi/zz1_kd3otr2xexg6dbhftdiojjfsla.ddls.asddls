@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_79B3DF7ACFF5'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_KD3OTR2XEXG6DBHFTDIOJJFSLA
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_VEHICLENO_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_VEHICLENO_COB
  end as ZZ1_VEHICLENO_ASC
}
