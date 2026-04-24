*&---------------------------------------------------------------------*
*& Report ZR_REMITTANCE_ADVICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfirp_purchase_order_process.

DATA: lv_fm_name        TYPE rs38l_fnam,
      ls_docparams      TYPE sfpdocparams,
      ls_output         TYPE sfpoutputparams,
      ls_formoutput     TYPE fpformoutput,
      ls_ekko           TYPE ekko,
      ls_lfa1           TYPE lfa1,
      ls_po             TYPE i_purchasingdocument,
      lt_poitems        TYPE mmpur_ekpo_tt,
      gv_logo           TYPE xstring,
      mv_tdform         TYPE tdobname,
      lv_xstring        TYPE xstring,
      gv_merged_xstring TYPE xstring,
      gv_length         TYPE i,
      gt_doc_bin        TYPE solix_tab.

*CONSTANTS: gc_title TYPE string VALUE 'PURCHASE ORDER'.
DATA: lv_tdobject           TYPE tdobjectgr,
      lv_tdname             TYPE tdobname,
      lv_tdid               TYPE tdidgr,
      lv_tdbtype            TYPE tdbtype,
      lv_po                 TYPE ebeln,
      gv_footer             TYPE string,
      gv_footer_note        TYPE string,
      gv_net_amount_wrbtr   TYPE wrbtr,
      gv_sales_tax_wrbtr    TYPE wrbtr,
      gv_total_amount_wrbtr TYPE wrbtr,
      gv_net_amount_c       TYPE c LENGTH 20,
      gv_sales_tax_c        TYPE c LENGTH 20,
      gv_total_amount_c     TYPE c LENGTH 20,
      gv_net_amount         TYPE string,
      gv_sales_tax          TYPE string,
      gv_total_amount       TYPE string,
      gv_tot_amt_print      TYPE string,
      gv_vendor_addr1       TYPE string,
      gv_vendor_addr2       TYPE string,
      gv_delivery_name      TYPE string,
      gv_delivery_addr1     TYPE string,
      gv_delivery_addr2     TYPE string,
      lv_lang1              TYPE sy-langu,
      lv_lang2              TYPE sy-langu,
      lv_num                TYPE n LENGTH 1,
      gv_title              TYPE string,
      lv_documentdate(10)   TYPE c,
      gv_document_date      TYPE string.
CONSTANTS: lc_usd   TYPE hkont VALUE '$',
           lc_cad   TYPE hkont VALUE 'CA$',
           lc_mex   TYPE hkont VALUE 'MX$',
           lc_pound TYPE hkont VALUE '£'.
*DATA: l_graphic_xstr TYPE xstring.
"* Define variables for graphic details, e.g., in an include or data declaration
"DATA: BEGIN OF g_stxbitmaps.
"        INCLUDE STRUCTURE stxbitmaps.
"DATA: END OF g_stxbitmaps.
** this code is written



*DATA: gs_reguh          TYPE reguh,
*      gt_doc_bin        TYPE solix_tab, "STANDARD TABLE OF x255,
*      gv_merged_xstring TYPE xstring,
*      gt_email_text     TYPE soli_tab,
*      gv_length         TYPE i,
*      gv_subject        TYPE so_obj_des,
*      gv_footer         TYPE string,
*      gv_text           TYPE string,
*      gs_header         TYPE zuk_header,
*      gt_items          TYPE zt_uk_item,
*      gs_item           TYPE zuk_item.
*CONSTANTS: lc_hkont TYPE hkont VALUE '22170070'.
*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_ebeln TYPE ebeln OBLIGATORY.

SELECTION-SCREEN END OF BLOCK blk1.
*
*SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-bl1.
*  PARAMETERS: p_email  AS CHECKBOX USER-COMMAND eml,
*              p_tdform TYPE tdobname MODIF ID eml DEFAULT 'ZF110_EMAIL',
*              p_down   AS CHECKBOX USER-COMMAND fil,
*              p_file   TYPE filename-fileintern MODIF ID fil DEFAULT 'ZDOWNLOAD'
*              .
*SELECTION-SCREEN END OF BLOCK blk2.

INITIALIZATION.

START-OF-SELECTION.
* Assign the technical details of the image stored in SE78
  lv_tdobject = 'GRAPHICS'.
  lv_tdname   = 'ZHOLMAN_LOGO'. " Replace with your image name
  lv_tdid     = 'BMAP'.                    " ID for Bitmap images
  lv_tdbtype  = 'BCOL'.                    " 'BCOL' for color image, 'BMON' for B/W
  mv_tdform = 'ZFI_PO_FOOTER'.
* Call the method to retrieve the graphic data
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lv_tdobject
      p_name         = lv_tdname
      p_id           = lv_tdid
      p_btype        = lv_tdbtype
    RECEIVING
      p_bmp          = gv_logo
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.

  IF sy-subrc <> 0.
    " Handle exceptions (e.g., image not found, error message)
    " MESSAGE ...
  ENDIF.

  DATA: it_tlines TYPE STANDARD TABLE OF tline,
        wa_tline  TYPE tline.

*  " Call the function module to read the text
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
*      id                 = 'ST'
*      language           = 'E' "sy-langu
*      name               = 'ZFI_PO_FOOTER' " Replace with the name of your SO10 text
*      object             = 'TEXT'
*    TABLES
*      lines              = it_tlines
*    EXCEPTIONS
*      id_not_found       = 1
*      language_not_found = 2
*      name_not_found     = 3
*      object_not_found   = 4
*      OTHERS             = 8.
*
*  IF sy-subrc EQ 0.
*    " Loop through the internal table to process or display the text lines
*    LOOP AT it_tlines INTO wa_tline.
**    WRITE: / wa_tline-tdline.
*      CONCATENATE gv_footer wa_tline-tdline INTO gv_footer SEPARATED BY space.
*    ENDLOOP.
*  ELSE.
*    " Handle errors, e.g., display an error message
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

*  gv_footer                = 'This Purchase Order is subject to the Vendor Terms and Conditions at https://www.holman.com/terms-of-service'.
*      gv_net_amount            = gv_net_amount
*      gv_sales_tax             = gv_sales_tax
*      gv_total_amount          = gv_total_amount

*      gv_deliver_addr          = gv_deliver_addr

*  lv_po = '2000000028'.
  lv_po = p_ebeln. "'2000000133'. "118 "124
  SELECT SINGLE * FROM i_purchasingdocument
  INTO @ls_po WHERE purchasingdocument = @lv_po.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM lfa1
    INTO @ls_lfa1 WHERE lifnr = @ls_po-supplier.
    gv_vendor_addr1 = ls_lfa1-stras .
    CONCATENATE ls_lfa1-ort01 ls_lfa1-regio ls_lfa1-pstlz  INTO gv_vendor_addr2 SEPARATED BY space.
    SELECT * FROM ekpo
    INTO TABLE @lt_poitems WHERE ebeln = @lv_po.

*    SELECT SINGLE adrnr FROM t001
*      INTO @DATA(ls_t001_adrnr) WHERE bukrs = @ls_po-companycode.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE name1, city1, post_code1, street, house_num1, region FROM adrc
*        INTO @DATA(ls_t001_adrc) WHERE addrnumber = @ls_t001_adrnr.
*      IF sy-subrc EQ 0.
*        gv_delivery_name = ls_t001_adrc-name1.
*        CONCATENATE ls_t001_adrc-house_num1 ls_t001_adrc-street  INTO gv_delivery_addr1 SEPARATED BY space.
*        CONCATENATE ls_t001_adrc-city1 ls_t001_adrc-region ls_t001_adrc-post_code1  INTO gv_delivery_addr2 SEPARATED BY space.
*      ENDIF.
*    ENDIF.
    SELECT SINGLE eindt FROM eket INTO @DATA(gv_delivery_date) WHERE ebeln = @lv_po.
*    SELECT * FROM i_purchasingdocumentitem
*      INTO TABLE @DATA(lt_poitems) WHERE purchasingdocument = '2000000003'.
  ENDIF.

  LOOP AT lt_poitems INTO DATA(ls_poitems).
    gv_net_amount_wrbtr = gv_net_amount_wrbtr + ls_poitems-netwr.
    gv_total_amount_wrbtr = gv_total_amount_wrbtr + ls_poitems-netwr.
  ENDLOOP.
** Plant address in the delivery address
  SELECT SINGLE adrnr FROM t001w
  INTO @DATA(ls_t001w_adrnr) WHERE werks = @ls_poitems-werks.
  IF sy-subrc EQ 0.
    SELECT SINGLE name1, city1, post_code1, street, house_num1, region FROM adrc
    INTO @DATA(ls_t001w_adrc) WHERE addrnumber = @ls_t001w_adrnr.
    IF sy-subrc EQ 0.
      gv_delivery_name = 'Holman'. "ls_t001w_adrc-name1.
      CONCATENATE ls_t001w_adrc-house_num1 ls_t001w_adrc-street  INTO gv_delivery_addr1 SEPARATED BY space.
      CONCATENATE ls_t001w_adrc-city1 ls_t001w_adrc-region ls_t001w_adrc-post_code1  INTO gv_delivery_addr2 SEPARATED BY space.
    ENDIF.
  ENDIF.

  DATA(lv_pr) = ls_poitems-banfn.

  SET COUNTRY 'US'.
*  gv_tot_amt_print = gv_total_amount_wrbtr.
  WRITE gv_net_amount_wrbtr TO gv_net_amount_c.
  WRITE gv_total_amount_wrbtr TO gv_total_amount_c.
  CONCATENATE gv_tot_amt_print ls_po-documentcurrency INTO gv_tot_amt_print SEPARATED BY space.
  FREE MEMORY ID 'SET COUNTRY'.
*    READ TABLE lt_po INTO ls_po INDEX 1.
*    ls_po = lt_po[ 1 ].


  lv_lang1 = 'E'.

  CASE ls_lfa1-land1.
    WHEN 'MX'.
      lv_lang2 = 'S'.
      gv_net_amount = |{ lc_mex } { gv_net_amount_c } |.
      gv_tot_amt_print = |{ lc_mex } { gv_total_amount_c } |.
*      lv_documentdate = ls_po-PurchasingDocumentOrderDate.
      WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
    WHEN 'GB'.
      gv_net_amount = |{ lc_pound } { gv_net_amount_c } |.
      gv_tot_amt_print = |{ lc_pound } { gv_total_amount_c } |.
      WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate DD/MM/YYYY.

    WHEN 'US'.
      gv_net_amount = |{ lc_usd } { gv_net_amount_c } |.
      gv_tot_amt_print = |{ lc_usd } { gv_total_amount_c } |.
      WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
    WHEN 'CA'.
      lv_lang2 = 'F'.
      gv_net_amount = |{ lc_cad } { gv_net_amount_c } |.
*      CONCATENATE lc_cad gv_net_amount_c INTO gv_net_amount SEPARATED BY space.
      gv_tot_amt_print = |{ lc_cad } { gv_total_amount_c } |.
      WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
*      CONCATENATE lc_cad gv_total_amount_c INTO gv_tot_amt_print SEPARATED BY space.
*        lv_subject_text = TEXT-011.
*        REPLACE '&1' IN lv_subject_text WITH |{ gs_reguh-zaldt DATE = USER }|.
*        gv_subject = lv_subject_text.
  ENDCASE.
  CONDENSE: gv_net_amount, gv_tot_amt_print.
  " PDF Merger Init
  TRY.
      DATA(lo_merger) = NEW cl_rspo_pdf_merge( ).
    CATCH cx_rspo_pdf_merge INTO DATA(lo_error).
      MESSAGE e001(zremit_msg).
      RETURN.
  ENDTRY.

*  ls_output-nopreview = 'X'.
*  ls_output-getpdf    = ls_output-nopreview.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = ls_output.

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

*    CONCATENATE mv_tdform '_' <lang> INTO lv_tdname.
*    get_text( EXPORTING i_lang    = <lang>
*              CHANGING  cv_tdname = lv_tdname ).
*    IF ls_lfa1-land1 = 'CA' OR ls_lfa1-land1 = 'GB'.
    CLEAR it_tlines.
    IF <lang> IS INITIAL.
      <lang> = 'E'.
    ENDIF.
    " Call the function module to read the text
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                 = 'ST'
        language           = <lang>
        name               = 'ZFI_PO_FOOTER_NOTE' " Replace with the name of your SO10 text
        object             = 'TEXT'
      TABLES
        lines              = it_tlines
      EXCEPTIONS
        id_not_found       = 1
        language_not_found = 2
        name_not_found     = 3
        object_not_found   = 4
        OTHERS             = 8.

    IF sy-subrc EQ 0.
      CLEAR gv_footer_note.
      LOOP AT it_tlines INTO wa_tline.
        IF sy-tabix = 1.
          gv_footer_note = wa_tline-tdline.
        ELSE.
          CONCATENATE gv_footer_note wa_tline-tdline INTO gv_footer_note SEPARATED BY space.
        ENDIF.
      ENDLOOP.
*      ELSE.
*        " Handle errors, e.g., display an error message
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
*    ENDIF.

*    " Call the function module to read the text
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        id                 = 'ST'
*        language           = <lang> "sy-langu
*        name               = mv_tdform " Replace with the name of your SO10 text
*        object             = 'TEXT'
*      TABLES
*        lines              = it_tlines
*      EXCEPTIONS
*        id_not_found       = 1
*        language_not_found = 2
*        name_not_found     = 3
*        object_not_found   = 4
*        OTHERS             = 8.
*
*    IF sy-subrc EQ 0.
*      CLEAR gv_footer.
*      CONCATENATE ls_lfa1-land1 '-' INTO gv_footer SEPARATED BY space.
*      " Loop through the internal table to process or display the text lines
*      LOOP AT it_tlines INTO wa_tline.
**    WRITE: / wa_tline-tdline.
**        IF gv_footer IS INITIAL.
***          gv_footer = wa_tline-tdline.
**
**        ELSE.
*        CONCATENATE gv_footer wa_tline-tdline INTO gv_footer SEPARATED BY space.
**        ENDIF.
*      ENDLOOP.
*    ELSE.
*      " Handle errors, e.g., display an error message
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.

    IF ls_lfa1-land1 = 'GB'.
      " Call the function module to read the text
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                 = 'ST'
          language           = <lang> "sy-langu
          name               = 'ZFI_PO_FOOTER_GB' " Replace with the name of your SO10 text
          object             = 'TEXT'
        TABLES
          lines              = it_tlines
        EXCEPTIONS
          id_not_found       = 1
          language_not_found = 2
          name_not_found     = 3
          object_not_found   = 4
          OTHERS             = 8.

      IF sy-subrc EQ 0.
        CLEAR gv_footer.
*        CONCATENATE ls_lfa1-land1 '-' INTO gv_footer SEPARATED BY space.
        " Loop through the internal table to process or display the text lines
        LOOP AT it_tlines INTO wa_tline.
          IF sy-tabix = 1.
            gv_footer = wa_tline-tdline.
          ELSE.
            CONCATENATE gv_footer wa_tline-tdline INTO gv_footer SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ELSE.
        " Handle errors, e.g., display an error message
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      " Call the function module to read the text
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                 = 'ST'
          language           = <lang> "sy-langu
          name               = 'ZFI_PO_FOOTER' " Replace with the name of your SO10 text
          object             = 'TEXT'
        TABLES
          lines              = it_tlines
        EXCEPTIONS
          id_not_found       = 1
          language_not_found = 2
          name_not_found     = 3
          object_not_found   = 4
          OTHERS             = 8.

      IF sy-subrc EQ 0.
        CLEAR gv_footer.
*        CONCATENATE ls_lfa1-land1 '-' INTO gv_footer SEPARATED BY space.
        " Loop through the internal table to process or display the text lines
        LOOP AT it_tlines INTO wa_tline.
          IF sy-tabix = 1.
            gv_footer = wa_tline-tdline.
          ELSE.
            CONCATENATE gv_footer wa_tline-tdline INTO gv_footer SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ELSE.
        " Handle errors, e.g., display an error message
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

    IF <lang> = 'E'.
      gv_title = 'PURCHASE ORDER'.
    ELSEIF <lang> = 'F'.
      gv_title = 'BON DE COMMANDE'.
    ELSEIF <lang> = 'S'.
      gv_title = 'ORDEN DE COMPRA'.
    ENDIF.

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = 'ZFI_F_PURCHASE_ORDER'
          IMPORTING
            e_funcname = lv_fm_name.

      CATCH cx_fp_api_usage INTO DATA(lx_api_usage).
        MESSAGE lx_api_usage TYPE 'E'.

      CATCH cx_fp_api_repository INTO DATA(lx_repo).
        MESSAGE lx_repo TYPE 'E'.

      CATCH cx_fp_api_internal INTO DATA(lx_internal).
        MESSAGE lx_internal TYPE 'E'.
    ENDTRY.
    gv_document_date = lv_documentdate.
    CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000013'
      EXPORTING
        /1bcdwb/docparams        = ls_docparams
        is_lfa1                  = ls_lfa1
        it_purchasingdocument    = ls_po
        it_purchasingdocumetitem = lt_poitems
        gv_logo                  = gv_logo
        gv_title                 = gv_title
        is_ekko                  = ls_ekko
        gv_footer                = gv_footer
        gv_footer_note           = gv_footer_note
        gv_net_amount            = gv_net_amount
        gv_sales_tax             = gv_sales_tax
        gv_tot_amt_print         = gv_tot_amt_print
        gv_vendor_addr1          = gv_vendor_addr1
        gv_vendor_addr2          = gv_vendor_addr2
        gv_delivery_addr1        = gv_delivery_addr1
        gv_delivery_addr2        = gv_delivery_addr2
        gv_delivery_name         = gv_delivery_name
        gv_document_date         = gv_document_date
      IMPORTING
        /1bcdwb/formoutput       = ls_formoutput
      EXCEPTIONS
        usage_error              = 1
        system_error             = 2
        internal_error           = 3
        OTHERS                   = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    lv_xstring = ls_formoutput-pdf.
    lo_merger->add_document( lv_xstring ).

    IF ls_lfa1-land1 = 'GB'.
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = 'ZFI_F_PURCHASE_ORDER_UK_TC'
            IMPORTING
              e_funcname = lv_fm_name.

        CATCH cx_fp_api_usage INTO lx_api_usage.
          MESSAGE lx_api_usage TYPE 'E'.

        CATCH cx_fp_api_repository INTO lx_repo.
          MESSAGE lx_repo TYPE 'E'.

        CATCH cx_fp_api_internal INTO lx_internal.
          MESSAGE lx_internal TYPE 'E'.
      ENDTRY.
      CLEAR ls_formoutput.
      CALL FUNCTION '/1BCDWB/SM00000016'
        EXPORTING
          /1bcdwb/docparams  = ls_docparams
        IMPORTING
          /1bcdwb/formoutput = ls_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      lv_xstring = ls_formoutput-pdf.
      lo_merger->add_document( lv_xstring ).
    ENDIF.

  ENDDO.

*  CALL FUNCTION lv_fm_name "'/1BCDWB/SM00000013'
*    EXPORTING
*      /1bcdwb/docparams        = ls_docparams
*      is_lfa1                  = ls_lfa1
*      it_purchasingdocument    = ls_po
*      it_purchasingdocumetitem = lt_poitems
*      gv_logo                  = gv_logo
*      gv_title                 = gc_title
*      is_ekko                  = ls_ekko
*      gv_footer                = gv_footer
*      gv_net_amount            = gv_net_amount
*      gv_sales_tax             = gv_sales_tax
*      gv_total_amount          = gv_total_amount
*      gv_vendor_addr1          = gv_vendor_addr1
*      gv_vendor_addr2          = gv_vendor_addr2
*      gv_delivery_addr1        = gv_delivery_addr1
*      gv_delivery_addr2        = gv_delivery_addr2
*      gv_delivery_name         = gv_delivery_name
*      gv_delivery_date         = gv_delivery_date
*    IMPORTING
*      /1bcdwb/formoutput       = ls_formoutput
*    EXCEPTIONS
*      usage_error              = 1
*      system_error             = 2
*      internal_error           = 3
*      OTHERS                   = 4.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

  CALL FUNCTION 'FP_JOB_CLOSE'.

  lo_merger->merge_documents( IMPORTING merged_document = gv_merged_xstring ).

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = gv_merged_xstring
    IMPORTING
      output_length = gv_length
    TABLES
      binary_tab    = gt_doc_bin.


*** Email form

  DATA: lt_rec          TYPE crmtt_email_address,
        lt_files        TYPE STANDARD TABLE OF zcl_send_email=>tp_files,
        lt_html         TYPE cl_abap_browser=>html_table,
        lv_file         TYPE string,
        lv_descr        TYPE string,
        lv_header_line  TYPE string,
        lv_subject_text TYPE so_obj_des,
        gt_email_text   TYPE soli_tab.

*    CHECK mv_email IS NOT INITIAL.
* get all the emails to send to
*  PERFORM get_file_name CHANGING lv_file.
*    get_file_name( CHANGING p_filename = lv_file ).
  SELECT SINGLE bpext FROM but000 INTO @DATA(lv_bpext) WHERE partner = @ls_lfa1-lifnr.
  lv_subject_text = 'Approved SAP Purchase Order'.
  IF lv_bpext IS INITIAL.
    CONCATENATE 'PO' '_' ls_lfa1-lifnr '_' ls_po-creationdate '_' ls_po-purchasingdocument '_' ls_lfa1-land1 '_' ls_lfa1-lifnr INTO lv_file." SEPARATED BY space.
  ELSE.
    CONCATENATE 'PO' '_' ls_lfa1-lifnr '_' ls_po-creationdate '_' ls_po-purchasingdocument '_' ls_lfa1-land1 '_' lv_bpext INTO lv_file." SEPARATED BY space.
  ENDIF.

  APPEND INITIAL LINE TO lt_files ASSIGNING FIELD-SYMBOL(<file>).
  <file>-file_name  = lv_file.
  lv_descr = TEXT-030.
  REPLACE '&1' IN lv_descr WITH |{ lv_po }|.
  <file>-file_descr = lv_file. "lv_descr.
  <file>-file_data  = gv_merged_xstring.
  <file>-file_extn  = 'PDF'.

  SELECT c~smtp_addr
    FROM eban AS a
    LEFT OUTER JOIN usr21 AS b
    ON a~ernam = b~bname
    LEFT OUTER JOIN adr6 AS c
    ON b~addrnumber = c~addrnumber
    INTO TABLE @lt_rec
  WHERE a~banfn = @lv_pr.
  IF sy-subrc NE 0.
    MESSAGE e000(zremit_msg) WITH 'Email Id Not found for Purchase Requisitioner'.
  ENDIF.
*  SELECT
*    FROM but020 AS a
*           JOIN
*             adr6 AS b ON a~addrnumber = b~addrnumber
*    FIELDS b~smtp_addr
*    WHERE a~partner = @ls_lfa1-lifnr
*    INTO TABLE @lt_rec.
*  IF lt_rec IS INITIAL.
*    MESSAGE e000(zremit_msg) WITH 'Email Id Not found for vendor' ls_lfa1-lifnr.
*  ENDIF.
*
*  IF mv_sim IS NOT INITIAL.
*    lv_header_line = TEXT-031.
*
*    REPLACE '&1' IN lv_header_line WITH gs_reguh-land1.
*    REPLACE '&2' IN lv_header_line WITH gv_subject.
*    REPLACE '&3' IN lv_header_line WITH lv_file.
*    INSERT INITIAL LINE INTO gt_email_text INDEX 1 ASSIGNING FIELD-SYMBOL(<text>).
*    <text>-line =  lv_header_line.
*    LOOP AT lt_rec ASSIGNING FIELD-SYMBOL(<rec>).
*      <text>-line = |{ <text>-line } { <rec> }; |.
*    ENDLOOP.
*    INSERT INITIAL LINE INTO gt_email_text INDEX 2 ASSIGNING <text>.
*    <text>-line = TEXT-032.
*
*    lt_html = gt_email_text.
*
*    cl_abap_browser=>show_html( html = lt_html
*                                size = cl_abap_browser=>medium ).
*  ELSE.

  " Call the function module to read the text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                 = 'ST'
      language           = sy-langu
      name               = 'ZFI_PO_EMAIL_BODY' " Replace with the name of your SO10 text
      object             = 'TEXT'
    TABLES
      lines              = it_tlines
    EXCEPTIONS
      id_not_found       = 1
      language_not_found = 2
      name_not_found     = 3
      object_not_found   = 4
      OTHERS             = 8.

  IF sy-subrc EQ 0.
    CLEAR gt_email_text.
    " Loop through the internal table to process or display the text lines
    LOOP AT it_tlines INTO wa_tline.
      REPLACE '&1' IN wa_tline WITH lv_po.
      APPEND wa_tline TO gt_email_text.
    ENDLOOP.
  ELSE.
    " Handle errors, e.g., display an error message
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  zcl_send_email=>send_email( i_subjct       = lv_subject_text
                              it_rec         = lt_rec
                              it_prefix_text = gt_email_text
                              i_simulation   = ''
                              it_files       = lt_files ).

*  ENDIF.


*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_laufi.
*  PERFORM get_laufi CHANGING p_laufi.
*
*AT SELECTION-SCREEN OUTPUT.
*  PERFORM change_screen.
*
*START-OF-SELECTION.
*
*  DATA(lo_app) = NEW zcl_remittance_advice(
*                    p_laufd = p_laufd
*                    p_laufi = p_laufi
*                    p_email = p_email
*                    p_down  = p_down
*                    p_tdform = p_tdform
*                    p_sim   =  p_sim
*                    p_file = p_file ).
*
*  lo_app->process( ).
*
**&---------------------------------------------------------------------*
**& Form change_screen
**&---------------------------------------------------------------------*
*FORM change_screen .
*
*  LOOP AT SCREEN.
*    CASE screen-group1.
*      WHEN 'EML'.
*        IF p_email IS INITIAL.
*          screen-output = screen-active = 0.
*        ELSE.
*          IF screen-name = 'P_TDFORM'.
*            screen-input = 0.
*          ENDIF.
*          screen-output = screen-active = 1.
*        ENDIF.
*        MODIFY SCREEN.
*      WHEN 'FIL'.
*        IF p_down IS INITIAL.
*          screen-output = screen-active = 0.
*        ELSE.
*          screen-output = screen-active = 1.
*        ENDIF.
*        MODIFY SCREEN.
*    ENDCASE.
*  ENDLOOP.
*ENDFORM.
*
**&---------------------------------------------------------------------*
**& Form get_laufi
**&---------------------------------------------------------------------*
*FORM get_laufi  CHANGING p_laufi TYPE laufi.
*
*  DATA: lt_LAUFK TYPE STANDARD TABLE OF ilaufk.
*
*  APPEND INITIAL LINE TO lt_laufk ASSIGNING FIELD-SYMBOL(<laufk>).
*  <laufk>-sign  = 'I'.
*
*  CALL FUNCTION 'F4_ZAHLLAUF'
*    EXPORTING
*      f1typ = 'I'
*      f2nme = 'F110V-LAUFD'
*    IMPORTING
*      laufd = p_LAUFD
*      laufi = p_LAUFI
*    TABLES
*      laufk = lt_laufk.
*  CHECK p_laufi IS NOT INITIAL.
*
*  DATA: lt_dynpfields TYPE STANDARD TABLE OF dynpread.
*  APPEND INITIAL LINE TO lt_dynpfields ASSIGNING FIELD-SYMBOL(<dynp>).
*  <dynp>-fieldname = 'P_LAUFD'.
*  <dynp>-fieldvalue = | { p_laufd DATE = USER }|.
*  SHIFT <dynp>-fieldvalue LEFT DELETING LEADING space.
*
*  CALL FUNCTION 'DYNP_VALUES_UPDATE'
*    EXPORTING
*      dyname     = sy-repid
*      dynumb     = sy-dynnr
*    TABLES
*      dynpfields = lt_dynpfields
*    EXCEPTIONS
*      OTHERS     = 0.
*ENDFORM.
