class ZCL_SEND_EMAIL definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF tp_files,
        file_name  TYPE sdok_filnm,
        file_descr TYPE so_obj_des,
        file_data  TYPE xstring,
        file_extn  TYPE pc_fext,
      END OF tp_files .
  types:
    tp_files_t TYPE STANDARD TABLE OF tp_files .
  types:
    BEGIN OF tp_param_dynamic,
        name  TYPE stringval,
        value TYPE REF TO data,
      END OF tp_param_dynamic .
  types:
    tp_param_dynamic_t TYPE STANDARD TABLE OF tp_param_dynamic .
  types:
    BEGIN OF tp_param,
        name  TYPE stringval,
        value TYPE soli_tab,
      END OF tp_param .
  types:
    tp_param_t TYPE STANDARD TABLE OF tp_param .

  constants MC_AP_EMAIL_TVARV type TVARVC-LOW value 'ZF110_SENDER_EMAIL' ##NO_TEXT.

  class-methods SEND_EMAIL
    importing
      !I_TDNAME type TDOBNAME optional
      !I_SUBJCT type SO_OBJ_DES
      !I_SENDER type APOC_SENDER_EMAIL_ADDR optional
      !I_COMMIT type BAPICOMMITWORK default 'X'
      !IT_PARAM type TP_PARAM_T optional
      !IT_PARAM_DYNAMIC type TP_PARAM_DYNAMIC_T optional
      !IT_REC type CRMTT_EMAIL_ADDRESS
      !IT_REC_COPY type CRMTT_EMAIL_ADDRESS optional
      !I_ATTACHMENT_OBJ type SIBFTYPEID optional
      !I_OBJ_KEY type SIBFBORIID optional
      !IT_PREFIX_TEXT type SOLI_TAB optional
      !IT_SUFIX_TEXT type SOLI_TAB optional
      !I_BUKRS type BUKRS optional
      !I_SIMULATION type CHAR1 optional
      !IT_FILES type TP_FILES_T optional
    returning
      value(R_SENT) type CHAR1 .
  class-methods GET_ATTACHMENTS
    importing
      !I_ATTACHMENT_OBJ type SIBFTYPEID
      !I_OBJ_KEY type SIBFBORIID
      !I_INFO_ONLY type CHAR1 optional
    exporting
      !ET_FILES type TP_FILES_T .
  class-methods GET_HTML_FROM_ALV
    importing
      value(IT_TABLE) type STANDARD TABLE
      !I_HDR type STRING optional
      !IT_EXCLUDING type FKK_FIELDS optional
    returning
      value(RT_HTML) type SOLI_TAB .
  class-methods FORMAT_STRING
    importing
      !I_DATA type ANY
    returning
      value(R_STRING) type STRING .
  class-methods GET_AP_EMAIL
    importing
      !I_BUKRS type BUKRS optional
    returning
      value(R_EMAIL) type AD_SMTPADR .
  class-methods GET_HTML
    importing
      !I_TDNAME type TDOBNAME
      value(IT_PARAM) type TP_PARAM_T optional
      !IT_PARAM_DYNAMIC type TP_PARAM_DYNAMIC_T optional
      !IT_PREFIX_TEXT type SOLI_TAB optional
      !IT_SUFIX_TEXT type SOLI_TAB optional
    returning
      value(RT_HTML) type SOLI_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SEND_EMAIL IMPLEMENTATION.


  METHOD format_string.

    DATA: lo_type_descr TYPE REF TO cl_abap_typedescr.

    lo_type_descr = cl_abap_typedescr=>describe_by_data( i_data ).
    CASE lo_type_descr->type_kind.
      WHEN 'C'.
        r_string = i_data.
        SHIFT r_string LEFT DELETING LEADING '0'.
      WHEN 'D'.
        r_string = |{ CONV dats( i_data ) DATE = USER }|.
      WHEN 'T'.
        r_string = |{ CONV tims( i_data ) TIME = USER }|.
      WHEN 'N'.
        r_string = i_data.
        SHIFT r_string LEFT DELETING LEADING '0'.
      WHEN 'P'.
        r_string = |{ CONV d16n( i_data ) NUMBER = USER }|.
      WHEN OTHERS.
        r_string = i_data.
    ENDCASE.

  ENDMETHOD.


  METHOD get_ap_email.


    IF i_bukrs IS NOT INITIAL.
      DATA(lv_email1) = |{ zcl_send_email=>mc_ap_email_tvarv }_{ i_bukrs }|.
    ENDIF.
    DATA(lv_email2) = zcl_send_email=>mc_ap_email_tvarv.

    DO 2 TIMES.
      CASE sy-index.
        WHEN 1.
          DATA(lv_email) = lv_email1.
        WHEN 2.
          lv_email = lv_email2.
      ENDCASE.
      CHECK lv_email IS NOT INITIAL.

      SELECT SINGLE low FROM tvarvc ##WARN_OK
             WHERE name = @lv_email
             INTO @r_email.

      IF sy-subrc IS INITIAL.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD get_attachments.

    DATA: ls_lpor  TYPE sibflporb,
          lt_links TYPE obl_t_link,
          lt_relat TYPE obl_t_relt,
          ls_sood  TYPE sood.

    DATA: lv_folder   TYPE soodk,
          lv_docid    TYPE soodk,
          lt_objcont  TYPE STANDARD TABLE OF soli,
          ls_loio     TYPE sdokobject,
          ls_phio     TYPE sdokobject,
          lt_context  TYPE STANDARD TABLE OF sdokpropty,
          lv_file     TYPE char255,
          ls_ph       TYPE soffphio,
          lv_size     TYPE i,
          lt_data_txt TYPE STANDARD TABLE OF sdokcntasc,
          lt_data_bin TYPE STANDARD TABLE OF sdokcntbin,
          lv_buffer   TYPE xstring,
          lt_data     TYPE STANDARD TABLE OF sood4 ##NEEDED.

    ls_lpor-objtype = i_attachment_obj.
    ls_lpor-instid  = i_obj_key.
    ls_lpor-catid   = 'BO'.

    APPEND 'IEQATTA' TO lt_relat.

    TRY.

        CALL METHOD cl_binary_relation=>read_links_of_binrels
          EXPORTING
            is_object           = ls_lpor
            it_relation_options = lt_relat
            ip_role             = 'GOSAPPLOBJ'
            ip_no_buffer        = 'X'
          IMPORTING
            et_links            = lt_links.

        LOOP AT lt_links ASSIGNING FIELD-SYMBOL(<link>).

          APPEND <link>-instid_b TO lt_data ASSIGNING FIELD-SYMBOL(<data>).

          SELECT SINGLE * FROM sood
                 INTO ls_sood
                 WHERE objtp = <data>-objtp
                   AND objyr = <data>-objyr
                   AND objno = <data>-objno
                   .
" ???? TODO check if we can change to the following select clause
*          SELECT single FROM sood
*                 fields FOLTP, FOLYR, FOLNO, OBJTP, OBJYR, OBJNO
*                 WHERE objtp = <data>-objtp
*                   AND objyr = <data>-objyr
*                   AND objno = <data>-objno
*                 INTO data(ls_sood)
*                   .
          MOVE-CORRESPONDING ls_sood TO <data>.
          CONCATENATE <data>-foltp
                      <data>-folyr
                      <data>-folno
                      INTO lv_folder.
          CONCATENATE <data>-objtp
                      <data>-objyr
                      <data>-objno
                      INTO lv_docid.
          CALL FUNCTION 'SO_OBJECT_READ'
            EXPORTING
              folder_id                  = lv_folder
              object_id                  = lv_docid
            TABLES
              objcont                    = lt_objcont
            EXCEPTIONS
              active_user_not_exist      = 1
              communication_failure      = 2
              component_not_available    = 3
              folder_not_exist           = 4
              folder_no_authorization    = 5
              object_not_exist           = 6
              object_no_authorization    = 7
              operation_no_authorization = 8
              owner_not_exist            = 9
              parameter_error            = 10
              substitute_not_active      = 11
              substitute_not_defined     = 12
              system_failure             = 13
              x_error                    = 14
              OTHERS                     = 15.
          CHECK sy-subrc IS INITIAL.

          CALL FUNCTION 'SO_KPRO_DATA_FROM_OBJCONT_GET'
            IMPORTING
              loio_object       = ls_loio
            TABLES
              objcont           = lt_objcont
              context           = lt_context
            EXCEPTIONS
              missing_kpro_data = 1
              OTHERS            = 2.
          CHECK sy-subrc IS INITIAL.
          CALL FUNCTION 'SO_LOIO_PHIO_GET'
            EXPORTING
              loio_object        = ls_loio
            IMPORTING
              phio_object        = ls_phio
            TABLES
              context            = lt_context
            EXCEPTIONS
              kpro_inconsistency = 1
              x_error            = 2
              OTHERS             = 3.
          CHECK sy-subrc IS INITIAL.
          SELECT SINGLE * FROM soffphio
                 INTO ls_ph
                 WHERE phio_id = ls_phio-objid
                 .
          SELECT SINGLE stor_rep FROM sdokstca
                 WHERE stor_cat = @ls_ph-stor_cat
                 INTO @DATA(lv_crep_id).

          SELECT SINGLE FROM soffphf  ##WARN_OK
                 FIELDS file_name
                 WHERE phio_id = @ls_phio-objid
                 INTO @lv_file.

          IF i_info_only IS INITIAL.
            CALL FUNCTION 'SCMS_R3DB_GET'
              EXPORTING
                crep_id      = lv_crep_id
                doc_id       = ls_phio-objid
                comp_id      = lv_file
              IMPORTING
                comp_size    = lv_size
              TABLES
                data_txt     = lt_data_txt
                data_bin     = lt_data_bin
              EXCEPTIONS
                error_import = 1
                error_config = 2
                OTHERS       = 3.
            CHECK sy-subrc IS INITIAL.

            CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
              EXPORTING
                input_length = lv_size
              IMPORTING
                buffer       = lv_buffer
              TABLES
                binary_tab   = lt_data_bin
              EXCEPTIONS
                failed       = 1
                OTHERS       = 2.
            CHECK sy-subrc IS INITIAL.
          ENDIF.

          APPEND INITIAL LINE TO et_files ASSIGNING FIELD-SYMBOL(<file>).

          <file>-file_name  = lv_file.
          <file>-file_descr = <data>-objdes.
          <file>-file_data  = lv_buffer.

          SPLIT <file>-file_descr AT '.' INTO TABLE DATA(lt_filename).

          IF lines( lt_filename ) < 2.

            CLEAR lt_filename.

            SPLIT <file>-file_name AT '.' INTO TABLE lt_filename.

            READ TABLE lt_filename ASSIGNING FIELD-SYMBOL(<ls_filename>) INDEX lines( lt_filename ).

            <file>-file_extn = <ls_filename>.

          ELSE.

            READ TABLE lt_filename ASSIGNING <ls_filename> INDEX lines( lt_filename ).

            <file>-file_extn = <ls_filename>.

          ENDIF.

        ENDLOOP.

      CATCH cx_obl_parameter_error cx_obl_internal_error cx_obl_model_error.
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD get_html.

    DATA: lt_text   TYPE tline_t,
          lv_string TYPE string,
          lv_name   TYPE string,
          lv_table  TYPE string,
          lv_field  TYPE string
          .
    FIELD-SYMBOLS: <data>  TYPE any,
                   <field> TYPE any.

    APPEND '<html><head><style>* {box-sizing: border-box;}.row { margin-left:-5px;margin-right:-5px;}.column' TO rt_html          ##NO_TEXT.
    APPEND '{float: left;width: 33%;padding: 5px;}.row::after {content: "";clear: both;display: table;}' TO rt_html               ##NO_TEXT.
    APPEND 'tbody tr:hover {background-color: #abf0ec;}@media screen and (max-width: 800px) {.column {width: 100%;}}' TO rt_html  ##NO_TEXT.
    append ' .highlight { background-color: #f6f8ff; text-align: center; }' TO rt_html.
    APPEND '</style></head><body>' TO rt_html ASSIGNING FIELD-SYMBOL(<line>).

    LOOP AT it_param ASSIGNING FIELD-SYMBOL(<param>).
      TRANSLATE <param>-name TO UPPER CASE.
    ENDLOOP.

    APPEND LINES OF it_prefix_text TO rt_html.

    IF i_tdname IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'ST'
          language                = sy-langu
          name                    = i_tdname
          object                  = 'TEXT'
        TABLES
          lines                   = lt_text
        EXCEPTIONS
          id                      = 0
          language                = 0
          name                    = 0
          not_found               = 0
          object                  = 0
          reference_check         = 0
          wrong_access_to_archive = 0
          OTHERS                  = 0.

      DELETE lt_text WHERE tdformat = '/*'.
      IF lt_text IS INITIAL.
        APPEND |<br><h2>Long text (t-code SO10) { i_tdname } not found or empty</h2><br>| TO rt_html  ##NO_TEXT.
      ENDIF.

      LOOP AT lt_text ASSIGNING FIELD-SYMBOL(<text>).
        DO.
          IF <text>-tdline CA '['.
            FIND ALL OCCURRENCES OF '[' IN <text>-tdline RESULTS DATA(lt_search).
            READ TABLE lt_search ASSIGNING FIELD-SYMBOL(<search>) INDEX 1.
            FIND FIRST OCCURRENCE OF ']' IN <text>-tdline IN CHARACTER MODE MATCH OFFSET DATA(lv_end).
            <search>-offset = <search>-offset + 1.
            lv_end = lv_end - <search>-offset.
            lv_name = <text>-tdline+<search>-offset(lv_end).
            TRANSLATE lv_name TO UPPER CASE.
            IF lv_name CA '-'.
              SPLIT lv_name AT '-' INTO lv_table lv_field.
              IF lv_field IS NOT INITIAL.
                READ TABLE it_param_dynamic ASSIGNING FIELD-SYMBOL(<param_dyn>)
                                            WITH KEY name = lv_table.
                IF sy-subrc IS INITIAL.
                  ASSIGN <param_dyn>-value->* TO <data>.
                  ASSIGN COMPONENT lv_field OF STRUCTURE <data> TO <field>.
                  IF sy-subrc IS INITIAL.
                    lv_string = zcl_send_email=>format_string( <field> ).
                    REPLACE '[' IN <text>-tdline WITH ''.
                    REPLACE ']' IN <text>-tdline WITH ''.
                    REPLACE lv_name IN <text>-tdline WITH lv_string IGNORING CASE.
                  ENDIF.
                ELSE.
                  "Check if this is some "system parameter"
                  ASSIGN (lv_name) TO <field>.
                  IF sy-subrc IS INITIAL.
                    lv_string = zcl_send_email=>format_string( <field> ).
                    REPLACE '[' IN <text>-tdline WITH ''.
                    REPLACE ']' IN <text>-tdline WITH ''.
                    REPLACE lv_name IN <text>-tdline WITH lv_string IGNORING CASE.
                  ELSE.
                    "This parameter must be a mistake - replace brackets to move to the next one
                    REPLACE '[' IN <text>-tdline WITH '!'.
                    REPLACE ']' IN <text>-tdline WITH '!'.
                  ENDIF.
                ENDIF.
              ENDIF.
            ELSE.
              READ TABLE it_param ASSIGNING <param> WITH KEY name = lv_name.
              IF sy-subrc IS INITIAL.
                SPLIT <text>-tdline AT '[' INTO lv_string <text>-tdline.
                IF lv_string IS NOT INITIAL.
                  APPEND lv_string TO rt_html.
                ENDIF.
                SPLIT <text>-tdline AT ']' INTO lv_string <text>-tdline.
                APPEND LINES OF <param>-value TO rt_html.
              ELSE.
                APPEND <text>-tdline TO rt_html.
                EXIT.
              ENDIF.
            ENDIF.
          ELSE.
            APPEND <text>-tdline TO rt_html.
            EXIT.
          ENDIF.
        ENDDO.
      ENDLOOP.
    ENDIF.

    APPEND LINES OF it_sufix_text TO rt_html.

    APPEND '</body></html>' TO rt_html.

  ENDMETHOD.


  METHOD get_html_from_alv.

    DATA: lv_string TYPE string.

    FIELD-SYMBOLS: <field> TYPE any.

* Prepare the Fields for the data to be sent
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = DATA(lr_table)
          CHANGING
            t_table      = it_table ).

        DATA(lt_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = lr_table->get_columns( )
                                                                           r_aggregations = lr_table->get_aggregations( ) ).
      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.

*   Add the header line
    APPEND '<TABLE cellspacing="0" cellpadding="3" border="1" style="margin-top: 10px;">'   TO rt_html.
    IF i_hdr IS NOT INITIAL.
      APPEND |<caption><b>{ i_hdr }</b></caption>| TO rt_html.
    ENDIF.

    APPEND '<TR>'           TO rt_html.
    LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<fcat>).
      DATA(lv_tabix) = sy-tabix.
      IF <fcat>-fieldname = 'MANDT'.
        DELETE lt_fcat INDEX sy-tabix.
        CONTINUE.
      ENDIF.
      IF it_excluding IS NOT INITIAL.
        READ TABLE it_excluding TRANSPORTING NO FIELDS WITH KEY table_line = <fcat>-fieldname.
        IF sy-subrc IS INITIAL.
          DELETE lt_fcat INDEX lv_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.

      APPEND |<TH>{ <fcat>-reptext }</TH>| TO rt_html.
    ENDLOOP.
    APPEND '</TR>' TO rt_html.

* Add the table data

    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<line>).
      APPEND '<TR>'           TO rt_html.
      LOOP AT lt_fcat ASSIGNING <fcat>.
        ASSIGN COMPONENT <fcat>-fieldname OF STRUCTURE <line> TO <field>.
        CASE <fcat>-inttype.
          WHEN 'C'.
            IF <field> IS INITIAL.
              lv_string = '&nbsp'.
            ELSE.
              lv_string = <field>.
              SHIFT lv_string LEFT DELETING LEADING '0'.
            ENDIF.
            APPEND |<TD>{ lv_string }</TD>| TO rt_html.
          WHEN 'D'.
            IF <field> IS INITIAL.
              APPEND '<TD>&nbsp</TD>' TO rt_html.
            ELSE.
              APPEND |<TD>{ CONV dats( <field> ) DATE = USER }</TD>| TO rt_html.
            ENDIF.
          WHEN 'N'.
            lv_string = <field>.
            SHIFT lv_string LEFT DELETING LEADING '0'.
            IF lv_string IS INITIAL.
              APPEND '<TD>&nbsp</TD>' TO rt_html.
            ELSE.
              APPEND |<TD>{ lv_string }</TD>| TO rt_html.
            ENDIF.
          WHEN 'P'.
            APPEND |<TD>{ CONV d16n( <field> ) NUMBER = USER }</TD>| TO rt_html.
        ENDCASE.
      ENDLOOP.
      APPEND '</TR>' TO rt_html.
    ENDLOOP.
    APPEND '</TABLE>' TO rt_html.

  ENDMETHOD.


  METHOD send_email.

    DATA: lo_doc_bcs   TYPE REF TO cl_document_bcs,
          lt_html      TYPE soli_tab,
          lt_files     TYPE tp_files_t,
          lt_files_gos TYPE tp_files_t.

    "IT_FILES will have the attachments which are being currently loaded from Fiori app and still in GOS draft version.
    lt_files = it_files.

    "Get the attachments from GOS as well as upon re-parking existing attachments are also emailed.
    IF i_attachment_obj IS NOT INITIAL AND i_obj_key IS NOT INITIAL.

      zcl_send_email=>get_attachments(
        EXPORTING
          i_attachment_obj = i_attachment_obj
          i_obj_key        = i_obj_key
        IMPORTING
          et_files         = lt_files_gos ).

      APPEND LINES OF lt_files_gos TO lt_files.

    ENDIF.

    lt_html = zcl_send_email=>get_html( i_tdname         = i_tdname
                                        it_prefix_text   = it_prefix_text
                                        it_sufix_text    = it_sufix_text
                                        it_param         = it_param
                                        it_param_dynamic = it_param_dynamic ).

    IF i_simulation IS NOT INITIAL.
      DATA: lt_html_tab TYPE cl_abap_browser=>html_table.
      lt_html_tab = lt_html.
      CALL METHOD cl_abap_browser=>show_html
        EXPORTING
          html     = lt_html_tab
          format   = cl_abap_browser=>landscape
          position = cl_abap_browser=>topleft.
      RETURN.
    ENDIF.

    TRY.
        DATA(lo_bcs) = cl_bcs=>create_persistent( ).

        "Set up document object
        lo_doc_bcs = cl_document_bcs=>create_document(
          i_type    = 'HTM'
          i_text    = lt_html
          i_subject = i_subjct ).

        "Add attachment
        LOOP AT lt_files ASSIGNING FIELD-SYMBOL(<file>).

          lo_doc_bcs->add_attachment( i_attachment_type    = <file>-file_extn
                                      i_attachment_size    = CONV #( xstrlen( <file>-file_data ) )
                                      i_attachment_subject = <file>-file_descr
                                      i_att_content_hex    = cl_bcs_convert=>xstring_to_solix( <file>-file_data ) ).

        ENDLOOP.

        lo_bcs->set_document( i_document = lo_doc_bcs ).
        lo_bcs->set_message_subject( ip_subject = CONV #( i_subjct ) ).

        TRY.
            LOOP AT it_rec ASSIGNING FIELD-SYMBOL(<rec>).
              DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address( i_address_string = <rec> ).
              lo_bcs->add_recipient( i_recipient = lo_recipient ).
            ENDLOOP.
          CATCH cx_address_bcs    ##NO_HANDLER.
          CATCH cx_send_req_bcs   ##NO_HANDLER.
        ENDTRY.

        TRY.

            LOOP AT it_rec_copy ASSIGNING FIELD-SYMBOL(<ls_rec_copy>).

              lo_recipient = cl_cam_address_bcs=>create_internet_address( i_address_string = <ls_rec_copy> ).

              lo_bcs->add_recipient( i_recipient = lo_recipient
                                     i_copy      = abap_true ).

            ENDLOOP.

          CATCH cx_address_bcs cx_send_req_bcs   ##NO_HANDLER.

        ENDTRY.

        TRY.
            IF i_sender IS NOT INITIAL.
              DATA(lv_sender) = i_sender.
            ELSE.
              lv_sender = zcl_send_email=>get_ap_email( i_bukrs ).
            ENDIF.
            DATA(lo_sender) = cl_cam_address_bcs=>create_internet_address( i_address_string = lv_sender ).
            lo_bcs->set_sender( i_sender = lo_sender ).
          CATCH cx_address_bcs    ##NO_HANDLER.
          CATCH cx_send_req_bcs   ##NO_HANDLER.
        ENDTRY.

        lo_bcs->set_status_attributes( i_requested_status = 'N' ).
        lo_bcs->send( ).
        IF i_commit IS NOT INITIAL.
          COMMIT WORK AND WAIT.
        ENDIF.
        r_sent = 'X'.

      CATCH cx_root   ##NO_HANDLER ##CATCH_ALL.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
