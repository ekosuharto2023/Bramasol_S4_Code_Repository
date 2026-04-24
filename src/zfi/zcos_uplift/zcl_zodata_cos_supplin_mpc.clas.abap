class ZCL_ZODATA_COS_SUPPLIN_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
      HEADERDATA type BAPI_INCINV_CREATE_HEADER .
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
     TS_ITEMDATA type BAPI_INCINV_CREATE_ITEM .
  types:
TT_ITEMDATA type standard table of TS_ITEMDATA .

  constants GC_HEADERDATA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Headerdata' ##NO_TEXT.
  constants GC_ITEMDATA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Itemdata' ##NO_TEXT.

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

  constants GC_INCL_NAME type STRING value 'ZCL_ZODATA_COS_SUPPLIN_MPC====CP' ##NO_TEXT.

  methods DEFINE_COMPLEXTYPES
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ITEMDATA
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZODATA_COS_SUPPLIN_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZODATA_COS_SUPPLINV_SRV' ).

define_complextypes( ).
define_itemdata( ).
  endmethod.


  method DEFINE_COMPLEXTYPES.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


 data:
       lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,             "#EC NEEDED
       lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,             "#EC NEEDED
       lo_property       type ref to /iwbep/if_mgw_odata_property.                "#EC NEEDED

***********************************************************************************************************************************
*   COMPLEX TYPE - Headerdata
***********************************************************************************************************************************
lo_complex_type = model->create_complex_type( 'Headerdata' ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvoiceInd' iv_abap_fieldname = 'INVOICE_IND' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DocType' iv_abap_fieldname = 'DOC_TYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DocDate' iv_abap_fieldname = 'DOC_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PstngDate' iv_abap_fieldname = 'PSTNG_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'RefDocNo' iv_abap_fieldname = 'REF_DOC_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 16 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'CompCode' iv_abap_fieldname = 'COMP_CODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DiffInv' iv_abap_fieldname = 'DIFF_INV' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Currency' iv_abap_fieldname = 'CURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'CurrencyIso' iv_abap_fieldname = 'CURRENCY_ISO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'ExchRate' iv_abap_fieldname = 'EXCH_RATE' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 5 ).
lo_property->set_maxlength( iv_max_length = 9 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'ExchRateV' iv_abap_fieldname = 'EXCH_RATE_V' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 5 ).
lo_property->set_maxlength( iv_max_length = 9 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GrossAmount' iv_abap_fieldname = 'GROSS_AMOUNT' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 4 ).
lo_property->set_maxlength( iv_max_length = 23 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'CalcTaxInd' iv_abap_fieldname = 'CALC_TAX_IND' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Pmnttrms' iv_abap_fieldname = 'PMNTTRMS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'BlineDate' iv_abap_fieldname = 'BLINE_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DsctDays1' iv_abap_fieldname = 'DSCT_DAYS1' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DsctDays2' iv_abap_fieldname = 'DSCT_DAYS2' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Netterms' iv_abap_fieldname = 'NETTERMS' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DsctPct1' iv_abap_fieldname = 'DSCT_PCT1' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DsctPct2' iv_abap_fieldname = 'DSCT_PCT2' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'IvCategory' iv_abap_fieldname = 'IV_CATEGORY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'HeaderTxt' iv_abap_fieldname = 'HEADER_TXT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 25 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PmntBlock' iv_abap_fieldname = 'PMNT_BLOCK' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DelCosts' iv_abap_fieldname = 'DEL_COSTS' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 4 ).
lo_property->set_maxlength( iv_max_length = 23 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DelCostsTaxc' iv_abap_fieldname = 'DEL_COSTS_TAXC' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DelCostsTaxj' iv_abap_fieldname = 'DEL_COSTS_TAXJ' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 15 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PersonExt' iv_abap_fieldname = 'PERSON_EXT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 12 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PymtMeth' iv_abap_fieldname = 'PYMT_METH' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Pmtmthsupl' iv_abap_fieldname = 'PMTMTHSUPL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvDocNo' iv_abap_fieldname = 'INV_DOC_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'ScbankInd' iv_abap_fieldname = 'SCBANK_IND' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Supcountry' iv_abap_fieldname = 'SUPCOUNTRY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'BllsrvInd' iv_abap_fieldname = 'BLLSRV_IND' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'RefDocNoLong' iv_abap_fieldname = 'REF_DOC_NO_LONG' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 35 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DsctAmount' iv_abap_fieldname = 'DSCT_AMOUNT' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 4 ).
lo_property->set_maxlength( iv_max_length = 23 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PoSubNo' iv_abap_fieldname = 'PO_SUB_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 11 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PoCheckdg' iv_abap_fieldname = 'PO_CHECKDG' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PoRefNo' iv_abap_fieldname = 'PO_REF_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 27 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PayeePayer' iv_abap_fieldname = 'PAYEE_PAYER' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PartnerBk' iv_abap_fieldname = 'PARTNER_BK' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Housebankid' iv_abap_fieldname = 'HOUSEBANKID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'AllocNmbr' iv_abap_fieldname = 'ALLOC_NMBR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 18 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PaymtRef' iv_abap_fieldname = 'PAYMT_REF' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 30 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvRefNo' iv_abap_fieldname = 'INV_REF_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvYear' iv_abap_fieldname = 'INV_YEAR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_conversion_exit( 'GJAHR' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvRecDate' iv_abap_fieldname = 'INV_REC_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PlanningLevel' iv_abap_fieldname = 'PLANNING_LEVEL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PlanningDate' iv_abap_fieldname = 'PLANNING_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Fixedterms' iv_abap_fieldname = 'FIXEDTERMS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'BusArea' iv_abap_fieldname = 'BUS_AREA' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'LotNumber' iv_abap_fieldname = 'LOT_NUMBER' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'ItemText' iv_abap_fieldname = 'ITEM_TEXT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 50 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'J1bnftype' iv_abap_fieldname = 'J_1BNFTYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'EuTriangDeal' iv_abap_fieldname = 'EU_TRIANG_DEAL' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Repcountry' iv_abap_fieldname = 'REPCOUNTRY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'VatRegNo' iv_abap_fieldname = 'VAT_REG_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 20 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'BusinessPlace' iv_abap_fieldname = 'BUSINESS_PLACE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'TaxExchRate' iv_abap_fieldname = 'TAX_EXCH_RATE' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 5 ).
lo_property->set_maxlength( iv_max_length = 9 ).
lo_property->set_conversion_exit( 'EXCRT' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GoodsAffected' iv_abap_fieldname = 'GOODS_AFFECTED' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'RetDueProp' iv_abap_fieldname = 'RET_DUE_PROP' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DelivPosting' iv_abap_fieldname = 'DELIV_POSTING' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'ReturnPosting' iv_abap_fieldname = 'RETURN_POSTING' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'InvTran' iv_abap_fieldname = 'INV_TRAN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Simulation' iv_abap_fieldname = 'SIMULATION' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'J1tpbupl' iv_abap_fieldname = 'J_1TPBUPL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Secco' iv_abap_fieldname = 'SECCO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Vatdate' iv_abap_fieldname = 'VATDATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DeCreInd' iv_abap_fieldname = 'DE_CRE_IND' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'TransDate' iv_abap_fieldname = 'TRANS_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'TaxCalcDate' iv_abap_fieldname = 'TAX_CALC_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Housebankacctid' iv_abap_fieldname = 'HOUSEBANKACCTID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'DelCostsTaxCountry' iv_abap_fieldname = 'DEL_COSTS_TAX_COUNTRY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GstPart' iv_abap_fieldname = 'GST_PART' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PlcSup' iv_abap_fieldname = 'PLC_SUP' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Irn' iv_abap_fieldname = 'IRN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 64 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'Fulfilldate' iv_abap_fieldname = 'FULFILLDATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloRef1Hd' iv_abap_fieldname = 'GLO_REF1_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '018' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 80 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloDat1Hd' iv_abap_fieldname = 'GLO_DAT1_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '019' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloRef2Hd' iv_abap_fieldname = 'GLO_REF2_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '020' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 25 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloDat2Hd' iv_abap_fieldname = 'GLO_DAT2_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '021' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloRef3Hd' iv_abap_fieldname = 'GLO_REF3_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '022' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 25 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloDat3Hd' iv_abap_fieldname = 'GLO_DAT3_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '023' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloRef4Hd' iv_abap_fieldname = 'GLO_REF4_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '024' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 50 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloDat4Hd' iv_abap_fieldname = 'GLO_DAT4_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '025' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloRef5Hd' iv_abap_fieldname = 'GLO_REF5_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '026' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 50 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloDat5Hd' iv_abap_fieldname = 'GLO_DAT5_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '027' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloBp1Hd' iv_abap_fieldname = 'GLO_BP1_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '028' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'GloBp2Hd' iv_abap_fieldname = 'GLO_BP2_HD' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '029' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ).
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_complex_type->create_property( iv_property_name  = 'PaytRsn' iv_abap_fieldname = 'PAYT_RSN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_complex_type->bind_structure( iv_structure_name   = 'BAPI_INCINV_CREATE_HEADER'
                                 iv_bind_conversions = 'X' ). "#EC NOTEXT
  endmethod.


  method DEFINE_ITEMDATA.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - Itemdata
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'Itemdata' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'InvoiceDocItem' iv_abap_fieldname = 'INVOICE_DOC_ITEM' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 6 ). "#EC NOTEXT
lo_property->set_creatable( abap_true ).
lo_property->set_updatable( abap_true ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoNumber' iv_abap_fieldname = 'PO_NUMBER' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoItem' iv_abap_fieldname = 'PO_ITEM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RefDoc' iv_abap_fieldname = 'REF_DOC' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RefDocYear' iv_abap_fieldname = 'REF_DOC_YEAR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'GJAHR' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RefDocIt' iv_abap_fieldname = 'REF_DOC_IT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DeCreInd' iv_abap_fieldname = 'DE_CRE_IND' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'TaxCode' iv_abap_fieldname = 'TAX_CODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Taxjurcode' iv_abap_fieldname = 'TAXJURCODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 15 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ItemAmount' iv_abap_fieldname = 'ITEM_AMOUNT' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 4 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 23 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Quantity' iv_abap_fieldname = 'QUANTITY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 13 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoUnit' iv_abap_fieldname = 'PO_UNIT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'CUNIT' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoUnitIso' iv_abap_fieldname = 'PO_UNIT_ISO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoPrQnt' iv_abap_fieldname = 'PO_PR_QNT' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 13 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoPrUom' iv_abap_fieldname = 'PO_PR_UOM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'CUNIT' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PoPrUomIso' iv_abap_fieldname = 'PO_PR_UOM_ISO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CondType' iv_abap_fieldname = 'COND_TYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CondStNo' iv_abap_fieldname = 'COND_ST_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CondCount' iv_abap_fieldname = 'COND_COUNT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'SheetNo' iv_abap_fieldname = 'SHEET_NO' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ItemText' iv_abap_fieldname = 'ITEM_TEXT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 50 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'FinalInv' iv_abap_fieldname = 'FINAL_INV' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'SheetItem' iv_abap_fieldname = 'SHEET_ITEM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'GrirClearSrv' iv_abap_fieldname = 'GRIR_CLEAR_SRV' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'FreightVen' iv_abap_fieldname = 'FREIGHT_VEN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CshdisInd' iv_abap_fieldname = 'CSHDIS_IND' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RetentionDocuCurrency' iv_abap_fieldname = 'RETENTION_DOCU_CURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 14 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RetentionPercentage' iv_abap_fieldname = 'RETENTION_PERCENTAGE' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 5 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RetentionDueDate' iv_abap_fieldname = 'RETENTION_DUE_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'NoRetention' iv_abap_fieldname = 'NO_RETENTION' ). "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ValuationType' iv_abap_fieldname = 'VALUATION_TYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'InvRelation' iv_abap_fieldname = 'INV_RELATION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 6 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'InvItmOrigin' iv_abap_fieldname = 'INV_ITM_ORIGIN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CondCountLong' iv_abap_fieldname = 'COND_COUNT_LONG' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DelCreateDate' iv_abap_fieldname = 'DEL_CREATE_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'TaxCountry' iv_abap_fieldname = 'TAX_COUNTRY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'HsnSac' iv_abap_fieldname = 'HSN_SAC' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 16 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CustomsVal' iv_abap_fieldname = 'CUSTOMS_VAL' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 4 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 23 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'TaxCalcDate' iv_abap_fieldname = 'TAX_CALC_DATE' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_precison( iv_precision = 7 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'BAPI_INCINV_CREATE_ITEM'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ItemdataSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20251222134530'.                  "#EC NOTEXT
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
     ls_text_element TYPE ts_text_element.                                 "#EC NEEDED


clear ls_text_element.
ls_text_element-artifact_name          = 'GloRef1Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '018'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloDat1Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '019'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloRef2Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '020'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloDat2Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '021'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloRef3Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '022'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloDat3Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '023'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloRef4Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '024'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloDat4Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '025'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloRef5Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '026'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloDat5Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '027'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloBp1Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '028'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'GloBp2Hd'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                           "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'Headerdata'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'CTYP'.                                           "#EC NOTEXT
ls_text_element-text_symbol            = '029'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
  endmethod.
ENDCLASS.
