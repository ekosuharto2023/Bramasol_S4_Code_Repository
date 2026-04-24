@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_102B5F1B8697'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_HB2RUTXKTIOBJ4V4NQGTISVX5E
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_ASF
}
