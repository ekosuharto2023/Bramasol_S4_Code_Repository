CLASS zcl_remittance_advice DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING p_laufd  TYPE laufd
                p_laufi  TYPE laufi
                p_email  TYPE abap_bool
                p_down   TYPE abap_bool
                p_tdform TYPE tdobname
                p_sim    TYPE abap_bool OPTIONAL
                p_file   TYPE filename-fileintern.

    METHODS process.
    METHODS get_uk_data.
    METHODS get_data.
    METHODS check_unlocked.
    METHODS email_form.
    METHODS download_file.

    METHODS get_file_name
      CHANGING p_filename TYPE string.

  PRIVATE SECTION.
    " Selection / control parameters
    DATA: mv_laufd          TYPE laufd,
          mv_laufi          TYPE laufi,
          mv_email          TYPE abap_bool,
          mv_down           TYPE abap_bool,
          mv_tdform         TYPE tdobname,
          mv_sim            TYPE abap_bool,
          mv_file           TYPE filename-fileintern,
          gs_reguh          TYPE reguh,
          gs_country        TYPE reguh,
          gt_doc_bin        TYPE solix_tab,
          gv_merged_xstring TYPE xstring,
          gt_email_text     TYPE soli_tab,
          gv_length         TYPE i ##NEEDED,
          gv_subject        TYPE so_obj_des,
          gv_footer         TYPE string,
          gv_text           TYPE string,
          gs_header         TYPE zuk_header,
          gt_items          TYPE zt_uk_item,
          gs_item           TYPE zuk_item,
          gv_doc            TYPE string,
          gv_your_doc       TYPE string,
          gv_date           TYPE string,
          gv_currency       TYPE string,
          gv_gross_amt      TYPE string.

    METHODS get_Country
      RETURNING VALUE(rs_reguh_tmp) TYPE reguh.

    CONSTANTS lc_hkont TYPE hkont VALUE '22170070'.
    CONSTANTS gb TYPE string VALUE 'GB'.
    CONSTANTS zf110_email TYPE string VALUE 'ZF110_EMAIL'.
    CONSTANTS zdownload TYPE string VALUE 'ZDOWNLOAD' .
    CONSTANTS test_filename TYPE string VALUE '\test_pdf.pdf'.

    TYPES ty_lt_reguh TYPE STANDARD TABLE OF reguh WITH DEFAULT KEY.
    TYPES ty_lt_regup TYPE STANDARD TABLE OF regup WITH DEFAULT KEY.

    METHODS get_line_item
      RETURNING VALUE(rt_regup) TYPE ty_lt_regup.

    METHODS get_payment_doc
      RETURNING VALUE(rt_reguh) TYPE ty_lt_reguh.

    METHODS get_vendor_addr
      IMPORTING is_reguh TYPE reguh.

    METHODS get_company_addr
      IMPORTING is_reguh TYPE reguh.

    METHODS get_invoice_details
      IMPORTING is_regup     TYPE regup
      EXPORTING es_bkpf      TYPE bkpf
                ev_total_c   TYPE wrbtr
                ev_vat_b     TYPE wrbtr
                ev_sknto_inv TYPE wrbtr.

    METHODS get_early_settl
      IMPORTING is_bkpf      TYPE bkpf
                iv_total_c   TYPE wrbtr
                iv_vat_b     TYPE wrbtr
                iv_sknto_inv TYPE wrbtr
      EXPORTING et_lines     TYPE zt_uk_item
      CHANGING  cs_line      TYPE zuk_item.

    METHODS total_invoice
      RETURNING VALUE(rt_total) TYPE zt_uk_item.

    METHODS total_intellipay
      IMPORTING it_lines TYPE zt_uk_item
      CHANGING  ct_total TYPE zt_uk_item.

    METHODS total_charity
      CHANGING ct_total TYPE zt_uk_item.

    METHODS final_total
      CHANGING ct_total TYPE zt_uk_item.

    METHODS print_UK_form
      IMPORTING it_lines TYPE zt_uk_item
                it_total TYPE zt_uk_item.

    METHODS get_addr_line
      RETURNING VALUE(rv_address) TYPE string.

    METHODS read_text_into_string
      IMPORTING iv_id     TYPE thead-tdid
                iv_langu  TYPE sy-langu
                iv_name   TYPE thead-tdname
                iv_object TYPE thead-tdobject
      EXPORTING ev_string TYPE string.

    METHODS get_text
      IMPORTING i_lang    TYPE data
      CHANGING  cv_tdname TYPE thead-tdname.
ENDCLASS.



CLASS zcl_remittance_advice IMPLEMENTATION.


  METHOD constructor.
    mv_laufd  = p_laufd.
    mv_laufi  = p_laufi.
    mv_email  = p_email.
    mv_down   = p_down.
    mv_tdform = p_tdform.
    mv_sim    = p_sim.
    " Default for Remittance Email Form
    IF p_tdform IS INITIAL.
      mv_tdform = zf110_email.
    ELSE.
      mv_tdform = p_tdform.
    ENDIF.

    " Default logical file name if no value provided
    IF p_file IS INITIAL.
      mv_file = zdownload.
    ELSE.
      mv_file = p_file.
    ENDIF.
  ENDMETHOD.


  METHOD process.
    check_unlocked( ).

    gs_country = get_Country( ).
    " Route to UK / non-UK logic
    IF gs_country-land1 = gb.
      get_uk_data( ).
    ELSE.
      get_data( ).
    ENDIF.

    email_form( ).
    download_file( ).
  ENDMETHOD.


  METHOD get_country.

    CLEAR rs_reguh_tmp-land1.

    SELECT land1
      FROM reguh
      INTO @rs_reguh_tmp-land1
      WHERE laufd = @mv_laufd
        AND laufi = @mv_laufi
        AND xvorl = @space
      ORDER BY PRIMARY KEY.

      EXIT.  "take first row
    ENDSELECT.

    IF rs_reguh_tmp-land1 IS INITIAL.
      MESSAGE e001(zfi_msg) WITH 'Company Code' ##NO_TEXT.
    ENDIF.

  ENDMETHOD.


  METHOD check_unlocked.
    DATA lt_reguh TYPE STANDARD TABLE OF reguh WITH EMPTY KEY.

    SELECT *
      FROM reguh
      INTO TABLE @lt_reguh
      WHERE laufd = @mv_laufd
        AND laufi = @mv_laufi
        AND xvorl = @space
      ORDER BY PRIMARY KEY.

    IF lt_reguh IS NOT INITIAL.
      gs_reguh = lt_reguh[ 1 ].
    ELSE.
      CLEAR gs_reguh.
    ENDIF.


    DO 10 TIMES.
      CALL FUNCTION 'ENQUEUE_EFREGUH'
        EXPORTING
          laufd          = gs_reguh-laufd
          laufi          = gs_reguh-laufi
          xvorl          = gs_reguh-xvorl
          _wait          = 'X'
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2.
      IF sy-subrc = 0.
        DATA(lv_cont) = 'X'.
        EXIT.
      ENDIF.
      WAIT UP TO 5 SECONDS.
    ENDDO.

    IF lv_cont IS INITIAL.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      CALL FUNCTION 'DEQUEUE_EFREGUH'
        EXPORTING
          laufd = gs_reguh-laufd
          laufi = gs_reguh-laufi
          xvorl = gs_reguh-xvorl.
    ENDIF.
  ENDMETHOD.


  METHOD get_uk_data.
    DATA: lt_regup      TYPE STANDARD TABLE OF regup,
          ls_regup      TYPE regup,
          ls_bkpf       TYPE bkpf,
          gt_lines      TYPE zt_uk_item,
          gs_line       TYPE zuk_item,
          gt_total      TYPE zt_uk_item,
          lt_reguh      TYPE STANDARD TABLE OF reguh,
          ls_reguh      TYPE reguh,
          lv_gjahr_pay  TYPE gjahr,
          lv_mask       TYPE string,
          lv_last4      TYPE string,
          lv_off        TYPE i,
          lv_clerk_code TYPE lfb1-busab ##NEEDED,
          lv_total_c    TYPE wrbtr,
          lv_vat_b      TYPE wrbtr,
          lv_sknto_inv  TYPE wrbtr,
          lv_pay_text1  TYPE string,
          lv_pay_text2  TYPE string,
          lv_final_text TYPE string,
          lv_busab      TYPE lfb1-busab.


    "Get all payment documents for the run (unlocked, not proposal)
    lt_reguh = get_payment_doc( ).

    SORT lt_reguh BY laufd laufi zbukr vblnr lifnr.
    READ TABLE lt_reguh INTO ls_reguh INDEX 1.
    IF sy-subrc <> 0.
      MESSAGE e003(zremit_msg).
      RETURN.
    ENDIF.

    " 3) Build header ONCE
    CLEAR gs_header.

    gs_header-laufd     = ls_reguh-laufd.
    gs_header-laufi     = ls_reguh-laufi.
    gs_header-bukrs     = ls_reguh-zbukr.
    gs_header-belnr_pay = ls_reguh-vblnr.
    gs_header-pay_date  = ls_reguh-zaldt.
    lv_gjahr_pay        = ls_reguh-zaldt(4).
    gs_header-gjahr_pay = lv_gjahr_pay.

    " Vendor / BP number for header
    CLEAR gs_header-vendor.
    gs_header-vendor = |{ ls_reguh-lifnr ALPHA = OUT }|.
    " BKPF: document currency
    CLEAR gs_header-doc_curr.
    SELECT SINGLE waers
      FROM bkpf
      INTO @gs_header-doc_curr
      WHERE bukrs = @ls_reguh-zbukr
        AND belnr = @ls_reguh-vblnr
        AND gjahr = @lv_gjahr_pay.

    " T001: company VAT number
    CLEAR gs_header-comp_vat_no.
    SELECT SINGLE stceg
      FROM t001
      INTO @gs_header-comp_vat_no
      WHERE bukrs = @ls_reguh-zbukr.

    " LFA1: vendor VAT number
    CLEAR gs_header-vendor_vat.
    SELECT SINGLE stceg
      FROM lfa1
      INTO @gs_header-vendor_vat
      WHERE lifnr = @ls_reguh-lifnr.

    " 1) Read clerk code from LFB1 (deterministic first row)
    CLEAR: lv_busab, lv_clerk_code, gs_header-acct_clerk.
    SELECT busab
      FROM lfb1
      INTO @lv_busab
      WHERE lifnr = @ls_reguh-lifnr
        AND bukrs = @ls_reguh-zbukr
      ORDER BY PRIMARY KEY.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND lv_busab IS NOT INITIAL.
      lv_clerk_code = lv_busab.

      " 2) Read clerk name from buffered table T001S (no JOIN)
      CLEAR gs_header-acct_clerk.
      SELECT sname
        FROM t001s
        INTO @gs_header-acct_clerk
        WHERE busab = @lv_busab
        ORDER BY PRIMARY KEY.
        EXIT.
      ENDSELECT.
    ENDIF.

    " 3) Bank sort code & account number from vendor bank details (deterministic)
    CLEAR: gs_header-bank_sort, gs_header-bank_acct.
    SELECT bankl, bankn
      FROM lfbk
      INTO (@gs_header-bank_sort, @gs_header-bank_acct)
      WHERE lifnr = @ls_reguh-lifnr
      ORDER BY PRIMARY KEY.
      EXIT.
    ENDSELECT.

    " Mask BANK ACCOUNT (keep last 4 digits)
    DATA(lv_len) = strlen( gs_header-bank_acct ).
    IF lv_len > 4.
      lv_off   = lv_len - 4.
      lv_last4 = gs_header-bank_acct+lv_off(4).
      lv_mask  = repeat( val = 'X' occ = lv_off ).
      gs_header-bank_acct = lv_mask && lv_last4.
    ENDIF.

    " Pay text lines
    lv_pay_text1 = TEXT-001.
    lv_pay_text2 = TEXT-002.

    REPLACE '&1' IN lv_pay_text1 WITH gs_header-doc_curr.
    REPLACE '&2' IN lv_pay_text1 WITH |{ ls_reguh-zaldt DATE = USER }|.

    REPLACE '&3' IN lv_pay_text2 WITH gs_header-bank_sort.
    REPLACE '&4' IN lv_pay_text2 WITH gs_header-bank_acct.

    gs_header-pay_text1 = |{ lv_pay_text1 } { lv_pay_text2 }|.

    " Vendor Address (TO:)
    get_vendor_addr( ls_reguh ).
    " Company Address (FROM:)
    get_company_addr( ls_reguh ).

    " Read line items from REGUP for this run
    lt_regup = get_line_item( ).

    LOOP AT lt_regup INTO ls_regup.

      CLEAR: gs_item,
             gs_line,
             ls_bkpf,
*             ls_rbkp,
             lv_total_c,
             lv_vat_b,
*             lv_net_a,
*             lv_yref,
             lv_sknto_inv.
*             lv_es_vat,
*             lv_es_base.

      get_invoice_details( EXPORTING is_regup     = ls_regup
                           IMPORTING es_bkpf      = ls_bkpf
                                     ev_total_c   = lv_total_c
                                     ev_vat_b     = lv_vat_b
                                     ev_sknto_inv = lv_sknto_inv ).

      " EARLY SETTLEMENT LINE FOR THIS INVOICE (GT_LINES)

      get_early_settl( EXPORTING is_bkpf      = ls_bkpf
                                 iv_total_c   = lv_total_c
                                 iv_vat_b     = lv_vat_b
                                 iv_sknto_inv = lv_sknto_inv
                       IMPORTING et_lines     = gt_lines
                       CHANGING  cs_line      = gs_line ).

    ENDLOOP.

    " SORT BOTH TABLES BY YOUR_REF HERE
    SORT gt_items BY your_ref ASCENDING.
    SORT gt_lines BY your_ref ASCENDING.
    " 4A — SUBTOTAL ROWS A/B/C BEFORE FINAL TOTAL (D)
    "--------------- A — Total (Invoices Only)
    gt_total = total_invoice( ).

    "--------------- B — Total Pay Push (ES)
    total_intellipay( EXPORTING it_lines = gt_lines
                      CHANGING  ct_total = gt_total ).

    " 4 — CHARITY LINE (ALSO KEEP SIGN)
    total_charity( CHANGING ct_total = gt_total ).

    " TOTALS A/B/C/D
    final_total( CHANGING ct_total = gt_total ).

    " 8. CALL ADOBE FORM ZFI_F_UK_REMITTANCE_ADVICE
    print_UK_form( it_lines = gt_lines
                   it_total = gt_total ).
  ENDMETHOD.


  METHOD print_UK_form.
    DATA: lv_fm_name    TYPE rs38l_fnam,
          ls_docparams  TYPE sfpdocparams,
          ls_output     TYPE sfpoutputparams,
          ls_formoutput TYPE fpformoutput,
          gv_footer     TYPE string,
          gv_title      TYPE string.


    gv_footer = TEXT-026.

    gv_title = TEXT-027.

    " Open print job
    ls_output-nodialog = abap_true.
    ls_output-getpdf   = abap_true.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_output
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4.

    IF sy-subrc <> 0.
      MESSAGE e005(zremit_msg).
    ENDIF.
*
*" Get generated FM name for the Adobe form
    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = 'ZFI_F_UK_REMITTANCE_ADVICE'
          IMPORTING
            e_funcname = lv_fm_name.

      CATCH cx_fp_api_usage INTO DATA(lx_api_usage).
        MESSAGE lx_api_usage TYPE 'E'.

      CATCH cx_fp_api_repository INTO DATA(lx_repo).
        MESSAGE lx_repo TYPE 'E'.

      CATCH cx_fp_api_internal INTO DATA(lx_internal).
        MESSAGE lx_internal TYPE 'E'.

    ENDTRY.
*
*" Call the Adobe form FM
    ls_docparams-langu = sy-langu.

    CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000011'
      EXPORTING
        /1bcdwb/docparams  = ls_docparams
        gs_header          = gs_header
        gt_items           = gt_items
        gt_es_lines        = it_lines
        gt_totals          = it_total
        gv_title           = gv_title
        gv_footer          = gv_footer
      IMPORTING
        /1bcdwb/formoutput = ls_formoutput.

*
*" Close PDF job
    CALL FUNCTION 'FP_JOB_CLOSE'.

    DATA lv_filename TYPE string.
    DATA lv_xstring  TYPE xstring.

    lv_xstring = ls_formoutput-pdf.
    lv_filename = TEXT-028.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_xstring
      IMPORTING
        output_length = gv_length
      TABLES
        binary_tab    = gt_doc_bin.

    IF mv_sim IS NOT INITIAL.
      cl_gui_frontend_services=>get_desktop_directory( CHANGING   desktop_directory    = lv_filename
                                                       EXCEPTIONS cntl_error           = 1
                                                                  error_no_gui         = 2
                                                                  not_supported_by_gui = 3
                                                                  OTHERS               = 4 ).
      IF sy-subrc IS INITIAL.
        cl_gui_cfw=>flush( ).
      ENDIF.

      CONCATENATE lv_filename test_filename INTO lv_filename.

      cl_gui_frontend_services=>gui_download( EXPORTING  filename                = lv_filename
                                                         filetype                = 'BIN'
                                              CHANGING   data_tab                = gt_doc_bin
                                              EXCEPTIONS file_write_error        = 1
                                                         no_batch                = 2
                                                         gui_refuse_filetransfer = 3
                                                         invalid_type            = 4
                                                         no_authority            = 5
                                                         unknown_error           = 6
                                                         header_not_allowed      = 7
                                                         separator_not_allowed   = 8
                                                         filesize_not_allowed    = 9
                                                         header_too_long         = 10
                                                         dp_error_create         = 11
                                                         dp_error_send           = 12
                                                         dp_error_write          = 13
                                                         unknown_dp_error        = 14
                                                         access_denied           = 15
                                                         dp_out_of_memory        = 16
                                                         disk_full               = 17
                                                         dp_timeout              = 18
                                                         file_not_found          = 19
                                                         dataprovider_exception  = 20
                                                         control_flush_error     = 21
                                                         not_supported_by_gui    = 22
                                                         error_no_gui            = 23
                                                         OTHERS                  = 24 ).
      IF sy-subrc <> 0.
        MESSAGE e861(cbgl00) WITH lv_filename.
      ENDIF.

      cl_gui_frontend_services=>execute( EXPORTING  document  = lv_filename
                                                    operation = 'OPEN'
                                         EXCEPTIONS OTHERS    = 1 ).

      IF sy-subrc <> 0.
        MESSAGE e881(cbgl00).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD final_total.
    DATA: gs_total     TYPE zuk_item,
          lv_final_net TYPE wrbtr VALUE 0,
          lv_final_vat TYPE wrbtr VALUE 0,
          lv_final_tot TYPE wrbtr VALUE 0.


    "---- Add A (Invoices)
    READ TABLE ct_total INTO gs_total WITH KEY line_type = 'A'.
    IF sy-subrc = 0.
      lv_final_net += gs_total-net_a.
      lv_final_vat += gs_total-vat_b.
      lv_final_tot += gs_total-total_c.
    ENDIF.

    "---- Add B (Pay Push)
    READ TABLE ct_total INTO gs_total WITH KEY line_type = 'B'.
    IF sy-subrc = 0.
      lv_final_net += gs_total-net_a.
      lv_final_vat += gs_total-vat_b.
      lv_final_tot += gs_total-total_c.
    ENDIF.

    "---- Add C (Charity)
    READ TABLE ct_total INTO gs_total WITH KEY line_type = TEXT-023.
    IF sy-subrc = 0.
      lv_final_net += gs_total-net_a.
      lv_final_vat += gs_total-vat_b.
      lv_final_tot += gs_total-total_c.
    ENDIF.

    "---- D: Final Totals (A + B + C)
    CLEAR gs_total.
    gs_total-line_type = TEXT-029.
    gs_total-descr     = TEXT-025.
    gs_total-our_ref   = gs_header-belnr_pay.
    gs_total-net_a     = lv_final_net.
    gs_total-vat_b     = lv_final_vat.
    gs_total-total_c   = lv_final_tot.
    APPEND gs_total TO ct_total.
  ENDMETHOD.


  METHOD total_charity.
    DATA: gs_total   TYPE zuk_item,
          lv_charity TYPE wrbtr.

    DATA(lv_hkont) = |{ lc_hkont ALPHA = IN }|.

    IF gs_header IS NOT INITIAL.
      CLEAR lv_charity.
      SELECT SUM( wrbtr )
        INTO lv_charity
        FROM bseg
        WHERE bukrs = gs_header-bukrs
          AND belnr = gs_header-belnr_pay
          AND gjahr = gs_header-gjahr_pay
          AND hkont = lv_hkont.

    ENDIF.

    IF lv_charity IS NOT INITIAL.
      CLEAR gs_total.
      gs_total-line_type = TEXT-023.
      gs_total-descr     = TEXT-024.

      " KEEP SIGN - charity is always negative
      gs_total-total_c   = - lv_charity.
      gs_total-net_a     = - lv_charity.
      gs_total-vat_b     = 0.

      APPEND gs_total TO ct_total.
    ENDIF.
  ENDMETHOD.


  METHOD total_intellipay.
    DATA: gs_line  TYPE zuk_item,
          gs_total TYPE zuk_item,
          lv_b_net TYPE wrbtr VALUE 0,
          lv_b_vat TYPE wrbtr VALUE 0,
          lv_b_tot TYPE wrbtr VALUE 0.


    LOOP AT it_lines INTO gs_line WHERE line_type = TEXT-018.
      lv_b_net += gs_line-net_a.
      lv_b_vat += gs_line-vat_b.
      lv_b_tot += gs_line-total_c.
    ENDLOOP.

    CLEAR gs_total.
    gs_total-line_type = 'B'.
    gs_total-descr     = TEXT-022.
    gs_total-net_a     = lv_b_net.
    gs_total-vat_b     = lv_b_vat.
    gs_total-total_c   = lv_b_tot.
    APPEND gs_total TO ct_total.
  ENDMETHOD.


  METHOD total_invoice.
    DATA: gs_total TYPE zuk_item,
          lv_a_net TYPE wrbtr VALUE 0,
          lv_a_vat TYPE wrbtr VALUE 0,
          lv_a_tot TYPE wrbtr VALUE 0.


    LOOP AT gt_items INTO DATA(ls_itm2).
      lv_a_net += ls_itm2-net_a.
      lv_a_vat += ls_itm2-vat_b.
      lv_a_tot += ls_itm2-total_c.
    ENDLOOP.

    CLEAR gs_total.
    gs_total-line_type = 'A'.
    gs_total-descr     = TEXT-021.
    gs_total-net_a     = lv_a_net.
    gs_total-vat_b     = lv_a_vat.
    gs_total-total_c   = lv_a_tot.
    APPEND gs_total TO rt_total.
  ENDMETHOD.


  METHOD get_early_settl.
    DATA: lv_es_vat  TYPE wrbtr,
          lv_es_base TYPE wrbtr.

    cs_line-line_type = TEXT-018.
    cs_line-doc_date  = gs_item-doc_date.
    cs_line-descr     = TEXT-019.
    cs_line-our_ref   = gs_item-our_ref.
    cs_line-your_ref  = gs_item-your_ref.

    IF iv_sknto_inv <> 0.    " ES exists for this invoice

      "--- proportion formula: VAT / TOTAL * ES_TOTAL
      "   => 1000 / 6000 * 180 = 30  (all magnitudes)
      IF iv_total_c <> 0.
        lv_es_base =
          abs( iv_vat_b ) * abs( iv_sknto_inv ) / abs( iv_total_c ).
      ELSE.
        lv_es_base = 0.
      ENDIF.

      " apply sign of SKNTO (usually negative)
      IF iv_sknto_inv < 0.
        lv_es_vat = - lv_es_base.
      ELSE.
        lv_es_vat = lv_es_base.
      ENDIF.

      cs_line-total_c = - iv_sknto_inv.          " e.g. -180
      cs_line-vat_b   = - lv_es_vat.             " e.g. -30
      cs_line-net_a   = - iv_sknto_inv + lv_es_vat. " -150

    ENDIF.

    " Flip ES sign for credit notes (Intellipay should reverse)
    IF is_bkpf-blart = TEXT-015 OR is_bkpf-blart = TEXT-016.
      cs_line-total_c = abs( cs_line-total_c ). " positive
      cs_line-vat_b   = abs( cs_line-vat_b ).
      cs_line-net_a   = abs( cs_line-net_a ).
    ENDIF.

*    IF gs_line-total_c <> 0 OR gs_line-vat_b  <> 0 OR gs_line-net_a  <> 0.
    APPEND cs_line TO et_lines.
  ENDMETHOD.


  METHOD get_invoice_details.
    DATA: ls_rbkp  TYPE rbkp,
          lv_yref  TYPE xblnr,
          lv_net_a TYPE wrbtr.

    "--------------- 1. Header BKPF --------------------
    SELECT SINGLE bldat, blart, xblnr
      FROM bkpf
      WHERE bukrs = @is_regup-bukrs
        AND belnr = @is_regup-belnr
        AND gjahr = @is_regup-gjahr
      INTO CORRESPONDING FIELDS OF @es_bkpf.

    gs_item-doc_date = es_bkpf-bldat.

    "--------------- 2. Description --------------------
    IF es_bkpf-blart = TEXT-012 OR es_bkpf-blart = TEXT-013.
      gs_item-descr = TEXT-014.
    ELSEIF es_bkpf-blart = TEXT-015 OR es_bkpf-blart = TEXT-016.
      gs_item-descr = TEXT-017.
    ELSE.
      gs_item-descr = es_bkpf-blart.
    ENDIF.

    "--------------- 3. Our Ref ------------------------
    gs_item-our_ref = is_regup-belnr.

    "--------------- 4. Your Ref priority --------------
    SELECT SINGLE zz1_invoiceno_mih, xblnr
      FROM rbkp
      WHERE bukrs = @is_regup-bukrs
        AND belnr = @is_regup-belnr
        AND gjahr = @is_regup-gjahr
      INTO CORRESPONDING FIELDS OF @ls_rbkp.

    IF ls_rbkp-zz1_invoiceno_mih IS NOT INITIAL.
      lv_yref = ls_rbkp-zz1_invoiceno_mih.
    ELSEIF ls_rbkp-xblnr IS NOT INITIAL.
      lv_yref = ls_rbkp-xblnr.
    ELSEIF es_bkpf-xblnr IS NOT INITIAL.
      lv_yref = es_bkpf-xblnr.
    ELSE.
      lv_yref = ''.
    ENDIF.

    gs_item-your_ref = lv_yref.

    "--------------- 5. Total (vendor line) & SKNTO ----
    " take both WRBTR and SKNTO from the same vendor line
    CLEAR: ev_total_c,
       ev_sknto_inv.

    SELECT wrbtr sknto
      FROM bseg
      INTO (ev_total_c, ev_sknto_inv)
      WHERE bukrs = is_regup-bukrs
        AND belnr = is_regup-belnr
        AND gjahr = is_regup-gjahr
        AND koart = 'K'
      ORDER BY PRIMARY KEY.
      EXIT. "take first vendor line deterministically
    ENDSELECT.

    gs_item-total_c = ev_total_c.        " keep original sign for doc

    "--------------- 6. VAT (invoice level) ------------
    SELECT SUM( fwste ) INTO @ev_vat_b
      FROM bset
      WHERE bukrs = @is_regup-bukrs
        AND belnr = @is_regup-belnr
        AND gjahr = @is_regup-gjahr.

    " For credit note we want VAT to have same sign as TOTAL
    IF ev_total_c < 0.
      ev_vat_b = - ev_vat_b.
    ENDIF.

    gs_item-vat_b = ev_vat_b.

    "--------------- 7. Net = Total – VAT --------------
    lv_net_a      = ev_total_c - ev_vat_b.
    gs_item-net_a = lv_net_a.

    " Fix sign for CREDIT NOTE documents
    IF es_bkpf-blart = TEXT-015 OR es_bkpf-blart = TEXT-016.  " Credit memo types
      gs_item-total_c = - ev_total_c.      " flip total
      gs_item-vat_b   = - ev_vat_b.
      gs_item-net_a   = - lv_net_a.        " flip VAT
    ENDIF.

    "--------------- 8. Key fields ---------------------
    gs_item-belnr = is_regup-belnr.
    gs_item-gjahr = is_regup-gjahr.
    gs_item-bukrs = is_regup-bukrs.

    APPEND gs_item TO gt_items.
  ENDMETHOD.


  METHOD get_line_item.
    SELECT *
  FROM regup
  WHERE laufd = @mv_laufd
    AND laufi = @mv_laufi
    AND xvorl = @space
  ORDER BY lifnr, zbukr, belnr, gjahr, buzei
  INTO TABLE @rt_regup.


    IF rt_regup IS INITIAL.
      MESSAGE e004(zremit_msg).
    ENDIF.
  ENDMETHOD.


  METHOD get_company_addr.

    DATA lv_adrnr      TYPE t001-adrnr.
    DATA ls_comp_addr  TYPE adrc.

    "Read address number from T001 (no JOIN, avoid AMB_SINGLE)
    CLEAR lv_adrnr.
    SELECT adrnr
      FROM t001
      INTO lv_adrnr
      WHERE bukrs = is_reguh-zbukr
      ORDER BY PRIMARY KEY.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND lv_adrnr IS NOT INITIAL.

      "Read address details from ADRC (avoid AMB_SINGLE)
      CLEAR ls_comp_addr.
      SELECT name1 street city1 post_code1 country
        FROM adrc
        INTO CORRESPONDING FIELDS OF ls_comp_addr
        WHERE addrnumber = lv_adrnr
        ORDER BY PRIMARY KEY.
        EXIT.
      ENDSELECT.

      IF sy-subrc = 0.
        gs_header-from_name1    = ls_comp_addr-name1.
        gs_header-from_street   = ls_comp_addr-street.
        gs_header-from_city     = ls_comp_addr-city1.
        gs_header-from_postcode = ls_comp_addr-post_code1.
        gs_header-from_country  = ls_comp_addr-country.
      ENDIF.

      "Contact details (avoid SELECT SINGLE not unique without UP TO)
      CLEAR: gs_header-from_tel,
             gs_header-from_email.

      SELECT p~tel_number,e~smtp_addr
        FROM adr2 AS p
        LEFT JOIN adr6 AS e
          ON  e~addrnumber = p~addrnumber
          AND e~consnumber = p~consnumber
        INTO (@gs_header-from_tel, @gs_header-from_email)
        WHERE p~addrnumber = @lv_adrnr
          AND p~consnumber = 1
        ORDER BY p~addrnumber, p~consnumber.
        EXIT. "first row only
      ENDSELECT.

    ENDIF.

  ENDMETHOD.


  METHOD get_vendor_addr.

    DATA ls_vend_addr TYPE adrc.

    CLEAR ls_vend_addr.

    SELECT c~name1, c~street, c~city1, c~post_code1, c~country
      FROM lfa1 AS a
      LEFT JOIN adrc AS c
        ON c~addrnumber = a~adrnr
      INTO CORRESPONDING FIELDS OF @ls_vend_addr
      WHERE a~lifnr = @is_reguh-lifnr
      ORDER BY a~lifnr.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND ls_vend_addr-name1 IS NOT INITIAL.
      gs_header-to_name1    = ls_vend_addr-name1.
      gs_header-to_street   = ls_vend_addr-street.
      gs_header-to_city     = ls_vend_addr-city1.
      gs_header-to_postcode = ls_vend_addr-post_code1.
      gs_header-to_country  = ls_vend_addr-country.
    ENDIF.

  ENDMETHOD.


  METHOD get_payment_doc.
    SELECT * FROM reguh
      INTO TABLE @rt_reguh
      WHERE laufd = @mv_laufd
        AND laufi = @mv_laufi
        AND xvorl = ''.           " exclude proposal / simulate runs

    IF rt_reguh IS INITIAL.
      MESSAGE e003(zremit_msg).
    ENDIF.
  ENDMETHOD.


  METHOD get_data.

    TYPES: BEGIN OF ty_item,
             bukrs             TYPE regup-bukrs,
             belnr             TYPE regup-belnr,
             waers             TYPE regup-waers,
             budat             TYPE regup-budat,
             dmbtr             TYPE regup-dmbtr,
             zz1_invoiceno_mih TYPE rbkp-zz1_invoiceno_mih,
           END OF ty_item.

    DATA: lv_fm_name        TYPE rs38l_fnam,
          ls_docparams      TYPE sfpdocparams,
          ls_output         TYPE sfpoutputparams,
          ls_formoutput     TYPE fpformoutput,
          lv_num            TYPE n LENGTH 1,
          lv_lang1          TYPE sy-langu ##NEEDED,
          lv_lang2          TYPE sy-langu ##NEEDED,
          lv_xstring        TYPE xstring,
          ls_fpayh          TYPE fpayh,
          ls_fpayhx         TYPE fpayhx,
          is_spell          TYPE spell,
          lv_filename       TYPE string,
          is_cpd_address    TYPE adrs_print,
          it_paymethod_text TYPE tline_tab,
          it_fpayp          TYPE f_t_payp,
          lv_tdname         TYPE thead-tdname,
          it_item           TYPE TABLE OF ty_item,
          lv_subject_text   TYPE string.


    " PDF Merger Init
    TRY.
        DATA(lo_merger) = NEW cl_rspo_pdf_merge( ).
      CATCH cx_rspo_pdf_merge INTO DATA(lo_error).
        MESSAGE e000(zremit_msg) WITH lo_error->get_text( ).
        RETURN.
    ENDTRY.

    ls_output-nopreview = 'X'.
    ls_output-getpdf    = ls_output-nopreview.

    " FI Payment Header
    CALL FUNCTION 'FI_PDF_PRINT_PREPARE'
      EXPORTING
        is_reguh  = gs_reguh
      IMPORTING
        es_fpayh  = ls_fpayh
        es_fpayhx = ls_fpayhx.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_output.

    " Address Fetch (ADRC)
    DATA lv_address TYPE string.

    lv_address = get_addr_line( ).

    " REGUP
    SELECT bukrs,
           belnr,
           budat,
           waers,
           dmbtr
      FROM regup
      WHERE bukrs = @gs_reguh-zbukr
        AND laufi = @mv_laufi
        AND xvorl = @space
      ORDER BY bukrs, belnr, budat
      INTO TABLE @DATA(lt_regup).


    " ACDOCA
    SELECT a~rbukrs,
           a~belnr,
           a~awref,
           a~zz1_invoicenumber_cob
      FROM acdoca AS a
             INNER JOIN
               regup AS r ON  a~rbukrs = r~bukrs
                          AND a~belnr  = r~belnr
      WHERE r~laufi = @mv_laufi
        AND r~xvorl = ' '
      INTO TABLE @DATA(lt_acdoca).

    " Build it_item

    LOOP AT lt_regup INTO DATA(ls_regup).

      READ TABLE lt_acdoca INTO DATA(ls_acdoca)
           WITH KEY rbukrs = ls_regup-bukrs
                    belnr  = ls_regup-belnr.

      IF sy-subrc = 0.
        APPEND VALUE ty_item( bukrs             = ls_regup-bukrs
                              belnr             = ls_regup-belnr
                              waers             = ls_regup-waers
                              budat             = ls_regup-budat
                              dmbtr             = ls_regup-dmbtr
                              zz1_invoiceno_mih = ls_acdoca-zz1_invoicenumber_cob ) TO it_item.
      ENDIF.

    ENDLOOP.

    " Email subject (unchanged logic)
    lv_subject_text = TEXT-010.

    REPLACE '&1' IN lv_subject_text WITH |{ gs_reguh-zaldt DATE = USER }|.

    gv_subject = lv_subject_text.


    lv_lang1 = 'E'.

    CASE gs_reguh-land1.
      WHEN 'MX'.
        lv_lang2 = 'S'.
      WHEN 'CA'.
        lv_lang2 = 'F'.
        lv_subject_text = TEXT-011.
        REPLACE '&1' IN lv_subject_text WITH |{ gs_reguh-zaldt DATE = USER }|.
        gv_subject = lv_subject_text.
    ENDCASE.

    " LOOP: 2-Language PDF Generation
    DO 2 TIMES.

      lv_num = sy-index.
      DATA(lv_lang_name) = |lv_lang{ lv_num }|.
      ASSIGN (lv_lang_name) TO FIELD-SYMBOL(<lang>).

      IF <lang> IS INITIAL.
        CONTINUE.
      ENDIF.

      ls_docparams-replangu1 = <lang>.
      ls_docparams-langu     = <lang>.

      CONCATENATE mv_tdform '_' <lang> INTO lv_tdname.
      get_text( EXPORTING i_lang    = <lang>
                CHANGING  cv_tdname = lv_tdname ).
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = 'ZFI_F_REMITTANCE_ADVICE'
            IMPORTING
              e_funcname = lv_fm_name.

        CATCH cx_fp_api_usage INTO DATA(lx_api_usage).
          MESSAGE lx_api_usage TYPE 'E'.

        CATCH cx_fp_api_repository INTO DATA(lx_repo).
          MESSAGE lx_repo TYPE 'E'.

        CATCH cx_fp_api_internal INTO DATA(lx_internal).
          MESSAGE lx_internal TYPE 'E'.

      ENDTRY.

      CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000007'
        EXPORTING
          /1bcdwb/docparams  = ls_docparams
          is_fpayh           = ls_fpayh
          is_fpayhx          = ls_fpayhx
          is_spell           = is_spell
          is_cpd_address     = is_cpd_address
          it_paymethod_text  = it_paymethod_text
          it_fpayp           = it_fpayp
          lv_address         = lv_address
          gv_footer          = gv_footer
          it_item            = it_item
          gv_text            = gv_text
          gv_doc             = gv_doc
          gv_your_doc        = gv_your_doc
          gv_date            = gv_date
          gv_gross_amt       = gv_gross_amt
          gv_currency        = gv_currency
        IMPORTING
          /1bcdwb/formoutput = ls_formoutput.

      lv_xstring = ls_formoutput-pdf.
      lo_merger->add_document( lv_xstring ).

    ENDDO.

    " Merge PDFs → XSTRING → SOLIX
    CALL FUNCTION 'FP_JOB_CLOSE'.

    lo_merger->merge_documents( IMPORTING merged_document = gv_merged_xstring ).

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = gv_merged_xstring
      IMPORTING
        output_length = gv_length
      TABLES
        binary_tab    = gt_doc_bin.

    " Optional front-end preview in simulation mode
    IF mv_sim IS NOT INITIAL.
      cl_gui_frontend_services=>get_desktop_directory( CHANGING   desktop_directory    = lv_filename
                                                       EXCEPTIONS cntl_error           = 1
                                                                  error_no_gui         = 2
                                                                  not_supported_by_gui = 3
                                                                  OTHERS               = 4 ).

      IF sy-subrc IS INITIAL.
        cl_gui_cfw=>flush( ).
      ENDIF.

      CONCATENATE lv_filename test_filename INTO lv_filename.

      cl_gui_frontend_services=>gui_download( EXPORTING  filename                = lv_filename
                                                         filetype                = 'BIN'
                                              CHANGING   data_tab                = gt_doc_bin
                                              EXCEPTIONS file_write_error        = 1
                                                         no_batch                = 2
                                                         gui_refuse_filetransfer = 3
                                                         invalid_type            = 4
                                                         no_authority            = 5
                                                         unknown_error           = 6
                                                         header_not_allowed      = 7
                                                         separator_not_allowed   = 8
                                                         filesize_not_allowed    = 9
                                                         header_too_long         = 10
                                                         dp_error_create         = 11
                                                         dp_error_send           = 12
                                                         dp_error_write          = 13
                                                         unknown_dp_error        = 14
                                                         access_denied           = 15
                                                         dp_out_of_memory        = 16
                                                         disk_full               = 17
                                                         dp_timeout              = 18
                                                         file_not_found          = 19
                                                         dataprovider_exception  = 20
                                                         control_flush_error     = 21
                                                         not_supported_by_gui    = 22
                                                         error_no_gui            = 23
                                                         OTHERS                  = 24 ).

      IF sy-subrc <> 0.
        MESSAGE e861(cbgl00) WITH lv_filename.
      ENDIF.

      cl_gui_frontend_services=>execute( EXPORTING  document  = lv_filename
                                                    operation = 'OPEN'
                                         EXCEPTIONS OTHERS    = 1 ).

      IF sy-subrc <> 0.
        MESSAGE e881(cbgl00).
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD get_text.
    " Read Header Text (HEADER)

    read_text_into_string( EXPORTING iv_id     = 'ST'
                                     iv_langu  = sy-langu
                                     iv_name   = cv_tdname        " same variable as before
                                     iv_object = 'TEXT'
                           IMPORTING ev_string = DATA(lv_header_text) ).

    " append header text into gt_email_text
    CLEAR gt_email_text.
    IF lv_header_text IS NOT INITIAL.
      APPEND lv_header_text TO gt_email_text.
    ENDIF.
    " Payment Text (BODY)
    CLEAR gv_text.

    read_text_into_string( EXPORTING iv_id     = 'ST'
                                     iv_langu  = i_lang            " English / French / Spanish
                                     iv_name   = 'ZPAYMENT_TEXT'
                                     iv_object = 'TEXT'
                           IMPORTING ev_string = gv_text ).

    " Footer Text (FOOTER)
    CLEAR gv_footer.

    CONCATENATE 'ZFI_REMIT_FOOTER_' gs_reguh-land1
                INTO cv_tdname.

    read_text_into_string( EXPORTING iv_id     = 'ST'
                                     iv_langu  = i_lang
                                     iv_name   = cv_tdname
                                     iv_object = 'TEXT'
                           IMPORTING ev_string = gv_footer ).
  ENDMETHOD.


  METHOD read_text_into_string.
    DATA lt_lines TYPE STANDARD TABLE OF tline.
    DATA ls_line  TYPE tline.

    CLEAR ev_string.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = iv_id
        language = iv_langu
        name     = iv_name
        object   = iv_object
      TABLES
        lines    = lt_lines
      EXCEPTIONS
        OTHERS   = 1.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT lt_lines INTO ls_line.
      ev_string = |{ ev_string }{ ls_line-tdline }|.
    ENDLOOP.

    ev_string = condense( ev_string ).
  ENDMETHOD.


  METHOD get_addr_line.

    DATA lv_adrnr TYPE t001-adrnr.
    DATA ls_adrc  TYPE adrc.

    CLEAR rv_address.

    "Read ADRNR from buffered table T001 (no JOIN, avoid AMB_SINGLE)
    CLEAR lv_adrnr.
    SELECT adrnr
      FROM t001
      INTO lv_adrnr
      WHERE bukrs = gs_reguh-zbukr
      ORDER BY PRIMARY KEY.
      EXIT.
    ENDSELECT.

    IF sy-subrc <> 0 OR lv_adrnr IS INITIAL.
      RETURN.
    ENDIF.

    "Read address fields from ADRC (avoid AMB_SINGLE)
    CLEAR ls_adrc.
    SELECT name1 city1 city2 post_code1 house_num1 street country
      FROM adrc
      INTO CORRESPONDING FIELDS OF ls_adrc
      WHERE addrnumber = lv_adrnr
      ORDER BY PRIMARY KEY.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND ls_adrc-name1 IS NOT INITIAL.

      rv_address =
        |{ ls_adrc-name1 } { ls_adrc-city1 } { ls_adrc-city2 } | &&
        |{ ls_adrc-post_code1 } { ls_adrc-house_num1 } | &&
        |{ ls_adrc-street } { ls_adrc-country }|.

      rv_address = condense( rv_address ).

    ENDIF.

  ENDMETHOD.


  METHOD email_form.
    DATA: lt_rec         TYPE crmtt_email_address,
          lt_files       TYPE STANDARD TABLE OF zcl_send_email=>tp_files,
          lt_html        TYPE cl_abap_browser=>html_table,
          lv_file        TYPE string,
          lv_descr       TYPE string,
          lv_header_line TYPE string.

    CHECK mv_email IS NOT INITIAL.
* get all the emails to send to
*  PERFORM get_file_name CHANGING lv_file.
    get_file_name( CHANGING p_filename = lv_file ).

    APPEND INITIAL LINE TO lt_files ASSIGNING FIELD-SYMBOL(<file>).
    <file>-file_name  = lv_file.
    lv_descr = TEXT-030.
    REPLACE '&1' IN lv_descr WITH |{ sy-datum }|.
    <file>-file_descr = lv_descr.
    <file>-file_data  = gv_merged_xstring.
    <file>-file_extn  = 'PDF'.

    SELECT
      FROM but020 AS a
             JOIN
               adr6 AS b ON a~addrnumber = b~addrnumber
      FIELDS b~smtp_addr
      WHERE a~partner = @gs_reguh-lifnr
      INTO TABLE @lt_rec.
    IF lt_rec IS INITIAL.
      MESSAGE e000(zremit_msg) WITH 'Email Id Not found for vendor' gs_reguh-lifnr.
    ENDIF.
    IF mv_sim IS NOT INITIAL.
      lv_header_line = TEXT-031.

      REPLACE '&1' IN lv_header_line WITH gs_reguh-land1.
      REPLACE '&2' IN lv_header_line WITH gv_subject.
      REPLACE '&3' IN lv_header_line WITH lv_file.
      INSERT INITIAL LINE INTO gt_email_text INDEX 1 ASSIGNING FIELD-SYMBOL(<text>).
      <text>-line =  lv_header_line.
      LOOP AT lt_rec ASSIGNING FIELD-SYMBOL(<rec>).
        <text>-line = |{ <text>-line } { <rec> }; |.
      ENDLOOP.
      INSERT INITIAL LINE INTO gt_email_text INDEX 2 ASSIGNING <text>.
      <text>-line = TEXT-032.

      lt_html = gt_email_text.

      cl_abap_browser=>show_html( html = lt_html
                                  size = cl_abap_browser=>medium ).
    ELSE.
      zcl_send_email=>send_email( i_subjct       = gv_subject
                                  it_rec         = lt_rec
                                  it_prefix_text = gt_email_text
                                  i_simulation   = mv_sim
                                  it_files       = lt_files ).

    ENDIF.
  ENDMETHOD.


  METHOD get_file_name.
    DATA lv_param1 TYPE string.
    DATA lv_param2 TYPE string.
    DATA lv_string TYPE string.

    " Get BP external number
    SELECT SINGLE bpext FROM but000
      WHERE partner = @gs_reguh-lifnr
      " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
      INTO @DATA(lv_bpext).

    " Remove leading zeros from vendor number
    lv_string = gs_reguh-lifnr.
    SHIFT lv_string LEFT DELETING LEADING '0'.

    " Build dynamic filename parameters
    lv_param1 = TEXT-020.

    REPLACE '&1' IN lv_param1 WITH lv_string.
    lv_param2 = |_{ gs_reguh-vblnr }_{ gs_reguh-land1 }|.

    IF lv_bpext IS NOT INITIAL.
      lv_param2 = |{ lv_param2 }_{ lv_bpext }|.
    ENDIF.

    " Get final logical → physical filename
    CALL FUNCTION 'FILE_GET_NAME'
      EXPORTING
        logical_filename = mv_file    " <--- was p_file
        parameter_1      = lv_param1
        parameter_2      = lv_param2
        parameter_3      = 'PDF'
      IMPORTING
        file_name        = p_filename
      EXCEPTIONS
        file_not_found   = 1
        OTHERS           = 2.

    IF sy-subrc <> 0.
      MESSAGE e541(gz) WITH p_filename.   " Logical file name & not found
    ENDIF.
  ENDMETHOD.


  METHOD download_file.
    DATA lv_file TYPE string.

    CHECK mv_down IS NOT INITIAL.

*  PERFORM get_file_name CHANGING lv_file.
    get_file_name( CHANGING p_filename = lv_file ).
    " Write merged PDF back to AL11 directory

    DATA(lv_fullpath_save) = lv_file.
    TRY.
        OPEN DATASET lv_fullpath_save FOR OUTPUT IN BINARY MODE.
        IF sy-subrc <> 0.
          RAISE EXCEPTION NEW cx_sy_file_open( textid   = cx_sy_file_open=>cx_sy_file_access_error
                                               filename = lv_fullpath_save ).
        ENDIF.

        LOOP AT gt_doc_bin ASSIGNING FIELD-SYMBOL(<lv_line>).
          TRANSFER <lv_line> TO lv_fullpath_save.
        ENDLOOP.

        CLOSE DATASET lv_fullpath_save.

        MESSAGE e000(zremit_msg) WITH lv_fullpath_save.

      CATCH cx_sy_file_open INTO DATA(lx_open).
        MESSAGE lx_open->get_text( ) TYPE 'E'.

      CATCH cx_sy_file_access_error INTO DATA(lx_access).
        MESSAGE lx_access->get_text( ) TYPE 'E'.

      CATCH cx_root INTO DATA(lx_root).
        MESSAGE lx_root->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
