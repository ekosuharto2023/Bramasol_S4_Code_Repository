@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_513226D2DB8B'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_QNE3TQ5ZOJHJE4WYML4ZZ2PNZE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_ASC
}
