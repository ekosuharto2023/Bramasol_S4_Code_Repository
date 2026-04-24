class ZCL_ZODQ_PAYPROPITMAGG_MPC definition
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
  begin of TS_DELTALINKSOFFACTSOFZVPAYTIT,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFFACTSOFZVPAYTIT .
  types:
TT_DELTALINKSOFFACTSOFZVPAYTIT type standard table of TS_DELTALINKSOFFACTSOFZVPAYTIT .
  types:
  begin of TS_FACTSOFZVPAYTITMAGGRGN,
     PAYMENTRUNDATE type string,
     PAYMENTRUNID type C length 6,
     PAYMENTRUNISPROPOSAL type C length 1,
     PAYINGCOMPANYCODE type C length 4,
     SUPPLIER type C length 10,
     CUSTOMER type C length 10,
     PAYMENTRECIPIENT type C length 16,
     PAYMENTDOCUMENT type C length 10,
     AMOUNTINTRANSACTIONCURRENCY type DECFLOAT34,
     HEADERAMTINCOCODECURRENCY type DECFLOAT34,
     WHLDGTAXAMTINTRANSACCRCY type DECFLOAT34,
     WHLDGTAXAMTINCOCODECRCY type DECFLOAT34,
     TOTDEDUCTIONAMTINTRANSACCRCY type DECFLOAT34,
     TOTDEDUCTIONAMTINCOCODECRCY type DECFLOAT34,
     NETAMOUNTINTRANSACCURRENCY type DECFLOAT34,
     NETAMOUNTINCOCODECURRENCY type DECFLOAT34,
     COMPANYCODECURRENCY type C length 5,
     PAYMENTCURRENCY type C length 5,
     FISCALYEAR type C length 4,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_FACTSOFZVPAYTITMAGGRGN .
  types:
TT_FACTSOFZVPAYTITMAGGRGN type standard table of TS_FACTSOFZVPAYTITMAGGRGN .

  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFFACTSOFZVPAYTIT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfFactsOfZVPAYTITMAGGRGN' ##NO_TEXT.
  constants GC_FACTSOFZVPAYTITMAGGRGN type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FactsOfZVPAYTITMAGGRGN' ##NO_TEXT.
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



CLASS ZCL_ZODQ_PAYPROPITMAGG_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_PAYPROPITMAGGRGN_1_MDL_01' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_PAYPROPITMAGGRGN_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_PAYPROPITMAGGRGN_1_SRV_01'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_PAYPROPITMAGGRGN_1_MDL_01'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250813205141'. "#EC NOTEXT
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
