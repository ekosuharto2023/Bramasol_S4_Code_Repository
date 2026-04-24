class ZCL_ZCDS_INV_CAT_1099_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
    begin of TS_I_COUNTRYVHTYPE.
      include type I_COUNTRYVH.
  types:
      T_COUNTRY type I_COUNTRYTEXT-COUNTRYNAME,
    end of TS_I_COUNTRYVHTYPE .
  types:
   TT_I_COUNTRYVHTYPE type standard table of TS_I_COUNTRYVHTYPE .
  types:
    begin of TS_I_WITHHOLDINGTAXCODEVHTYPE.
      include type I_WITHHOLDINGTAXCODEVH.
  types:
      T_WITHHOLDINGTAXCODE type I_EXTENDEDWHLDGTAXCODETEXT-WHLDGTAXCODENAME,
      T_REGION type I_REGIONTEXT-REGIONNAME,
      T_WITHHOLDINGTAXINCOMETYPE type I_WITHHOLDINGTAXINCOMETYPETEXT-WITHHOLDINGTAXINCOMETYPENAME,
    end of TS_I_WITHHOLDINGTAXCODEVHTYPE .
  types:
   TT_I_WITHHOLDINGTAXCODEVHTYPE type standard table of TS_I_WITHHOLDINGTAXCODEVHTYPE .
  types:
    begin of TS_ZC_INVOICE_CATEGORYTYPE.
      include type ZC_INVOICE_CATEGORY.
  types:
    end of TS_ZC_INVOICE_CATEGORYTYPE .
  types:
   TT_ZC_INVOICE_CATEGORYTYPE type standard table of TS_ZC_INVOICE_CATEGORYTYPE .
  types:
    begin of TS_ZI_FI_INV_CAT_1099TYPE.
      include type ZI_FI_INV_CAT_1099.
  types:
      M_DELETE type SADL_GW_DYNAMIC_METH_PROPERTY,
      M_UPDATE type SADL_GW_DYNAMIC_METH_PROPERTY,
    end of TS_ZI_FI_INV_CAT_1099TYPE .
  types:
   TT_ZI_FI_INV_CAT_1099TYPE type standard table of TS_ZI_FI_INV_CAT_1099TYPE .

  constants GC_I_COUNTRYVHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_CountryVHType' ##NO_TEXT.
  constants GC_I_WITHHOLDINGTAXCODEVHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_WithholdingTaxCodeVHType' ##NO_TEXT.
  constants GC_ZC_INVOICE_CATEGORYTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZC_INVOICE_CATEGORYType' ##NO_TEXT.
  constants GC_ZI_FI_INV_CAT_1099TYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_FI_INV_CAT_1099Type' ##NO_TEXT.

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZCL_ZCDS_INV_CAT_1099_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZCDS_INV_CAT_1099_SRV' ).

define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
    TRY.
        if_sadl_gw_model_exposure_data~get_model_exposure( )->expose( model )->expose_vocabulary( vocab_anno_model ).
      CATCH cx_sadl_exposure_error INTO DATA(lx_sadl_exposure_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
          EXPORTING
            previous = lx_sadl_exposure_error.
    ENDTRY.
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20251024193359'.                  "#EC NOTEXT
 DATA: lv_rds_last_modified TYPE timestamp .
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
 lv_rds_last_modified =  GET_LAST_MODIFIED_RDS_4( ).
 IF rv_last_modified LT lv_rds_last_modified.
 rv_last_modified  = lv_rds_last_modified .
 ENDIF .
  endmethod.


  method GET_LAST_MODIFIED_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
*    @@TYPE_SWITCH:
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20251024193359'.
    TRY.
        rv_last_modified_rds = CAST cl_sadl_gw_model_exposure( if_sadl_gw_model_exposure_data~get_model_exposure( ) )->get_last_modified( ).
      CATCH cx_root ##CATCH_ALL.
        rv_last_modified_rds = co_gen_date_time.
    ENDTRY.
    IF rv_last_modified_rds < co_gen_date_time.
      rv_last_modified_rds = co_gen_date_time.
    ENDIF.
  endmethod.


  method IF_SADL_GW_MODEL_EXPOSURE_DATA~GET_MODEL_EXPOSURE.
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20251024193359'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="" >|  &
               | <sadl:dataSource type="CDS" name="I_COUNTRYVH" binding="I_COUNTRYVH" />|  &
               | <sadl:dataSource type="CDS" name="I_WITHHOLDINGTAXCODEVH" binding="I_WITHHOLDINGTAXCODEVH" />|  &
               | <sadl:dataSource type="CDS" name="ZC_INVOICE_CATEGORY" binding="ZC_INVOICE_CATEGORY" />|  &
               | <sadl:dataSource type="CDS" name="ZI_FI_INV_CAT_1099" binding="ZI_FI_INV_CAT_1099" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="I_CountryVH" dataSource="I_COUNTRYVH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="I_WithholdingTaxCodeVH" dataSource="I_WITHHOLDINGTAXCODEVH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZC_INVOICE_CATEGORY" dataSource="ZC_INVOICE_CATEGORY" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_FI_INV_CAT_1099" dataSource="ZI_FI_INV_CAT_1099" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZCDS_INV_CAT_1099' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.
ENDCLASS.
