@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_DEAEB9C2A365'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_NZFKVL4USEUPSN5VG72JQHJE3A
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_ICNNO_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_ICNNO_COB
  end as ZZ1_ICNNO_ASC
}
