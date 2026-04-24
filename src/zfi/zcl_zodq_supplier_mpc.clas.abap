class ZCL_ZODQ_SUPPLIER_MPC definition
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
  begin of TS_ATTROFI_SUPPLIER_CDS,
     SUPPLIER type C length 10,
     SUPPLIERACCOUNTGROUP type C length 4,
     SUPPLIERNAME type C length 80,
     SUPPLIERFULLNAME type C length 220,
     BPSUPPLIERNAME type C length 81,
     BPSUPPLIERFULLNAME type C length 163,
     BUSINESSPARTNERNAME1 type C length 40,
     BUSINESSPARTNERNAME2 type C length 40,
     BUSINESSPARTNERNAME3 type C length 40,
     BUSINESSPARTNERNAME4 type C length 40,
     BPADDRCITYNAME type C length 40,
     BPADDRSTREETNAME type C length 60,
     ADDRESSSEARCHTERM1 type C length 20,
     ADDRESSSEARCHTERM2 type C length 20,
     DISTRICTNAME type C length 40,
     POBOXDEVIATINGCITYNAME type C length 40,
     BUSINESSPARTNERFORMOFADDRESS type C length 4,
     ISBUSINESSPURPOSECOMPLETED type C length 1,
     CREATEDBYUSER type C length 12,
     CREATIONDATE type TIMESTAMP,
     ISONETIMEACCOUNT type C length 1,
     AUTHORIZATIONGROUP type C length 4,
     VATREGISTRATION type C length 20,
     ACCOUNTISBLOCKEDFORPOSTING type C length 1,
     TAXJURISDICTION type C length 15,
     SUPPLIERSTANDARDCARRIERACCESS type C length 4,
     SUPPLIERFWDAGENTFREIGHTGROUP type C length 4,
     SUPPLIERAGENTPROCEDUREGROUP type C length 4,
     SUPPLISSOCIALINSURANCEREGTRD type C length 1,
     SOCIALINSURANCEACTIVITYCODE type C length 3,
     SUPPLIERCORPORATEGROUP type C length 10,
     CUSTOMER type C length 10,
     INDUSTRY type C length 4,
     TAXNUMBER1 type C length 16,
     TAXNUMBER2 type C length 11,
     TAXNUMBER3 type C length 18,
     TAXNUMBER4 type C length 18,
     TAXNUMBER5 type C length 60,
     TAXNUMBER6 type C length 20,
     POSTINGISBLOCKED type C length 1,
     PURCHASINGISBLOCKED type C length 1,
     INTERNATIONALLOCATIONNUMBER1 type C length 7,
     INTERNATIONALLOCATIONNUMBER2 type C length 5,
     INTERNATIONALLOCATIONNUMBER3 type C length 1,
     ADDRESSID type C length 10,
     REGION type C length 3,
     ORGANIZATIONBPNAME1 type C length 35,
     ORGANIZATIONBPNAME2 type C length 35,
     CITYNAME type C length 35,
     POSTALCODE type C length 10,
     STREETNAME type C length 35,
     COUNTRY type C length 3,
     CONCATENATEDINTERNATIONALLOCNO type C length 20,
     SUPPLIERPROCUREMENTBLOCK type C length 2,
     SUPLRQUALITYMANAGEMENTSYSTEM type C length 4,
     SUPLRQLTYINPROCMTCERTFNVALIDTO type TIMESTAMP,
     SUPPLIERLANGUAGE type C length 2,
     ALTERNATIVEPAYEEACCOUNTNUMBER type C length 10,
     PHONENUMBER1 type C length 16,
     FAXNUMBER type C length 31,
     ISNATURALPERSON type C length 1,
     TAXNUMBERRESPONSIBLE type C length 18,
     UK_CONTRACTORBUSINESSTYPE type C length 12,
     UK_PARTNERTRADINGNAME type C length 30,
     UK_PARTNERTAXREFERENCE type C length 20,
     UK_VERIFICATIONSTATUS type C length 3,
     UK_VERIFICATIONNUMBER type C length 20,
     UK_COMPANYREGISTRATIONNUMBER type C length 8,
     UK_VERIFIEDTAXSTATUS type C length 1,
     FORMOFADDRESS type C length 15,
     REFERENCEACCOUNTGROUP type C length 4,
     VATLIABILITY type C length 1,
     RESPONSIBLETYPE type C length 2,
     TAXNUMBERTYPE type C length 2,
     FISCALADDRESS type C length 10,
     BUSINESSTYPE type C length 30,
     BIRTHDATE type TIMESTAMP,
     PAYMENTISBLOCKEDFORSUPPLIER type C length 1,
     SORTFIELD type C length 10,
     PHONENUMBER2 type C length 16,
     DELETIONINDICATOR type C length 1,
     TAXINVOICEREPRESENTATIVENAME type C length 10,
     INDUSTRYTYPE type C length 30,
     IN_GSTSUPPLIERCLASSIFICATION type C length 1,
     SUPLRPROOFOFDELIVRLVTCODE type C length 1,
     TRADINGPARTNER type C length 6,
     BR_TAXISSPLIT type C length 1,
     AU_PAYERISPAYINGTOCARRYONENT type C length 1,
     AU_INDIVIDUALISUNDER18 type C length 1,
     AU_PAYMENTISEXCEEDING75 type C length 1,
     AU_PAYMENTISWHOLLYINPUTTAXED type C length 1,
     AU_PARTNERISSUPPLYWITHOUTGAIN type C length 1,
     AU_SUPPLIERISENTITLEDTOABN type C length 1,
     AU_PAYMENTISINCOMEEXEMPTED type C length 1,
     AU_SUPPLYISMADEASPRIVATEHOBBY type C length 1,
     AU_SUPPLYMADEISOFDMSTCNATURE type C length 1,
     ISTOBEACCEPTEDATORIGIN type C length 1,
     BPISEQUALIZATIONTAXSUBJECT type C length 1,
     BRSPCFCTAXBASEPERCENTAGECODE type C length 1,
     SUPPLIERPROFESSION type C length 30,
     SUPLRMANUFACTUREREXTERNALNAME type C length 10,
     DATAMEDIUMEXCHANGEINDICATOR type C length 1,
     DATAEXCHANGEINSTRUCTIONKEY type C length 2,
     SUPPLIERISSUBRANGERELEVANT type C length 1,
     TRAINSTATIONNAME type C length 25,
     ALTERNATIVEPAYEEISALLOWED type C length 1,
     PAYTSLIPWTHREFSUBSCRIBER type C length 11,
     TRANSPSERVICEAGENTSTSTCGRP type C length 2,
     SUPPLIERISPLANTRELEVANT type C length 1,
     SUPLRTAXAUTHORITYACCOUNTNUMBER type C length 10,
     SUPLRCARRIERCONFIRMISEXPECTED type C length 1,
     SUPPLIERPLANT type C length 4,
     FACTORYCALENDAR type C length 2,
     PAYMENTREASON type C length 4,
     SUPPLIERCENTRALDELETIONISBLOCK type C length 1,
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
     SUPPLIERTRANSPORTATIONCHAIN type C length 10,
     SUPPLIERSTAGINGTIMEINDAYS type P length 3 decimals 0,
     SUPPLIERSCHEDULINGPROCEDURE type C length 1,
     COLLECTIVENUMBERINGISRELEVANT type C length 1,
     BUSINESSPARTNERPANNUMBER type C length 40,
     BPPANREFERENCENUMBER type C length 40,
     BPPANVALIDFROMDATE type TIMESTAMP,
     ODQ_CHANGEMODE type C length 1,
     ODQ_ENTITYCNTR type DECFLOAT34,
  end of TS_ATTROFI_SUPPLIER_CDS .
  types:
TT_ATTROFI_SUPPLIER_CDS type standard table of TS_ATTROFI_SUPPLIER_CDS .
  types:
  begin of TS_DELTALINKSOFATTROFI_SUPPLIE,
     DELTA_TOKEN type string,
     CREATED_AT type TIMESTAMP,
     IS_INITIAL_LOAD type FLAG,
  end of TS_DELTALINKSOFATTROFI_SUPPLIE .
  types:
TT_DELTALINKSOFATTROFI_SUPPLIE type standard table of TS_DELTALINKSOFATTROFI_SUPPLIE .

  constants GC_ATTROFI_SUPPLIER_CDS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AttrOfI_SUPPLIER_CDS' ##NO_TEXT.
  constants GC_CHANGETRACKINGDETAILS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ChangeTrackingDetails' ##NO_TEXT.
  constants GC_DELTALINKSOFATTROFI_SUPPLIE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DeltaLinksOfAttrOfI_SUPPLIER_CDS' ##NO_TEXT.
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



CLASS ZCL_ZODQ_SUPPLIER_MPC IMPLEMENTATION.


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
model->extend_model( iv_model_name = 'ZODQ_SUPPLIER_1_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'ZODQ_SUPPLIER_SRV' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'ZODQ_SUPPLIER_1_SRV'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'ZODQ_SUPPLIER_1_MDL'.                    "#EC NOTEXT
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


  constants: lc_gen_date_time type timestamp value '20250801182910'. "#EC NOTEXT
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
