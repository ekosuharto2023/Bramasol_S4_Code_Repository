@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_49805AE74BCF'

extend view I_ACTUALPLANLINEITEMSEMTAG with ZZ1_QXSHPZRLPMDCKNR2MC2MUQI3HM
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when P_Actualplanlineitemsemtag.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_ASC
}
