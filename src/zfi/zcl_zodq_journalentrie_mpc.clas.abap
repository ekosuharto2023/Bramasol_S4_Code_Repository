class ZCL_ZODQ_JOURNALENTRIE_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
    begin of CHANGETRACKINGDETAILS,
        SUBSCRIPTION_BOOL_FLAG type FLAG,
    end of CHANGETRACKINGDETAILS .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol .
  types:
    begin of SUBSCRIPTIONTERMINATIONDETAILS,
        RESULT_BOOL_FLAG type FLAG,
    end of SUBSCRIPTIONTERMINATIONDETAILS .
  types:
  begin of TS_DELTALINKSOFFACTSOFIFIGLACC,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFFACTSOFIFIGLACC .
  types:
TT_DELTALINKSOFFACTSOFIFIGLACC type standard table of TS_DELTALINKSOFFACTSOFIFIGLACC .
  types:
      begin of TS_FACTSOFIFIGLACCTLIR,
     SOURCELEDGER type C length 2,
     COMPANYCODE type C length 4,
     FISCALYEAR type C length 4,
     ACCOUNTINGDOCUMENT type C length 10,
     LEDGERGLLINEITEM type C length 6,
     LEDGERFISCALYEAR type C length 4,
     GLRECORDTYPE type C length 1,
     JRNLENTRALTVFYCONSECUTIVEID type C length 10,
     CHARTOFACCOUNTS type C length 4,
     CONTROLLINGAREA type C length 4,
     FINANCIALTRANSACTIONTYPE type C length 3,
     GLBUSINESSTRANSACTIONTYPE type C length 4,
     BUSINESSTRANSACTIONCATEGORY type C length 4,
     BUSINESSTRANSACTIONTYPE type C length 4,
     FINANCIALCLOSINGSTEP type C length 3,
     CONTROLLINGBUSTRANSACTYPE type C length 4,
     REFERENCEDOCUMENTTYPE type C length 5,
     LOGICALSYSTEM type C length 10,
     REFERENCEDOCUMENTCONTEXT type C length 10,
     REFERENCEDOCUMENT type C length 10,
     REFERENCEDOCUMENTITEM type C length 6,
     REFERENCEDOCUMENTITEMGROUP type C length 6,
     TRANSACTIONSUBITEM type C length 6,
     ACCOUNTINGNOTIFICATIONUUID type string,
     ISREVERSAL type C length 1,
     ISREVERSED type C length 1,
     REVERSALREFERENCEDOCUMENTTYPE type C length 5,
     REVERSALREFERENCEDOCUMENTCNTXT type C length 10,
     REVERSALREFERENCEDOCUMENT type C length 10,
     REVERSALTRANSACTIONSUBITEM type C length 6,
     ISSETTLEMENT type C length 1,
     ISSETTLED type C length 1,
     PREDECESSORREFERENCEDOCTYPE type C length 5,
     PREDECESSORREFERENCEDOCCNTXT type C length 10,
     PREDECESSORREFERENCEDOCUMENT type C length 10,
     PREDECESSORREFERENCEDOCITEM type C length 6,
     PRDCSSRJOURNALENTRYCOMPANYCODE type C length 4,
     PRDCSSRJOURNALENTRYFISCALYEAR type C length 4,
     PREDECESSORJOURNALENTRY type C length 10,
     PREDECESSORJOURNALENTRYITEM type C length 6,
     SOURCEREFERENCEDOCUMENTTYPE type C length 5,
     SOURCELOGICALSYSTEM type C length 10,
     SOURCEREFERENCEDOCUMENTCNTXT type C length 10,
     SOURCEREFERENCEDOCUMENT type C length 10,
     SOURCEREFERENCEDOCUMENTITEM type C length 6,
     SOURCEREFERENCEDOCSUBITEM type C length 6,
     ISCOMMITMENT type C length 1,
     JRNLENTRYITEMOBSOLETEREASON type C length 1,
     JOURNALENTRYISSECONDARYENTRY type C length 1,
     JRNLPERIODENDCLOSINGRUNLOGUUID type string,
     ORGANIZATIONALCHANGE type C length 10,
     GLACCOUNT type C length 10,
     COSTCENTER type C length 10,
     PROFITCENTER type C length 10,
     FUNCTIONALAREA type C length 16,
     BUSINESSAREA type C length 4,
     SEGMENT type C length 10,
     PARTNERCOSTCENTER type C length 10,
     PARTNERPROFITCENTER type C length 10,
     PARTNERFUNCTIONALAREA type C length 16,
     PARTNERBUSINESSAREA type C length 4,
     PARTNERCOMPANY type C length 6,
     PARTNERSEGMENT type C length 10,
     BALANCETRANSACTIONCURRENCY type C length 5,
     AMOUNTINBALANCETRANSACCRCY type DECFLOAT34,
     TRANSACTIONCURRENCY type C length 5,
     AMOUNTINTRANSACTIONCURRENCY type DECFLOAT34,
     COMPANYCODECURRENCY type C length 5,
     AMOUNTINCOMPANYCODECURRENCY type DECFLOAT34,
     GLOBALCURRENCY type C length 5,
     AMOUNTINGLOBALCURRENCY type DECFLOAT34,
     FUNCTIONALCURRENCY type C length 5,
     AMOUNTINFUNCTIONALCURRENCY type DECFLOAT34,
     FREEDEFINEDCURRENCY1 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY1 type DECFLOAT34,
     FREEDEFINEDCURRENCY2 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY2 type DECFLOAT34,
     FREEDEFINEDCURRENCY3 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY3 type DECFLOAT34,
     FREEDEFINEDCURRENCY4 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY4 type DECFLOAT34,
     FREEDEFINEDCURRENCY5 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY5 type DECFLOAT34,
     FREEDEFINEDCURRENCY6 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY6 type DECFLOAT34,
     FREEDEFINEDCURRENCY7 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY7 type DECFLOAT34,
     FREEDEFINEDCURRENCY8 type C length 5,
     AMOUNTINFREEDEFINEDCURRENCY8 type DECFLOAT34,
     FIXEDAMOUNTINGLOBALCRCY type DECFLOAT34,
     GRPVALNFIXEDAMTINGLOBCRCY type DECFLOAT34,
     PRFTCTRVALNFXDAMTINGLOBCRCY type DECFLOAT34,
     FIXEDAMOUNTINCOCODECRCY type DECFLOAT34,
     FIXEDAMOUNTINTRANSCRCY type DECFLOAT34,
     TOTALPRICEVARCINGLOBALCRCY type DECFLOAT34,
     GRPVALNTOTPRCVARCINGLOBCRCY type DECFLOAT34,
     PRFTCTRVALNTOTPRCVARCINGLBCRCY type DECFLOAT34,
     FIXEDPRICEVARCINGLOBALCRCY type DECFLOAT34,
     GRPVALNFIXEDPRCVARCINGLOBCRCY type DECFLOAT34,
     PRFTCTRVALNFXDPRCVARCINGLBCRCY type DECFLOAT34,
     CONTROLLINGOBJECTCURRENCY type C length 5,
     AMOUNTINOBJECTCURRENCY type DECFLOAT34,
     GRANTCURRENCY type C length 5,
     AMOUNTINGRANTCURRENCY type DECFLOAT34,
     BASEUNIT type C length 3,
     QUANTITY type DECFLOAT34,
     FIXEDQUANTITY type DECFLOAT34,
     COSTSOURCEUNIT type C length 3,
     VALUATIONQUANTITY type DECFLOAT34,
     VALUATIONFIXEDQUANTITY type DECFLOAT34,
     REFERENCEQUANTITYUNIT type C length 3,
     REFERENCEQUANTITY type DECFLOAT34,
     ADDITIONALQUANTITY1UNIT type C length 3,
     ADDITIONALQUANTITY1 type DECFLOAT34,
     ADDITIONALQUANTITY2UNIT type C length 3,
     ADDITIONALQUANTITY2 type DECFLOAT34,
     ADDITIONALQUANTITY3UNIT type C length 3,
     ADDITIONALQUANTITY3 type DECFLOAT34,
     INCMPLTSUMMABLEVALNQTYUNT type C length 3,
     INCMPLTSUMMABLEVALNQTY type DECFLOAT34,
     INCMPLTSUMMABLEVALNFXDQTY type DECFLOAT34,
     DEBITCREDITCODE type C length 1,
     FISCALPERIOD type C length 3,
     FISCALYEARVARIANT type C length 2,
     FISCALYEARPERIOD type C length 7,
     POSTINGDATE type TIMESTAMP,
     DOCUMENTDATE type TIMESTAMP,
     ACCOUNTINGDOCUMENTTYPE type C length 2,
     ACCOUNTINGDOCUMENTITEM type C length 3,
     ASSIGNMENTREFERENCE type C length 18,
     ACCOUNTINGDOCUMENTCATEGORY type C length 1,
     JOURNALENTRYITEMCATEGORY type C length 5,
     POSTINGKEY type C length 2,
     TRANSACTIONTYPEDETERMINATION type C length 3,
     SUBLEDGERACCTLINEITEMTYPE type C length 5,
     ACCOUNTINGDOCCREATEDBYUSER type C length 12,
     LASTCHANGEDATETIME type P length 15 decimals 0,
     CREATIONDATETIME type P length 15 decimals 0,
     CREATIONDATE type TIMESTAMP,
     ELIMINATIONPROFITCENTER type C length 10,
     ORIGINOBJECTTYPE type C length 2,
     GLACCOUNTTYPE type C length 1,
     ALTERNATIVEGLACCOUNT type C length 10,
     COUNTRYCHARTOFACCOUNTS type C length 4,
     ITEMISSPLIT type C length 1,
     CONSOLIDATIONUNIT type C length 18,
     PARTNERCONSOLIDATIONUNIT type C length 18,
     COMPANY type C length 6,
     CONSOLIDATIONCHARTOFACCOUNTS type C length 2,
     CNSLDTNFINANCIALSTATEMENTITEM type C length 10,
     CNSLDTNSUBITEMCATEGORY type C length 3,
     CNSLDTNSUBITEM type C length 10,
     INVOICEREFERENCE type C length 10,
     INVOICEREFERENCEFISCALYEAR type C length 4,
     FOLLOWONDOCUMENTTYPE type C length 1,
     INVOICEITEMREFERENCE type C length 3,
     REFERENCEPURCHASEORDERCATEGORY type C length 3,
     PURCHASINGDOCUMENT type C length 10,
     PURCHASINGDOCUMENTITEM type C length 5,
     ACCOUNTASSIGNMENTNUMBER type C length 2,
     DOCUMENTITEMTEXT type C length 50,
     SALESDOCUMENT type C length 10,
     SALESDOCUMENTITEM type C length 6,
     PRODUCT type C length 40,
     PLANT type C length 4,
     SUPPLIER type C length 10,
     CUSTOMER type C length 10,
     SERVICESRENDEREDDATE type TIMESTAMP,
     PERFORMANCEPERIODSTARTDATE type TIMESTAMP,
     PERFORMANCEPERIODENDDATE type TIMESTAMP,
     CONDITIONCONTRACT type C length 10,
     EXCHANGERATEDATE type TIMESTAMP,
     FINANCIALACCOUNTTYPE type C length 1,
     SPECIALGLCODE type C length 1,
     TAXCODE type C length 2,
     TAXCOUNTRY type C length 3,
     HOUSEBANK type C length 5,
     HOUSEBANKACCOUNT type C length 5,
     ISOPENITEMMANAGED type C length 1,
     CLEARINGDATE type TIMESTAMP,
     CLEARINGDOCFISCALYEAR type C length 4,
     CLEARINGACCOUNTINGDOCUMENT type C length 10,
     CLEARINGJOURNALENTRYFISCALYEAR type C length 4,
     CLEARINGJOURNALENTRY type C length 10,
     VALUEDATE type TIMESTAMP,
     GENERALLEDGERAGINGSCOPE type C length 10,
     GENERALLEDGERAGINGINCREMENT type C length 15,
     ASSETDEPRECIATIONAREA type C length 2,
     MASTERFIXEDASSET type C length 12,
     FIXEDASSET type C length 4,
     ASSETVALUEDATE type TIMESTAMP,
     ASSETTRANSACTIONTYPE type C length 3,
     ASSETACCTTRANSCLASSFCTN type C length 2,
     DEPRECIATIONFISCALPERIOD type C length 3,
     GROUPMASTERFIXEDASSET type C length 12,
     GROUPFIXEDASSET type C length 4,
     ASSETCLASS type C length 8,
     PARTNERMASTERFIXEDASSET type C length 12,
     PARTNERFIXEDASSET type C length 4,
     COSTESTIMATE type C length 12,
     INVENTORYSPECIALSTOCKVALNTYPE type C length 1,
     ISSUPPLIERSTOCKVALUATION type C length 1,
     INVENTORYSPECIALSTOCKTYPE type C length 1,
     INVENTORYSPCLSTKSALESDOCUMENT type C length 10,
     INVENTORYSPCLSTKSALESDOCITM type C length 6,
     INVTRYSPCLSTOCKWBSELMNTINTID type C length 8,
     INVENTORYSPCLSTOCKWBSELEMENT type C length 24,
     INVENTORYSPECIALSTOCKSUPPLIER type C length 10,
     INVENTORYVALUATIONTYPE type C length 10,
     VALUATIONAREA type C length 4,
     MATERIALLEDGERPROCESSTYPE type C length 4,
     MATERIALLEDGERCATEGORY type C length 2,
     SLSPRICEAMOUNTINCOCODECRCY type DECFLOAT34,
     PRODUCTPRICECONTROL type C length 1,
     SENDERCOMPANYCODE type C length 4,
     SENDERGLACCOUNT type C length 10,
     SENDERACCOUNTASSIGNMENT type C length 30,
     SENDERACCOUNTASSIGNMENTTYPE type C length 2,
     CONTROLLINGOBJECT type C length 22,
     COSTORIGINGROUP type C length 4,
     ORIGINSENDEROBJECT type C length 22,
     CONTROLLINGDEBITCREDITCODE type C length 1,
     ORIGINCTRLGDEBITCREDITCODE type C length 1,
     CONTROLLINGOBJECTDEBITTYPE type C length 1,
     QUANTITYISINCOMPLETE type C length 1,
     OFFSETTINGACCOUNT type C length 10,
     OFFSETTINGACCOUNTTYPE type C length 1,
     OFFSETTINGCHARTOFACCOUNTS type C length 4,
     LINEITEMISCOMPLETED type C length 1,
     PERSONNELNUMBER type C length 8,
     CONTROLLINGOBJECTCLASS type C length 2,
     PARTNERCOMPANYCODE type C length 4,
     PARTNERCONTROLLINGOBJECTCLASS type C length 2,
     ORIGINPROFITCENTER type C length 10,
     ORIGINORDER type C length 12,
     ORIGINCOSTCTRACTIVITYTYPE type C length 6,
     ORIGINCOSTCENTER type C length 10,
     ORIGINPRODUCT type C length 40,
     VARIANCEORIGINGLACCOUNT type C length 10,
     ACCOUNTASSIGNMENT type C length 30,
     ACCOUNTASSIGNMENTTYPE type C length 2,
     COSTCTRACTIVITYTYPE type C length 6,
     ORDERID type C length 12,
     ORDERCATEGORY type C length 2,
     WBSELEMENTINTERNALID type C length 8,
     WBSELEMENT type C length 24,
     PARTNERWBSELEMENTINTERNALID type C length 8,
     PARTNERWBSELEMENT type C length 24,
     PROJECTINTERNALID type C length 8,
     PROJECT type C length 24,
     PARTNERPROJECTINTERNALID type C length 8,
     PARTNERPROJECT type C length 24,
     OPERATINGCONCERN type C length 4,
     PROJECTNETWORK type C length 12,
     RELATEDNETWORKACTIVITY type C length 4,
     BUSINESSPROCESS type C length 12,
     COSTOBJECT type C length 12,
     BILLABLECONTROL type C length 2,
     COSTANALYSISRESOURCE type C length 10,
     CUSTOMERSERVICENOTIFICATION type C length 12,
     SERVICEDOCUMENTTYPE type C length 4,
     SERVICEDOCUMENT type C length 10,
     SERVICEDOCUMENTITEM type C length 6,
     PARTNERSERVICEDOCUMENTTYPE type C length 4,
     PARTNERSERVICEDOCUMENT type C length 10,
     PARTNERSERVICEDOCUMENTITEM type C length 6,
     SERVICECONTRACTTYPE type C length 4,
     SERVICECONTRACT type C length 10,
     SERVICECONTRACTITEM type C length 6,
     BUSINESSSOLUTIONORDER type C length 10,
     BUSINESSSOLUTIONORDERITEM type C length 6,
     PROVIDERCONTRACT type C length 20,
     PROVIDERCONTRACTITEM type C length 6,
     REVENUEACCOUNTINGCONTRACT type C length 14,
     PERFORMANCEOBLIGATION type C length 16,
     TIMESHEETOVERTIMECATEGORY type C length 4,
     PARTNERACCOUNTASSIGNMENT type C length 30,
     PARTNERACCOUNTASSIGNMENTTYPE type C length 2,
     STSTCLACCOUNTASSIGNMENTTYPE1 type C length 2,
     STSTCLACCOUNTASSIGNMENTTYPE2 type C length 2,
     STSTCLACCOUNTASSIGNMENTTYPE3 type C length 2,
     WORKPACKAGE type C length 50,
     WORKITEM type C length 10,
     PARTNERCOSTCTRACTIVITYTYPE type C length 6,
     PARTNERORDER type C length 12,
     PARTNERORDERCATEGORY type C length 2,
     PARTNERSALESDOCUMENT type C length 10,
     PARTNERSALESDOCUMENTITEM type C length 6,
     PARTNERPROJECTNETWORK type C length 12,
     PARTNERPROJECTNETWORKACTIVITY type C length 4,
     PARTNERBUSINESSPROCESS type C length 12,
     PARTNERCOSTOBJECT type C length 12,
     CONTROLLINGDOCUMENTITEM type C length 3,
     VARIANCEORIGINGROUP type C length 4,
     BILLINGDOCUMENTTYPE type C length 4,
     SALESORGANIZATION type C length 4,
     DISTRIBUTIONCHANNEL type C length 2,
     ORGANIZATIONDIVISION type C length 2,
     SOLDPRODUCT type C length 40,
     SOLDPRODUCTGROUP type C length 9,
     CUSTOMERGROUP type C length 2,
     CUSTOMERSUPPLIERCOUNTRY type C length 3,
     CUSTOMERSUPPLIERINDUSTRY type C length 4,
     SALESDISTRICT type C length 6,
     BILLTOPARTY type C length 10,
     SHIPTOPARTY type C length 10,
     CUSTOMERSUPPLIERCORPORATEGROUP type C length 10,
     CASHLEDGERCOMPANYCODE type C length 4,
     CASHLEDGERACCOUNT type C length 10,
     FINANCIALMANAGEMENTAREA type C length 4,
     COMMITMENTITEM type C length 24,
     FUNDSCENTER type C length 16,
     FUNDEDPROGRAM type C length 24,
     FUND type C length 10,
     GRANTID type C length 20,
     BUDGETPERIOD type C length 10,
     PARTNERFUND type C length 10,
     PARTNERGRANT type C length 20,
     PARTNERBUDGETPERIOD type C length 10,
     PUBSECBUDGETACCOUNT type C length 10,
     PUBSECBUDGETACCOUNTCOCODE type C length 4,
     PUBSECBUDGETCNSMPNDATE type TIMESTAMP,
     PUBSECBUDGETCNSMPNFSCLPERIOD type C length 3,
     PUBSECBUDGETCNSMPNFSCLYEAR type C length 4,
     PUBSECBUDGETISRELEVANT type C length 1,
     PUBSECBUDGETCNSMPNTYPE type C length 2,
     PUBSECBUDGETCNSMPNAMTTYPE type C length 4,
     SPONSOREDPROGRAM type C length 20,
     SPONSOREDCLASS type C length 20,
     GTEEMBUDGETVALIDITYNUMBER type C length 3,
     EARMARKEDFUNDSDOCUMENT type C length 10,
     EARMARKEDFUNDSDOCUMENTITEM type C length 3,
     FINANCIALSERVICESPRODUCTGROUP type C length 10,
     FINANCIALSERVICESBRANCH type C length 10,
     FINANCIALDATASOURCE type C length 10,
     JOINTVENTURE type C length 6,
     JOINTVENTUREEQUITYGROUP type C length 3,
     JOINTVENTURECOSTRECOVERYCODE type C length 2,
     JOINTVENTUREPARTNER type C length 10,
     JOINTVENTUREBILLINGTYPE type C length 2,
     JOINTVENTUREEQUITYTYPE type C length 3,
     JOINTVENTUREPRODUCTIONDATE type TIMESTAMP,
     JOINTVENTUREBILLINGDATE type TIMESTAMP,
     JOINTVENTUREOPERATIONALDATE type TIMESTAMP,
     CUTBACKRUN type DECFLOAT34,
     JOINTVENTUREACCOUNTINGACTIVITY type C length 2,
     PARTNERVENTURE type C length 6,
     PARTNEREQUITYGROUP type C length 3,
     SENDERCOSTRECOVERYCODE type C length 2,
     CUTBACKACCOUNT type C length 10,
     CUTBACKCOSTOBJECT type C length 22,
     REBUSINESSENTITY type C length 8,
     REALESTATEBUILDING type C length 8,
     REALESTATEPROPERTY type C length 8,
     RERENTALOBJECT type C length 8,
     REALESTATECONTRACT type C length 13,
     RESERVICECHARGEKEY type C length 4,
     RESETTLEMENTUNITID type C length 5,
     SETTLEMENTREFERENCEDATE type TIMESTAMP,
     REPARTNERBUSINESSENTITY type C length 8,
     REALESTATEPARTNERBUILDING type C length 8,
     REALESTATEPARTNERPROPERTY type C length 8,
     REPARTNERRENTALOBJECT type C length 8,
     REALESTATEPARTNERCONTRACT type C length 13,
     REPARTNERSERVICECHARGEKEY type C length 4,
     REPARTNERSETTLEMENTUNITID type C length 5,
     PARTNERSETTLEMENTREFERENCEDATE type TIMESTAMP,
     ACCRUALOBJECTTYPE type C length 4,
     ACCRUALOBJECTLOGICALSYSTEM type C length 10,
     ACCRUALOBJECT type C length 32,
     ACCRUALSUBOBJECT type C length 32,
     ACCRUALITEMTYPE type C length 11,
     ACCRUALREFERENCEOBJECT type C length 32,
     ACCRUALVALUEDATE type TIMESTAMP,
     FINANCIALVALUATIONOBJECTTYPE type C length 4,
     FINANCIALVALUATIONOBJECT type C length 32,
     FINANCIALVALUATIONSUBOBJECT type C length 32,
     NETDUEDATE type TIMESTAMP,
     CREDITRISKCLASS type C length 3,
     WORKCENTERINTERNALID type C length 8,
     ORDEROPERATION type C length 4,
     ORDERITEM type C length 4,
     PARTNERORDERITEM type C length 4,
     ORDERSUBOPERATION type C length 4,
     EQUIPMENT type C length 18,
     FUNCTIONALLOCATION type C length 30,
     ASSEMBLY type C length 40,
     MAINTENANCEACTIVITYTYPE type C length 3,
     MAINTENANCEORDERPLANNINGCODE type C length 1,
     MAINTPRIORITYTYPE type C length 2,
     MAINTPRIORITY type C length 1,
     SUPERIORORDER type C length 12,
     PRODUCTGROUP type C length 9,
     MAINTENANCEORDERISPLANNED type C length 1,
     ORIGINORDEROPERATION type C length 4,
     JRNLENTRYITEMMIGRATIONSOURCE type C length 1,
     ZZ1_ICNNO_COB type C length 10,
     ZZ1_PRICINGELEMENT_COB type C length 4,
     ZZ1_PRODUCTCODE_COB type C length 4,
     ZZ1_SERIALNO_COB type C length 30,
     ZZ1_VEHICLENO_COB type C length 12,
     ZZ1_INVOICECATEGORY_COB type C length 3,
     ZZ1_TRANSACTIONKEY_COB type C length 22,
     ZZ1_CLIENTCODE_COB type C length 5,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_FACTSOFIFIGLACCTLIR .
  types:
TT_FACTSOFIFIGLACCTLIR type standard table of TS_FACTSOFIFIGLACCTLIR .

  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFFACTSOFIFIGLACC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfFactsOfIFIGLACCTLIR' ##NO_TEXT.
  constants GC_FACTSOFIFIGLACCTLIR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FactsOfIFIGLACCTLIR' ##NO_TEXT.
  constants GC_SUBSCRIPTIONTERMINATIONDETA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SubscriptionTerminationDetails' ##NO_TEXT.

  methods GET_EXTENDED_MODEL
  final
    exporting
      !EV_EXTENDED_SERVICE type /IWBEP/MED_GRP_TECHNICAL_NAME
      !EV_EXT_SERVICE_VERSION type /IWBEP/MED_GRP_VERSION
      !EV_EXTENDED_MODEL type /IWBEP/MED_MDL_TECHNICAL_NAME
      !EV_EXT_MODEL_VERSION type /IWBEP/MED_MDL_VERSION
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZODQ_JOURNALENTRIE_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ, "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type, "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,  "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set, "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr, "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop, "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action, "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set, "#EC NEEDED
  lo_complex_prop   type ref to /iwbep/if_mgw_odata_cmplx_prop. "#EC NEEDED

* Extend the model
model->extend_model( iv_model_name = 'ZODQ_JOURNALENTRIES_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_JOURNALENTRIES_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_JOURNALENTRIES_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_JOURNALENTRIES_1_MDL'.                    "#EC NOTEXT
ev_ext_model_version = '0001'.                   "#EC NOTEXT
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  constants: lc_gen_date_time type timestamp value '20250611181335'. "#EC NOTEXT
rv_last_modified = super->get_last_modified( ).
IF rv_last_modified LT lc_gen_date_time.
  rv_last_modified = lc_gen_date_time.
ENDIF.
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,           "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,           "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,                "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set,            "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr,           "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop,             "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action,               "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.           "#EC NEEDED


DATA:
     ls_text_element TYPE ts_text_element.                   "#EC NEEDED
  endmethod.
ENDCLASS.
