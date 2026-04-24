@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_D103820177BE'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_CWWAAL57AJO3W2G6ZC6JSFHK6A
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRODUCTCODE_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRODUCTCODE_COB
  end as ZZ1_PRODUCTCODE_ASC
}
