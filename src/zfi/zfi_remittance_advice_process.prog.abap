*&---------------------------------------------------------------------*
*& Report ZR_REMITTANCE_ADVICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_remittance_advice.

DATA: gs_reguh          TYPE reguh,
      gt_doc_bin        TYPE solix_tab, "STANDARD TABLE OF x255,
      gv_merged_xstring TYPE xstring,
      gt_email_text     TYPE soli_tab,
      gv_length         TYPE i,
      gv_subject        TYPE so_obj_des,
      gv_footer         TYPE string,
      gv_text           TYPE string,
      gs_header         TYPE zuk_header,
      gt_items          TYPE zt_uk_item,
      gs_item           TYPE zuk_item.
CONSTANTS: lc_hkont TYPE hkont VALUE '22170070'.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_laufd TYPE laufd OBLIGATORY, " DEFAULT '20251027',
              p_laufi TYPE laufi OBLIGATORY, " DEFAULT 'CHOW7',
              p_sim   AS CHECKBOX DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_email  AS CHECKBOX USER-COMMAND eml,
              p_tdform TYPE tdobname MODIF ID eml DEFAULT 'ZF110_EMAIL',
              p_down   AS CHECKBOX USER-COMMAND fil,
              p_file   TYPE filename-fileintern MODIF ID fil DEFAULT 'ZDOWNLOAD'
              .
SELECTION-SCREEN END OF BLOCK blk2.

INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_laufi.
  PERFORM get_laufi CHANGING p_laufi.

AT SELECTION-SCREEN OUTPUT.
  PERFORM change_screen.

START-OF-SELECTION.

  DATA(lo_app) = NEW zcl_remittance_advice(
                    p_laufd = p_laufd
                    p_laufi = p_laufi
                    p_email = p_email
                    p_down  = p_down
                    p_tdform = p_tdform
                    p_sim   =  p_sim
                    p_file = p_file ).

  lo_app->process( ).

*&---------------------------------------------------------------------*
*& Form change_screen
*&---------------------------------------------------------------------*
FORM change_screen .

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'EML'.
        IF p_email IS INITIAL.
          screen-output = screen-active = 0.
        ELSE.
          IF screen-name = 'P_TDFORM'.
            screen-input = 0.
          ENDIF.
          screen-output = screen-active = 1.
        ENDIF.
        MODIFY SCREEN.
      WHEN 'FIL'.
        IF p_down IS INITIAL.
          screen-output = screen-active = 0.
        ELSE.
          screen-output = screen-active = 1.
        ENDIF.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form get_laufi
*&---------------------------------------------------------------------*
FORM get_laufi  CHANGING p_laufi TYPE laufi.

  DATA: lt_LAUFK TYPE STANDARD TABLE OF ilaufk.

  APPEND INITIAL LINE TO lt_laufk ASSIGNING FIELD-SYMBOL(<laufk>).
  <laufk>-sign  = 'I'.

  CALL FUNCTION 'F4_ZAHLLAUF'
    EXPORTING
      f1typ = 'I'
      f2nme = 'F110V-LAUFD'
    IMPORTING
      laufd = p_LAUFD
      laufi = p_LAUFI
    TABLES
      laufk = lt_laufk.
  CHECK p_laufi IS NOT INITIAL.

  DATA: lt_dynpfields TYPE STANDARD TABLE OF dynpread.
  APPEND INITIAL LINE TO lt_dynpfields ASSIGNING FIELD-SYMBOL(<dynp>).
  <dynp>-fieldname = 'P_LAUFD'.
  <dynp>-fieldvalue = | { p_laufd DATE = USER }|.
  SHIFT <dynp>-fieldvalue LEFT DELETING LEADING space.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = lt_dynpfields
    EXCEPTIONS
      OTHERS     = 0.
ENDFORM.
