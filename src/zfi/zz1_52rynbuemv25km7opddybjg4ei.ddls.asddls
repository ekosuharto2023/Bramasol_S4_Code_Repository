@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_1BD2694AFCA2'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_52RYNBUEMV25KM7OPDDYBJG4EI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_CLIENTCODE_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_CLIENTCODE_COB
  end as ZZ1_CLIENTCODE_ASC
}
