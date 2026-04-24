@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_CFC08093BC31'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_MNIMQFHMR26VOEDIKC7RDR2Y54
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_SOURCE_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_SOURCE_COB
  end as ZZ1_SOURCE_ASC
}
