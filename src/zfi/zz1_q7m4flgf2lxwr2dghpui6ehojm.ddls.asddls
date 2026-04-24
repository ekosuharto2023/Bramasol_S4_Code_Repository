@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_E7A1C481FE3A'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_Q7M4FLGF2LXWR2DGHPUI6EHOJM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_PRICINGELEMENT_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_PRICINGELEMENT_COB
  end as ZZ1_PRICINGELEMENT_ASF
}
