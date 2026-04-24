*&---------------------------------------------------------------------*
*& Report zr_license_check_void_bdc
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_license_check_void_bdc.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*
DATA gv_bukrs TYPE bukrs.
DATA gv_belnr TYPE belnr_d.
DATA gv_gjahr TYPE gjahr.
DATA gv_cpudt TYPE cpudt.
DATA gv_zlsch TYPE dzlsch.
DATA lt_log_handle TYPE bal_t_logh.

SELECT-OPTIONS:
  s_bukrs FOR gv_bukrs OBLIGATORY,
  s_gjahr FOR gv_gjahr OBLIGATORY,
  s_cpudt FOR gv_cpudt,
  s_belnr FOR gv_belnr,
  s_zlsch FOR gv_zlsch.

PARAMETERS:
  p_voidr TYPE payr-voidr  DEFAULT '05',
  p_stgrd TYPE uf05a-stgrd DEFAULT '01',
  p_test  TYPE abap_bool  DEFAULT abap_true AS CHECKBOX.

*---------------------------------------------------------------------*
* Default ZLSCH = 'L'
*---------------------------------------------------------------------*
INITIALIZATION.
  CLEAR s_zlsch.
  s_zlsch-sign   = 'I'.
  s_zlsch-option = 'EQ'.
  s_zlsch-low    = 'L'.
  APPEND s_zlsch.

*---------------------------------------------------------------------*
* Data
*---------------------------------------------------------------------*
DATA:
  lt_checks  TYPE zcl_license_check_void=>tt_check,
  lt_results TYPE zcl_license_check_void=>tt_result.

DATA:
  lo_alv TYPE REF TO cl_salv_table.

*---------------------------------------------------------------------*
* Application Log (SLG1)
*---------------------------------------------------------------------*
DATA:
  gv_log_handle TYPE balloghndl,
  gs_log        TYPE bal_s_log,
  gs_msg        TYPE bal_s_msg.

*---------------------------------------------------------------------*
* Start-of-selection
*---------------------------------------------------------------------*
START-OF-SELECTION.

  lt_checks =
    zcl_license_check_void=>get_checks_to_void(
      it_bukrs = s_bukrs[]
      it_gjahr = s_gjahr[]
      it_cpudt = s_cpudt[]
      it_zlsch = s_zlsch[]
      it_belnr = s_belnr[]
      iv_voidr = p_voidr
      iv_stgrd = p_stgrd ).

  IF lt_checks IS INITIAL.
    MESSAGE ID 'ZFI_MSG' TYPE 'I' NUMBER '008'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* TEST RUN – No FCH8, No SLG1
*---------------------------------------------------------------------*
  IF p_test = abap_true.
    PERFORM display_alv.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* Create SLG1 Log (only real run)
*---------------------------------------------------------------------*
  gs_log-object    = 'ZFI'.
  gs_log-subobject = 'CHECK_VOID'.
  gs_log-aldate    = sy-datum.
  gs_log-altime    = sy-uzeit.
  gs_log-aluser    = sy-uname.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log      = gs_log
    IMPORTING
      e_log_handle = gv_log_handle.

*---------------------------------------------------------------------*
* Execute FCH8 Voiding
*---------------------------------------------------------------------*
  DATA(lo_voider) = NEW zcl_license_check_void(
                      iv_dismode = 'N'
                      iv_updmode = 'S'
                      iv_commit  = abap_true ).

  lt_results = lo_voider->void_checks( lt_checks ).

*---------------------------------------------------------------------*
* Log results to SLG1
*---------------------------------------------------------------------*
  LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<r>).

    CLEAR gs_msg.
    gs_msg-msgid = 'ZFI'.
    gs_msg-msgno = '000'.
    gs_msg-msgty = COND #( WHEN <r>-success = abap_true THEN 'S' ELSE 'E' ).

    gs_msg-msgv1 = <r>-check-rbkp_belnr.
    gs_msg-msgv2 = <r>-check-rbkp_gjahr.
    gs_msg-msgv3 = <r>-check-zbukr.
    gs_msg-msgv4 = <r>-check-chect.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle = gv_log_handle
        i_s_msg      = gs_msg.

    IF <r>-success = abap_false.
      LOOP AT <r>-messages ASSIGNING FIELD-SYMBOL(<m>).
        CLEAR gs_msg.
        gs_msg-msgty = <m>-msgtyp.
        gs_msg-msgid = <m>-msgid.
        gs_msg-msgno = <m>-msgnr.
        gs_msg-msgv1 = <m>-msgv1.
        gs_msg-msgv2 = <m>-msgv2.
        gs_msg-msgv3 = <m>-msgv3.
        gs_msg-msgv4 = <m>-msgv4.

        CALL FUNCTION 'BAL_LOG_MSG_ADD'
          EXPORTING
            i_log_handle = gv_log_handle
            i_s_msg      = gs_msg.
      ENDLOOP.
    ENDIF.

  ENDLOOP.

CLEAR lt_log_handle.
APPEND gv_log_handle TO lt_log_handle.

CALL FUNCTION 'BAL_DB_SAVE'
  EXPORTING
    i_t_log_handle = lt_log_handle
  EXCEPTIONS
    OTHERS         = 1.

IF sy-subrc <> 0.
  " handle error (optional)
ENDIF.

*---------------------------------------------------------------------*
* Display ALV
*---------------------------------------------------------------------*
  PERFORM display_alv.

*---------------------------------------------------------------------*
* Form: Display ALV
*---------------------------------------------------------------------*
FORM display_alv.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_checks ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      lo_alv->display( ).

    CATCH cx_salv_msg.
      MESSAGE ID 'ZFI_MSG' TYPE 'E' NUMBER '009'.
  ENDTRY.

ENDFORM.
