@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_C8B70E32199B'

extend view I_ACTUALPLANSTATKEYFIGSEMTAG with ZZ1_RRRXSJ23XQ2IHQJEIITXAV5WGE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when P_ACTPLNSTATKEYFIGITEMSEMTAG.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_ASF
}
