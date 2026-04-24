@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_3BE5B64CB8E6'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_3Q54WS22O76V4Y6L4KIRVAA6ZQ
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_THIRDPARTYREF_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_THIRDPARTYREF_COB
  end as ZZ1_THIRDPARTYREF_ASC
}
