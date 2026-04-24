@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_D648B1202D7D'

extend view I_ACTUALPLANJRNLENTRYITEMCUBE with ZZ1_FFCAB7QZ4V7LDN4PGSMIDPIGKE
  
{ 
@AbapCatalog.compiler.caseJoin
  case
    when APJEI.ActualPlanCode = 'A'
      then  _Extension_acdoca.ZZ1_INVOICENUMBER_COB
    when APJEI.ActualPlanCode = 'P'
      then  _Extension_acdocp.ZZ1_INVOICENUMBER_COB
  end as ZZ1_InvoiceNumber_APC
}
