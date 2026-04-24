class ZCL_ZODQ_SUPPLIERCOMPA_MPC definition
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
  begin of TS_DELTALINKSOFFACTSOFISUPPLCO,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFFACTSOFISUPPLCO .
  types:
TT_DELTALINKSOFFACTSOFISUPPLCO type standard table of TS_DELTALINKSOFFACTSOFISUPPLCO .
  types:
  begin of TS_FACTSOFISUPPLCOMPANY,
     SUPPLIER type C length 10,
     COMPANYCODE type C length 4,
     AUTHORIZATIONGROUP type C length 4,
     COMPANYCODENAME type C length 25,
     PAYMENTBLOCKINGREASON type C length 1,
     SUPPLIERISBLOCKEDFORPOSTING type C length 1,
     ISBUSINESSPURPOSECOMPLETED type C length 1,
     ACCOUNTINGCLERK type C length 2,
     ACCOUNTINGCLERKFAXNUMBER type C length 31,
     ACCOUNTINGCLERKPHONENUMBER type C length 30,
     ACCOUNTINGCLERKINTERNETADDRESS type C length 130,
     SUPPLIERCLERK type C length 15,
     SUPPLIERCLERKURL type C length 130,
     PAYMENTMETHODSLIST type C length 10,
     PAYMENTTERMS type C length 4,
     CLEARCUSTOMERSUPPLIER type C length 1,
     ISTOBELOCALLYPROCESSED type C length 1,
     ITEMISTOBEPAIDSEPARATELY type C length 1,
     PAYMENTISTOBESENTBYEDI type C length 1,
     HOUSEBANK type C length 5,
     CHECKPAIDDURATIONINDAYS type P length 3 decimals 0,
     CURRENCY type C length 5,
     BILLOFEXCHLMTAMTINCOCODECRCY type DECFLOAT34,
     SUPPLIERCLERKIDBYSUPPLIER type C length 12,
     ISDOUBLEINVOICE type C length 1,
     CUSTOMERSUPPLIERCLEARINGISUSED type C length 1,
     RECONCILIATIONACCOUNT type C length 10,
     INTERESTCALCULATIONCODE type C length 2,
     INTERESTCALCULATIONDATE type TIMESTAMP,
     INTRSTCALCFREQUENCYINMONTHS type C length 2,
     SUPPLIERHEADOFFICE type C length 10,
     ALTERNATIVEPAYEE type C length 10,
     LAYOUTSORTINGRULE type C length 3,
     APARTOLERANCEGROUP type C length 4,
     SUPLRINVCVERIFICATTOLGROUP type C length 4,
     SUPPLIERCERTIFICATIONDATE type TIMESTAMP,
     SUPPLIERACCOUNTNOTE type C length 30,
     WITHHOLDINGTAXCOUNTRY type C length 3,
     DELETIONINDICATOR type C length 1,
     CASHPLANNINGGROUP type C length 10,
     ISTOBECHECKEDFORDUPLICATES type C length 1,
     PERSONNELNUMBER type C length 8,
     PREVIOUSACCOUNTNUMBER type C length 10,
     MINORITYGROUP type C length 3,
     LASTINTERESTCALCRUNDATE type TIMESTAMP,
     US_FOREIGNSUPLRHASPARTNERSHIP type C length 1,
     US_SECONDTINNOTICEISISSUED type C length 1,
     US_FOREIGNSUPLRLMTNONBNFTCODE type C length 2,
     SUPPLIERRELEASEGROUP type C length 4,
     CREDITMEMOPAYMENTTERMS type C length 4,
     PAYMENTMETHODSUPPLEMENT type C length 2,
     US_FRGNACCTTAXFILINGISREQUIRED type C length 1,
     US_RECIPIENTFOREIGNTAXID type C length 22,
     US_FW9RECEIVEDATE type TIMESTAMP,
     US_FW8BENRECEIVEDATE type TIMESTAMP,
     US_FRGNACCTTAXRCPNTCNTRY type C length 3,
     US_GLOBINTERMEDIARYIDNNUMBER type C length 19,
     US_LOBTREATYCODE type C length 2,
     US_CHAPTER4STATUSCODE type C length 2,
     PAYMENTCLEARINGGROUP type C length 8,
     PAYMENTREASON type C length 4,
     DELETIONISBLOCKED type C length 1,
     ISACTIVEENTITY type C length 1,
     UK_CONTRACTORBUSINESSTYPE type C length 12,
     UK_PARTNERTRADINGNAME type C length 30,
     UK_PARTNERTAXREFERENCE type C length 20,
     UK_VERIFICATIONSTATUS type C length 3,
     UK_VERIFICATIONNUMBER type C length 20,
     UK_COMPANYREGISTRATIONNUMBER type C length 8,
     UK_VERIFIEDTAXSTATUS type C length 1,
     AVSND type C length 1,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_FACTSOFISUPPLCOMPANY .
  types:
TT_FACTSOFISUPPLCOMPANY type standard table of TS_FACTSOFISUPPLCOMPANY .

  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFFACTSOFISUPPLCO type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfFactsOfISUPPLCOMPANY' ##NO_TEXT.
  constants GC_FACTSOFISUPPLCOMPANY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FactsOfISUPPLCOMPANY' ##NO_TEXT.
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



CLASS ZCL_ZODQ_SUPPLIERCOMPA_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_SUPPLIERCOMPANY_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_SUPPLIERCOMPANY_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_SUPPLIERCOMPANY_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_SUPPLIERCOMPANY_1_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250807131546'. "#EC NOTEXT
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
