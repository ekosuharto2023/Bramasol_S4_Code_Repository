class ZCL_ZMM_SUPPLIER_IN_01_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
      ACTIONRESULT type MMIV_SI_S_ACTION_RESULT .
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
      ACTIONRESULTAPPOVEREJECT type MMIV_SI_S_ACTION_RES_APPR_REJ .
  types:
      ACTIONRESULTCANCEL type MMIV_SI_S_ACTION_RESULT_CANCEL .
  types:
      ACTIONRESULTCONVERTLC type MMIV_SI_S_ACTION_RES_CONVRT_LC .
  types:
      ACTIONRESULTCREATEOTVDRAFT type MMIV_SI_S_ACTION_RES_OTV .
  types:
      ACTIONRESULTEDITCHECK type MMIV_SI_S_ACTION_RES_CHK_EDIT .
  types:
      ACTIONRESULTFEATURECHECK type MMIV_SI_S_ACTION_RES_FEAT_CHK .
  types:
      ACTIONRESULTGETCHANGESTATEID type MMIV_SI_S_ACTION_RES_CHG_ST_ID .
  types:
      ACTIONRESULTPOST type MMIV_SI_S_ACTION_RESULT_POST .
  types:
      ACTIONRESULTSAVEERRONEOUSORBAT type MMIV_SI_S_ACTION_RES_SAVEER_BA .
  types:
      ACTIONRESULTSAVEPRELIM type MMIV_SI_S_ACTION_RESULT_SAVEPR .
  types:
      ACTIONRESULTUSERDEFAULTSETTING type MMIV_SI_S_ACTION_RES_USER_VAL .
  types:
    begin of SAP__FITTOPAGE,
        ERRORRECOVERYBEHAVIOR type C length 8,
        ISENABLED type FLAG,
        MINIMUMFONTSIZE type I,
    end of SAP__FITTOPAGE .
  types:
    begin of SAP__HEADERFOOTERFIELD,
        TYPE type string,
    end of SAP__HEADERFOOTERFIELD .
  types:
    begin of TS_SIMULATE,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_SIMULATE .
  types:
    begin of TS_CANCEL,
        BUDAT type TIMESTAMP,
        ROOT_KEY type SYSUUID_X,
        STGRD type C length 2,
        STATE type C length 2,
    end of TS_CANCEL .
  types:
    begin of TS_CALCULATETAX,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_CALCULATETAX .
  types:
    begin of TS_SAVEPRELIM,
        SAVE_ACTION type C length 2,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_SAVEPRELIM .
  types:
    begin of TS_GETCHANGESTATEID,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_GETCHANGESTATEID .
  types:
    begin of TS_ASSIGNINCOMPLETEITEMS,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_ASSIGNINCOMPLETEITEMS .
  types:
    begin of TS_RELEASE,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_RELEASE .
  types:
    begin of TS_DOASSIGNMENT,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_DOASSIGNMENT .
  types:
    begin of TS_POST,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_POST .
  types:
    begin of TS_DISCARD,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_DISCARD .
  types:
    begin of TS_PROPOSETAXFROMBASE,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_PROPOSETAXFROMBASE .
  types:
    begin of TS_APPROVEORREJECTSUPPLIERVALU,
        STATE type C length 2,
        ACTION type C length 7,
        ROOT_KEY type SYSUUID_X,
    end of TS_APPROVEORREJECTSUPPLIERVALU .
  types:
    begin of TS_ISEDITALLOWED,
        GJAHR type C length 4,
        BELNR type C length 10,
    end of TS_ISEDITALLOWED .
  types:
    begin of TS_ADDTAXITEM,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_ADDTAXITEM .
  types:
    begin of TS_MAINTAINUSERSETTINGS,
        NO_POPUP type FLAG,
    end of TS_MAINTAINUSERSETTINGS .
  types:
    begin of TS_SAVEERRONEOUSORBATCH,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_SAVEERRONEOUSORBATCH .
  types:
    begin of TS_UPDATEASSIGNMENT,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_UPDATEASSIGNMENT .
  types:
    begin of TS_MASSCHANGEITEMSELECTIONS,
        SELKZ type FLAG,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_MASSCHANGEITEMSELECTIONS .
  types:
    begin of TS_MASSCHANGEACCASSIGNMENTSELE,
        SELKZ type FLAG,
        NODE_KEY type SYSUUID_X,
        STATE type C length 2,
        XUNPL type FLAG,
    end of TS_MASSCHANGEACCASSIGNMENTSELE .
  types:
    begin of TS_ADDUNPLACCASSIGNMENT,
        NODE_KEY type SYSUUID_X,
    end of TS_ADDUNPLACCASSIGNMENT .
  types:
    begin of TS_CREATEOTVDRAFT,
        BELNR type C length 10,
        GJAHR type C length 4,
    end of TS_CREATEOTVDRAFT .
  types:
    begin of TS_DELETEUNPLACCASSIGNMENT,
        NODE_KEY type SYSUUID_X,
    end of TS_DELETEUNPLACCASSIGNMENT .
  types:
    begin of TS_POSTPRELIM,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_POSTPRELIM .
  types:
    begin of TS_DELETEUNSELECTEDITEMS,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
    end of TS_DELETEUNSELECTEDITEMS .
  types:
    begin of TS_GETUSERDEFAULTSETTINGS,
        NAME type string,
    end of TS_GETUSERDEFAULTSETTINGS .
  types:
    begin of TS_MASSCHANGETAXCODES,
        CHANGE_PO_ITEMS type FLAG,
        CHANGE_GL_ITEMS type FLAG,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
        TAX_COUNTRY type C length 3,
        MWSKZ type C length 2,
        TXDAT type TIMESTAMP,
    end of TS_MASSCHANGETAXCODES .
  types:
    begin of TS_GETVALUEHELPRESULT,
        SHLPNAME type string,
        SHLPKEY type string,
        FILTERS type string,
    end of TS_GETVALUEHELPRESULT .
  types:
    begin of TS_SETUSERDEFAULTSETTINGS,
        NAME type string,
        VALUE type string,
    end of TS_SETUSERDEFAULTSETTINGS .
  types:
    begin of TS_CONVERTTOLOCALCURRENCY,
        AMOUNT type P length 2 decimals 2,
        STATE type C length 2,
        ROOT_KEY type SYSUUID_X,
        HSWAE type C length 5,
    end of TS_CONVERTTOLOCALCURRENCY .
  types:
    begin of TS_CHECKFEATURECOMPATIBILITY,
        GJAHR type C length 4,
        BELNR type C length 10,
    end of TS_CHECKFEATURECOMPATIBILITY .
  types:
    begin of TS_CONFIRM,
        GJAHR type C length 4,
        BELNR type C length 10,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_CONFIRM .
  types:
    begin of TS_CHECKSESSIONINTEGRITY,
        CHANGE_STATE_ID type C length 40,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_CHECKSESSIONINTEGRITY .
  types:
    begin of TS_DELETEINVOICE,
        ROOT_KEY type SYSUUID_X,
        STATE type C length 2,
    end of TS_DELETEINVOICE .
  types:
    begin of TS_COPYGLACCOUNTITEM,
        NODE_KEY type SYSUUID_X,
    end of TS_COPYGLACCOUNTITEM .
  types:
     TS_ACCOUNTASSIGNMENT type MMIV_SI_S_ACCOUNT_ASSIGNMENT .
  types:
TT_ACCOUNTASSIGNMENT type standard table of TS_ACCOUNTASSIGNMENT .
  types:
     TS_BILLOFLADINGREFERENCE type MMIV_SI_S_BOL_REF .
  types:
TT_BILLOFLADINGREFERENCE type standard table of TS_BILLOFLADINGREFERENCE .
  types:
     TS_BLOCKINGREASON type MMIV_SI_S_BLOCKING_REASON .
  types:
TT_BLOCKINGREASON type standard table of TS_BLOCKINGREASON .
  types:
     TS_CONSIGNMENTITEM type MMIV_SI_S_CONSIGNMENT_ITEM .
  types:
TT_CONSIGNMENTITEM type standard table of TS_CONSIGNMENTITEM .
  types:
     TS_DELIVERYNOTEREFERENCE type MMIV_SI_S_DLN_REF .
  types:
TT_DELIVERYNOTEREFERENCE type standard table of TS_DELIVERYNOTEREFERENCE .
  types:
     TS_GLACCOUNTITEM type MMIV_SI_S_GL_ACC_ITEM .
  types:
TT_GLACCOUNTITEM type standard table of TS_GLACCOUNTITEM .
  types:
     TS_HEADER type MMIV_SI_S_HEADER .
  types:
TT_HEADER type standard table of TS_HEADER .
  types:
     TS_HEADERGLOFIELD type MMIV_SI_S_GLO_HD .
  types:
TT_HEADERGLOFIELD type standard table of TS_HEADERGLOFIELD .
  types:
     TS_INCOMPLETEITEM type MMIV_SI_S_INCOMPLETE_ITEM .
  types:
TT_INCOMPLETEITEM type standard table of TS_INCOMPLETEITEM .
  types:
     TS_ITEMWITHPURCHASEORDERREFERE type MMIV_SI_S_ITEM_WITH_PO_REF .
  types:
TT_ITEMWITHPURCHASEORDERREFERE type standard table of TS_ITEMWITHPURCHASEORDERREFERE .
  types:
     TS_NOTE type MMIV_SI_S_NOTE .
  types:
TT_NOTE type standard table of TS_NOTE .
  types:
     TS_POITEMTAXCHANGE type MMIV_SI_S_PO_TAX_CHANGE .
  types:
TT_POITEMTAXCHANGE type standard table of TS_POITEMTAXCHANGE .
  types:
     TS_PURCHASEORDERHISTORYRECORD type MMIV_SI_S_PO_HISTORY .
  types:
TT_PURCHASEORDERHISTORYRECORD type standard table of TS_PURCHASEORDERHISTORYRECORD .
  types:
     TS_PURCHASEORDERITEMSEARCHRESU type MMIV_SI_S_PO_ASSIGNMENT_SEARCH .
  types:
TT_PURCHASEORDERITEMSEARCHRESU type standard table of TS_PURCHASEORDERITEMSEARCHRESU .
  types:
     TS_PURCHASEORDERREFERENCE type MMIV_SI_S_PO_REF .
  types:
TT_PURCHASEORDERREFERENCE type standard table of TS_PURCHASEORDERREFERENCE .
  types:
  begin of TS_SAP__COVERPAGE,
     TITLE type string,
     ID type SYSUUID_X,
     NAME type string,
     VALUE type string,
  end of TS_SAP__COVERPAGE .
  types:
TT_SAP__COVERPAGE type standard table of TS_SAP__COVERPAGE .
  types:
  begin of TS_SAP__DOCUMENTDESCRIPTION,
     ID type SYSUUID_X,
     CREATED_BY type string,
     CREATED_AT type TIMESTAMP,
     FILENAME type string,
     TITLE type string,
  end of TS_SAP__DOCUMENTDESCRIPTION .
  types:
TT_SAP__DOCUMENTDESCRIPTION type standard table of TS_SAP__DOCUMENTDESCRIPTION .
  types:
  begin of TS_SAP__FORMAT,
     ID type SYSUUID_X,
     FONTSIZE type I,
     ORIENTATION type C length 10,
     PAPERSIZE type C length 10,
     BORDERSIZE type I,
     MARGINSIZE type I,
     FONTNAME type C length 255,
     PADDING type I,
     FITTOPAGE type SAP__FITTOPAGE,
  end of TS_SAP__FORMAT .
  types:
TT_SAP__FORMAT type standard table of TS_SAP__FORMAT .
  types:
  begin of TS_SAP__HIERARCHY,
     ID type SYSUUID_X,
     DISTANCEFROMROOTELEMENT type string,
     DRILLSTATEELEMENT type string,
  end of TS_SAP__HIERARCHY .
  types:
TT_SAP__HIERARCHY type standard table of TS_SAP__HIERARCHY .
  types:
  begin of TS_SAP__PDFFOOTER,
     ID type SYSUUID_X,
     RIGHT type SAP__HEADERFOOTERFIELD,
     LEFT type SAP__HEADERFOOTERFIELD,
     CENTER type SAP__HEADERFOOTERFIELD,
  end of TS_SAP__PDFFOOTER .
  types:
TT_SAP__PDFFOOTER type standard table of TS_SAP__PDFFOOTER .
  types:
  begin of TS_SAP__PDFHEADER,
     ID type SYSUUID_X,
     RIGHT type SAP__HEADERFOOTERFIELD,
     LEFT type SAP__HEADERFOOTERFIELD,
     CENTER type SAP__HEADERFOOTERFIELD,
  end of TS_SAP__PDFHEADER .
  types:
TT_SAP__PDFHEADER type standard table of TS_SAP__PDFHEADER .
  types:
  begin of TS_SAP__PDFSTANDARD,
     ID type SYSUUID_X,
     USEPDFACONFORMANCEVC type C length 1,
     USEPDFACONFORMANCE type FLAG,
     DOENABLEACCESSIBILITYVC type C length 1,
     DOENABLEACCESSIBILITY type FLAG,
  end of TS_SAP__PDFSTANDARD .
  types:
TT_SAP__PDFSTANDARD type standard table of TS_SAP__PDFSTANDARD .
  types:
  begin of TS_SAP__SIGNATURE,
     ID type SYSUUID_X,
     DO_SIGN type FLAG,
     REASON type string,
  end of TS_SAP__SIGNATURE .
  types:
TT_SAP__SIGNATURE type standard table of TS_SAP__SIGNATURE .
  types:
  begin of TS_SAP__TABLECOLUMNS,
     ID type SYSUUID_X,
     NAME type string,
     HEADER type string,
     HORIZONTAL_ALIGNMENT type C length 10,
  end of TS_SAP__TABLECOLUMNS .
  types:
TT_SAP__TABLECOLUMNS type standard table of TS_SAP__TABLECOLUMNS .
  types:
  begin of TS_SAP__VALUEHELP,
     VALUEHELP type string,
     FIELD_VALUE type string,
     DESCRIPTION type string,
  end of TS_SAP__VALUEHELP .
  types:
TT_SAP__VALUEHELP type standard table of TS_SAP__VALUEHELP .
  types:
     TS_SEARCHHELPFIELD type FIN_S_SH_FIELD .
  types:
TT_SEARCHHELPFIELD type standard table of TS_SEARCHHELPFIELD .
  types:
     TS_SERVICEENTRYSHEETLEANREFERE type MMIV_SI_S_SES_LEAN_REF .
  types:
TT_SERVICEENTRYSHEETLEANREFERE type standard table of TS_SERVICEENTRYSHEETLEANREFERE .
  types:
     TS_SIMULATIONPOSTINGITEM type MMIV_SI_S_SIM_PSTNG_ITEM .
  types:
TT_SIMULATIONPOSTINGITEM type standard table of TS_SIMULATIONPOSTINGITEM .
  types:
     TS_SIMULATIONSUMMARY type MMIV_SI_S_SIM_SUMMARY .
  types:
TT_SIMULATIONSUMMARY type standard table of TS_SIMULATIONSUMMARY .
  types:
     TS_SUPPLIERCONTACTCARDDATA type MMIV_SI_S_SUPPL_CONTACT_CARD .
  types:
TT_SUPPLIERCONTACTCARDDATA type standard table of TS_SUPPLIERCONTACTCARDDATA .
  types:
     TS_TAX type MMIV_SI_S_TAX .
  types:
TT_TAX type standard table of TS_TAX .
  types:
     TS_TRANSPORTATIONMANAGEMENTREF type MMIV_SI_S_TM_REF .
  types:
TT_TRANSPORTATIONMANAGEMENTREF type standard table of TS_TRANSPORTATIONMANAGEMENTREF .
  types:
     TS_USERDRAFTINFO type MMIV_SI_S_DRAFT_INFO .
  types:
TT_USERDRAFTINFO type standard table of TS_USERDRAFTINFO .
  types:
     TS_VHBANKDETAIL type MMIV_SI_S_BANK_DETAILS .
  types:
TT_VHBANKDETAIL type standard table of TS_VHBANKDETAIL .
  types:
  begin of TS_VHGLACCOUNTFORINPUT,
     EDITLOKKT type string,
     HKONT type C length 10,
     GLACCT type C length 10,
     GLACCT_TXT20 type C length 20,
     GLACCT_TXT50 type C length 50,
     BUKRS type C length 4,
  end of TS_VHGLACCOUNTFORINPUT .
  types:
TT_VHGLACCOUNTFORINPUT type standard table of TS_VHGLACCOUNTFORINPUT .
  types:
  begin of TS_VL_CT_CBPR,
     KOKRS type C length 4,
     PRZNR type C length 12,
     DATBI type TIMESTAMP,
     KTEXT type C length 20,
  end of TS_VL_CT_CBPR .
  types:
TT_VL_CT_CBPR type standard table of TS_VL_CT_CBPR .
  types:
  begin of TS_VL_CT_T005,
     LAND1 type C length 3,
     LANDX type C length 15,
  end of TS_VL_CT_T005 .
  types:
TT_VL_CT_T005 type standard table of TS_VL_CT_T005 .
  types:
  begin of TS_VL_CT_T005S,
     LAND1 type C length 3,
     BLAND type C length 3,
     BEZEI type C length 20,
  end of TS_VL_CT_T005S .
  types:
TT_VL_CT_T005S type standard table of TS_VL_CT_T005S .
  types:
  begin of TS_VL_CT_T042F,
     UZAWE type C length 2,
     TXT30 type C length 30,
  end of TS_VL_CT_T042F .
  types:
TT_VL_CT_T042F type standard table of TS_VL_CT_T042F .
  types:
  begin of TS_VL_CT_T169COMPLAINT,
     COMPLAINT_REASON type C length 2,
     TEXT type C length 50,
  end of TS_VL_CT_T169COMPLAINT .
  types:
TT_VL_CT_T169COMPLAINT type standard table of TS_VL_CT_T169COMPLAINT .
  types:
  begin of TS_VL_FV_MMIV_SI_INVOICE_SELEC,
     DOMVALUE_L type C length 2,
     DDTEXT type C length 60,
  end of TS_VL_FV_MMIV_SI_INVOICE_SELEC .
  types:
TT_VL_FV_MMIV_SI_INVOICE_SELEC type standard table of TS_VL_FV_MMIV_SI_INVOICE_SELEC .
  types:
  begin of TS_VL_FV_MRM_REFERENZBELEGTYP,
     DOMVALUE_L type C length 1,
     DDTEXT type C length 60,
  end of TS_VL_FV_MRM_REFERENZBELEGTYP .
  types:
TT_VL_FV_MRM_REFERENZBELEGTYP type standard table of TS_VL_FV_MRM_REFERENZBELEGTYP .
  types:
  begin of TS_VL_FV_MRM_VORGANG,
     DOMVALUE_L type C length 1,
     DDTEXT type C length 60,
  end of TS_VL_FV_MRM_VORGANG .
  types:
TT_VL_FV_MRM_VORGANG type standard table of TS_VL_FV_MRM_VORGANG .
  types:
  begin of TS_VL_FV_SHKZG,
     DOMVALUE_L type C length 1,
     DDTEXT type C length 60,
  end of TS_VL_FV_SHKZG .
  types:
TT_VL_FV_SHKZG type standard table of TS_VL_FV_SHKZG .
  types:
  begin of TS_VL_FV_XRECH,
     DOMVALUE_L type C length 1,
     DDTEXT type C length 60,
  end of TS_VL_FV_XRECH .
  types:
TT_VL_FV_XRECH type standard table of TS_VL_FV_XRECH .
  types:
  begin of TS_VL_FV_ZBFIX,
     DOMVALUE_L type C length 1,
     DDTEXT type C length 60,
  end of TS_VL_FV_ZBFIX .
  types:
TT_VL_FV_ZBFIX type standard table of TS_VL_FV_ZBFIX .
  types:
  begin of TS_VL_SH_FAC_ASSET,
     KEYDATE type TIMESTAMP,
     ANLN1 type C length 12,
     ANLN2 type C length 4,
     MCOA1 type C length 50,
     ANLKL type C length 8,
     BUKRS type C length 4,
     KOSTL type C length 10,
     WERKS type C length 4,
     GSBER type C length 4,
     PRCTR type C length 10,
     ADATU type TIMESTAMP,
     BDATU type TIMESTAMP,
  end of TS_VL_SH_FAC_ASSET .
  types:
TT_VL_SH_FAC_ASSET type standard table of TS_VL_SH_FAC_ASSET .
  types:
  begin of TS_VL_SH_FAC_ASSET_TRANSACTION,
     BWASL type C length 3,
     BWATXT type C length 50,
  end of TS_VL_SH_FAC_ASSET_TRANSACTION .
  types:
TT_VL_SH_FAC_ASSET_TRANSACTION type standard table of TS_VL_SH_FAC_ASSET_TRANSACTION .
  types:
  begin of TS_VL_SH_FAC_BASE_UNIT,
     SPRAS type C length 2,
     MSEHI type C length 3,
     MSEH3 type C length 3,
     MSEHL type C length 30,
     TXDIM type C length 20,
  end of TS_VL_SH_FAC_BASE_UNIT .
  types:
TT_VL_SH_FAC_BASE_UNIT type standard table of TS_VL_SH_FAC_BASE_UNIT .
  types:
  begin of TS_VL_SH_FAC_COST_CENTER,
     KOKRS type C length 4,
     BUKRS type C length 4,
     SPRAS type C length 2,
     KEYDATE type TIMESTAMP,
     KOSTL type C length 10,
     KTEXT type C length 20,
     KOSAR type C length 1,
     VERAK type C length 20,
     VERAK_USER type C length 12,
     LTEXT type C length 40,
     DATAB type TIMESTAMP,
     DATBI type TIMESTAMP,
  end of TS_VL_SH_FAC_COST_CENTER .
  types:
TT_VL_SH_FAC_COST_CENTER type standard table of TS_VL_SH_FAC_COST_CENTER .
  types:
  begin of TS_VL_SH_FAC_COST_OBJECT,
     KOKRS type C length 4,
     SPRAS type C length 2,
     KSTRG type C length 12,
     KTEXT type C length 40,
     KTRAT type C length 4,
  end of TS_VL_SH_FAC_COST_OBJECT .
  types:
TT_VL_SH_FAC_COST_OBJECT type standard table of TS_VL_SH_FAC_COST_OBJECT .
  types:
  begin of TS_VL_SH_FAC_FIN_TRANSACTION_T,
     TRTYP type C length 3,
     TXT type C length 20,
  end of TS_VL_SH_FAC_FIN_TRANSACTION_T .
  types:
TT_VL_SH_FAC_FIN_TRANSACTION_T type standard table of TS_VL_SH_FAC_FIN_TRANSACTION_T .
  types:
  begin of TS_VL_SH_FAC_GL_ACCOUNT,
     SPRAS type C length 2,
     GLACCT type C length 10,
     GLACCT_TXT20 type C length 20,
     GLACCT_TXT50 type C length 50,
     KTOPL type C length 4,
     BUKRS type C length 4,
  end of TS_VL_SH_FAC_GL_ACCOUNT .
  types:
TT_VL_SH_FAC_GL_ACCOUNT type standard table of TS_VL_SH_FAC_GL_ACCOUNT .
  types:
  begin of TS_VL_SH_FAC_HBKID_SHLP,
     BUKRS type C length 4,
     HKONT type C length 10,
     HBKID type C length 5,
     BANKS type C length 3,
     BANKL type C length 15,
     BANKA type C length 60,
     ORT01 type C length 35,
  end of TS_VL_SH_FAC_HBKID_SHLP .
  types:
TT_VL_SH_FAC_HBKID_SHLP type standard table of TS_VL_SH_FAC_HBKID_SHLP .
  types:
  begin of TS_VL_SH_FAC_HKTID_SHLP,
     BUKRS type C length 4,
     HKONT type C length 10,
     HBKID type C length 5,
     HKTID type C length 5,
     TEXT1 type C length 50,
  end of TS_VL_SH_FAC_HKTID_SHLP .
  types:
TT_VL_SH_FAC_HKTID_SHLP type standard table of TS_VL_SH_FAC_HKTID_SHLP .
  types:
  begin of TS_VL_SH_FAC_MATERIAL,
     SPRAS type C length 2,
     BUKRS type C length 4,
     MATNR type C length 40,
     MAKTX type C length 40,
     MTART type C length 4,
     MATKL type C length 9,
     WERKS type C length 4,
  end of TS_VL_SH_FAC_MATERIAL .
  types:
TT_VL_SH_FAC_MATERIAL type standard table of TS_VL_SH_FAC_MATERIAL .
  types:
  begin of TS_VL_SH_FAC_NETWORK,
     KOKRS type C length 4,
     AUFNR type C length 12,
     KTEXT type C length 40,
     PLNNR type C length 8,
     PLNAL type C length 2,
     PRONR type C length 24,
     KDAUF type C length 10,
     KDPOS type C length 6,
  end of TS_VL_SH_FAC_NETWORK .
  types:
TT_VL_SH_FAC_NETWORK type standard table of TS_VL_SH_FAC_NETWORK .
  types:
  begin of TS_VL_SH_FAC_NETWORK_ACTIVITY,
     AUFNR type C length 12,
     VORNR type C length 4,
     LTXA1 type C length 40,
  end of TS_VL_SH_FAC_NETWORK_ACTIVITY .
  types:
TT_VL_SH_FAC_NETWORK_ACTIVITY type standard table of TS_VL_SH_FAC_NETWORK_ACTIVITY .
  types:
  begin of TS_VL_SH_FAC_ORDER,
     KOKRS type C length 4,
     AUFNR type C length 12,
     KTEXT type C length 40,
     AUART type C length 4,
  end of TS_VL_SH_FAC_ORDER .
  types:
TT_VL_SH_FAC_ORDER type standard table of TS_VL_SH_FAC_ORDER .
  types:
  begin of TS_VL_SH_FAC_PRODUCT_VH,
     PRODUCT type C length 40,
     PRODUCTEXTERNALID type C length 40,
     PRODUCTTYPE type C length 4,
     PRODUCTGROUP type C length 9,
  end of TS_VL_SH_FAC_PRODUCT_VH .
  types:
TT_VL_SH_FAC_PRODUCT_VH type standard table of TS_VL_SH_FAC_PRODUCT_VH .
  types:
  begin of TS_VL_SH_FAC_PROFIT_CENTER,
     BUKRS type C length 4,
     PRCTR type C length 10,
     KTEXT type C length 20,
     LTEXT type C length 40,
     VERAK_USER type C length 12,
     VERAK type C length 20,
     DATBI type TIMESTAMP,
     KOKRS type C length 4,
  end of TS_VL_SH_FAC_PROFIT_CENTER .
  types:
TT_VL_SH_FAC_PROFIT_CENTER type standard table of TS_VL_SH_FAC_PROFIT_CENTER .
  types:
  begin of TS_VL_SH_FAC_PS_POSID,
     POSID type C length 24,
     POST1 type C length 40,
     POSKI type C length 16,
     VERNR type C length 8,
     VERNA type C length 25,
     PBUKR type C length 4,
     PKOKR type C length 4,
     PSPID type C length 24,
  end of TS_VL_SH_FAC_PS_POSID .
  types:
TT_VL_SH_FAC_PS_POSID type standard table of TS_VL_SH_FAC_PS_POSID .
  types:
  begin of TS_VL_SH_FAC_REVERSAL_REASON,
     STGRD type C length 2,
     TXT40 type C length 40,
  end of TS_VL_SH_FAC_REVERSAL_REASON .
  types:
TT_VL_SH_FAC_REVERSAL_REASON type standard table of TS_VL_SH_FAC_REVERSAL_REASON .
  types:
  begin of TS_VL_SH_FAC_SALES_ORDER,
     VBELN type C length 10,
     AUART type C length 4,
     KUNNR type C length 10,
     VKORG type C length 4,
     VTWEG type C length 2,
     KOKRS type C length 4,
  end of TS_VL_SH_FAC_SALES_ORDER .
  types:
TT_VL_SH_FAC_SALES_ORDER type standard table of TS_VL_SH_FAC_SALES_ORDER .
  types:
  begin of TS_VL_SH_FAC_SALES_ORDER_ITEM,
     SPRAS type C length 2,
     VBELN type C length 10,
     POSNR type C length 6,
     MATNR type C length 40,
     MAKTX type C length 40,
  end of TS_VL_SH_FAC_SALES_ORDER_ITEM .
  types:
TT_VL_SH_FAC_SALES_ORDER_ITEM type standard table of TS_VL_SH_FAC_SALES_ORDER_ITEM .
  types:
  begin of TS_VL_SH_FAC_SEGMENT,
     SEGMENT type C length 10,
     NAME type C length 50,
  end of TS_VL_SH_FAC_SEGMENT .
  types:
TT_VL_SH_FAC_SEGMENT type standard table of TS_VL_SH_FAC_SEGMENT .
  types:
  begin of TS_VL_SH_FAC_SUBASSET,
     ANLN1 type C length 12,
     ANLN2 type C length 4,
     MCOA1 type C length 50,
  end of TS_VL_SH_FAC_SUBASSET .
  types:
TT_VL_SH_FAC_SUBASSET type standard table of TS_VL_SH_FAC_SUBASSET .
  types:
  begin of TS_VL_SH_FAC_TAX_JURISDICTION_,
     SPRAS type C length 2,
     TXJCD type C length 15,
     TEXT1 type C length 50,
     KALSM type C length 6,
     BUKRS type C length 4,
  end of TS_VL_SH_FAC_TAX_JURISDICTION_ .
  types:
TT_VL_SH_FAC_TAX_JURISDICTION_ type standard table of TS_VL_SH_FAC_TAX_JURISDICTION_ .
  types:
  begin of TS_VL_SH_FAC_TAX_JURISDICTION,
     TXJCD_EXT type C length 15,
     BUKRS type C length 4,
     STATE type C length 3,
     COUNTY type C length 35,
     CITY type C length 35,
     ZIPCODE type C length 10,
     STREET type C length 60,
     STREET1 type C length 40,
  end of TS_VL_SH_FAC_TAX_JURISDICTION .
  types:
TT_VL_SH_FAC_TAX_JURISDICTION type standard table of TS_VL_SH_FAC_TAX_JURISDICTION .
  types:
  begin of TS_VL_SH_FAC_WHTX_CODE,
     SPRAS type C length 2,
     WT_WITHCD type C length 2,
     TEXT40 type C length 40,
     WITHT type C length 2,
     BUKRS type C length 4,
  end of TS_VL_SH_FAC_WHTX_CODE .
  types:
TT_VL_SH_FAC_WHTX_CODE type standard table of TS_VL_SH_FAC_WHTX_CODE .
  types:
  begin of TS_VL_SH_FAP_H_HKTID,
     HKTID type C length 5,
     ZBUKR type C length 4,
     HBKID type C length 5,
     TEXT1 type C length 50,
  end of TS_VL_SH_FAP_H_HKTID .
  types:
TT_VL_SH_FAP_H_HKTID type standard table of TS_VL_SH_FAP_H_HKTID .
  types:
  begin of TS_VL_SH_FAP_T003,
     XKOAK type FLAG,
     BLART type C length 2,
     LTEXT type C length 20,
  end of TS_VL_SH_FAP_T003 .
  types:
TT_VL_SH_FAP_T003 type standard table of TS_VL_SH_FAP_T003 .
  types:
  begin of TS_VL_SH_FCO_SHLP_SRVDOC,
     GLBUSINESSTRANSACTIONTYPE type C length 4,
     SERVICEDOCUMENTTYPE type C length 4,
     SERVICEDOCUMENT type C length 10,
     SERVICEDOCUMENTDESCRIPTION type C length 40,
     SERVICEDOCITEMCATEGORY type C length 4,
     SERVICEDOCUMENTITEM type C length 6,
     SERVICEDOCUMENTITEMDESCRIPTION type C length 40,
     ORIGINALLYREQUESTEDPRODUCT type C length 54,
     POSTINGDATE type TIMESTAMP,
     PROFITCENTER type C length 10,
     COMPANYCODE type C length 4,
  end of TS_VL_SH_FCO_SHLP_SRVDOC .
  types:
TT_VL_SH_FCO_SHLP_SRVDOC type standard table of TS_VL_SH_FCO_SHLP_SRVDOC .
  types:
  begin of TS_VL_SH_FCO_SHLP_SRVDOC_ITEM,
     GLBUSINESSTRANSACTIONTYPE type C length 4,
     SERVICEDOCUMENTTYPE type C length 4,
     SERVICEDOCUMENT type C length 10,
     SERVICEDOCUMENTDESCRIPTION type C length 40,
     SERVICEDOCITEMCATEGORY type C length 4,
     SERVICEDOCUMENTITEM type C length 6,
     SERVICEDOCUMENTITEMDESCRIPTION type C length 40,
     ORIGINALLYREQUESTEDPRODUCT type C length 54,
     POSTINGDATE type TIMESTAMP,
     COMPANYCODE type C length 4,
     PROFITCENTER type C length 10,
  end of TS_VL_SH_FCO_SHLP_SRVDOC_ITEM .
  types:
TT_VL_SH_FCO_SHLP_SRVDOC_ITEM type standard table of TS_VL_SH_FCO_SHLP_SRVDOC_ITEM .
  types:
  begin of TS_VL_SH_FCO_SHLP_SRVDOC_TYPE,
     SERVICEDOCUMENTTYPENAME type C length 40,
     GLBUSINESSTRANSACTIONTYPE type C length 4,
     SERVICEDOCUMENTTYPE type C length 4,
  end of TS_VL_SH_FCO_SHLP_SRVDOC_TYPE .
  types:
TT_VL_SH_FCO_SHLP_SRVDOC_TYPE type standard table of TS_VL_SH_FCO_SHLP_SRVDOC_TYPE .
  types:
  begin of TS_VL_SH_FMBPD,
     BUDGET_PD type C length 10,
     BUDGETPDTX type C length 35,
     DATAB type TIMESTAMP,
     DATBIS type TIMESTAMP,
     DATE_EXP type TIMESTAMP,
     DATE_CAN type TIMESTAMP,
     AUTHGRP type C length 10,
     CREATED_BY type C length 12,
     CREATED_ON type TIMESTAMP,
     MODIFIED_BY type C length 12,
     MODIFIED_ON type TIMESTAMP,
  end of TS_VL_SH_FMBPD .
  types:
TT_VL_SH_FMBPD type standard table of TS_VL_SH_FMBPD .
  types:
  begin of TS_VL_SH_FMBPD_F,
     BUDGET_PD type C length 10,
     FIKRS type C length 4,
     FINCODE type C length 10,
  end of TS_VL_SH_FMBPD_F .
  types:
TT_VL_SH_FMBPD_F type standard table of TS_VL_SH_FMBPD_F .
  types:
  begin of TS_VL_SH_FM_RESERV_ES_AA,
     BUKRS type C length 4,
     CWTFREE type C length 16,
     DOMNAME type C length 30,
     BLTYP type C length 3,
     BLART type C length 2,
     EARMARKEDFUNDS type C length 10,
     EARMARKEDFUNDSITEM type C length 3,
     PTEXT type C length 50,
     WAERS type C length 5,
     SAKNR type C length 10,
     KOSTL type C length 10,
     GEBER type C length 10,
     BUDGET_PD type C length 10,
     FKBER type C length 16,
     GRANTID type C length 20,
     ERLKZ type C length 1,
     BLPKZ type C length 1,
  end of TS_VL_SH_FM_RESERV_ES_AA .
  types:
TT_VL_SH_FM_RESERV_ES_AA type standard table of TS_VL_SH_FM_RESERV_ES_AA .
  types:
  begin of TS_VL_SH_FM_RESERV_ES_HDR,
     BUKRS type C length 4,
     DOMNAME type C length 30,
     MVSTAT type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     EARMARKEDFUNDS type C length 10,
     WAERS type C length 5,
     XBLNR type C length 16,
     KTEXT type C length 50,
     KERFAS type C length 12,
     BLDAT type TIMESTAMP,
  end of TS_VL_SH_FM_RESERV_ES_HDR .
  types:
TT_VL_SH_FM_RESERV_ES_HDR type standard table of TS_VL_SH_FM_RESERV_ES_HDR .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_A,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BUKRS type C length 4,
     XBLNR type C length 16,
     KTEXT type C length 50,
     MVSTAT type C length 1,
     FMRE_XBLNR2 type C length 70,
     FMRE_XBLNR3 type C length 70,
  end of TS_VL_SH_FM_RESERV_GEN_A .
  types:
TT_VL_SH_FM_RESERV_GEN_A type standard table of TS_VL_SH_FM_RESERV_GEN_A .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_B,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     PTEXT type C length 50,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_B .
  types:
TT_VL_SH_FM_RESERV_GEN_B type standard table of TS_VL_SH_FM_RESERV_GEN_B .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_C,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     PRCTR type C length 10,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     KOKRS type C length 4,
     WAERS type C length 5,
     SAKNR type C length 10,
     KOSTL type C length 10,
     AUFNR type C length 12,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_C .
  types:
TT_VL_SH_FM_RESERV_GEN_C type standard table of TS_VL_SH_FM_RESERV_GEN_C .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_H,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     FIKRS type C length 4,
     WAERS type C length 5,
     FIPEX type C length 24,
     FISTL type C length 16,
     GEBER type C length 10,
     FKBER type C length 16,
     GRANT_NBR type C length 20,
     MEASURE type C length 24,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_H .
  types:
TT_VL_SH_FM_RESERV_GEN_H type standard table of TS_VL_SH_FM_RESERV_GEN_H .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_K,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     WAERS type C length 5,
     ERLKZ type C length 1,
     BLPKZ type C length 1,
     WKAPP type C length 1,
     STATS type C length 1,
     CARRYOV type FLAG,
     CONSUMEKZ type FLAG,
     ACCHANG type FLAG,
     ABGWAERS type FLAG,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_K .
  types:
TT_VL_SH_FM_RESERV_GEN_K type standard table of TS_VL_SH_FM_RESERV_GEN_K .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_P,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     PRCTR type C length 10,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     KOKRS type C length 4,
     WAERS type C length 5,
     SAKNR type C length 10,
     KOSTL type C length 10,
     AUFNR type C length 12,
     POSID type C length 24,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_P .
  types:
TT_VL_SH_FM_RESERV_GEN_P type standard table of TS_VL_SH_FM_RESERV_GEN_P .
  types:
  begin of TS_VL_SH_FM_RESERV_GEN_Z,
     CWTFREE type C length 16,
     DOMNAME type C length 30,
     NPRBUDGET type C length 1,
     BLTYP type C length 3,
     BLART type C length 2,
     BELNR type C length 10,
     BLPOS type C length 3,
     BUKRS type C length 4,
     WAERS type C length 5,
     KERFAS type C length 12,
     FDATK type TIMESTAMP,
     BLDAT type TIMESTAMP,
     MVSTAT type C length 1,
  end of TS_VL_SH_FM_RESERV_GEN_Z .
  types:
TT_VL_SH_FM_RESERV_GEN_Z type standard table of TS_VL_SH_FM_RESERV_GEN_Z .
  types:
  begin of TS_VL_SH_FOT_TXA_F4_FRGN_REGIS,
     LANDX type C length 15,
     COMP_CODE type C length 4,
     TAX_COUNTRY type C length 3,
  end of TS_VL_SH_FOT_TXA_F4_FRGN_REGIS .
  types:
TT_VL_SH_FOT_TXA_F4_FRGN_REGIS type standard table of TS_VL_SH_FOT_TXA_F4_FRGN_REGIS .
  types:
  begin of TS_VL_SH_FRTDOCACCR_SH,
     FREIGHTORDER type C length 20,
     CARRIER type C length 10,
     TRANSPORDDEPARTUREDATE type TIMESTAMPL,
     TRANSPORDARRIVALDATE type TIMESTAMPL,
     SOURCELOCATION type C length 20,
     DESTINATIONLOCATION type C length 20,
  end of TS_VL_SH_FRTDOCACCR_SH .
  types:
TT_VL_SH_FRTDOCACCR_SH type standard table of TS_VL_SH_FRTDOCACCR_SH .
  types:
  begin of TS_VL_SH_GLO_SH_BRNCH_ID,
     BUKRS type C length 4,
     BRANCH type C length 4,
     NAME type C length 30,
  end of TS_VL_SH_GLO_SH_BRNCH_ID .
  types:
TT_VL_SH_GLO_SH_BRNCH_ID type standard table of TS_VL_SH_GLO_SH_BRNCH_ID .
  types:
  begin of TS_VL_SH_GLO_SH_BUPLA_ID,
     BUKRS type C length 4,
     BUPLA type C length 4,
     NAME type C length 30,
  end of TS_VL_SH_GLO_SH_BUPLA_ID .
  types:
TT_VL_SH_GLO_SH_BUPLA_ID type standard table of TS_VL_SH_GLO_SH_BUPLA_ID .
  types:
  begin of TS_VL_SH_H_FAGL_SEGM,
     SEGMENT type C length 10,
     NAME type C length 50,
  end of TS_VL_SH_H_FAGL_SEGM .
  types:
TT_VL_SH_H_FAGL_SEGM type standard table of TS_VL_SH_H_FAGL_SEGM .
  types:
  begin of TS_VL_SH_H_FARP_PAYT_RSN_CD,
     DESCRIPT type C length 130,
     REC_BANK_CTRY type C length 3,
     REC_CTRY_CODE type C length 35,
     SND_BANK_CTRY type C length 3,
     SND_CTRY_CODE type C length 35,
     PAYT_RSN type C length 4,
     DTWSC type C length 5,
  end of TS_VL_SH_H_FARP_PAYT_RSN_CD .
  types:
TT_VL_SH_H_FARP_PAYT_RSN_CD type standard table of TS_VL_SH_H_FARP_PAYT_RSN_CD .
  types:
  begin of TS_VL_SH_H_FARP_PAYT_RSN_T,
     DESCRIPT type C length 130,
     PAYT_RSN type C length 4,
  end of TS_VL_SH_H_FARP_PAYT_RSN_T .
  types:
TT_VL_SH_H_FARP_PAYT_RSN_T type standard table of TS_VL_SH_H_FARP_PAYT_RSN_T .
  types:
  begin of TS_VL_SH_H_T001,
     XTEMPLT type FLAG,
     BUKRS type C length 4,
     BUTXT type C length 25,
     ORT01 type C length 25,
     WAERS type C length 5,
  end of TS_VL_SH_H_T001 .
  types:
TT_VL_SH_H_T001 type standard table of TS_VL_SH_H_T001 .
  types:
  begin of TS_VL_SH_H_T001W,
     CITY1 type C length 40,
     NAME1 type C length 40,
     SORT2 type C length 20,
     SORT1 type C length 20,
     POST_CODE1 type C length 10,
     MC_CITY1 type C length 25,
     NAME2 type C length 40,
     MC_NAME1 type C length 25,
     NATION type C length 1,
     WERKS type C length 4,
  end of TS_VL_SH_H_T001W .
  types:
TT_VL_SH_H_T001W type standard table of TS_VL_SH_H_T001W .
  types:
  begin of TS_VL_SH_H_T012,
     BANKA type C length 60,
     ORT01 type C length 35,
     NAME1 type C length 30,
     BUKRS type C length 4,
     HBKID type C length 5,
     BANKS type C length 3,
     BANKL type C length 15,
  end of TS_VL_SH_H_T012 .
  types:
TT_VL_SH_H_T012 type standard table of TS_VL_SH_H_T012 .
  types:
  begin of TS_VL_SH_H_T015L,
     LZBKZ type C length 3,
     LVAWV type C length 3,
     ZWCK1 type C length 70,
  end of TS_VL_SH_H_T015L .
  types:
TT_VL_SH_H_T015L type standard table of TS_VL_SH_H_T015L .
  types:
  begin of TS_VL_SH_H_T042Z,
     TEXT1 type C length 30,
     LAND1 type C length 3,
     ZLSCH type C length 1,
     TEXT2 type C length 30,
  end of TS_VL_SH_H_T042Z .
  types:
TT_VL_SH_H_T042Z type standard table of TS_VL_SH_H_T042Z .
  types:
  begin of TS_VL_SH_H_T161,
     BSTYP type C length 1,
     BSART type C length 4,
     BATXT type C length 20,
  end of TS_VL_SH_H_T161 .
  types:
TT_VL_SH_H_T161 type standard table of TS_VL_SH_H_T161 .
  types:
  begin of TS_VL_SH_H_T8JF,
     BUKRS type C length 4,
     VNAME type C length 6,
     EGRUP type C length 3,
     EGTXT type C length 35,
  end of TS_VL_SH_H_T8JF .
  types:
TT_VL_SH_H_T8JF type standard table of TS_VL_SH_H_T8JF .
  types:
  begin of TS_VL_SH_H_T8JJ,
     BUKRS type C length 4,
     RECID type C length 2,
     TTEXT type C length 35,
  end of TS_VL_SH_H_T8JJ .
  types:
TT_VL_SH_H_T8JJ type standard table of TS_VL_SH_H_T8JJ .
  types:
  begin of TS_VL_SH_H_T8JV,
     BUKRS type C length 4,
     VNAME type C length 6,
     VTEXT type C length 35,
  end of TS_VL_SH_H_T8JV .
  types:
TT_VL_SH_H_T8JV type standard table of TS_VL_SH_H_T8JV .
  types:
  begin of TS_VL_SH_H_TGSB,
     GSBER type C length 4,
     GTEXT type C length 30,
  end of TS_VL_SH_H_TGSB .
  types:
TT_VL_SH_H_TGSB type standard table of TS_VL_SH_H_TGSB .
  types:
  begin of TS_VL_SH_H_TKA01,
     KOKRS type C length 4,
     BEZEI type C length 25,
     WAERS type C length 5,
     KTOPL type C length 4,
     LMONA type C length 2,
     KHINR type C length 12,
  end of TS_VL_SH_H_TKA01 .
  types:
TT_VL_SH_H_TKA01 type standard table of TS_VL_SH_H_TKA01 .
  types:
  begin of TS_VL_SH_H_TTXJ,
     KALSM type C length 6,
     TXJCD type C length 15,
     TEXT1 type C length 50,
  end of TS_VL_SH_H_TTXJ .
  types:
TT_VL_SH_H_TTXJ type standard table of TS_VL_SH_H_TTXJ .
  types:
  begin of TS_VL_SH_J_1IG_HSN_SAC,
     LAND1 type C length 3,
     STEUC type C length 16,
     TEXT1 type C length 60,
     TEXT2 type C length 60,
     TEXT3 type C length 60,
     TEXT4 type C length 60,
     TEXT5 type C length 60,
  end of TS_VL_SH_J_1IG_HSN_SAC .
  types:
TT_VL_SH_J_1IG_HSN_SAC type standard table of TS_VL_SH_J_1IG_HSN_SAC .
  types:
  begin of TS_VL_SH_KREDA,
     BEGRU type C length 4,
     KTOKK type C length 4,
     SORTL type C length 10,
     LAND1 type C length 3,
     PSTLZ type C length 10,
     MCOD3 type C length 25,
     MCOD1 type C length 25,
     LIFNR type C length 10,
     LOEVM type FLAG,
  end of TS_VL_SH_KREDA .
  types:
TT_VL_SH_KREDA type standard table of TS_VL_SH_KREDA .
  types:
  begin of TS_VL_SH_KREDI,
     BEGRU type C length 4,
     KTOKK type C length 4,
     LAND1 type C length 3,
     MCOD3 type C length 25,
     SORTL type C length 10,
     MCOD1 type C length 25,
     LIFNR type C length 10,
     BUKRS type C length 4,
  end of TS_VL_SH_KREDI .
  types:
TT_VL_SH_KREDI type standard table of TS_VL_SH_KREDI .
  types:
  begin of TS_VL_SH_KREDK,
     BEGRU type C length 4,
     KTOKK type C length 4,
     SORTL type C length 10,
     LAND1 type C length 3,
     PSTLZ type C length 10,
     MCOD3 type C length 25,
     MCOD1 type C length 25,
     LIFNR type C length 10,
     BUKRS type C length 4,
     LOEVM type FLAG,
  end of TS_VL_SH_KREDK .
  types:
TT_VL_SH_KREDK type standard table of TS_VL_SH_KREDK .
  types:
  begin of TS_VL_SH_KREDL,
     BEGRU type C length 4,
     KTOKK type C length 4,
     LAND1 type C length 3,
     SORTL type C length 10,
     MCOD1 type C length 25,
     MCOD3 type C length 25,
     LIFNR type C length 10,
  end of TS_VL_SH_KREDL .
  types:
TT_VL_SH_KREDL type standard table of TS_VL_SH_KREDL .
  types:
  begin of TS_VL_SH_KREDP,
     BEGRU type C length 4,
     KTOKK type C length 4,
     LIFNR type C length 10,
     PERNR type C length 8,
     MCOD1 type C length 25,
     BUKRS type C length 4,
  end of TS_VL_SH_KREDP .
  types:
TT_VL_SH_KREDP type standard table of TS_VL_SH_KREDP .
  types:
  begin of TS_VL_SH_KREDT,
     BEGRU type C length 4,
     KTOKK type C length 4,
     STCD1 type C length 16,
     STCD2 type C length 11,
     STCD3 type C length 18,
     STCD4 type C length 18,
     STCD5 type C length 60,
     STCD6 type C length 20,
     STCEG type C length 20,
     LAND1 type C length 3,
     MCOD1 type C length 25,
     LIFNR type C length 10,
  end of TS_VL_SH_KREDT .
  types:
TT_VL_SH_KREDT type standard table of TS_VL_SH_KREDT .
  types:
  begin of TS_VL_SH_KREDY,
     LIFNR type C length 10,
  end of TS_VL_SH_KREDY .
  types:
TT_VL_SH_KREDY type standard table of TS_VL_SH_KREDY .
  types:
  begin of TS_VL_SH_LARTN,
     DATAB type TIMESTAMP,
     DATBI type TIMESTAMP,
     LSTAR type C length 6,
     KOKRS type C length 4,
     MCTXT type C length 20,
     SPRAS type C length 2,
  end of TS_VL_SH_LARTN .
  types:
TT_VL_SH_LARTN type standard table of TS_VL_SH_LARTN .
  types:
  begin of TS_VL_SH_LARTS,
     DATAB type TIMESTAMP,
     DATBI type TIMESTAMP,
     MCTXT type C length 20,
     SPRAS type C length 2,
     KOKRS type C length 4,
     LATYP type C length 1,
     LSTAR type C length 6,
  end of TS_VL_SH_LARTS .
  types:
TT_VL_SH_LARTS type standard table of TS_VL_SH_LARTS .
  types:
  begin of TS_VL_SH_MEBZF,
     FRBNR type C length 16,
     LIFNR type C length 10,
     EBELN type C length 10,
     EBELP type C length 5,
     STUNR type C length 3,
     ZAEHK type C length 3,
     VGABE type C length 1,
     GJAHR type C length 4,
     BELNR type C length 10,
     BUZEI type C length 4,
  end of TS_VL_SH_MEBZF .
  types:
TT_VL_SH_MEBZF type standard table of TS_VL_SH_MEBZF .
  types:
  begin of TS_VL_SH_ODATA_KREDI,
     BEGRU type C length 4,
     KTOKK type C length 4,
     LAND1 type C length 3,
     MCOD3 type C length 25,
     SORTL type C length 10,
     MCOD1 type C length 25,
     LIFNR type C length 10,
     BUKRS type C length 4,
  end of TS_VL_SH_ODATA_KREDI .
  types:
TT_VL_SH_ODATA_KREDI type standard table of TS_VL_SH_ODATA_KREDI .
  types:
  begin of TS_VL_SH_ODATA_LANDL,
     LANGUAGE type C length 2,
     COUNTRY type C length 3,
     COUNTRYNAME type C length 50,
  end of TS_VL_SH_ODATA_LANDL .
  types:
TT_VL_SH_ODATA_LANDL type standard table of TS_VL_SH_ODATA_LANDL .
  types:
  begin of TS_VL_SH_ODATA_MEKKL,
     EBELN type C length 10,
     LIFNR type C length 10,
     BUKRS type C length 4,
     EKORG type C length 4,
     EKGRP type C length 3,
     BEDAT type TIMESTAMP,
  end of TS_VL_SH_ODATA_MEKKL .
  types:
TT_VL_SH_ODATA_MEKKL type standard table of TS_VL_SH_ODATA_MEKKL .
  types:
  begin of TS_VL_SH_ODATA_MMIV_MEDLN,
     XBLNR type C length 16,
     EBELN type C length 10,
     EBELP type C length 5,
     GJAHR type C length 4,
     BELNR type C length 10,
     BUZEI type C length 4,
     BUDAT type TIMESTAMP,
     BLDAT type TIMESTAMP,
  end of TS_VL_SH_ODATA_MMIV_MEDLN .
  types:
TT_VL_SH_ODATA_MMIV_MEDLN type standard table of TS_VL_SH_ODATA_MMIV_MEDLN .
  types:
  begin of TS_VL_SH_ODATA_MMIV_TAX_CODE,
     MWART type C length 1,
     SPRAS type C length 2,
     XINACT type FLAG,
     BUKRS type C length 4,
     LAND1 type C length 3,
     MWSKZ type C length 2,
     TEXT1 type C length 50,
  end of TS_VL_SH_ODATA_MMIV_TAX_CODE .
  types:
TT_VL_SH_ODATA_MMIV_TAX_CODE type standard table of TS_VL_SH_ODATA_MMIV_TAX_CODE .
  types:
  begin of TS_VL_SH_ODATA_MMIV_ZTERM_SHLP,
     PAYMENTTERMSVALIDITYMONTHDAY type C length 2,
     PAYMENTTERMSNAME type C length 30,
     PAYTTRMSCNDNEXPLANATIONTEXT type C length 200,
     CASHDISCOUNT1DAYS type P length 2 decimals 0,
     CASHDISCOUNT1PERCENT type P length 3 decimals 3,
     CASHDISCOUNT2DAYS type P length 2 decimals 0,
     CASHDISCOUNT2PERCENT type P length 3 decimals 3,
     NETPAYMENTDAYS type P length 2 decimals 0,
     PAYMENTTERMS type C length 4,
  end of TS_VL_SH_ODATA_MMIV_ZTERM_SHLP .
  types:
TT_VL_SH_ODATA_MMIV_ZTERM_SHLP type standard table of TS_VL_SH_ODATA_MMIV_ZTERM_SHLP .
  types:
  begin of TS_VL_SH_ODATA_ZLSPR,
     LANGUAGE type C length 2,
     PAYMENTBLOCKINGREASON type C length 1,
     PAYMENTBLOCKINGREASONNAME type C length 20,
  end of TS_VL_SH_ODATA_ZLSPR .
  types:
TT_VL_SH_ODATA_ZLSPR type standard table of TS_VL_SH_ODATA_ZLSPR .
  types:
  begin of TS_VL_SH_SECCODE,
     NAME type C length 30,
     BUKRS type C length 4,
     SECCODE type C length 4,
     BPLACE type C length 4,
  end of TS_VL_SH_SECCODE .
  types:
TT_VL_SH_SECCODE type standard table of TS_VL_SH_SECCODE .
  types:
  begin of TS_VL_SH_SESITEM_E,
     APPROVALSTATUS type C length 2,
     APPROVALSTATUSDESCRIPTION type C length 60,
     PERSONFULLNAME type C length 80,
     SERVICEENTRYSHEET type C length 10,
     SERVICEENTRYSHEETITEM type C length 5,
     SERVICE type C length 40,
     SERVICEPERFORMER type C length 10,
     PERFORMANCEDATE type TIMESTAMP,
     REFERENCEPURCHASEORDER type C length 10,
     REFERENCEPURCHASEORDERITEM type C length 5,
     QUANTITY type P length 7 decimals 3,
     UNIT type C length 3,
  end of TS_VL_SH_SESITEM_E .
  types:
TT_VL_SH_SESITEM_E type standard table of TS_VL_SH_SESITEM_E .
  types:
  begin of TS_VL_SH_SESNR_E,
     APPROVALSTATUS type C length 2,
     APPROVALSTATUSDESCRIPTION type C length 60,
     SERVICEENTRYSHEET type C length 10,
     REFERENCEPURCHASEORDER type C length 10,
     SUPPLIER type C length 10,
  end of TS_VL_SH_SESNR_E .
  types:
TT_VL_SH_SESNR_E type standard table of TS_VL_SH_SESNR_E .
  types:
  begin of TS_VL_SH_SH_BRANCH,
     ACCOUNTTYPE type C length 1,
     BUSINESSPARTNER type C length 10,
     BRANCHCODE type C length 5,
     TH_BRANCHCODEDESCRIPTION type C length 40,
     ISDEFAULTVALUE type C length 1,
  end of TS_VL_SH_SH_BRANCH .
  types:
TT_VL_SH_SH_BRANCH type standard table of TS_VL_SH_SH_BRANCH .
  types:
  begin of TS_VL_SH_SH_FMAREA_CDS,
     FINANCIALMANAGEMENTAREA type C length 4,
     FINANCIALMANAGEMENTAREANAME type C length 25,
     FINANCIALMANAGEMENTAREACRCY type C length 5,
     FINMGMTAREAFISCALYEARVARIANT type C length 2,
  end of TS_VL_SH_SH_FMAREA_CDS .
  types:
TT_VL_SH_SH_FMAREA_CDS type standard table of TS_VL_SH_SH_FMAREA_CDS .
  types:
  begin of TS_VL_SH_SH_FMBPD_CDS,
     VALIDITYENDDATE type TIMESTAMP,
     VALIDITYSTARTDATE type TIMESTAMP,
     BUDGETPERIOD type C length 10,
     BUDGETPERIODNAME type C length 35,
     BUDGETPERIODAUTHZNGRP type C length 10,
     BUDGETPERIODEXPIRATIONDATE type TIMESTAMP,
     BUDGETPERIODPERIODICITY type C length 10,
  end of TS_VL_SH_SH_FMBPD_CDS .
  types:
TT_VL_SH_SH_FMBPD_CDS type standard table of TS_VL_SH_SH_FMBPD_CDS .
  types:
  begin of TS_VL_SH_SH_FMCI_CDS,
     FINANCIALMANAGEMENTAREA type C length 4,
     FINMGMTAREAFISCALYEAR type C length 4,
     COMMITMENTITEM type C length 24,
     COMMITMENTITEMNAME type C length 20,
     VALIDITYENDDATE type TIMESTAMP,
     VALIDITYSTARTDATE type TIMESTAMP,
  end of TS_VL_SH_SH_FMCI_CDS .
  types:
TT_VL_SH_SH_FMCI_CDS type standard table of TS_VL_SH_SH_FMCI_CDS .
  types:
  begin of TS_VL_SH_SH_FMFCTR_CDS,
     FINANCIALMANAGEMENTAREA type C length 4,
     FUNDSCENTER type C length 16,
     FUNDSCENTERNAME type C length 20,
     VALIDITYENDDATE type TIMESTAMP,
  end of TS_VL_SH_SH_FMFCTR_CDS .
  types:
TT_VL_SH_SH_FMFCTR_CDS type standard table of TS_VL_SH_SH_FMFCTR_CDS .
  types:
  begin of TS_VL_SH_SH_FMFUNDEDPRG_CDS,
     FINANCIALMANAGEMENTAREA type C length 4,
     FUNDEDPROGRAM type C length 24,
     VALIDITYENDDATE type TIMESTAMP,
     VALIDITYSTARTDATE type TIMESTAMP,
  end of TS_VL_SH_SH_FMFUNDEDPRG_CDS .
  types:
TT_VL_SH_SH_FMFUNDEDPRG_CDS type standard table of TS_VL_SH_SH_FMFUNDEDPRG_CDS .
  types:
  begin of TS_VL_SH_SH_FMFUNDSMGMTFUNCARE,
     FUNCTIONALAREA type C length 16,
     FUNCTIONALAREANAME type C length 25,
     VALIDITYSTARTDATE type TIMESTAMP,
     VALIDITYENDDATE type TIMESTAMP,
  end of TS_VL_SH_SH_FMFUNDSMGMTFUNCARE .
  types:
TT_VL_SH_SH_FMFUNDSMGMTFUNCARE type standard table of TS_VL_SH_SH_FMFUNDSMGMTFUNCARE .
  types:
  begin of TS_VL_SH_SH_FMFUND_CDS,
     FINANCIALMANAGEMENTAREA type C length 4,
     FUND type C length 10,
     FUNDNAME type C length 20,
     FUNDDESCRIPTION type C length 40,
     VALIDITYENDDATE type TIMESTAMP,
     VALIDITYSTARTDATE type TIMESTAMP,
     FUNDAUTHZNGRP type C length 10,
  end of TS_VL_SH_SH_FMFUND_CDS .
  types:
TT_VL_SH_SH_FMFUND_CDS type standard table of TS_VL_SH_SH_FMFUND_CDS .
  types:
  begin of TS_VL_SH_SH_GMGR_S4C_CDS,
     GRANTID type C length 20,
     GRANTNAME type C length 20,
     VALIDITYSTARTDATE type TIMESTAMP,
     VALIDITYENDDATE type TIMESTAMP,
  end of TS_VL_SH_SH_GMGR_S4C_CDS .
  types:
TT_VL_SH_SH_GMGR_S4C_CDS type standard table of TS_VL_SH_SH_GMGR_S4C_CDS .
  types:
  begin of TS_VL_SH_SH_TCURC,
     WAERS type C length 5,
     LTEXT type C length 40,
  end of TS_VL_SH_SH_TCURC .
  types:
TT_VL_SH_SH_TCURC type standard table of TS_VL_SH_SH_TCURC .
  types:
  begin of TS_VL_SH_XCPDXSS_WORK_ITEM,
     WORKITEM type C length 10,
     WORKPACKAGE type C length 50,
     WORKITEMNAME type C length 40,
     WORKITEMISINACTIVE type C length 1,
  end of TS_VL_SH_XCPDXSS_WORK_ITEM .
  types:
TT_VL_SH_XCPDXSS_WORK_ITEM type standard table of TS_VL_SH_XCPDXSS_WORK_ITEM .
  types:
  begin of TS_VL_SH_XCPDXSS_WORK_ITEM_CUS,
     WORKITEM_ID type C length 10,
     WORKITEM_NAME type C length 40,
  end of TS_VL_SH_XCPDXSS_WORK_ITEM_CUS .
  types:
TT_VL_SH_XCPDXSS_WORK_ITEM_CUS type standard table of TS_VL_SH_XCPDXSS_WORK_ITEM_CUS .
  types:
  begin of TS_VL_SH_XSHCMXEMPLOYMENTBASIC,
     EMPLOYEEFULLNAME type C length 80,
     COMPANYCODE type C length 4,
     COMPANYCODENAME type C length 25,
     COSTCENTER type C length 10,
     COSTCENTERNAME type C length 20,
     USERID type C length 12,
     ORGANIZATIONALUNITNAME type C length 25,
     JOBNAME type C length 25,
     GIVENNAME type C length 35,
     FAMILYNAME type C length 35,
     EMPLOYEE type C length 60,
     EMPLOYMENTINTERNALID type C length 8,
  end of TS_VL_SH_XSHCMXEMPLOYMENTBASIC .
  types:
TT_VL_SH_XSHCMXEMPLOYMENTBASIC type standard table of TS_VL_SH_XSHCMXEMPLOYMENTBASIC .
  types:
     TS_VALUEHELPRESULT type MMIV_SI_S_GET_VALUE_HELP_RP .
  types:
TT_VALUEHELPRESULT type standard table of TS_VALUEHELPRESULT .
  types:
     TS_WITHHOLDINGTAX type MMIV_SI_S_WITHHOLDING_TAX .
  types:
TT_WITHHOLDINGTAX type standard table of TS_WITHHOLDINGTAX .

  constants GC_VL_SH_H_T8JJ type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T8JJ' ##NO_TEXT.
  constants GC_VL_SH_H_T8JF type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T8JF' ##NO_TEXT.
  constants GC_VL_SH_H_T161 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T161' ##NO_TEXT.
  constants GC_VL_SH_H_T042Z type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T042Z' ##NO_TEXT.
  constants GC_VL_SH_H_T015L type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T015L' ##NO_TEXT.
  constants GC_VL_SH_H_T012 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T012' ##NO_TEXT.
  constants GC_VL_SH_H_T001W type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T001W' ##NO_TEXT.
  constants GC_VL_SH_H_T001 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T001' ##NO_TEXT.
  constants GC_VL_SH_H_FARP_PAYT_RSN_T type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_FARP_PAYT_RSN_T' ##NO_TEXT.
  constants GC_VL_SH_H_FARP_PAYT_RSN_CD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_FARP_PAYT_RSN_CD' ##NO_TEXT.
  constants GC_VL_SH_H_FAGL_SEGM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_FAGL_SEGM' ##NO_TEXT.
  constants GC_VL_SH_GLO_SH_BUPLA_ID type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_GLO_SH_BUPLA_ID' ##NO_TEXT.
  constants GC_VL_SH_GLO_SH_BRNCH_ID type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_GLO_SH_BRNCH_ID' ##NO_TEXT.
  constants GC_VL_SH_FRTDOCACCR_SH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FRTDOCACCR_SH' ##NO_TEXT.
  constants GC_VL_SH_FOT_TXA_F4_FRGN_REGIS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FOT_TXA_F4_FRGN_REGISTRATIONS' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_Z type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_Z' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_P type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_P' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_K type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_K' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_H type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_H' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_C type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_C' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_B type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_B' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_GEN_A type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_GEN_A' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_ES_HDR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_ES_HDR' ##NO_TEXT.
  constants GC_VL_SH_FM_RESERV_ES_AA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FM_RESERV_ES_AA' ##NO_TEXT.
  constants GC_VL_SH_FMBPD_F type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FMBPD_F' ##NO_TEXT.
  constants GC_VL_SH_FMBPD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FMBPD' ##NO_TEXT.
  constants GC_VL_SH_FCO_SHLP_SRVDOC_TYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FCO_SHLP_SRVDOC_TYPE' ##NO_TEXT.
  constants GC_VL_SH_FCO_SHLP_SRVDOC_ITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FCO_SHLP_SRVDOC_ITEM' ##NO_TEXT.
  constants GC_VL_SH_FCO_SHLP_SRVDOC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FCO_SHLP_SRVDOC' ##NO_TEXT.
  constants GC_VL_SH_FAP_T003 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAP_T003' ##NO_TEXT.
  constants GC_VL_SH_FAP_H_HKTID type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAP_H_HKTID' ##NO_TEXT.
  constants GC_VL_SH_FAC_WHTX_CODE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_WHTX_CODE' ##NO_TEXT.
  constants GC_VL_SH_FAC_TAX_JURISDICTION_ type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_TAX_JURISDICTION_CODE' ##NO_TEXT.
  constants GC_VL_SH_FAC_TAX_JURISDICTION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_TAX_JURISDICTION_CODE_EXT' ##NO_TEXT.
  constants GC_VL_SH_FAC_SUBASSET type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_SUBASSET' ##NO_TEXT.
  constants GC_VL_SH_FAC_SEGMENT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_SEGMENT' ##NO_TEXT.
  constants GC_VL_SH_FAC_SALES_ORDER_ITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_SALES_ORDER_ITEM' ##NO_TEXT.
  constants GC_VL_SH_FAC_SALES_ORDER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_SALES_ORDER' ##NO_TEXT.
  constants GC_VL_SH_H_T8JV type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_T8JV' ##NO_TEXT.
  constants GC_WITHHOLDINGTAX type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'WithholdingTax' ##NO_TEXT.
  constants GC_VL_SH_XSHCMXEMPLOYMENTBASIC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_xSHCMxEMPLOYMENTBASIC' ##NO_TEXT.
  constants GC_VL_SH_XCPDXSS_WORK_ITEM_CUS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_xCPDxSS_WORK_ITEM_CUST' ##NO_TEXT.
  constants GC_VL_SH_XCPDXSS_WORK_ITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_xCPDxSS_WORK_ITEM' ##NO_TEXT.
  constants GC_VL_SH_SH_TCURC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_TCURC' ##NO_TEXT.
  constants GC_VL_SH_SH_GMGR_S4C_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_GMGR_S4C_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMFUND_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMFUND_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMFUNDSMGMTFUNCARE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMFUNDSMGMTFUNCAREA_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMFUNDEDPRG_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMFUNDEDPRG_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMFCTR_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMFCTR_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMCI_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMCI_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMBPD_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMBPD_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_FMAREA_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_FMAREA_CDS' ##NO_TEXT.
  constants GC_VL_SH_SH_BRANCH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SH_BRANCH' ##NO_TEXT.
  constants GC_VL_SH_SESNR_E type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SESNR_E' ##NO_TEXT.
  constants GC_VL_SH_SESITEM_E type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SESITEM_E' ##NO_TEXT.
  constants GC_VL_SH_SECCODE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_SECCODE' ##NO_TEXT.
  constants GC_VL_SH_ODATA_ZLSPR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_ZLSPR' ##NO_TEXT.
  constants GC_VL_SH_ODATA_MMIV_ZTERM_SHLP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_MMIV_ZTERM_SHLP' ##NO_TEXT.
  constants GC_VL_SH_ODATA_MMIV_TAX_CODE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_MMIV_TAX_CODE' ##NO_TEXT.
  constants GC_VL_SH_ODATA_MMIV_MEDLN type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_MMIV_MEDLN' ##NO_TEXT.
  constants GC_VL_SH_ODATA_MEKKL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_MEKKL' ##NO_TEXT.
  constants GC_VL_SH_ODATA_LANDL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_LANDL' ##NO_TEXT.
  constants GC_VL_SH_ODATA_KREDI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_KREDI' ##NO_TEXT.
  constants GC_VL_SH_MEBZF type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_MEBZF' ##NO_TEXT.
  constants GC_VL_SH_LARTS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_LARTS' ##NO_TEXT.
  constants GC_VL_SH_LARTN type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_LARTN' ##NO_TEXT.
  constants GC_VL_SH_KREDY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDY' ##NO_TEXT.
  constants GC_VL_SH_KREDT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDT' ##NO_TEXT.
  constants GC_VL_SH_KREDP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDP' ##NO_TEXT.
  constants GC_VL_SH_KREDL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDL' ##NO_TEXT.
  constants GC_VL_SH_KREDK type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDK' ##NO_TEXT.
  constants GC_VL_SH_KREDI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDI' ##NO_TEXT.
  constants GC_VL_SH_KREDA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_KREDA' ##NO_TEXT.
  constants GC_VL_SH_J_1IG_HSN_SAC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_J_1IG_HSN_SAC' ##NO_TEXT.
  constants GC_VL_SH_H_TTXJ type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_TTXJ' ##NO_TEXT.
  constants GC_VL_SH_H_TKA01 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_TKA01' ##NO_TEXT.
  constants GC_VL_SH_H_TGSB type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_H_TGSB' ##NO_TEXT.
  constants GC_VL_SH_FAC_REVERSAL_REASON type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_REVERSAL_REASON' ##NO_TEXT.
  constants GC_SAP__TABLECOLUMNS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__TableColumns' ##NO_TEXT.
  constants GC_SAP__SIGNATURE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__Signature' ##NO_TEXT.
  constants GC_SAP__PDFSTANDARD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__PDFStandard' ##NO_TEXT.
  constants GC_SAP__PDFHEADER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__PDFHeader' ##NO_TEXT.
  constants GC_SAP__PDFFOOTER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__PDFFooter' ##NO_TEXT.
  constants GC_SAP__HIERARCHY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__Hierarchy' ##NO_TEXT.
  constants GC_SAP__HEADERFOOTERFIELD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__HeaderFooterField' ##NO_TEXT.
  constants GC_SAP__FORMAT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__Format' ##NO_TEXT.
  constants GC_SAP__FITTOPAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__FitToPage' ##NO_TEXT.
  constants GC_SAP__DOCUMENTDESCRIPTION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__DocumentDescription' ##NO_TEXT.
  constants GC_SAP__COVERPAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__CoverPage' ##NO_TEXT.
  constants GC_PURCHASEORDERREFERENCE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'PurchaseOrderReference' ##NO_TEXT.
  constants GC_PURCHASEORDERITEMSEARCHRESU type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'PurchaseOrderItemSearchResult' ##NO_TEXT.
  constants GC_PURCHASEORDERHISTORYRECORD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'PurchaseOrderHistoryRecord' ##NO_TEXT.
  constants GC_POITEMTAXCHANGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'PoItemTaxChange' ##NO_TEXT.
  constants GC_NOTE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Note' ##NO_TEXT.
  constants GC_ITEMWITHPURCHASEORDERREFERE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ItemWithPurchaseOrderReference' ##NO_TEXT.
  constants GC_INCOMPLETEITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'IncompleteItem' ##NO_TEXT.
  constants GC_HEADERGLOFIELD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'HeaderGloField' ##NO_TEXT.
  constants GC_HEADER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Header' ##NO_TEXT.
  constants GC_GLACCOUNTITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'GLAccountItem' ##NO_TEXT.
  constants GC_DELIVERYNOTEREFERENCE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeliveryNoteReference' ##NO_TEXT.
  constants GC_CONSIGNMENTITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ConsignmentItem' ##NO_TEXT.
  constants GC_BLOCKINGREASON type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'BlockingReason' ##NO_TEXT.
  constants GC_BILLOFLADINGREFERENCE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'BillOfLadingReference' ##NO_TEXT.
  constants GC_ACTIONRESULTUSERDEFAULTSETT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultUserDefaultSettings' ##NO_TEXT.
  constants GC_ACTIONRESULTSAVEPRELIM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultSavePrelim' ##NO_TEXT.
  constants GC_ACTIONRESULTSAVEERRONEOUSOR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultSaveErroneousOrBatch' ##NO_TEXT.
  constants GC_ACTIONRESULTPOST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultPost' ##NO_TEXT.
  constants GC_ACTIONRESULTGETCHANGESTATEI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultGetChangeStateId' ##NO_TEXT.
  constants GC_ACTIONRESULTFEATURECHECK type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultFeatureCheck' ##NO_TEXT.
  constants GC_ACTIONRESULTEDITCHECK type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultEditCheck' ##NO_TEXT.
  constants GC_ACTIONRESULTCREATEOTVDRAFT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultCreateOTVDraft' ##NO_TEXT.
  constants GC_ACTIONRESULTCONVERTLC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultConvertLC' ##NO_TEXT.
  constants GC_ACTIONRESULTCANCEL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultCancel' ##NO_TEXT.
  constants GC_ACTIONRESULTAPPOVEREJECT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultAppoveReject' ##NO_TEXT.
  constants GC_ACTIONRESULT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResult' ##NO_TEXT.
  constants GC_ACCOUNTASSIGNMENT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AccountAssignment' ##NO_TEXT.
  constants GC_SAP__VALUEHELP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__ValueHelp' ##NO_TEXT.
  constants GC_VL_SH_FAC_PS_POSID type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_PS_POSID' ##NO_TEXT.
  constants GC_VL_SH_FAC_PROFIT_CENTER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_PROFIT_CENTER' ##NO_TEXT.
  constants GC_VL_SH_FAC_PRODUCT_VH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_PRODUCT_VH' ##NO_TEXT.
  constants GC_VL_SH_FAC_ORDER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_ORDER' ##NO_TEXT.
  constants GC_VL_SH_FAC_NETWORK_ACTIVITY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_NETWORK_ACTIVITY' ##NO_TEXT.
  constants GC_VL_SH_FAC_NETWORK type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_NETWORK' ##NO_TEXT.
  constants GC_VL_SH_FAC_MATERIAL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_MATERIAL' ##NO_TEXT.
  constants GC_VL_SH_FAC_HKTID_SHLP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_HKTID_SHLP' ##NO_TEXT.
  constants GC_VL_SH_FAC_HBKID_SHLP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_HBKID_SHLP' ##NO_TEXT.
  constants GC_VL_SH_FAC_GL_ACCOUNT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_GL_ACCOUNT' ##NO_TEXT.
  constants GC_VL_SH_FAC_FIN_TRANSACTION_T type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_FIN_TRANSACTION_TYPE' ##NO_TEXT.
  constants GC_VL_SH_FAC_COST_OBJECT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_COST_OBJECT' ##NO_TEXT.
  constants GC_VL_SH_FAC_COST_CENTER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_COST_CENTER' ##NO_TEXT.
  constants GC_VL_SH_FAC_BASE_UNIT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_BASE_UNIT' ##NO_TEXT.
  constants GC_VL_SH_FAC_ASSET_TRANSACTION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_ASSET_TRANSACTION_TYPE' ##NO_TEXT.
  constants GC_VL_SH_FAC_ASSET type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAC_ASSET' ##NO_TEXT.
  constants GC_VL_FV_ZBFIX type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_ZBFIX' ##NO_TEXT.
  constants GC_VL_FV_XRECH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_XRECH' ##NO_TEXT.
  constants GC_VL_FV_SHKZG type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_SHKZG' ##NO_TEXT.
  constants GC_VL_FV_MRM_VORGANG type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_MRM_VORGANG' ##NO_TEXT.
  constants GC_VL_FV_MRM_REFERENZBELEGTYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_MRM_REFERENZBELEGTYP' ##NO_TEXT.
  constants GC_VL_FV_MMIV_SI_INVOICE_SELEC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_FV_MMIV_SI_INVOICE_SELECTION' ##NO_TEXT.
  constants GC_VL_CT_T169COMPLAINT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_CT_T169COMPLAINT' ##NO_TEXT.
  constants GC_VL_CT_T042F type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_CT_T042F' ##NO_TEXT.
  constants GC_VL_CT_T005S type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_CT_T005S' ##NO_TEXT.
  constants GC_VL_CT_T005 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_CT_T005' ##NO_TEXT.
  constants GC_VL_CT_CBPR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_CT_CBPR' ##NO_TEXT.
  constants GC_VHGLACCOUNTFORINPUT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VHGLAccountForInput' ##NO_TEXT.
  constants GC_VHBANKDETAIL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VHBankDetail' ##NO_TEXT.
  constants GC_VALUEHELPRESULT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ValueHelpResult' ##NO_TEXT.
  constants GC_USERDRAFTINFO type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'UserDraftInfo' ##NO_TEXT.
  constants GC_TRANSPORTATIONMANAGEMENTREF type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'TransportationManagementReference' ##NO_TEXT.
  constants GC_TAX type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Tax' ##NO_TEXT.
  constants GC_SUPPLIERCONTACTCARDDATA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SupplierContactCardData' ##NO_TEXT.
  constants GC_SIMULATIONSUMMARY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SimulationSummary' ##NO_TEXT.
  constants GC_SIMULATIONPOSTINGITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SimulationPostingItem' ##NO_TEXT.
  constants GC_SERVICEENTRYSHEETLEANREFERE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ServiceEntrySheetLeanReference' ##NO_TEXT.
  constants GC_SEARCHHELPFIELD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SearchHelpField' ##NO_TEXT.

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



CLASS ZCL_ZMM_SUPPLIER_IN_01_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'MM_SUPPLIER_INVOICE_MANAGE' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'MM_SUPPLIER_INVOICE_MANAGE_Entities' ).


*
* Disable all the complex types that were disabled from reference model
*
* Disable complex type 'CancellationParameters'
try.
lo_complex_type = model->get_complex_type( iv_cplx_type_name = 'CancellationParameters' ). "#EC NOTEXT
lo_complex_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

if lo_complex_type is bound.
* Disable all the properties for this complex type
try.
lo_property = lo_complex_type->get_property( iv_property_name = 'CancellationReason' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_complex_type->get_property( iv_property_name = 'PostingDate' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_complex_type->get_property( iv_property_name = 'RootKey' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
endif.

* Disable complex type 'Belnr'
try.
lo_complex_type = model->get_complex_type( iv_cplx_type_name = 'Belnr' ). "#EC NOTEXT
lo_complex_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

if lo_complex_type is bound.
* Disable all the properties for this complex type
try.
lo_property = lo_complex_type->get_property( iv_property_name = 'Zeile' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_complex_type->get_property( iv_property_name = 'Ebelp' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
endif.


*
* Disable all the entity types that were disabled from reference model
*
* Disable entity type 'SAP__Currency'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'SAP__Currency' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CurrencyCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ISOCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'Text' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DecimalPlaces' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


endif.

* Disable entity type 'SAP__UnitOfMeasure'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'SAP__UnitOfMeasure' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'UnitCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ISOCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ExternalCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'Text' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DecimalPlaces' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


endif.


*
*Disable all the entity sets that were disabled from reference model
*
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'SAP__Currencies' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'SAP__UnitsOfMeasure' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'MM_SUPPLIER_INVOICE_MANAGE'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'MM_SUPPLIER_INVOICE_MANAGE'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20260403163955'. "#EC NOTEXT
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
