@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_198975F5E8AE'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_OHGVFWMLD2XRAJCBMOYMOVADNU
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_HOLMANPO_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_HOLMANPO_COB
  end as ZZ1_HOLMANPO_ASF
}
