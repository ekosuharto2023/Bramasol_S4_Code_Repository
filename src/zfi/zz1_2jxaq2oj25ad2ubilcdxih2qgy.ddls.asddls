@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_E64C08779150'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_2JXAQ2OJ25AD2UBILCDXIH2QGY
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_ASC
}
