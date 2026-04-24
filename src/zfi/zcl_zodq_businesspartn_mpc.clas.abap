class ZCL_ZODQ_BUSINESSPARTN_MPC definition
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
  begin of TS_ATTROFIBUSINESSPARTNER,
     BUSINESSPARTNER type C length 10,
     BUSINESSPARTNERCATEGORY type C length 1,
     AUTHORIZATIONGROUP type C length 4,
     BUSINESSPARTNERUUID type string,
     PERSONNUMBER type C length 10,
     ETAG type C length 26,
     BUSINESSPARTNERNAME type C length 81,
     BUSINESSPARTNERFULLNAME type C length 81,
     CREATEDBYUSER type C length 12,
     CREATIONDATE type TIMESTAMP,
     CREATIONTIME type T,
     LASTCHANGEDBYUSER type C length 12,
     LASTCHANGEDATE type TIMESTAMP,
     LASTCHANGETIME type T,
     BUSINESSPARTNERISBLOCKED type C length 1,
     ISBUSINESSPURPOSECOMPLETED type C length 1,
     FIRSTNAME type C length 40,
     LASTNAME type C length 40,
     PERSONFULLNAME type C length 80,
     ORGANIZATIONBPNAME1 type C length 40,
     ORGANIZATIONBPNAME2 type C length 40,
     ORGANIZATIONBPNAME3 type C length 40,
     ORGANIZATIONBPNAME4 type C length 40,
     INTERNATIONALLOCATIONNUMBER1 type C length 7,
     INTERNATIONALLOCATIONNUMBER2 type C length 5,
     INTERNATIONALLOCATIONNUMBER3 type C length 1,
     LEGALFORM type C length 2,
     ORGANIZATIONFOUNDATIONDATE type TIMESTAMP,
     ORGANIZATIONLIQUIDATIONDATE type TIMESTAMP,
     INDUSTRY type C length 10,
     ISNATURALPERSON type C length 1,
     ISFEMALE type C length 1,
     ISMALE type C length 1,
     ISSEXUNKNOWN type C length 1,
     FORMOFADDRESS type C length 4,
     ACADEMICTITLE type C length 4,
     ACADEMICTITLE2 type C length 4,
     NAMEFORMAT type C length 2,
     NAMECOUNTRY type C length 3,
     BUSINESSPARTNERGROUPING type C length 4,
     BUSINESSPARTNERTYPE type C length 4,
     MIDDLENAME type C length 40,
     ADDITIONALLASTNAME type C length 40,
     GROUPBUSINESSPARTNERNAME1 type C length 40,
     GROUPBUSINESSPARTNERNAME2 type C length 40,
     CORRESPONDENCELANGUAGE type C length 2,
     LANGUAGE type C length 2,
     SEARCHTERM1 type C length 20,
     SEARCHTERM2 type C length 20,
     BPLASTNAMESEARCHHELP type C length 35,
     BPFIRSTNAMESEARCHHELP type C length 35,
     BUSINESSPARTNERNICKNAMELABEL type C length 40,
     INDEPENDENTADDRESSID type C length 10,
     ISACTIVEENTITY type C length 1,
     BIRTHDATE type TIMESTAMP,
     ISMARKEDFORARCHIVING type C length 1,
     CONTACTPERMISSION type C length 1,
     BUSINESSPARTNERIDBYEXTSYSTEM type C length 20,
     LEGALENTITYOFORGANIZATION type C length 2,
     BUSINESSPARTNERPRINTFORMAT type C length 1,
     BUSINESSPARTNERDATAORIGINTYPE type C length 4,
     BUSINESSPARTNERISNOTRELEASED type C length 1,
     ISNOTCONTRACTUALLYCAPABLE type C length 1,
     BUSINESSPARTNEROCCUPATION type C length 4,
     BUSPARTMARITALSTATUS type C length 1,
     BUSPARTNATIONALITY type C length 3,
     NONRESIDENTCOMPANYORIGINCNTRY type C length 3,
     BUSINESSPARTNERSALUTATION type C length 50,
     BUSINESSPARTNERBIRTHNAME type C length 40,
     BUSINESSPARTNERSUPPLEMENTNAME type C length 4,
     BUSINESSPARTNERBIRTHPLACENAME type C length 40,
     NATURALPERSONEMPLOYERNAME type C length 35,
     BUSINESSPARTNERDEATHDATE type TIMESTAMP,
     BUSINESSPARTNERBIRTHDATESTATUS type C length 1,
     BUSINESSPARTNERGROUPTYPE type C length 4,
     LASTNAMEPREFIX type C length 4,
     LASTNAMESECONDPREFIX type C length 4,
     INITIALS type C length 10,
     GENDERCODENAME type C length 1,
     DATACONTROLLERSET type C length 1,
     DATACONTROLLER1 type C length 30,
     DATACONTROLLER2 type C length 30,
     DATACONTROLLER3 type C length 30,
     DATACONTROLLER4 type C length 30,
     DATACONTROLLER5 type C length 30,
     DATACONTROLLER6 type C length 30,
     DATACONTROLLER7 type C length 30,
     DATACONTROLLER8 type C length 30,
     DATACONTROLLER9 type C length 30,
     DATACONTROLLER10 type C length 30,
     BPDATACONTROLLERISNOTREQUIRED type C length 1,
     TRDCMPLNCLICENSEISMILITARYSCTR type C length 1,
     TRDCMPLNCLICENSEISNUCLEARSCTR type C length 1,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_ATTROFIBUSINESSPARTNER .
  types:
TT_ATTROFIBUSINESSPARTNER type standard table of TS_ATTROFIBUSINESSPARTNER .
  types:
  begin of TS_DELTALINKSOFATTROFIBUSINESS,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFATTROFIBUSINESS .
  types:
TT_DELTALINKSOFATTROFIBUSINESS type standard table of TS_DELTALINKSOFATTROFIBUSINESS .

  constants GC_ATTROFIBUSINESSPARTNER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AttrOfIBUSINESSPARTNER' ##NO_TEXT.
  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFATTROFIBUSINESS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfAttrOfIBUSINESSPARTNER' ##NO_TEXT.
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



CLASS ZCL_ZODQ_BUSINESSPARTN_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_BUSINESSPARTNER_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_BUSINESSPARTNER_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_BUSINESSPARTNER_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_BUSINESSPARTNER_1_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250611180556'. "#EC NOTEXT
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
