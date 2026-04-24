class ZCL_ZODQ_GLACCTINCOMPA_MPC definition
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
  begin of TS_ATTROFIFIGLACCINCCODE,
     GLACCOUNT type C length 10,
     COMPANYCODE type C length 4,
     AUTHORIZATIONGROUP type C length 4,
     ACCOUNTINGCLERK type C length 2,
     LASTINTERESTCALCRUNDATE type TIMESTAMP,
     CREATIONDATE type TIMESTAMP,
     CREATEDBYUSER type C length 12,
     LASTCHANGEDATETIME type P length 15 decimals 0,
     PLANNINGLEVEL type C length 2,
     HOUSEBANK type C length 5,
     HOUSEBANKACCOUNT type C length 5,
     EXCHRATEDIFFERENCESACCOUNTDETN type C length 4,
     RECONCILIATIONACCOUNTTYPE type C length 1,
     TAXCATEGORY type C length 2,
     INTERESTCALCULATIONCODE type C length 2,
     GLACCOUNTCURRENCY type C length 5,
     RECONCILIATIONACCTISCHANGEABLE type C length 1,
     ISMANAGEDEXTERNALLY type C length 1,
     ISAUTOMATICALLYPOSTED type C length 1,
     LINEITEMDISPLAYISENABLED type C length 1,
     SUPPLEMENTISALLOWED type C length 1,
     ISOPENITEMMANAGED type C length 1,
     INTERESTCALCULATIONDATE type TIMESTAMP,
     INTRSTCALCFREQUENCYINMONTHS type C length 2,
     ACCTGDOCITMDISPLAYSEQUENCERULE type C length 3,
     ALTERNATIVEGLACCOUNT type C length 10,
     JOINTVENTURERECOVERYCODE type C length 2,
     COMMITMENTITEM type C length 14,
     COMMITMENTITEMSHORTID type C length 14,
     TAXCODEISREQUIRED type C length 1,
     BALANCEHASLOCALCURRENCY type C length 1,
     VALUATIONGROUP type C length 10,
     APARTOLERANCEGROUP type C length 4,
     ACCOUNTISBLOCKEDFORPOSTING type C length 1,
     ACCOUNTISMARKEDFORDELETION type C length 1,
     CLEARINGISLEDGERGROUPSPECIFIC type C length 1,
     CASHPLANNINGGROUP type C length 10,
     ISCASHFLOWACCOUNT type C length 1,
     GLACCTINFLATIONKEY type C length 8,
     FIELDSTATUSGROUP type C length 4,
     MULTICURRENCYACCOUNTINGCODE type C length 5,
     ISEXTENDEDOPENITEMMANAGED type C length 1,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_ATTROFIFIGLACCINCCODE .
  types:
TT_ATTROFIFIGLACCINCCODE type standard table of TS_ATTROFIFIGLACCINCCODE .
  types:
  begin of TS_DELTALINKSOFATTROFIFIGLACCI,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFATTROFIFIGLACCI .
  types:
TT_DELTALINKSOFATTROFIFIGLACCI type standard table of TS_DELTALINKSOFATTROFIFIGLACCI .

  constants GC_ATTROFIFIGLACCINCCODE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AttrOfIFIGLACCINCCODE' ##NO_TEXT.
  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFATTROFIFIGLACCI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfAttrOfIFIGLACCINCCODE' ##NO_TEXT.
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



CLASS ZCL_ZODQ_GLACCTINCOMPA_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_GLACCTINCOMPANYCODE_4_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_GLACCTINCOMPANYCODE_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_GLACCTINCOMPANYCODE_4_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_GLACCTINCOMPANYCODE_4_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250611183330'. "#EC NOTEXT
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
