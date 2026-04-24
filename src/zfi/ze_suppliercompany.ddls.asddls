@AbapCatalog.sqlViewAppendName: 'ZESUPPCOMPNY'
@EndUserText.label: 'Extenstion for XML Output Field in Supplier Company'
extend view I_SupplierCompany with ZE_SupplierCompany
{
    lfb1.avsnd as IsSendPaymentAdviceByXML
}
