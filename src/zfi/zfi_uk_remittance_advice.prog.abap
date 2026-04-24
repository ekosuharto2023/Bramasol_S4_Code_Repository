*&---------------------------------------------------------------------*
*& Report ZFI_UK_REMITTANCE_ADVICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_uk_remittance_advice.

DATA: gs_reguh          TYPE reguh,
      gt_doc_bin        TYPE solix_tab, "STANDARD TABLE OF x255,
      gv_merged_xstring TYPE xstring,
      gt_email_text     TYPE soli_tab,
      gv_subject        TYPE so_obj_des,
      gv_length         TYPE i.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_laufd TYPE laufd OBLIGATORY,
              p_laufi TYPE laufi OBLIGATORY,
              p_sim   AS CHECKBOX DEFAULT 'X'. "not used yet, just kept
SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_email  AS CHECKBOX USER-COMMAND eml,
              p_tdform TYPE tdobname MODIF ID eml DEFAULT 'ZF110_EMAIL',
              p_down   AS CHECKBOX USER-COMMAND fil,
              p_file   TYPE filename-fileintern MODIF ID fil DEFAULT 'ZDOWNLOAD'
              .
SELECTION-SCREEN END OF BLOCK blk2.
*---------------------------------------------------------------------*
* Header type for Adobe form (one line per payment document)
*---------------------------------------------------------------------*
CONSTANTS: lc_hkont TYPE hkont VALUE '22170070'.

DATA:  gs_header TYPE zuk_header. "ty_header.

*---------------------------------------------------------------------*
* STEP 2: Collect invoice / credit note items for the payment run
*---------------------------------------------------------------------*

DATA: gt_items TYPE zt_uk_item,
      gs_item  TYPE zuk_item.

DATA: lt_regup TYPE STANDARD TABLE OF regup,
      ls_regup TYPE regup.

DATA: ls_bkpf  TYPE bkpf,
      ls_rbkp  TYPE rbkp,
      lv_vat   TYPE wrbtr,
      lv_total TYPE wrbtr,
      lv_net   TYPE wrbtr,
      lv_yref  TYPE xblnr,
      lv_zuawa TYPE lfb1-zuawa.


DATA: gt_lines TYPE zt_uk_item, "STANDARD TABLE OF zuk_item,
      gs_line  TYPE zuk_item,
      gt_total TYPE zt_uk_item, "STANDARD TABLE OF zuk_item,
      gs_total TYPE zuk_item.


*---------------------------------------------------------------------*
* Local work data
*---------------------------------------------------------------------*
DATA: lt_reguh TYPE STANDARD TABLE OF reguh,
      ls_reguh TYPE reguh.

DATA: lv_gjahr_pay TYPE gjahr,
      lv_usnam     TYPE syuname,
      lv_mask      TYPE string,
      lv_last4     TYPE string,
      lv_off       TYPE i.

*---------------------------------------------------------------------*
* START-OF-SELECTION
*---------------------------------------------------------------------*
START-OF-SELECTION.

* 1. Get all payment documents for the run (unlocked, not proposal)
  SELECT *
    FROM reguh
    INTO TABLE @lt_reguh
    WHERE laufd = @p_laufd
      AND laufi = @p_laufi
      AND xvorl = ''.           "exclude proposal / simulate runs

  IF lt_reguh IS INITIAL.
    MESSAGE 'No payment documents found for this run' TYPE 'E'.
  ENDIF.

* 2. Build header record per payment
  LOOP AT lt_reguh INTO ls_reguh.

    CLEAR gs_header.

    gs_header-laufd     = ls_reguh-laufd.
    gs_header-laufi     = ls_reguh-laufi.
    gs_header-bukrs     = ls_reguh-zbukr.
    gs_header-belnr_pay = ls_reguh-vblnr.
    gs_header-pay_date  = ls_reguh-zaldt.

    " Derive fiscal year from payment date (year part of ZALDT)
    lv_gjahr_pay        = ls_reguh-zaldt(4).
    gs_header-gjahr_pay = lv_gjahr_pay.

    " Document currency from BKPF (payment document)
    SELECT SINGLE waers
      INTO @gs_header-doc_curr
      FROM bkpf
      WHERE bukrs = @ls_reguh-zbukr
        AND belnr = @ls_reguh-vblnr
        AND gjahr = @lv_gjahr_pay.

    " Company VAT number (under Holman address)
    SELECT SINGLE stceg
      INTO @gs_header-comp_vat_no
      FROM t001
      WHERE bukrs = @ls_reguh-zbukr.

    " Vendor number & VAT
    gs_header-vendor = ls_reguh-lifnr.

    SELECT SINGLE stceg
      INTO @gs_header-vendor_vat
      FROM lfa1
      WHERE lifnr = @ls_reguh-lifnr.

    " Vendor BP number – safe assumption: same as vendor
    gs_header-vendor_bp = ls_reguh-lifnr.


    " Company Accounting Clerk Name
    DATA lv_clerk_code TYPE lfb1-busab.

    SELECT SINGLE busab
      INTO @lv_clerk_code
      FROM lfb1
      WHERE lifnr = @ls_reguh-lifnr
        AND bukrs = @ls_reguh-zbukr.

    SELECT SINGLE sname
      INTO @gs_header-acct_clerk
      FROM t001s
      WHERE busab = @lv_clerk_code.



    " Bank sort code & account number from vendor bank details (LFBK)
    CLEAR: gs_header-bank_sort, gs_header-bank_acct.
    SELECT SINGLE bankl, bankn
      INTO (@gs_header-bank_sort, @gs_header-bank_acct)
      FROM lfbk
      WHERE lifnr = @ls_reguh-lifnr.

    "------- Mask BANK ACCOUNT (keep last 4 digits) --------
    DATA(lv_len)   = strlen( gs_header-bank_acct ).

    IF lv_len > 4.
      lv_off = lv_len - 4.
      lv_last4 = gs_header-bank_acct+lv_off(4).    " <-- VALID SYNTAX
      lv_mask  = repeat( val = 'X' occ = lv_off ).
      gs_header-bank_acct = lv_mask && lv_last4.
    ENDIF.


    gs_header-pay_text1 =
      |Payment in { gs_header-doc_curr } will be made direct to your account via BACS on { ls_reguh-zaldt DATE = USER } and will be available within 2-3 business days. | &&
      |The payments will be made to Sort Code { gs_header-bank_sort } bank account no { gs_header-bank_acct }.|.


*---------------------------------------------------------------------*
* Vendor Address (TO:)
*---------------------------------------------------------------------*
    DATA lv_vend_adrnr TYPE adrnr.

    SELECT SINGLE adrnr
      INTO @lv_vend_adrnr
      FROM lfa1
      WHERE lifnr = @ls_reguh-lifnr.

    IF lv_vend_adrnr IS NOT INITIAL.
      SELECT SINGLE
             name1,
             street,
             city1,
             post_code1,
             country
        INTO (@gs_header-to_name1,
              @gs_header-to_street,
              @gs_header-to_city,
              @gs_header-to_postcode,
              @gs_header-to_country)
        FROM adrc
        WHERE addrnumber = @lv_vend_adrnr.
    ENDIF.


*---------------------------------------------------------------------*
* Company Address (FROM:)
*---------------------------------------------------------------------*
    DATA lv_comp_adrnr TYPE adrnr.

    SELECT SINGLE adrnr
      INTO @lv_comp_adrnr
      FROM t001
      WHERE bukrs = @ls_reguh-zbukr.

    IF lv_comp_adrnr IS NOT INITIAL.
      SELECT SINGLE
             name1,
             street,
             city1,
             post_code1,
             country
        INTO (@gs_header-from_name1,
              @gs_header-from_street,
              @gs_header-from_city,
              @gs_header-from_postcode,
              @gs_header-from_country)
        FROM adrc
        WHERE addrnumber = @lv_comp_adrnr.
    ENDIF.

    "---------------------------------------------------------------
    " Fetch FROM Telephone (ADR2)
    "---------------------------------------------------------------
    SELECT SINGLE tel_number
      INTO @gs_header-from_tel
      FROM adr2
      WHERE addrnumber = @lv_comp_adrnr
        AND consnumber = 1.    "first phone entry

    "---------------------------------------------------------------
    " Fetch FROM Email (ADR6)
    "---------------------------------------------------------------
    SELECT SINGLE smtp_addr
      INTO @gs_header-from_email
      FROM adr6
      WHERE addrnumber = @lv_comp_adrnr
        AND consnumber = 1.    "first email entry

*    APPEND gs_header TO gt_header.

  ENDLOOP.


*---------------------------------------------------------------------*
* Read line items from REGUP for this run
*---------------------------------------------------------------------*
  SELECT *
    FROM regup
    INTO TABLE @lt_regup
    WHERE laufd = @p_laufd
      AND laufi = @p_laufi
      AND xvorl = ''.

  IF lt_regup IS INITIAL.
    MESSAGE 'No invoice/credit note items found for this run' TYPE 'E'.
  ENDIF.




  DATA: lv_total_c   TYPE wrbtr,
        lv_vat_b     TYPE wrbtr,
        lv_net_a     TYPE wrbtr,
        lv_sknto_inv TYPE wrbtr,
        lv_es_vat    TYPE wrbtr,
        lv_es_base   TYPE wrbtr.

  LOOP AT lt_regup INTO ls_regup.

    CLEAR: gs_item, gs_line, ls_bkpf, ls_rbkp,
           lv_total_c, lv_vat_b, lv_net_a, lv_yref,
           lv_sknto_inv, lv_es_vat, lv_es_base.

    "--------------- 1. Header BKPF --------------------
    SELECT SINGLE *
      INTO @ls_bkpf
      FROM bkpf
      WHERE bukrs = @ls_regup-bukrs
        AND belnr = @ls_regup-belnr
        AND gjahr = @ls_regup-gjahr.

    gs_item-doc_date = ls_bkpf-bldat.

    "--------------- 2. Description --------------------
    IF ls_bkpf-blart = 'KR' OR ls_bkpf-blart = 'RE'.
      gs_item-descr = 'INVOICE'.
    ELSEIF ls_bkpf-blart = 'KG' OR ls_bkpf-blart = 'RN'.
      gs_item-descr = 'CREDIT NOTE'.
    ELSE.
      gs_item-descr = ls_bkpf-blart.
    ENDIF.

    "--------------- 3. Our Ref ------------------------
    gs_item-our_ref = ls_regup-belnr.

    "--------------- 4. Your Ref priority --------------
    SELECT SINGLE *
      INTO @ls_rbkp
      FROM rbkp
      WHERE bukrs = @ls_regup-bukrs
        AND belnr = @ls_regup-belnr
        AND gjahr = @ls_regup-gjahr.

    IF ls_rbkp-zz1_invoiceno_mih IS NOT INITIAL.
      lv_yref = ls_rbkp-zz1_invoiceno_mih.
    ELSEIF ls_rbkp-xblnr IS NOT INITIAL.
      lv_yref = ls_rbkp-xblnr.
    ELSEIF ls_bkpf-xblnr IS NOT INITIAL.
      lv_yref = ls_bkpf-xblnr.
    ELSE.
      lv_yref = ''.
    ENDIF.

    gs_item-your_ref = lv_yref.

    "--------------- 5. Total (vendor line) & SKNTO ----
    " take both WRBTR and SKNTO from the same vendor line
    SELECT SINGLE wrbtr, sknto
      INTO (@lv_total_c, @lv_sknto_inv)
      FROM bseg
      WHERE bukrs = @ls_regup-bukrs
        AND belnr = @ls_regup-belnr
        AND gjahr = @ls_regup-gjahr
        AND koart = 'K'.

    gs_item-total_c = lv_total_c.        " keep original sign for doc

    "--------------- 6. VAT (invoice level) ------------
    SELECT SUM( fwste )
      INTO @lv_vat_b
      FROM bset
      WHERE bukrs = @ls_regup-bukrs
        AND belnr = @ls_regup-belnr
        AND gjahr = @ls_regup-gjahr.

    " For credit note we want VAT to have same sign as TOTAL
    IF lv_total_c < 0.
      lv_vat_b = - lv_vat_b.
    ENDIF.

    gs_item-vat_b = lv_vat_b.

    "--------------- 7. Net = Total – VAT --------------
    lv_net_a       = lv_total_c - lv_vat_b.
    gs_item-net_a  = lv_net_a.

    " Fix sign for CREDIT NOTE documents
    IF ls_bkpf-blart = 'KG' OR ls_bkpf-blart = 'RN'.  "Credit memo types
      gs_item-total_c = - lv_total_c.      "flip total
      gs_item-vat_b   = - lv_vat_b.
      gs_item-net_a   = - lv_net_a.        "flip VAT
    ENDIF.

    "--------------- 8. Key fields ---------------------
    gs_item-belnr = ls_regup-belnr.
    gs_item-gjahr = ls_regup-gjahr.
    gs_item-bukrs = ls_regup-bukrs.

    APPEND gs_item TO gt_items.

    "===================================================
    "* EARLY SETTLEMENT LINE FOR THIS INVOICE (GT_LINES)
    "===================================================

    CLEAR gs_line.
    gs_line-line_type = 'ES'.
    gs_line-doc_date  = gs_item-doc_date.
    gs_line-descr     = 'Intellipay'.
    gs_line-our_ref   = gs_item-our_ref.
    gs_line-your_ref  = gs_item-your_ref.

    IF lv_sknto_inv <> 0.    " ES exists for this invoice

      "--- proportion formula: VAT / TOTAL * ES_TOTAL
      "   => 1000 / 6000 * 180 = 30  (all magnitudes)
      IF lv_total_c <> 0.
        lv_es_base =
          abs( lv_vat_b ) * abs( lv_sknto_inv ) / abs( lv_total_c ).
      ELSE.
        lv_es_base = 0.
      ENDIF.

      " apply sign of SKNTO (usually negative)
      IF lv_sknto_inv < 0.
        lv_es_vat = - lv_es_base.
      ELSE.
        lv_es_vat = lv_es_base.
      ENDIF.

      gs_line-total_c = - lv_sknto_inv.          " e.g. -180
      gs_line-vat_b   = - lv_es_vat.             " e.g. -30
      gs_line-net_a   = - lv_sknto_inv + lv_es_vat. " -150

    ENDIF.

    " Flip ES sign for credit notes (Intellipay should reverse)
    IF ls_bkpf-blart = 'KG' OR ls_bkpf-blart = 'RN'.
      gs_line-total_c = abs( gs_line-total_c ). "positive
      gs_line-vat_b   = abs( gs_line-vat_b ).
      gs_line-net_a   = abs( gs_line-net_a ).
    ENDIF.
    APPEND gs_line TO gt_lines.

  ENDLOOP.

  "********************************************
  " SORT BOTH TABLES BY YOUR_REF HERE
  "********************************************
  SORT gt_items BY your_ref ASCENDING.
  SORT gt_lines BY your_ref ASCENDING.
  "********************************************
*---------------------------------------------------------------------*
* 4A — SUBTOTAL ROWS A/B/C BEFORE FINAL TOTAL (D)
*---------------------------------------------------------------------*

  DATA: lv_a_net TYPE wrbtr VALUE 0,
        lv_a_vat TYPE wrbtr VALUE 0,
        lv_a_tot TYPE wrbtr VALUE 0,

        lv_b_net TYPE wrbtr VALUE 0,
        lv_b_vat TYPE wrbtr VALUE 0,
        lv_b_tot TYPE wrbtr VALUE 0,

        lv_c_net TYPE wrbtr VALUE 0,
        lv_c_vat TYPE wrbtr VALUE 0,
        lv_c_tot TYPE wrbtr VALUE 0.

  "--------------- A — Total (Invoices Only)
  LOOP AT gt_items INTO DATA(ls_itm2).
    lv_a_net = lv_a_net + ls_itm2-net_a.
    lv_a_vat = lv_a_vat + ls_itm2-vat_b.
    lv_a_tot = lv_a_tot + ls_itm2-total_c.
  ENDLOOP.

  CLEAR gs_total.
  gs_total-line_type = 'A'.
  gs_total-descr     = 'Total'.
  gs_total-net_a     = lv_a_net.
  gs_total-vat_b     = lv_a_vat.
  gs_total-total_c   = lv_a_tot.
  APPEND gs_total TO gt_total.

  "--------------- B — Total Pay Push (ES)
  LOOP AT gt_lines INTO gs_line WHERE line_type = 'ES'.
    lv_b_net = lv_b_net + gs_line-net_a.
    lv_b_vat = lv_b_vat + gs_line-vat_b.
    lv_b_tot = lv_b_tot + gs_line-total_c.
  ENDLOOP.

  CLEAR gs_total.
  gs_total-line_type = 'B'.
  gs_total-descr     = 'Total Intellipay'.
  gs_total-net_a     = lv_b_net.
  gs_total-vat_b     = lv_b_vat.
  gs_total-total_c   = lv_b_tot.
  APPEND gs_total TO gt_total.

*---------------------------------------------------------------------*
* 4 — CHARITY LINE (ALSO KEEP SIGN)
*---------------------------------------------------------------------*

  DATA lv_charity TYPE wrbtr.

  DATA(lv_hkont) = |{ lc_hkont ALPHA = IN }|.

  IF gs_header IS NOT INITIAL.
    SELECT SINGLE wrbtr
      INTO @lv_charity
      FROM bseg
      WHERE bukrs = @gs_header-bukrs
        AND belnr = @gs_header-belnr_pay
        AND gjahr = @gs_header-gjahr_pay
        AND hkont = @lv_hkont.
  ENDIF
  .
  IF lv_charity IS NOT INITIAL.
    CLEAR gs_total.
    gs_total-line_type = 'CHAR'.
    gs_total-descr     = 'Charity donation'.

    " KEEP SIGN - charity is always negative
    gs_total-total_c = - lv_charity.
    gs_total-net_a   = - lv_charity.
    gs_total-vat_b   = 0.

    APPEND gs_total TO gt_total.
  ENDIF.



*---------------------------------------------------------------------*
* TOTALS A/B/C/D – Correct (NO double counting)
*---------------------------------------------------------------------*

  DATA: lv_final_net TYPE wrbtr VALUE 0,
        lv_final_vat TYPE wrbtr VALUE 0,
        lv_final_tot TYPE wrbtr VALUE 0.

  "---- Add A (Invoices)
  READ TABLE gt_total INTO gs_total WITH KEY line_type = 'A'.
  IF sy-subrc = 0.
    lv_final_net = lv_final_net + gs_total-net_a.
    lv_final_vat = lv_final_vat + gs_total-vat_b.
    lv_final_tot = lv_final_tot + gs_total-total_c.
  ENDIF.

  "---- Add B (Pay Push)
  READ TABLE gt_total INTO gs_total WITH KEY line_type = 'B'.
  IF sy-subrc = 0.
    lv_final_net = lv_final_net + gs_total-net_a.
    lv_final_vat = lv_final_vat + gs_total-vat_b.
    lv_final_tot = lv_final_tot + gs_total-total_c.
  ENDIF.

  "---- Add C (Charity)
  READ TABLE gt_total INTO gs_total WITH KEY line_type = 'CHAR'.
  IF sy-subrc = 0.
    lv_final_net = lv_final_net + gs_total-net_a.
    lv_final_vat = lv_final_vat + gs_total-vat_b.
    lv_final_tot = lv_final_tot + gs_total-total_c.
  ENDIF.

  "---- D: Final Totals (A + B + C)
  CLEAR gs_total.
  gs_total-line_type = 'TOT'.
  gs_total-descr     = 'Totals'.
  gs_total-our_ref   = gs_header-belnr_pay.
  gs_total-net_a     = lv_final_net.
  gs_total-vat_b     = lv_final_vat.
  gs_total-total_c   = lv_final_tot.
  APPEND gs_total TO gt_total.

**---------------------------------------------------------------------*
** 8. CALL ADOBE FORM ZFI_F_UK_REMITTANCE_ADVICE
**---------------------------------------------------------------------*
  DATA: lv_fm_name    TYPE rs38l_fnam,
        ls_docparams  TYPE sfpdocparams,
        ls_output     TYPE sfpoutputparams,
        ls_formoutput TYPE fpformoutput,
        gv_footer     TYPE string,
        gv_title      TYPE string.

  gv_footer = 'Please send all invoices to Invoices@holman.co.uk and statements to PurchaseLedger@holman.co.uk. Always quote our Purchase Order number.'.

  gv_title = 'Remittance Advice'.

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
    MESSAGE 'Error starting Adobe print job' TYPE 'E'.
  ENDIF.
*
*" Get generated FM name for the Adobe form
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZFI_F_UK_REMITTANCE_ADVICE'
    IMPORTING
      e_funcname = lv_fm_name.
*
*" Call the Adobe form FM
  ls_docparams-langu = sy-langu.

  CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000011'
    EXPORTING
      /1bcdwb/docparams  = ls_docparams
      gs_header          = gs_header
      gt_items           = gt_items
      gt_es_lines        = gt_lines
      gt_totals          = gt_total
      gv_title           = gv_title
      gv_footer          = gv_footer
    IMPORTING
      /1bcdwb/formoutput = ls_formoutput.


*  CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000011'
*    EXPORTING
*      /1bcdwb/docparams  = ls_docparams
*      gs_header          = gs_header
*      gt_items           = gt_items
*      gt_es_lines        = gt_lines
*      gv_title           = gv_title
*      gv_footer          = gv_footer
*    IMPORTING
*      /1bcdwb/formoutput = ls_formoutput.


*
*" Close PDF job
  CALL FUNCTION 'FP_JOB_CLOSE'.

  DATA : lv_filename TYPE string,
         lv_xstring  TYPE xstring.

  lv_xstring = ls_formoutput-pdf.
  lv_filename = 'UK_Test'.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = lv_xstring
    IMPORTING
      output_length = gv_length
    TABLES
      binary_tab    = gt_doc_bin.

  IF p_sim IS NOT INITIAL.
    cl_gui_frontend_services=>get_desktop_directory( CHANGING   desktop_directory    = lv_filename
                                                     EXCEPTIONS cntl_error           = 1
                                                                error_no_gui         = 2
                                                                not_supported_by_gui = 3
                                                                OTHERS               = 4 ).
    IF sy-subrc IS INITIAL.
      cl_gui_cfw=>flush( ).
    ENDIF.

    CONCATENATE lv_filename '\test_pdf.pdf' INTO lv_filename.

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
  ENDIF.

  PERFORM email_form.
  PERFORM download_file.


*&---------------------------------------------------------------------*
*& Form email_form
*&---------------------------------------------------------------------*
FORM email_form.

  DATA: lt_rec   TYPE crmtt_email_address,
        lt_files TYPE STANDARD TABLE OF zcl_send_email=>tp_files,
        lt_html  TYPE cl_abap_browser=>html_table,
        lv_file  TYPE string
        .
  gv_subject = |Remittance Advice - { gs_reguh-zaldt DATE = USER }|.
  CHECK p_email IS NOT INITIAL.
* get all the emails to send to
  PERFORM get_file_name CHANGING lv_file.

  APPEND INITIAL LINE TO lt_files ASSIGNING FIELD-SYMBOL(<file>).
  <file>-file_name  = lv_file.
  <file>-file_descr = |Remittance Advice - { sy-datum }|.
  <file>-file_data  = gv_merged_xstring.
  <file>-file_extn  = 'PDF'.

  SELECT FROM but020 AS a JOIN adr6 AS b ON a~addrnumber = b~addrnumber
         FIELDS b~smtp_addr
         WHERE a~partner = @gs_reguh-lifnr
         INTO TABLE @lt_rec.

  IF p_sim IS NOT INITIAL.

    INSERT INITIAL LINE INTO gt_email_text INDEX 1 ASSIGNING FIELD-SYMBOL(<text>).
    <text>-line = |<B>Country:</B> { gs_reguh-land1 }<BR><BR>| &&
                  |<B>Email Subject:</B> { gv_subject }<BR><BR>| &&
                  |<B>File Name:</B> { lv_file }<BR><BR>| &&
                  |<B>Recipients:</B>|
                  .
    LOOP AT lt_rec ASSIGNING FIELD-SYMBOL(<rec>).
      <text>-line = |{ <text>-line } { <rec> }; |.
    ENDLOOP.
    INSERT INITIAL LINE INTO gt_email_text INDEX 2 ASSIGNING <text>.
    <text>-line = |<BR><BR><B>Email Body:</B><BR>|.

    lt_html = gt_email_text.

    CALL METHOD cl_abap_browser=>show_html
      EXPORTING
        html = lt_html
        size = cl_abap_browser=>medium.
  ELSE.
    CALL METHOD zcl_send_email=>send_email
      EXPORTING
        i_subjct       = gv_subject
        it_rec         = lt_rec
        it_prefix_text = gt_email_text
        i_simulation   = p_sim
        it_files       = lt_files.

  ENDIF.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form download_file
*&---------------------------------------------------------------------*
FORM download_file .

  DATA: lv_file      TYPE string,
        lv_bin(1000) TYPE x
        .

*  CHECK p_down IS NOT INITIAL.

*  PERFORM get_file_name CHANGING lv_file.
*
*  OPEN DATASET lv_file FOR OUTPUT IN BINARY MODE.
*  IF sy-subrc IS NOT INITIAL.
*    MESSAGE s117(lx) WITH lv_file.  "Error saving file &1
*    EXIT.
*  ENDIF.
*  LOOP AT gt_doc_bin ASSIGNING FIELD-SYMBOL(<bin>).
*    IF gv_length > 1000.
*      DATA(lv_len) = 1000.
*      gv_length = gv_length - 1000.
*    ELSE.
*      lv_len = gv_length.
*    ENDIF.
*    TRANSFER <bin> TO lv_file  LENGTH lv_len.
*  ENDLOOP.
*  MESSAGE s599(5u) WITH lv_file. "File &1 successfully saved.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form get_file_name
*&---------------------------------------------------------------------*
FORM get_file_name  CHANGING p_filename TYPE string.

  DATA: lv_param1 TYPE string,
        lv_param2 TYPE string,
        lv_string TYPE string
        .
  SELECT SINGLE FROM but000
         FIELDS bpext
         WHERE partner = @gs_reguh-lifnr
         INTO @DATA(lv_bpext).

  lv_string = gs_reguh-lifnr.
  SHIFT lv_string LEFT DELETING LEADING '0'.
  lv_param1 = |Remittance_Advice_{ lv_string }|.
  lv_param2 = |_{ gs_reguh-vblnr }_{ gs_reguh-land1 }|.
  IF lv_bpext IS NOT INITIAL.
    lv_param2 = |{ lv_param2 }_{ lv_bpext }|.
  ENDIF.
  CALL FUNCTION 'FILE_GET_NAME'
    EXPORTING
      logical_filename = p_file
      parameter_1      = lv_param1
      parameter_2      = lv_param2
      parameter_3      = 'PDF'
    IMPORTING
      file_name        = p_filename
    EXCEPTIONS
      file_not_found   = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    MESSAGE e541(gz) WITH p_filename.   "Logical file name & not found
  ENDIF.

ENDFORM.
