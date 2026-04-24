class ZCL_ZODQ_SUPPLIERINVOI_MPC definition
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
  begin of TS_DELTALINKSOFFACTSOFZVSUPPLI,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFFACTSOFZVSUPPLI .
  types:
TT_DELTALINKSOFFACTSOFZVSUPPLI type standard table of TS_DELTALINKSOFFACTSOFZVSUPPLI .
  types:
  begin of TS_FACTSOFZVSUPPLIERINV,
     SUPPLIERINVOICE type C length 10,
     FISCALYEAR type C length 4,
     SUPPLIERINVOICEWTHNFISCALYEAR type C length 14,
     COMPANYCODE type C length 4,
     DOCUMENTDATE type TIMESTAMP,
     POSTINGDATE type TIMESTAMP,
     SUPPLIERINVOICEIDBYINVCGPARTY type C length 16,
     INVOICINGPARTY type C length 10,
     ISINVOICE type C length 1,
     DOCUMENTCURRENCY type C length 5,
     INVOICEGROSSAMOUNT type DECFLOAT34,
     EXCHANGERATE type DECFLOAT34,
     ACCOUNTINGDOCUMENTTYPE type C length 2,
     SUPPLIERINVOICESTATUS type C length 1,
     SUPPLIERINVOICEORIGIN type C length 1,
     CREATEDBYUSER type C length 12,
     LASTCHANGEDBYUSER type C length 12,
     INVOICEREFERENCE type C length 10,
     INVOICEREFERENCEFISCALYEAR type C length 4,
     ASSIGNMENTREFERENCE type C length 18,
     TAXISCALCULATEDAUTOMATICALLY type C length 1,
     BUSINESSPLACE type C length 4,
     CREATIONDATE type TIMESTAMP,
     UNPLANNEDDELIVERYCOST type DECFLOAT34,
     UNPLANNEDDELIVERYCOSTTAXCODE type C length 2,
     UNPLNDDELIVCOSTTAXJURISDICTION type C length 15,
     DOCUMENTHEADERTEXT type C length 25,
     SUPPLIERPOSTINGLINEITEMTEXT type C length 50,
     PAYMENTTERMS type C length 4,
     DUECALCULATIONBASEDATE type TIMESTAMP,
     CASHDISCOUNT1PERCENT type DECFLOAT34,
     CASHDISCOUNT1DAYS type P length 3 decimals 0,
     CASHDISCOUNT2PERCENT type DECFLOAT34,
     CASHDISCOUNT2DAYS type P length 3 decimals 0,
     NETPAYMENTDAYS type P length 3 decimals 0,
     MANUALCASHDISCOUNT type DECFLOAT34,
     FIXEDCASHDISCOUNT type C length 1,
     STATECENTRALBANKPAYMENTREASON type C length 3,
     SUPPLYINGCOUNTRY type C length 3,
     BPBANKACCOUNTINTERNALID type C length 4,
     PAYMENTMETHOD type C length 1,
     PAYMENTREFERENCE type C length 30,
     PAYTSLIPWTHREFSUBSCRIBER type C length 11,
     PAYTSLIPWTHREFCHECKDIGIT type C length 2,
     PAYTSLIPWTHREFREFERENCE type C length 27,
     PAYMENTREASON type C length 4,
     REVERSEDOCUMENT type C length 10,
     REVERSEDOCUMENTFISCALYEAR type C length 4,
     SUPLRINVCMANUALLYREDUCEDAMOUNT type DECFLOAT34,
     SUPLRINVCAUTOMREDUCEDAMOUNT type DECFLOAT34,
     TAXDETERMINATIONDATE type TIMESTAMP,
     TAXREPORTINGDATE type TIMESTAMP,
     TAXFULFILLMENTDATE type TIMESTAMP,
     TAXCOUNTRY type C length 3,
     UNPLNDDELIVERYCOSTTAXCOUNTRY type C length 3,
     DELIVERYOFGOODSREPORTINGCNTRY type C length 3,
     SUPPLIERVATREGISTRATION type C length 20,
     ISEUTRIANGULARDEAL type C length 1,
     SUPLRINVCDEBITCRDTCODEDELIVERY type C length 1,
     SUPLRINVCDEBITCRDTCODERETURNS type C length 1,
     ELECTRONICINVOICEUUID type C length 36,
     JRNLENTRYCNTRYSPECIFICREF1 type C length 80,
     JRNLENTRYCNTRYSPECIFICDATE1 type TIMESTAMP,
     JRNLENTRYCNTRYSPECIFICREF2 type C length 25,
     JRNLENTRYCNTRYSPECIFICDATE2 type TIMESTAMP,
     JRNLENTRYCNTRYSPECIFICREF3 type C length 25,
     JRNLENTRYCNTRYSPECIFICDATE3 type TIMESTAMP,
     JRNLENTRYCNTRYSPECIFICREF4 type C length 50,
     JRNLENTRYCNTRYSPECIFICDATE4 type TIMESTAMP,
     JRNLENTRYCNTRYSPECIFICREF5 type C length 50,
     JRNLENTRYCNTRYSPECIFICDATE5 type TIMESTAMP,
     JRNLENTRYCNTRYSPECIFICBP1 type C length 10,
     JRNLENTRYCNTRYSPECIFICBP2 type C length 10,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_FACTSOFZVSUPPLIERINV .
  types:
TT_FACTSOFZVSUPPLIERINV type standard table of TS_FACTSOFZVSUPPLIERINV .

  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFFACTSOFZVSUPPLI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfFactsOfZVSUPPLIERINV' ##NO_TEXT.
  constants GC_FACTSOFZVSUPPLIERINV type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FactsOfZVSUPPLIERINV' ##NO_TEXT.
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



CLASS ZCL_ZODQ_SUPPLIERINVOI_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_SUPPLIERINVOICE_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_SUPPLIERINVOICE_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_SUPPLIERINVOICE_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_SUPPLIERINVOICE_1_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250613130441'. "#EC NOTEXT
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
