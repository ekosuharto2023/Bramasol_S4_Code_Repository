@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_5EA7A7DCE9E3'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_LB3FLD73YTDLZHKYCIT4A3LPBM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SERIALNO_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SERIALNO_COB
  end as ZZ1_SERIALNO_ASC
}
