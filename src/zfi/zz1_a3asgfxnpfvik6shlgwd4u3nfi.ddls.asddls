@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_5217347BB4D5'

extend view I_ACTLPLNLINEITEMSEMTAGGLACCT with ZZ1_A3ASGFXNPFVIK6SHLGWD4U3NFI
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when P_ActlPlnLineItemSemTagGLAcct.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_ATC
}
