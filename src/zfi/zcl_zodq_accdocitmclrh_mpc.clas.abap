class ZCL_ZODQ_ACCDOCITMCLRH_MPC definition
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
  begin of TS_DELTALINKSOFFACTSOFZVACCCLR,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFFACTSOFZVACCCLR .
  types:
TT_DELTALINKSOFFACTSOFZVACCCLR type standard table of TS_DELTALINKSOFFACTSOFZVACCCLR .
  types:
  begin of TS_FACTSOFZVACCCLRHIST,
     CLEARINGCOMPANYCODE type C length 4,
     CLEARINGACCOUNTINGDOCUMENT type C length 10,
     CLEARINGFISCALYEAR type C length 4,
     CLEARINGINDEX type C length 6,
     CLEAREDCOMPANYCODE type C length 4,
     CLEAREDACCOUNTINGDOCUMENT type C length 10,
     CLEAREDFISCALYEAR type C length 4,
     CLEAREDACCOUNTINGDOCUMENTITEM type C length 3,
     CLEARINGITEM type P length 5 decimals 0,
     CLEARINGDOWNPAYMENTITEM type C length 3,
     CLEARINGTYPE type C length 1,
     CLEARINGTRANSACTIONCURRENCY type C length 5,
     CLEARINGCOMPANYCODECURRENCY type C length 5,
     FINANCIALACCOUNTTYPE type C length 1,
     AMOUNTINCOMPANYCODECURRENCY type DECFLOAT34,
     AMOUNTININCLRGTRANSCRCY type DECFLOAT34,
     DIFFERENCEAMTINCOCODECRCY type DECFLOAT34,
     DIFFERENCEAMTINCLRGTRANSCRCY type DECFLOAT34,
     CASHDISCOUNTAMTINCOCODECRCY type DECFLOAT34,
     CASHDISCOUNTAMTINCLRGTRANSCRCY type DECFLOAT34,
     EXCHRATEDIFFAMTINCOCODECRCY type DECFLOAT34,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_FACTSOFZVACCCLRHIST .
  types:
TT_FACTSOFZVACCCLRHIST type standard table of TS_FACTSOFZVACCCLRHIST .

  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFFACTSOFZVACCCLR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfFactsOfZVACCCLRHIST' ##NO_TEXT.
  constants GC_FACTSOFZVACCCLRHIST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FactsOfZVACCCLRHIST' ##NO_TEXT.
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

  methods CREATE_NEW_ARTIFACTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZODQ_ACCDOCITMCLRH_MPC IMPLEMENTATION.


  method CREATE_NEW_ARTIFACTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
  lo_entity_type    TYPE REF TO /iwbep/if_mgw_odata_entity_typ,                      "#EC NEEDED
  lo_complex_type   TYPE REF TO /iwbep/if_mgw_odata_cmplx_type,                      "#EC NEEDED
  lo_property       TYPE REF TO /iwbep/if_mgw_odata_property,                        "#EC NEEDED
  lo_association    TYPE REF TO /iwbep/if_mgw_odata_assoc,                           "#EC NEEDED
  lo_assoc_set      TYPE REF TO /iwbep/if_mgw_odata_assoc_set,                       "#EC NEEDED
  lo_ref_constraint TYPE REF TO /iwbep/if_mgw_odata_ref_constr,                      "#EC NEEDED
  lo_nav_property   TYPE REF TO /iwbep/if_mgw_odata_nav_prop,                        "#EC NEEDED
  lo_action         TYPE REF TO /iwbep/if_mgw_odata_action,                          "#EC NEEDED
  lo_parameter      TYPE REF TO /iwbep/if_mgw_odata_property,                        "#EC NEEDED
  lo_entity_set     TYPE REF TO /iwbep/if_mgw_odata_entity_set.                      "#EC NEEDED


***********************************************************************************************************************************
*   ENTITY - DeltaLinksOfFactsOfZVACCCLRHIST
***********************************************************************************************************************************
lo_entity_type = model->create_entity_type( iv_entity_type_name = 'DeltaLinksOfFactsOfZVACCCLRHIST' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'DeltaToken' iv_abap_fieldname = 'DELTA_TOKEN' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CreatedAt' iv_abap_fieldname = 'CREATED_AT' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'IsInitialLoad' iv_abap_fieldname = 'IS_INITIAL_LOAD' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZODQ_ACCDOCITMCLRH_MPC=>TS_DELTALINKSOFFACTSOFZVACCCLR' ). "#EC NOTEXT


lo_entity_type = model->create_entity_type( iv_entity_type_name = 'FactsOfZVACCCLRHIST' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGCOMPANYCODE' iv_abap_fieldname = 'CLEARINGCOMPANYCODE' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGACCOUNTINGDOCUMENT' iv_abap_fieldname = 'CLEARINGACCOUNTINGDOCUMENT' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGFISCALYEAR' iv_abap_fieldname = 'CLEARINGFISCALYEAR' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGINDEX' iv_abap_fieldname = 'CLEARINGINDEX' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 6 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEAREDCOMPANYCODE' iv_abap_fieldname = 'CLEAREDCOMPANYCODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEAREDACCOUNTINGDOCUMENT' iv_abap_fieldname = 'CLEAREDACCOUNTINGDOCUMENT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEAREDFISCALYEAR' iv_abap_fieldname = 'CLEAREDFISCALYEAR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEAREDACCOUNTINGDOCUMENTITEM' iv_abap_fieldname = 'CLEAREDACCOUNTINGDOCUMENTITEM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGITEM' iv_abap_fieldname = 'CLEARINGITEM' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_maxlength( iv_max_length = 9 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGDOWNPAYMENTITEM' iv_abap_fieldname = 'CLEARINGDOWNPAYMENTITEM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGTYPE' iv_abap_fieldname = 'CLEARINGTYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGTRANSACTIONCURRENCY' iv_abap_fieldname = 'CLEARINGTRANSACTIONCURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_semantic( 'currency-code' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CLEARINGCOMPANYCODECURRENCY' iv_abap_fieldname = 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_semantic( 'currency-code' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'FINANCIALACCOUNTTYPE' iv_abap_fieldname = 'FINANCIALACCOUNTTYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AMOUNTINCOMPANYCODECURRENCY' iv_abap_fieldname = 'AMOUNTINCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AMOUNTININCLRGTRANSCRCY' iv_abap_fieldname = 'AMOUNTININCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGTRANSACTIONCURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DIFFERENCEAMTINCOCODECRCY' iv_abap_fieldname = 'DIFFERENCEAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DIFFERENCEAMTINCLRGTRANSCRCY' iv_abap_fieldname = 'DIFFERENCEAMTINCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGTRANSACTIONCURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CASHDISCOUNTAMTINCOCODECRCY' iv_abap_fieldname = 'CASHDISCOUNTAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CASHDISCOUNTAMTINCLRGTRANSCRCY' iv_abap_fieldname = 'CASHDISCOUNTAMTINCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGTRANSACTIONCURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'EXCHRATEDIFFAMTINCOCODECRCY' iv_abap_fieldname = 'EXCHRATEDIFFAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ).
lo_property->set_maxlength( iv_max_length = 45 ).
lo_property->set_unit_property( 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ODQ_CHANGEMODE' iv_abap_fieldname = 'ODQ_CHANGEMODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ODQ_ENTITYCNTR' iv_abap_fieldname = 'ODQ_ENTITYCNTR' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_maxlength( iv_max_length = 37 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZODQ_ACCDOCITMCLRH_MPC=>TS_FACTSOFZVACCCLRHIST' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_type = model->get_entity_type( iv_entity_name = 'DeltaLinksOfFactsOfZVACCCLRHIST' ). "#EC NOTEXT
lo_entity_set = lo_entity_type->create_entity_set( 'DeltaLinksOfFactsOfZVACCCLRHIST' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
lo_entity_type = model->get_entity_type( iv_entity_name = 'FactsOfZVACCCLRHIST' ). "#EC NOTEXT
lo_entity_set = lo_entity_type->create_entity_set( 'FactsOfZVACCCLRHIST' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_true ).
lo_entity_set->set_updatable( abap_true ).
lo_entity_set->set_deletable( abap_true ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).


***********************************************************************************************************************************
*   ACTION - SubscribedToFactsOfZVACCCLRHIST
***********************************************************************************************************************************

lo_action = model->create_action( 'SubscribedToFactsOfZVACCCLRHIST' ). "#EC NOTEXT
*Set return complex type
lo_action->set_return_complex_type( 'ChangeTrackingDetails' ). "#EC NOTEXT
*Set HTTP method GET or POST
lo_action->set_http_method( 'GET' )."#EC NOTEXT
* Set return type multiplicity
lo_action->set_return_multiplicity( '1' ). "#EC NOTEXT
***********************************************************************************************************************************
*   ACTION - TerminateDeltasForFactsOfZVACCCLRHIST
***********************************************************************************************************************************

lo_action = model->create_action( 'TerminateDeltasForFactsOfZVACCCLRHIST' ). "#EC NOTEXT
*Set return complex type
lo_action->set_return_complex_type( 'SubscriptionTerminationDetails' ). "#EC NOTEXT
*Set HTTP method GET or POST
lo_action->set_http_method( 'GET' )."#EC NOTEXT
* Set return type multiplicity
lo_action->set_return_multiplicity( '1' ). "#EC NOTEXT

***********************************************************************************************************************************
*   new_associations
***********************************************************************************************************************************

 lo_association = model->create_association(
                            iv_association_name = 'factsOfZVACCCLRHIST' "#EC NOTEXT
                            iv_left_type        = 'DeltaLinksOfFactsOfZVACCCLRHIST' "#EC NOTEXT
                            iv_right_type       = 'FactsOfZVACCCLRHIST' "#EC NOTEXT
                            iv_right_card       = 'M' "#EC NOTEXT
                            iv_left_card        = '1' ). "#EC NOTEXT
* Association Sets for association - factsOfZVACCCLRHIST
lo_assoc_set = lo_association->create_assoc_set( iv_assoc_set_name = 'factsOfZVACCCLRHIST_AssocSet' ). "#EC NOTEXT


* Navigation Properties for entity - DeltaLinksOfFactsOfZVACCCLRHIST
lo_entity_type = model->get_entity_type( iv_entity_name = 'DeltaLinksOfFactsOfZVACCCLRHIST' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'ChangesAfter' "#EC NOTEXT
                                                          iv_association_name = 'factsOfZVACCCLRHIST' ). "#EC NOTEXT
  endmethod.


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
model->extend_model( iv_model_name = 'ZODQ_ACCDOCITMCLRHIST_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_ACCDOCITMCLRHIST_SRV' ).


*
* Disable all the entity types that were disabled from reference model
*
* Disable entity type 'AttrOfI_OPLACCTGDOCITEMCLRGHIST'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'AttrOfI_OPLACCTGDOCITEMCLRGHIST' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGCOMPANYCODE' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGACCOUNTINGDOCUMENT' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGFISCALYEAR' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGINDEX' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEAREDCOMPANYCODE' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEAREDACCOUNTINGDOCUMENT' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEAREDFISCALYEAR' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEAREDACCOUNTINGDOCUMENTITEM' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGITEM' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGDOWNPAYMENTITEM' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGTYPE' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGTRANSACTIONCURRENCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CLEARINGCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'FINANCIALACCOUNTTYPE' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'AMOUNTINCOMPANYCODECURRENCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'AMOUNTININCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DIFFERENCEAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DIFFERENCEAMTINCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CASHDISCOUNTAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CASHDISCOUNTAMTINCLRGTRANSCRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'EXCHRATEDIFFAMTINCOCODECRCY' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ODQ_CHANGEMODE' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ODQ_ENTITYCNTR' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


endif.

* Disable entity type 'DLinksOfI_OPLACCTGDOCITEMCLRGHIST$P'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'DLinksOfI_OPLACCTGDOCITEMCLRGHIST$P' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DeltaToken' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CreatedAt' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'IsInitialLoad' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

* Disable all the navigation properties for this entity type
try.
lo_nav_property = lo_entity_type->get_navigation_property( iv_name    = 'ChangesAfter' ). "#EC NOTEXT
lo_nav_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

endif.


*
*Disable all the entity sets that were disabled from reference model
*
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'AttrOfI_OPLACCTGDOCITEMCLRGHIST' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'DLinksOfI_OPLACCTGDOCITEMCLRGHIST$P' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


*
*Disable all the associations, association sets that were disabled from reference model
*
try.
lo_association = model->get_association( iv_association_name = 'attrOfI_OPLACCTGDOCITEMCLRGHIST' ). "#EC NOTEXT
lo_association->set_disabled( iv_disabled = abap_true ).
lo_ref_constraint = lo_association->get_ref_constraint( ).
lo_ref_constraint->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


try.
lo_assoc_set  = model->get_association_set( iv_assoc_set_name = 'attrOfI_OPLACCTGDOCITEMCLRGHIST_AssocSet' ). "#EC NOTEXT
IF lo_assoc_set IS BOUND.
lo_assoc_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


*
* Disable the actions
*
try.
lo_action = model->get_action( iv_action_name = 'SubscrToI_OPLACCTGDOCITEMCLRGHIST$P' ). "#EC NOTEXT
lo_action->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_action = model->get_action( iv_action_name = 'TDeltForI_OPLACCTGDOCITEMCLRGHIST$P' ). "#EC NOTEXT
lo_action->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
* New artifacts have been created in the service builder after the redefinition of service
create_new_artifacts( ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_ACCDOCITMCLRHIST_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_ACCDOCITMCLRHIST_1_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250805141130'. "#EC NOTEXT
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
