"! Unit tests for ZCL_FI_REVERSAL_SYNC.
CLASS lcl_fi_reversal_sync_test DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.

    DATA m_cut TYPE REF TO zcl_fi_reversal_sync.

    METHODS setup.

    CONSTANTS c_bukrs TYPE bukrs VALUE '1000'.
    CONSTANTS c_revdoc TYPE belnr_d VALUE '0000000001'.
    CONSTANTS c_revyr  TYPE gjahr VALUE '2024'.

    METHODS given_accit_line
      IMPORTING
        iv_buzei              TYPE buzei DEFAULT '001'
        iv_blart              TYPE blart DEFAULT 'Y2'
        iv_hkont              TYPE hkont DEFAULT '0019000198'
        iv_source             TYPE zz1_source DEFAULT ' '
        iv_transactionkey     TYPE zz1_transactionkey DEFAULT 'TRK001'
        iv_lifnr              TYPE lifnr DEFAULT '0000100000'
        iv_waers              TYPE waers DEFAULT 'USD'
        iv_wrbtr              TYPE wrbtr DEFAULT '100.00'
        iv_augbl              TYPE augbl DEFAULT ' '
        iv_augdt              TYPE augdt DEFAULT '00000000'
        iv_clientcode         TYPE zz1_clientcode DEFAULT ' '
        iv_vehicleno          TYPE zz1_vehicleno DEFAULT ' '
        iv_invoicenumber      TYPE zz1_invoicenumber DEFAULT ' '
      RETURNING
        VALUE(rs_accit)       TYPE accit.

    METHODS qual_lines_empty_accit FOR TESTING.
    METHODS qual_lines_one_matching FOR TESTING.
    METHODS qual_lines_wrong_blart FOR TESTING.
    METHODS qual_lines_wrong_hkont FOR TESTING.
    METHODS qual_lines_source_excluded FOR TESTING.
    METHODS qual_lines_initial_trnkey FOR TESTING.
    METHODS qual_lines_two_matching FOR TESTING.


ENDCLASS.


CLASS lcl_fi_reversal_sync_test IMPLEMENTATION.

  METHOD setup.
    m_cut = NEW zcl_fi_reversal_sync( ).
  ENDMETHOD.


  METHOD given_accit_line.
    rs_accit = VALUE #(
      bukrs                  = c_bukrs
      buzei                  = iv_buzei
      blart                  = iv_blart
      hkont                  = iv_hkont
      zz1_source_cob         = iv_source
      zz1_transactionkey_cob = iv_transactionkey
      lifnr                  = iv_lifnr
      swaer                  = iv_waers
      lwbtr                  = iv_wrbtr
      augbl                  = iv_augbl
      augdt                  = iv_augdt
      zz1_clientcode_cob     = iv_clientcode
      zz1_vehicleno_cob      = iv_vehicleno
      zz1_invoicenumber_cob  = iv_invoicenumber ).
  ENDMETHOD.


  METHOD qual_lines_empty_accit.
    DATA(lt_accit) = VALUE accit_tab( ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_initial( lt_result ).
  ENDMETHOD.


  METHOD qual_lines_one_matching.
    DATA(ls_accit) = given_accit_line( ).
    DATA(lt_accit) = VALUE accit_tab( ( ls_accit ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result ) exp = 1 ).
    READ TABLE lt_result INTO DATA(ls_line) INDEX 1.
    cl_abap_unit_assert=>assert_equals( act = ls_line-bukrs exp = c_bukrs ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-belnr exp = c_revdoc ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-gjahr exp = c_revyr ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-blart exp = 'Y2' ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-waers exp = 'USD' ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-wrbtr exp = '100.00' ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-zz1_transactionkey_cob exp = 'TRK001' ).
    cl_abap_unit_assert=>assert_equals( act = ls_line-docln exp = '001' ).
  ENDMETHOD.


  METHOD qual_lines_wrong_blart.
    DATA(ls_accit) = given_accit_line( iv_blart = 'SA' ).
    DATA(lt_accit) = VALUE accit_tab( ( ls_accit ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_initial( lt_result ).
  ENDMETHOD.


  METHOD qual_lines_wrong_hkont.
    DATA(ls_accit) = given_accit_line( iv_hkont = '0000000001' ).
    DATA(lt_accit) = VALUE accit_tab( ( ls_accit ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_initial( lt_result ).
  ENDMETHOD.


  METHOD qual_lines_source_excluded.
    DATA(ls_accit) = given_accit_line( iv_source = 'BR198REV' ).
    DATA(lt_accit) = VALUE accit_tab( ( ls_accit ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_initial( lt_result ).
  ENDMETHOD.


  METHOD qual_lines_initial_trnkey.
    DATA(ls_accit) = given_accit_line( iv_transactionkey = '' ).
    DATA(lt_accit) = VALUE accit_tab( ( ls_accit ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_initial( lt_result ).
  ENDMETHOD.


  METHOD qual_lines_two_matching.
    DATA(ls1) = given_accit_line( iv_buzei = '001' iv_transactionkey = 'KEY1' ).
    DATA(ls2) = given_accit_line( iv_buzei = '002' iv_transactionkey = 'KEY2' iv_wrbtr = '200.00' ).
    DATA(lt_accit) = VALUE accit_tab( ( ls1 ) ( ls2 ) ).
    DATA(lt_result) = m_cut->get_qualifying_lines(
      it_accit     = lt_accit
      iv_revdoc    = c_revdoc
      iv_revdocyear = c_revyr ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result ) exp = 2 ).
    READ TABLE lt_result INTO DATA(la1) INDEX 1.
    READ TABLE lt_result INTO DATA(la2) INDEX 2.
    cl_abap_unit_assert=>assert_equals( act = la1-zz1_transactionkey_cob exp = 'KEY1' ).
    cl_abap_unit_assert=>assert_equals( act = la1-docln exp = '001' ).
    cl_abap_unit_assert=>assert_equals( act = la2-zz1_transactionkey_cob exp = 'KEY2' ).
    cl_abap_unit_assert=>assert_equals( act = la2-docln exp = '002' ).
    cl_abap_unit_assert=>assert_equals( act = la2-wrbtr exp = '200.00' ).
  ENDMETHOD.


ENDCLASS.
