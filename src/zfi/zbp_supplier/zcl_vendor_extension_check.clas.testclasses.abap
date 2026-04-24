CLASS ltcl_vendor_extension_check DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_vendor_extension_check.

    METHODS setup.

    " <= 30 chars each
    METHODS test_scope_miss_reg_error FOR TESTING.
    METHODS test_scope_reg_ok_no_error FOR TESTING.
    METHODS test_outscope_miss_reg_ok FOR TESTING.

    METHODS build_vendor_ext
      IMPORTING
        iv_bukrs  TYPE bukrs
        iv_region TYPE ad_region OPTIONAL
      RETURNING
        VALUE(rs_vendor_ext) TYPE vmds_ei_extern.  " adjust if needed
ENDCLASS.


CLASS ltcl_vendor_extension_check IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW zcl_vendor_extension_check( ).
  ENDMETHOD.

  METHOD build_vendor_ext.
    CLEAR rs_vendor_ext.

    APPEND INITIAL LINE TO rs_vendor_ext-company_data-company ASSIGNING FIELD-SYMBOL(<ls_comp>).
    <ls_comp>-task = 'I'.
    <ls_comp>-data_key-bukrs = iv_bukrs.

    rs_vendor_ext-central_data-address-postal-data-region = iv_region.
  ENDMETHOD.


  METHOD test_scope_miss_reg_error.
    DATA(ls_vendor_ext) = build_vendor_ext( iv_bukrs = 'US01' ).
    DATA:ls_error     TYPE cvis_error. " adjust if needed
    CLEAR ls_error.

    TEST-INJECTION t001_land1.
      CASE lv_bukrs.
        WHEN 'US01'.
          lv_land1 = 'US'.
          sy-subrc = 0.
        WHEN OTHERS.
          sy-subrc = 4.
      ENDCASE.
    END-TEST-INJECTION.

    mo_cut->if_ex_vendor_extension_check~check(
      EXPORTING
        is_vendor_ext = ls_vendor_ext
      CHANGING
        cs_error      = ls_error
    ).

    cl_abap_unit_assert=>assert_true(
      act = ls_error-is_error
      msg = 'Expected error when Region missing for in-scope company code.'
    ).

    cl_abap_unit_assert=>assert_not_initial(
      act = ls_error-messages
      msg = 'Expected at least one error message.'
    ).

    READ TABLE ls_error-messages INDEX 1 INTO DATA(ls_msg).
    cl_abap_unit_assert=>assert_equals( act = ls_msg-type   exp = 'E'     msg = 'Message type' ).
    cl_abap_unit_assert=>assert_equals( act = ls_msg-id     exp = 'ZPARK' msg = 'Message class' ).
    cl_abap_unit_assert=>assert_equals( act = ls_msg-number exp = '014'   msg = 'Message number' ).
    cl_abap_unit_assert=>assert_equals( act = ls_msg-message_v1 exp = 'US01' msg = 'BUKRS in V1' ).
    cl_abap_unit_assert=>assert_equals( act = ls_msg-message_v2 exp = 'US'   msg = 'LAND1 in V2' ).
  ENDMETHOD.


  METHOD test_scope_reg_ok_no_error.
    DATA(ls_vendor_ext) = build_vendor_ext( iv_bukrs = 'CA01' iv_region = 'ON' ).
    DATA: ls_error TYPE cvis_error. " adjust if needed
    CLEAR ls_error.

    TEST-INJECTION t001_land1.
      CASE lv_bukrs.
        WHEN 'CA01'.
          lv_land1 = 'CA'.
          sy-subrc = 0.
        WHEN OTHERS.
          sy-subrc = 4.
      ENDCASE.
    END-TEST-INJECTION.

    mo_cut->if_ex_vendor_extension_check~check(
      EXPORTING
        is_vendor_ext = ls_vendor_ext
      CHANGING
        cs_error      = ls_error
    ).

    cl_abap_unit_assert=>assert_false(
      act = ls_error-is_error
      msg = 'Did not expect error when Region present for in-scope company code.'
    ).
    cl_abap_unit_assert=>assert_initial(
      act = ls_error-messages
      msg = 'Did not expect messages when Region present.'
    ).
  ENDMETHOD.


  METHOD test_outscope_miss_reg_ok.
    DATA(ls_vendor_ext) = build_vendor_ext( iv_bukrs = 'DE01' ).
    DATA ls_error      TYPE cvis_error. " adjust if needed
    CLEAR ls_error.

    TEST-INJECTION t001_land1.
      CASE lv_bukrs.
        WHEN 'DE01'.
          lv_land1 = 'DE'.
          sy-subrc = 0.
        WHEN OTHERS.
          sy-subrc = 4.
      ENDCASE.
    END-TEST-INJECTION.

    mo_cut->if_ex_vendor_extension_check~check(
      EXPORTING
        is_vendor_ext = ls_vendor_ext
      CHANGING
        cs_error      = ls_error
    ).

    cl_abap_unit_assert=>assert_false(
      act = ls_error-is_error
      msg = 'Did not expect error when company code country is out of scope.'
    ).
    cl_abap_unit_assert=>assert_initial(
      act = ls_error-messages
      msg = 'Did not expect messages when out of scope.'
    ).
  ENDMETHOD.

ENDCLASS.
