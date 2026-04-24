*&---------------------------------------------------------------------*
*& Report ZBRIM_ACDOCA_HYPERLINK.
*&---------------------------------------------------------------------*
*& Description: Query ACDOCA and display results with hyperlinks to BRIM
*& The SGTXT field contains clickable links that open TCode FPF3 in BRIM
*&---------------------------------------------------------------------*
REPORT zbrim_drillback.

*----------------------------------------------------------------------*
* Type Definitions
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_acdoca_display,
         rbukrs  TYPE acdoca-rbukrs,      " Company Code
         gjahr   TYPE acdoca-gjahr,       " Fiscal Year
         belnr   TYPE acdoca-belnr,       " Accounting Document Number
         buzei   TYPE acdoca-buzei,       " Line Item
         sgtxt   TYPE acdoca-sgtxt,       " Segment Text
         racct   TYPE acdoca-racct,       " Account
         hsl     TYPE acdoca-hsl,         " Amount in Local Currency
         rhcur   TYPE acdoca-rhcur,       " Local Currency
         budat   TYPE acdoca-budat,       " Posting Date
         blart   TYPE acdoca-blart,       " Document Type
         fikey   TYPE string,             " FI Key for BRIM (derived)
         url     TYPE string,             " Generated URL for hyperlink
         t_color TYPE lvc_t_scol,         " Cell colors
       END OF ty_acdoca_display.

*----------------------------------------------------------------------*
* Global Data
*----------------------------------------------------------------------*
DATA: gt_acdoca     TYPE STANDARD TABLE OF ty_acdoca_display,
      go_alv        TYPE REF TO cl_gui_alv_grid,
      go_container  TYPE REF TO cl_gui_custom_container,
      go_splitter   TYPE REF TO cl_gui_splitter_container,
      gv_sm59_dest  TYPE rfcdest VALUE 'DE1CLNT220',
      gv_brim_tcode TYPE sy-tcode VALUE 'FPF3'.

* Data objects for SELECT-OPTIONS references
DATA: gv_gjahr TYPE acdoca-gjahr,
      gv_belnr TYPE acdoca-belnr,
      gv_sgtxt TYPE acdoca-sgtxt,
      gv_budat TYPE acdoca-budat,
      gv_racct TYPE acdoca-racct.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS:     p_bukrs TYPE acdoca-rbukrs OBLIGATORY.
  SELECT-OPTIONS: s_gjahr FOR gv_gjahr DEFAULT sy-datum+0(4),
                  s_belnr FOR gv_belnr,
                  s_sgtxt FOR gv_sgtxt,
                  s_budat FOR gv_budat,
                  s_racct FOR gv_racct.
  PARAMETERS:     p_maxrow TYPE i DEFAULT 1000.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
* Main Processing
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM select_acdoca_data.
  IF gt_acdoca IS INITIAL.
    MESSAGE ID 'ZFI_MSG' TYPE 'S' NUMBER '007' DISPLAY LIKE 'W'.
    RETURN.
  ENDIF.
  PERFORM generate_brim_urls.
  PERFORM display_alv.

*&---------------------------------------------------------------------*
*& Form SELECT_ACDOCA_DATA
*&---------------------------------------------------------------------*
FORM select_acdoca_data.
  DATA: lv_maxrow TYPE i.
  lv_maxrow = p_maxrow.

  SELECT rbukrs gjahr belnr buzei sgtxt racct hsl rhcur budat blart
    FROM acdoca
    INTO CORRESPONDING FIELDS OF TABLE gt_acdoca
    UP TO lv_maxrow ROWS
    WHERE rbukrs = p_bukrs
      AND gjahr  IN s_gjahr
      AND belnr  IN s_belnr
      AND sgtxt  IN s_sgtxt
      AND budat  IN s_budat
      AND racct  IN s_racct
      AND sgtxt  NE space.  "Only rows with populated SGTXT (DocumentItemText)
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GENERATE_BRIM_URLS
*&---------------------------------------------------------------------*
FORM generate_brim_urls.
  CONSTANTS c_tcode  TYPE sy-tcode VALUE 'FPF3'.
  DATA: lt_param TYPE tihttpnvp,
        lv_url   TYPE string.

  CASE sy-sysid.
    WHEN 'DS4'.
      DATA(lv_sysid) = 'DE1'.
      DATA(lv_client) = '220'.
      DATA(lv_brim_url) = 'https://sapfinancedev.holman.com:8202/nwbc'.
    WHEN 'QS4'.
      lv_sysid = 'QE1'.
      lv_client = '300'.
      lv_brim_url = 'https://sapfinanceqa.holman.com:8202/nwbc'.
    WHEN 'PS4'.
      lv_sysid = 'TE1'.
      lv_client = '300'.
      lv_brim_url = 'https://sapfinanceprd.holman.com:8202/nwbc'.
    WHEN OTHERS.
  ENDCASE.
  CONCATENATE lv_sysid lv_client INTO DATA(lv_dest).

  LOOP AT gt_acdoca ASSIGNING FIELD-SYMBOL(<wa>).
    " Build the FI Key - typically document number or combination
    " Adjust this logic based on your BRIM document key format
    <wa>-fikey = |{ <wa>-sgtxt }|.

    " Clear and build parameters
    CLEAR lt_param.
    APPEND INITIAL LINE TO lt_param ASSIGNING FIELD-SYMBOL(<param>).
    <param>-name = 'RFKB1-FIKEY'.
    <param>-value = <wa>-fikey.

    " Construct the NWBC URL for BRIM
    TRY.
        lv_url = cl_nwbc=>url_construct(
          canvas_transaction = c_tcode
          sm59_alias         = lv_dest
          query_parameters   = lt_param
          for_use_in_email   = 'X' ).

        " Extract and rebuild with proper host if needed
        SPLIT lv_url AT 'nwbc' INTO DATA(lv_prefix) DATA(lv_suffix).

        " Get the BRIM host from RFC destination (optional enhancement)
        " For now using configured host - adjust as needed
        CONCATENATE lv_brim_url lv_suffix INTO <wa>-url.

      CATCH cx_root.
        <wa>-url = ''.
    ENDTRY.

    " Set color for SGTXT column to indicate it's clickable
    APPEND INITIAL LINE TO <wa>-t_color ASSIGNING FIELD-SYMBOL(<color>).
    <color>-fname = 'SGTXT'.
    <color>-color-col = col_key.
    <color>-color-int = 0.
    <color>-color-inv = 0.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv.
  DATA: lt_fieldcat TYPE lvc_t_fcat,
        ls_layout   TYPE lvc_s_layo,
        lt_events   TYPE slis_t_event.

  " Build field catalog
  PERFORM build_fieldcat CHANGING lt_fieldcat.

  " Set layout
  ls_layout-zebra      = abap_true.
  ls_layout-cwidth_opt = abap_true.
  ls_layout-sel_mode   = 'A'.
  ls_layout-ctab_fname = 'T_COLOR'.

  " Display ALV using function module (supports hotspot)
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout_lvc           = ls_layout
      it_fieldcat_lvc         = lt_fieldcat
    TABLES
      t_outtab                = gt_acdoca
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM build_fieldcat CHANGING ct_fieldcat TYPE lvc_t_fcat.
  DATA: ls_fieldcat TYPE lvc_s_fcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'RBUKRS'.
  ls_fieldcat-coltext   = 'Company Code'.
  ls_fieldcat-outputlen = 6.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'GJAHR'.
  ls_fieldcat-coltext   = 'Fiscal Year'.
  ls_fieldcat-outputlen = 6.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'BELNR'.
  ls_fieldcat-coltext   = 'Accounting Doc #'.
  ls_fieldcat-outputlen = 12.
  ls_fieldcat-key       = abap_true.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'BUZEI'.
  ls_fieldcat-coltext   = 'Line Item'.
  ls_fieldcat-outputlen = 6.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SGTXT'.
  ls_fieldcat-coltext   = 'Segment Text (Click for BRIM)'.
  ls_fieldcat-outputlen = 50.
  ls_fieldcat-hotspot   = abap_true.  " Make clickable
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'RACCT'.
  ls_fieldcat-coltext   = 'Account'.
  ls_fieldcat-outputlen = 12.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'HSL'.
  ls_fieldcat-coltext   = 'Amount (LC)'.
  ls_fieldcat-outputlen = 16.
  ls_fieldcat-do_sum    = abap_true.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'RHCUR'.
  ls_fieldcat-coltext   = 'Currency'.
  ls_fieldcat-outputlen = 5.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'BUDAT'.
  ls_fieldcat-coltext   = 'Posting Date'.
  ls_fieldcat-outputlen = 10.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'BLART'.
  ls_fieldcat-coltext   = 'Doc Type'.
  ls_fieldcat-outputlen = 4.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'FIKEY'.
  ls_fieldcat-coltext   = 'FI Key (BRIM)'.
  ls_fieldcat-outputlen = 20.
  ls_fieldcat-tech      = abap_true.  " Hidden by default
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'URL'.
  ls_fieldcat-coltext   = 'BRIM URL'.
  ls_fieldcat-outputlen = 100.
  ls_fieldcat-tech      = abap_true.  " Hidden by default
  APPEND ls_fieldcat TO ct_fieldcat.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
FORM user_command USING r_ucomm     TYPE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  DATA: lv_url TYPE string.

  CASE r_ucomm.
    WHEN '&IC1'.  " Hotspot click
      IF rs_selfield-fieldname = 'SGTXT'.
        " Get the clicked row
        READ TABLE gt_acdoca INTO DATA(ls_acdoca) INDEX rs_selfield-tabindex.
        IF sy-subrc = 0 AND ls_acdoca-url IS NOT INITIAL.

"          IF p_direct = abap_true.
"            " Direct launch in browser
"            cl_nwbc=>url_launch( CONV #( ls_acdoca-url ) ).
"          ELSE.
"            " Show in popup with clickable link
            PERFORM show_link_popup USING ls_acdoca.
"          ENDIF.
        ELSE.
          MESSAGE 'No BRIM URL available for this entry' TYPE 'S' DISPLAY LIKE 'W'.
        ENDIF.
      ENDIF.

  ENDCASE.

  " Refresh display
  rs_selfield-refresh = abap_true.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_LINK_POPUP
*&---------------------------------------------------------------------*
FORM show_link_popup USING is_acdoca TYPE ty_acdoca_display.
  DATA: lt_html TYPE cl_abap_browser=>html_table,
        lt_text TYPE soli_tab.

  " Build HTML content with clickable link
  APPEND INITIAL LINE TO lt_text ASSIGNING FIELD-SYMBOL(<text>).
  <text>-line = |<html><head><title>BRIM Link</title>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<style>body \{ font-family: Arial, sans-serif; padding: 20px; \}|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |.info \{ margin-bottom: 15px; \}|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |.link \{ font-size: 14px; \}</style></head><body>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<h2>Open Document in BRIM</h2>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<div class="info"><strong>Document:</strong> { is_acdoca-belnr }</div>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<div class="info"><strong>Segment Text:</strong> { is_acdoca-sgtxt }</div>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<div class="info"><strong>FI Key:</strong> { is_acdoca-fikey }</div>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<div class="link">|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |<a href="{ is_acdoca-url }" target="_blank">|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |Click here to open in BRIM (TCode FPF3)</a></div>|.
  APPEND INITIAL LINE TO lt_text ASSIGNING <text>.
  <text>-line = |</body></html>|.

  " Convert to HTML table format
  LOOP AT lt_text ASSIGNING FIELD-SYMBOL(<line>).
    APPEND <line>-line TO lt_html.
  ENDLOOP.

  " Show in browser control
  CALL METHOD cl_abap_browser=>show_html
    EXPORTING
      html     = lt_html
      title    = |BRIM Link - Document { is_acdoca-belnr }|
      size     = cl_abap_browser=>medium
      format   = cl_abap_browser=>landscape
      position = cl_abap_browser=>middle
      modal    = abap_true
      buttons  = cl_abap_browser=>navigate_off.
ENDFORM.
