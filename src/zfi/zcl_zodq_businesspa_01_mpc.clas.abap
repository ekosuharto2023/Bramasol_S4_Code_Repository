class ZCL_ZODQ_BUSINESSPA_01_MPC definition
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
  begin of TS_ATTROFIBUPAADDRESS,
     BUSINESSPARTNER type C length 10,
     ADDRESSID type C length 10,
     ADDRESSUUID type string,
     VALIDITYSTARTDATE type P length 15 decimals 0,
     VALIDITYENDDATE type P length 15 decimals 0,
     ADDRESSIDBYEXTERNALSYSTEM type C length 20,
     BPTARGETADDRESSID type C length 10,
     BPADDRESSMOVEDATETIME type P length 15 decimals 0,
     AUTHORIZATIONGROUP type C length 4,
     ISBUSINESSPURPOSECOMPLETED type C length 1,
     CAREOFNAME type C length 40,
     FORMOFADDRESS type C length 4,
     FULLNAME type C length 80,
     HOUSENUMBER type C length 10,
     STREETNAME type C length 60,
     HOUSENUMBERSUPPLEMENTTEXT type C length 10,
     DISTRICT type C length 40,
     POSTALCODE type C length 10,
     CITYNAME type C length 40,
     COUNTRY type C length 3,
     REGION type C length 3,
     ADDRESSTIMEZONE type C length 6,
     TAXJURISDICTION type C length 15,
     TRANSPORTZONE type C length 10,
     COMPANYPOSTALCODE type C length 10,
     DELIVERYSERVICENUMBER type C length 10,
     POBOX type C length 10,
     POBOXISWITHOUTNUMBER type C length 1,
     POBOXPOSTALCODE type C length 10,
     POBOXLOBBYNAME type C length 40,
     POBOXDEVIATINGCITYNAME type C length 40,
     POBOXDEVIATINGREGION type C length 3,
     POBOXDEVIATINGCOUNTRY type C length 3,
     CORRESPONDENCELANGUAGE type C length 2,
     PRFRDCOMMMEDIUMTYPE type C length 3,
     STREETPREFIXNAME type C length 40,
     ADDITIONALSTREETPREFIXNAME type C length 40,
     STREETSUFFIXNAME type C length 40,
     ADDITIONALSTREETSUFFIXNAME type C length 40,
     HOMECITYNAME type C length 40,
     DELIVERYSERVICETYPECODE type C length 4,
     ADDRESSSTREETUNUSABLE type C length 4,
     ADDRESSPOSTBOXUNUSABLE type C length 4,
     BUILDING type C length 20,
     FLOOR type C length 10,
     ROOMNUMBER type C length 10,
     COUNTY type C length 40,
     COUNTYCODE type C length 8,
     TOWNSHIPCODE type C length 8,
     TOWNSHIPNAME type C length 40,
     CITYFILETESTSTATUS type C length 1,
     PHONENUMBER type C length 30,
     PHONENUMBERCOUNTRY type C length 3,
     PHONENUMBEREXTENSION type C length 10,
     FAXNUMBER type C length 30,
     FAXCOUNTRY type C length 3,
     FAXNUMBEREXTENSION type C length 10,
     MOBILEPHONENUMBER type C length 30,
     MOBILEPHONECOUNTRY type C length 3,
     EMAILADDRESS type C length 241,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_ATTROFIBUPAADDRESS .
  types:
TT_ATTROFIBUPAADDRESS type standard table of TS_ATTROFIBUPAADDRESS .
  types:
  begin of TS_DELTALINKSOFATTROFIBUPAADDR,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFATTROFIBUPAADDR .
  types:
TT_DELTALINKSOFATTROFIBUPAADDR type standard table of TS_DELTALINKSOFATTROFIBUPAADDR .

  constants GC_ATTROFIBUPAADDRESS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AttrOfIBUPAADDRESS' ##NO_TEXT.
  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFATTROFIBUPAADDR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfAttrOfIBUPAADDRESS' ##NO_TEXT.
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



CLASS ZCL_ZODQ_BUSINESSPA_01_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_BUSINESSPARTNERADDRESS_1_MD' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_BUSINESSPARTNERADDRESS_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_BUSINESSPARTNERADDRESS_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_BUSINESSPARTNERADDRESS_1_MD'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250807203722'. "#EC NOTEXT
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
