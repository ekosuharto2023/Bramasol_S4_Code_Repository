class ZCL_PURCHASE_ORDER definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !P_EBELN type EBELN .
  methods PROCESS .
  methods GET_DATA .
  methods EMAIL_FORM .
  methods GET_LOGO .
  methods GET_TAX_ID .
private section.

  types:
    ty_lt_reguh TYPE STANDARD TABLE OF reguh WITH DEFAULT KEY .
  types:
    ty_lt_regup TYPE STANDARD TABLE OF regup WITH DEFAULT KEY .

  data MV_EBELN type EBELN .
  data MV_LOGO type XSTRING .
  data MV_MERGED_XSTRING type XSTRING .
  data MV_LFA1 type LFA1 .
  data MV_PO type I_PURCHASINGDOCUMENT .
  data MV_PR type BANFN .
  data MT_PR type WTYSC_WWB_BANFN_TAB .
  data MV_REGIO type LAND1_GP .
  data MV_LIFNR type LIFNR .
  data MV_TAXNUM type BPTAXNUM .
ENDCLASS.



CLASS ZCL_PURCHASE_ORDER IMPLEMENTATION.


  METHOD CONSTRUCTOR.
    mv_ebeln = p_ebeln.
  ENDMETHOD.


  METHOD email_form.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZCL_PURCHASE_ORDER=>EMAIL_FORM()                      *
*& TITLE       : Purchase Order Form                                   *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This method will Email PO Form as attachment          *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*
*** Email form
    DATA: lt_rec          TYPE crmtt_email_address,
          lt_rec_temp     TYPE crmtt_email_address,
          lt_files        TYPE STANDARD TABLE OF zcl_send_email=>tp_files,
          lt_html         TYPE cl_abap_browser=>html_table,
          lv_file         TYPE string,
          lv_descr        TYPE string,
          lv_header_line  TYPE string,
          lv_subject_text TYPE so_obj_des,
          gt_email_text   TYPE soli_tab.
    DATA: it_tlines TYPE STANDARD TABLE OF tline,
          wa_tline  TYPE tline.
    CONSTANTS: lc_subject       TYPE string VALUE 'Approved SAP Purchase Order',
               lc_pdf_extn      TYPE string VALUE 'PDF',
               lc_po_email_body TYPE tdobname VALUE 'ZFI_PO_EMAIL_BODY',
               lc_underscore    TYPE char1 VALUE '_',
               lc_po            TYPE string VALUE 'PO'.

    SELECT SINGLE bpext FROM but000 INTO @DATA(lv_bpext) WHERE partner = @mv_lfa1-lifnr.
    lv_subject_text = lc_subject.

    IF lv_bpext IS INITIAL.
      CONCATENATE lc_po  mv_lfa1-lifnr  mv_po-creationdate  mv_po-purchasingdocument  mv_lfa1-land1  mv_lfa1-lifnr INTO lv_file SEPARATED BY lc_underscore.
    ELSE.
      CONCATENATE lc_po  mv_lfa1-lifnr  mv_po-creationdate  mv_po-purchasingdocument  mv_lfa1-land1  lv_bpext INTO lv_file SEPARATED BY lc_underscore.
    ENDIF.

    APPEND INITIAL LINE TO lt_files ASSIGNING FIELD-SYMBOL(<file>).
    <file>-file_name  = lv_file.
    <file>-file_descr = lv_file. "lv_descr.
    <file>-file_data  = mv_merged_xstring.
    <file>-file_extn  = lc_pdf_extn.

** Get email address of all Purchase Requestor
    IF mt_pr IS NOT INITIAL.
      LOOP AT mt_pr INTO mv_pr.
        SELECT DISTINCT c~smtp_addr
          FROM eban AS a
          LEFT OUTER JOIN usr21 AS b
          ON a~ernam = b~bname
          LEFT OUTER JOIN adr6 AS c
          ON b~addrnumber = c~addrnumber
         AND b~persnumber = c~persnumber
        INTO TABLE @lt_rec_temp
        WHERE a~banfn = @mv_pr.
        IF sy-subrc EQ 0.
          APPEND LINES OF lt_rec_temp TO lt_rec.
        ELSE.
          MESSAGE e000(zremit_msg) WITH 'Email Id Not found for Purchase Requisitioner'.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Call the function module to read the text
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                 = 'ST'
        language           = sy-langu
        name               = lc_po_email_body "'ZFI_PO_EMAIL_BODY'
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
        REPLACE '&1' IN wa_tline WITH mv_po-purchasingdocument.
        APPEND wa_tline TO gt_email_text.
      ENDLOOP.
    ELSE.
      " Handle errors, e.g., display an error message
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

** Send Email
    zcl_send_email=>send_email( i_subjct       = lv_subject_text
                                it_rec         = lt_rec
                                it_prefix_text = gt_email_text
                                i_simulation   = ''
                                it_files       = lt_files ).

  ENDMETHOD.


  METHOD get_data.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZCL_PURCHASE_ORDER=>GET_DATA()                         *
*& TITLE       : Purchase Order Form                                   *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This method will retreive PO Data                     *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*
    DATA: lv_fm_name    TYPE rs38l_fnam,
          ls_docparams  TYPE sfpdocparams,
          ls_output     TYPE sfpoutputparams,
          ls_formoutput TYPE fpformoutput,
          ls_ekko       TYPE ekko,
          ls_lfa1       TYPE lfa1,
          ls_po         TYPE i_purchasingdocument,
          lt_poitems    TYPE mmpur_ekpo_tt,
          ls_pr         TYPE banfn,
          lt_pr         TYPE wtysc_wwb_banfn_tab,
          lv_xstring    TYPE xstring.

    DATA: lv_po                 TYPE ebeln,
          gv_footer             TYPE string,
          gv_footer_note        TYPE string,
          gv_net_amount_wrbtr   TYPE wrbtr,
          gv_total_amount_wrbtr TYPE wrbtr,
          gv_total_unit         TYPE bstmg,
          gv_total_unit_i       TYPE i,
          gv_net_amount_c       TYPE c LENGTH 20,
          gv_total_amount_c     TYPE c LENGTH 20,
          gv_total_unit_c       TYPE c LENGTH 20,
          gv_net_amount         TYPE string,
          gv_sales_tax          TYPE string,
          gv_tot_amt_print      TYPE string,
          gv_tot_unit_print     TYPE string,
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
          gv_document_date      TYPE string,
          gv_payment_term       TYPE string,
          ls_result             TYPE sfpjoboutput.
    DATA: it_tlines TYPE STANDARD TABLE OF tline,
          wa_tline  TYPE tline.
    CONSTANTS: lc_usd               TYPE hkont VALUE '$',
               lc_cad               TYPE hkont VALUE '$',
               lc_mex               TYPE hkont VALUE 'MX$',
               lc_pound             TYPE hkont VALUE '£',
               lc_po_fpname         TYPE fpname VALUE 'ZFI_F_PURCHASE_ORDER',
               lc_po_uk_tc_fpname   TYPE fpname VALUE 'ZFI_F_PURCHASE_ORDER_UK_TC',
               lc_po_footer         TYPE tdobname VALUE 'ZFI_PO_FOOTER',
               lc_po_footer_gb      TYPE tdobname VALUE 'ZFI_PO_FOOTER_GB',
               lc_po_footer_note    TYPE tdobname VALUE 'ZFI_PO_FOOTER_NOTE',
               lc_land1_us          TYPE land1_gp VALUE 'US',
               lc_land1_gb          TYPE land1_gp VALUE 'GB',
               lc_land1_ca          TYPE land1_gp VALUE 'CA',
               lc_land1_mx          TYPE land1_gp VALUE 'MX',
               lc_english           TYPE char1 VALUE 'E',
               lc_french            TYPE char1 VALUE 'F',
               lc_spanish           TYPE char1 VALUE 'S',
               lc_gb                TYPE land1_gp VALUE 'GB',
               lc_print_program     TYPE string VALUE 'ZFIRP_SAPFM06P',
               lc_device            TYPE string VALUE 'PRINTER',
               lc_ads               TYPE string VALUE 'ADS',
               lc_lp01              TYPE string VALUE 'LP01',
               lc_purchase_order_en TYPE string VALUE 'PURCHASE ORDER',
               lc_purchase_order_fr TYPE string VALUE 'BON DE COMMANDE',
               lc_purchase_order_es TYPE string VALUE 'ORDEN DE COMPRA'.

    IF sy-msgv1 = lc_print_program.
      ls_output-nodialog = abap_true.
      ls_output-preview = abap_true.
      ls_output-dest    = lc_lp01.
    ELSE.
      ls_output-device      = lc_device.
      ls_output-connection  = lc_ads.
      ls_output-nodialog    = abap_true.
      ls_output-preview = abap_true.
      ls_output-dest        = lc_lp01.
      ls_output-getpdf = abap_true.
    ENDIF.

    get_logo( ). "Get holman logo

    lv_po = mv_ebeln.

    SELECT SINGLE * FROM i_purchasingdocument       " Get PO header
    INTO @ls_po WHERE purchasingdocument = @lv_po.

    IF sy-subrc EQ 0.

      SELECT SINGLE * FROM lfa1                     " get vendor details
      INTO @ls_lfa1 WHERE lifnr = @ls_po-supplier.

      IF sy-subrc EQ 0.
        gv_vendor_addr1 = ls_lfa1-stras.            "get vendor Addr1
        CONCATENATE ls_lfa1-ort01 ls_lfa1-regio ls_lfa1-pstlz  INTO gv_vendor_addr2 SEPARATED BY space. " Address 2
      ENDIF.

      SELECT SINGLE vtext FROM tvzbt
        INTO @DATA(lv_vtext) WHERE zterm = @ls_po-paymentterms AND spras = @lc_english.
      IF sy-subrc EQ 0.
        gv_payment_term = |{ ls_po-paymentterms } { '-' } { lv_vtext }|.
      ENDIF.

      SELECT * FROM ekpo                        " get PO line items
      INTO TABLE @lt_poitems WHERE ebeln = @lv_po.
      IF sy-subrc EQ 0.
        SET COUNTRY 'US'. "Amount format
        LOOP AT lt_poitems INTO DATA(ls_poitems).
          WRITE ls_poitems-netwr TO ls_poitems-ematn.
          CONDENSE ls_poitems-ematn.
          CASE ls_lfa1-land1.
            WHEN lc_land1_mx.
              ls_poitems-ematn = |{ lc_mex } { ls_poitems-ematn } |.
            WHEN lc_land1_gb.
              ls_poitems-ematn = |{ lc_pound } { ls_poitems-ematn } |.
            WHEN lc_land1_us.
              ls_poitems-ematn = |{ lc_usd } { ls_poitems-ematn } |.
            WHEN lc_land1_ca.
              ls_poitems-ematn = |{ lc_cad } { ls_poitems-ematn } |.
          ENDCASE.
          CONDENSE ls_poitems-ematn.
          gv_net_amount_wrbtr = gv_net_amount_wrbtr + ls_poitems-netwr.
          gv_total_amount_wrbtr = gv_total_amount_wrbtr + ls_poitems-netwr.
          gv_total_unit = gv_total_unit + ls_poitems-menge.
          MODIFY lt_poitems FROM ls_poitems TRANSPORTING ematn.
          ls_pr = ls_poitems-banfn.
          APPEND ls_pr TO lt_pr.
        ENDLOOP.

** Company code address in the delivery address
        SELECT SINGLE adrnr FROM t001
        INTO @DATA(ls_t001_adrnr) WHERE bukrs = @ls_po-companycode.
        IF sy-subrc EQ 0.
          SELECT SINGLE name1, city1, post_code1, street, house_num1, region FROM adrc
          INTO @DATA(ls_t001_adrc) WHERE addrnumber = @ls_t001_adrnr.
          IF sy-subrc EQ 0.
            gv_delivery_name = ls_t001_adrc-name1.
            CONCATENATE ls_t001_adrc-house_num1 ls_t001_adrc-street INTO gv_delivery_addr1 SEPARATED BY space.
            CONCATENATE ls_t001_adrc-city1 ls_t001_adrc-region ls_t001_adrc-post_code1 INTO gv_delivery_addr2 SEPARATED BY space.
            CONDENSE: gv_delivery_addr1, gv_delivery_addr2.
          ENDIF.
        ENDIF.

        DELETE ADJACENT DUPLICATES FROM lt_pr. "Purchase Req
        mt_pr = lt_pr.

        WRITE gv_net_amount_wrbtr TO gv_net_amount_c.
        WRITE gv_total_amount_wrbtr TO gv_total_amount_c.
        gv_total_unit_i = gv_total_unit.
        WRITE gv_total_unit_i TO gv_total_unit_c.
        gv_tot_unit_print = gv_total_unit_c.

        CONCATENATE gv_tot_amt_print ls_po-documentcurrency INTO gv_tot_amt_print SEPARATED BY space.
        FREE MEMORY ID 'SET COUNTRY'.

        lv_lang1 = lc_english.
        CASE ls_lfa1-land1.
          WHEN lc_land1_mx.
            lv_lang2 = lc_spanish.
            gv_net_amount = |{ lc_mex } { gv_net_amount_c } |.
            gv_tot_amt_print = |{ lc_mex } { gv_total_amount_c } |.
            WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
          WHEN lc_land1_gb.
            gv_net_amount = |{ lc_pound } { gv_net_amount_c } |.
            gv_tot_amt_print = |{ lc_pound } { gv_total_amount_c } |.
            CONCATENATE ls_po-purchasingdocumentorderdate+6(2) ls_po-purchasingdocumentorderdate+4(2) ls_po-purchasingdocumentorderdate+0(4) INTO lv_documentdate SEPARATED BY '/'.
          WHEN lc_land1_us.
            gv_net_amount = |{ lc_usd } { gv_net_amount_c } |.
            gv_tot_amt_print = |{ lc_usd } { gv_total_amount_c } |.
            WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
          WHEN lc_land1_ca.
            lv_lang2 = lc_french.
            gv_net_amount = |{ lc_cad } { gv_net_amount_c } |.
            gv_tot_amt_print = |{ lc_cad } { gv_total_amount_c } |.
            WRITE ls_po-purchasingdocumentorderdate TO lv_documentdate MM/DD/YYYY.
        ENDCASE.
        CONDENSE: gv_net_amount, gv_tot_amt_print.
***   get tax details
        mv_po = lv_po.
        mv_lfa1 = ls_lfa1.
        get_tax_id( ). "Get Tax ID
        ls_lfa1-stcd1 = mv_taxnum.

        " PDF Merger Init
        TRY.
            DATA(lo_merger) = NEW cl_rspo_pdf_merge( ).
          CATCH cx_rspo_pdf_merge INTO DATA(lo_error).
            MESSAGE e001(zremit_msg).
            RETURN.
        ENDTRY.

        "Job open
        CALL FUNCTION 'FP_JOB_OPEN'
          CHANGING
            ie_outputparams = ls_output
          EXCEPTIONS
            cancel          = 1
            usage_error     = 2
            system_error    = 3
            internal_error  = 4
            OTHERS          = 5.
        IF sy-subrc <> 0.
*            <error handling>
        ENDIF.

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

          CLEAR it_tlines.
          IF <lang> IS INITIAL.
            <lang> = lc_english.
          ENDIF.
          " Call the function module to read the text
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                 = 'ST'
              language           = <lang>
              name               = lc_po_footer_note "'ZFI_PO_FOOTER_NOTE'
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
          ENDIF.

          IF ls_lfa1-land1 = lc_gb. "Add T&C footer only for UK
            " Call the function module to read the text
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                 = 'ST'
                language           = <lang>
                name               = lc_po_footer_gb "'ZFI_PO_FOOTER_GB'
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
                language           = <lang>
                name               = lc_po_footer "'ZFI_PO_FOOTER'
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

          IF <lang> = lc_english.
            gv_title = lc_purchase_order_en.
          ELSEIF <lang> = lc_french.
            gv_title = lc_purchase_order_fr.
          ELSEIF <lang> = lc_spanish.
            gv_title = lc_purchase_order_es.
          ENDIF.

          TRY.
              CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
                EXPORTING
                  i_name     = lc_po_fpname "'ZFI_F_PURCHASE_ORDER'
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
          CALL FUNCTION lv_fm_name
            EXPORTING
              /1bcdwb/docparams        = ls_docparams
              is_lfa1                  = ls_lfa1
              it_purchasingdocument    = ls_po
              it_purchasingdocumetitem = lt_poitems
              gv_logo                  = mv_logo
              gv_title                 = gv_title
              is_ekko                  = ls_ekko
              gv_footer                = gv_footer
              gv_footer_note           = gv_footer_note
              gv_net_amount            = gv_net_amount
              gv_sales_tax             = gv_sales_tax
              gv_tot_amt_print         = gv_tot_amt_print
              gv_tot_unit_print        = gv_tot_unit_print
              gv_vendor_addr1          = gv_vendor_addr1
              gv_vendor_addr2          = gv_vendor_addr2
              gv_delivery_addr1        = gv_delivery_addr1
              gv_delivery_addr2        = gv_delivery_addr2
              gv_delivery_name         = gv_delivery_name
              gv_document_date         = gv_document_date
              gv_payment_term          = gv_payment_term
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

          IF ls_lfa1-land1 = lc_land1_gb. "Get T&C page only for UK - call T&C adobe form
            TRY.
                CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
                  EXPORTING
                    i_name     = lc_po_uk_tc_fpname "'ZFI_F_PURCHASE_ORDER_UK_TC'
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
            CALL FUNCTION lv_fm_name
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

        CALL FUNCTION 'FP_JOB_CLOSE'
          IMPORTING
            e_result       = ls_result
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        lo_merger->merge_documents( IMPORTING merged_document = mv_merged_xstring ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_logo.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZCL_PURCHASE_ORDER=>GET_LOGO()                        *
*& TITLE       : Purchase Order Form                                   *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This method helps to get Holman Logo                  *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*
    CONSTANTS: lc_image_url TYPE string VALUE '/SAP/PUBLIC/Holman_Logo.bmp'.
    DATA: o_mr_api  TYPE REF TO if_mr_api,
          is_folder TYPE boole_d,
          e_emage   TYPE xstring,
          l_loio    TYPE skwf_io.

    IF o_mr_api IS INITIAL.
      o_mr_api = cl_mime_repository_api=>if_mr_api~get_api( ).
    ENDIF.

    CALL METHOD o_mr_api->get
      EXPORTING
        i_url              = lc_image_url
      IMPORTING
        e_is_folder        = is_folder
        e_content          = mv_logo
        e_loio             = l_loio
      EXCEPTIONS
        parameter_missing  = 1
        error_occured      = 2
        not_found          = 3
        permission_failure = 4
        OTHERS             = 5.

  ENDMETHOD.


  METHOD PROCESS.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZCL_PURCHASE_ORDER=>PROCESS()                         *
*& TITLE       : Purchase Order Form                                   *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This method will retreive PO Data                     *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*

      get_data( ).

  ENDMETHOD.


  METHOD get_tax_id.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZCL_PURCHASE_ORDER=>GET_TAX_ID()                      *
*& TITLE       : Purchase Order Form                                   *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This method helps to get tax ID logic                 *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*
    DATA: lv_taxtype TYPE bptaxtype.
    CONSTANTS: lc_taxtype_region type RVARI_VNAM VALUE 'ZFI_TAXTYPE_REGION'.

    SELECT * FROM tvarvc INTO TABLE @DATA(lt_tvarvc_tax)
      WHERE name = @lc_taxtype_region AND type = 'S'.
    IF sy-subrc EQ 0.
      lv_taxtype = lt_tvarvc_tax[ low = mv_lfa1-land1 ]-high.
      CLEAR mv_taxnum.
      SELECT SINGLE taxnum FROM dfkkbptaxnum
        INTO mv_taxnum
        WHERE partner = mv_lfa1-lifnr
          AND taxtype = lv_taxtype.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
