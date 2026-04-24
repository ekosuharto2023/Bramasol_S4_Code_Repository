*&---------------------------------------------------------------------*
*&  Include           Z_AL11_CLS
*&---------------------------------------------------------------------*

  TYPES: tp_folder_tbl TYPE STANDARD TABLE OF lvc_value,
         tp_zal11_t    TYPE STANDARD TABLE OF tp_al11
         .


*---------------------------------------------------------------------*
*       CLASS lcl_popup_evt_rcv DEFINITION
*---------------------------------------------------------------------*
  CLASS lcl_popup_evt_rcv DEFINITION.

    PUBLIC SECTION.
      METHODS:
*     when double clicking on the data, show the line parsed to position
        handle_close_popup
          FOR EVENT close        OF cl_gui_dialogbox_container
          IMPORTING sender,
        handle_dbl_click_data
          FOR EVENT double_click OF cl_gui_alv_grid
          IMPORTING e_row
          .

    PRIVATE SECTION.

  ENDCLASS.                    "lcl_popup_evt_rcv DEFINITION



*---------------------------------------------------------------------*
*       CLASS lcl_tree_evt_rcv DEFINITION
*---------------------------------------------------------------------*
  CLASS lcl_tree_evt_rcv DEFINITION.

    PUBLIC SECTION.
      METHODS:
        on_function_selected
          FOR EVENT function_selected OF cl_gui_toolbar
          IMPORTING fcode,
        handle_node_cm_req_server
          FOR EVENT node_context_menu_request OF cl_gui_alv_tree
          IMPORTING node_key menu,
        handle_node_cm_sel_server
          FOR EVENT node_context_menu_selected OF cl_gui_alv_tree
          IMPORTING node_key fcode,
        handle_node_cm_req_local
          FOR EVENT node_context_menu_request OF cl_gui_alv_tree
          IMPORTING node_key menu,
        handle_node_cm_sel_local
          FOR EVENT node_context_menu_selected OF cl_gui_alv_tree
          IMPORTING node_key fcode,
        handle_expand_node_nc_server
          FOR EVENT expand_nc OF cl_gui_alv_tree
          IMPORTING node_key,
        handle_expand_node_nc_local
          FOR EVENT expand_nc OF cl_gui_alv_tree
          IMPORTING node_key,
        handle_select_server
          FOR EVENT selection_changed OF cl_gui_alv_tree
          IMPORTING node_key,
        handle_select_local
          FOR EVENT selection_changed OF cl_gui_alv_tree
          IMPORTING node_key
          .

    PRIVATE SECTION.
      TYPES: BEGIN OF tp_path,
               folder TYPE string.
               INCLUDE TYPE filepath.
      TYPES: END OF tp_path.

      DATA: gt_path TYPE STANDARD TABLE OF tp_path.

      METHODS:
        handle_cm_req
          IMPORTING
            server   TYPE char1
            node_key TYPE lvc_nkey
            menu     TYPE REF TO cl_ctmenu,
        handle_cm_sel
          IMPORTING
            server   TYPE char1
            node_key TYPE lvc_nkey
            fcode    TYPE sy-ucomm,
        find_logical_path
          IMPORTING
            node_key TYPE lvc_nkey,
        upload_file
          IMPORTING
            node_key TYPE lvc_nkey,
        add_to_fav
          IMPORTING
            server     TYPE char1
            from_nodes TYPE lvc_t_nkey
            to_node    TYPE lvc_nkey,
        change_dir
          IMPORTING
            logical_folder TYPE char1,
        get_open_directories
          IMPORTING
            parent_node TYPE lvc_nkey
          CHANGING
            folder      TYPE tp_folder_tbl
            node_table  TYPE lvc_t_nkey
            last_dir    TYPE string
          .

  ENDCLASS.                    "LCL_APPLICATION DEFINITION



*---------------------------------------------------------------------*
*    CLASS lcl_dnd_evt_rcv     DEFINITION.
*---------------------------------------------------------------------*
  CLASS lcl_dnd_evt_rcv DEFINITION.
    PUBLIC SECTION.
      METHODS:
        handle_alv_drag
          FOR EVENT ondrag OF cl_gui_alv_grid
          IMPORTING sender e_row e_dragdropobj,
        handle_line_drop_server
          FOR EVENT on_drop OF cl_gui_alv_tree
          IMPORTING sender node_key drag_drop_object,
        handle_line_drop_local
          FOR EVENT on_drop OF cl_gui_alv_tree
          IMPORTING sender node_key drag_drop_object
          .

  ENDCLASS.                    "lcl_dnd_evt_rcv DEFINITION



*---------------------------------------------------------------------*
*    CLASS lcl_dragdropobj         DEFINITION.
*---------------------------------------------------------------------*
  CLASS lcl_dragdropobj DEFINITION.
    PUBLIC SECTION.
      DATA: full_path TYPE string,
            name      TYPE filename75,
            index     TYPE sy-tabix,
            upload    TYPE char1
            .

  ENDCLASS.                    "lcl_dragdropobj DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_grid_evt_rcv DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_grid_evt_rcv DEFINITION.

    PUBLIC SECTION.

      METHODS:
        handle_toolbar
          FOR EVENT toolbar OF cl_gui_alv_grid
          IMPORTING sender e_object,

        handle_menu_button
          FOR EVENT menu_button OF cl_gui_alv_grid
          IMPORTING e_object e_ucomm,

        handle_user_command
          FOR EVENT user_command OF cl_gui_alv_grid
          IMPORTING e_ucomm,

        handle_double_click
          FOR EVENT double_click OF cl_gui_alv_grid
          IMPORTING sender es_row_no
          .

    PRIVATE SECTION.

      METHODS:  show_file
        IMPORTING
          file_name TYPE string
          delimiter TYPE tgsut-separator OPTIONAL
          tabbed    TYPE c OPTIONAL
          regular   TYPE c OPTIONAL,

        show_editor
          IMPORTING
            file_name TYPE string,

        show_html
          IMPORTING
            file_name TYPE string,

        show_bin_file
          IMPORTING
            file_name TYPE string,

        rename_file
          IMPORTING
            file_name TYPE string,

        download_file
          IMPORTING
            file_name TYPE string,

        copy
        .

      DATA: g_alv_popup   TYPE REF TO cl_gui_alv_grid,
            dialog_contnr TYPE REF TO cl_gui_dialogbox_container
            .

  ENDCLASS.                    "lcl_grid_evt_rcv DEFINITION




*----------------------------------------------------------------------*
*       CLASS lcl_grid_evt_rcv IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_grid_evt_rcv IMPLEMENTATION.

    METHOD handle_toolbar.

      DATA: ls_sxpg   TYPE sxpgcostab,
            ls_layout TYPE lvc_s_layo
            .
      FIELD-SYMBOLS: <line> LIKE LINE OF e_object->mt_toolbar.

      LOOP AT e_object->mt_toolbar ASSIGNING <line>.
        CASE <line>-function.
          WHEN '&&SEP04' OR '&MB_SUM'     OR '&MB_SUBTOT' OR '&INFO'      OR
               '&&SEP05' OR '&PRINT_BACK' OR '&MB_VIEW'   OR '&MB_EXPORT' OR
               '&COL0'   OR '&&SEP06'     OR '&GRAPH'     OR '&&SEP07'
            .
            DELETE e_object->mt_toolbar INDEX sy-tabix.
        ENDCASE.
      ENDLOOP.

      CALL METHOD sender->get_frontend_layout
        IMPORTING
          es_layout = ls_layout.

      CASE ls_layout-countfname.
        WHEN 'GT_DIR_SERVER'.
*         Append a separator to normal toolbar
          CLEAR gs_toolbar.
          MOVE 3 TO gs_toolbar-butn_type.
          APPEND gs_toolbar TO e_object->mt_toolbar.

*         Append a menu
          CLEAR gs_toolbar.
          gs_toolbar-function  = gc_toolbar_open_file.
          gs_toolbar-icon      = gc_icon_file_open.
          gs_toolbar-quickinfo =
          gs_toolbar-text = 'Open file'(op8).
          gs_toolbar-butn_type = 2.
          APPEND gs_toolbar TO e_object->mt_toolbar.

*         Append a button
          CLEAR gs_toolbar.
          gs_toolbar-function  = gc_fcode_download_file.
          gs_toolbar-icon      = gc_icon_down.
          gs_toolbar-quickinfo = 'Download file'(dwn).
          gs_toolbar-text = 'Download file'(dwn).
          gs_toolbar-butn_type = 0.
          APPEND gs_toolbar TO e_object->mt_toolbar.

*         Append a button
          CLEAR gs_toolbar.
          gs_toolbar-function  = gc_fcode_upload_file.
          gs_toolbar-icon      = gc_icon_up.
          gs_toolbar-quickinfo = 'Upload file'(fup).
          gs_toolbar-text = 'Upload file'(fup).
          gs_toolbar-butn_type = 0.
          APPEND gs_toolbar TO e_object->mt_toolbar.

          SELECT SINGLE * FROM sxpgcostab
                 INTO ls_sxpg
                 WHERE name     = gc_sxpg_rename
                   AND opsystem = sy-opsys
                   .
          IF sy-subrc IS INITIAL.
            CLEAR gs_toolbar.
            gs_toolbar-function  = gc_fcode_rename_file.
            gs_toolbar-icon      = gc_icon_rename.
            gs_toolbar-quickinfo = 'Rename file'(ren).
            gs_toolbar-text = 'Rename file'(ren).
            gs_toolbar-butn_type = 0.
            APPEND gs_toolbar TO e_object->mt_toolbar.
          ENDIF.

*         Append a button
          CLEAR gs_toolbar.
          gs_toolbar-function  = gc_fcode_copy.
          gs_toolbar-icon      = gc_icon_copy.
          gs_toolbar-quickinfo = 'Copy filename to memory'(cop).
          gs_toolbar-butn_type = 0.
          APPEND gs_toolbar TO e_object->mt_toolbar.

        WHEN 'GT_DIR_LOCAL'.
          CLEAR gs_toolbar.
          gs_toolbar-function  = gc_fcode_transfer.
          gs_toolbar-icon      = gc_icon_transfer.
          gs_toolbar-quickinfo = 'Choose Transfer Mode'(trn).
          gs_toolbar-text      = 'Choose Transfer Mode'(trn).
          gs_toolbar-butn_type = 2.
          APPEND gs_toolbar TO e_object->mt_toolbar.

      ENDCASE.

    ENDMETHOD.                    "handle_toolbar


*--------------------------------------------------------------------
    METHOD handle_menu_button.

      CASE e_ucomm.
        WHEN gc_fcode_transfer.
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_tm_auto
              text  = 'Auto'(tm0).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_tm_ascii
              text  = 'ASCII (text)'(tm1).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_tm_bin
              text  = 'Binary'(tm2).

        WHEN gc_toolbar_open_file.
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file
              text  = 'Open File'(op1).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file_parse
              text  = 'Open file (parsed)'(op2).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file_tab
              text  = 'Open File (Tabbed)'(op3).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file_edit
              text  = 'Open File in Editor'(op4).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file_pdf
              text  = 'Open File as PDF'(op5).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_column_marker
              text  = 'Open File (Column Marker)'(op6).
          CALL METHOD e_object->add_function
            EXPORTING
              fcode = gc_fcode_open_file_html
              text  = 'Open Fille in Browser (HTML)'(op7).

      ENDCASE.
    ENDMETHOD.                    "handle_menu_button



*---------------------------------------------------------------------
    METHOD handle_double_click.

      DATA: ls_layout   TYPE lvc_s_layo,
            lt_children TYPE lvc_t_nkey,
            lt_nodes    TYPE lvc_t_nkey,
            wa_dir      TYPE tp_al11,
            lv_phyfile  TYPE rlgrap-filename,
            lv_server   TYPE char1
            .

      FIELD-SYMBOLS: <file>     TYPE tp_al11,
                     <dir>      TYPE STANDARD TABLE,
                     <tree>     TYPE REF TO cl_gui_alv_tree,
                     <node>     TYPE lvc_nkey,
                     <child>    TYPE lvc_nkey,
                     <last_dir> TYPE string
                     .

      CALL METHOD sender->get_frontend_layout
        IMPORTING
          es_layout = ls_layout.

      ASSIGN (ls_layout-countfname) TO <dir>.

      CASE ls_layout-countfname.
        WHEN 'GT_DIR_SERVER'.
          ASSIGN g_tree_server TO <tree>.
          ASSIGN gv_last_node_server TO <node>.
          ASSIGN gv_last_dir_server TO <last_dir>.
          lv_server = 'X'.
        WHEN 'GT_DIR_LOCAL'.
          ASSIGN g_tree_local TO <tree>.
          ASSIGN gv_last_node_local TO <node>.
          ASSIGN gv_last_dir_local TO <last_dir>.
      ENDCASE.

      READ TABLE <dir> ASSIGNING <file> INDEX es_row_no-row_id.
      CASE <file>-type.
        WHEN gc_directory.

          IF <file>-name = '..'.
            CALL METHOD <tree>->get_parent
              EXPORTING
                i_node_key        = <node>
              IMPORTING
                e_parent_node_key = <node>.
            CALL METHOD <tree>->get_outtab_line
              EXPORTING
                i_node_key     = <node>
              IMPORTING
                e_outtab_line  = wa_dir
              EXCEPTIONS
                node_not_found = 1
                OTHERS         = 2.
          ELSE.
            CALL METHOD <tree>->get_children
              EXPORTING
                i_node_key  = <node>
              IMPORTING
                et_children = lt_children.
            IF lt_children IS INITIAL.
              IF lv_server = 'X'.
                PERFORM create_hier_server USING <last_dir>
                                                 <node>
                                                 .
              ELSE.
                PERFORM create_hier_local USING <last_dir>
                                                 <node>
                                                 .
              ENDIF.
              CALL METHOD <tree>->get_children
                EXPORTING
                  i_node_key  = <node>
                IMPORTING
                  et_children = lt_children.
            ENDIF.
            LOOP AT lt_children ASSIGNING <child>.
              CALL METHOD <tree>->get_outtab_line
                EXPORTING
                  i_node_key     = <child>
                IMPORTING
                  e_outtab_line  = wa_dir
                EXCEPTIONS
                  node_not_found = 1
                  OTHERS         = 2.
              IF wa_dir-name = <file>-name.
                <node> = <child>.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
          APPEND <node> TO lt_nodes.
          <tree>->set_selected_nodes(
            EXPORTING
              it_selected_nodes = lt_nodes
          ).
          wa_dir-name = <last_dir> = wa_dir-full_path.
          PERFORM update_dir_files USING lv_server wa_dir-name.

        WHEN OTHERS.
          IF lv_server IS INITIAL.
            CALL METHOD cl_gui_frontend_services=>execute
              EXPORTING
                document               = <file>-full_path
              EXCEPTIONS
                cntl_error             = 0
                error_no_gui           = 0
                bad_parameter          = 0
                file_not_found         = 0
                path_not_found         = 0
                file_extension_unknown = 0
                error_execute_failed   = 0
                synchronous_failed     = 0
                not_supported_by_gui   = 0
                OTHERS                 = 0.
          ELSE.

            lv_phyfile = <file>-name.
            PERFORM get_transfer_mode USING lv_phyfile.

            CASE trans_mode.
              WHEN '' OR gc_ascii.
                CALL METHOD show_editor
                  EXPORTING
                    file_name = <file>-full_path.

              WHEN gc_binary.
                CALL METHOD show_bin_file
                  EXPORTING
                    file_name = <file>-full_path.
            ENDCASE.
          ENDIF.
      ENDCASE.

    ENDMETHOD.    "handle_double_click


*---------------------------------------------------------------------
    METHOD handle_user_command.
      DATA: lv_tabix     TYPE i,
            lv_delimiter TYPE tgsut-separator,
            lv_ans       TYPE c,
            lt_cells     TYPE lvc_t_cell
            .
      FIELD-SYMBOLS: <dir>  LIKE LINE OF gt_dir_server,
                     <cell> TYPE lvc_s_cell
                     .

      CLEAR: gv_last_file.
      CALL METHOD g_alv_grid_server->get_selected_cells
        IMPORTING
          et_cell = lt_cells.
      READ TABLE lt_cells INDEX 1 ASSIGNING <cell>.
      IF sy-subrc IS INITIAL.
        lv_tabix = <cell>-row_id-index.
        IF lv_tabix IS INITIAL.
          MESSAGE s398(00) WITH '????' '' '' ''.
          EXIT.
        ENDIF.
        READ TABLE gt_dir_server ASSIGNING <dir> INDEX lv_tabix.
        gv_last_file = <dir>-full_path.
      ENDIF.
      CASE e_ucomm.
        WHEN gc_fcode_tm_auto.
          CLEAR trans_mode.

        WHEN gc_fcode_tm_ascii.
          trans_mode = gc_ascii.

        WHEN gc_fcode_tm_bin.
          trans_mode = gc_binary.

*       Rename file on app. server
        WHEN gc_fcode_rename_file.
          CALL METHOD rename_file
            EXPORTING
              file_name = gv_last_file.

        WHEN gc_fcode_column_marker.
          CALL METHOD show_file
            EXPORTING
              file_name = gv_last_file
              delimiter = gc_use_columns.

*       copy filename + path to clipboard
        WHEN gc_fcode_copy.
          CALL METHOD copy.

*       open file with a deimiter
        WHEN gc_fcode_open_file_parse.
          CALL FUNCTION 'POPUP_TO_GET_VALUE'                "#EC *
            EXPORTING
              fieldname           = 'SEPARATOR'
              tabname             = 'TGSUT'
              titel               = 'Please Enter Structure Delimiter'(t07)
              valuein             = ','
            IMPORTING
              answer              = lv_ans
              valueout            = lv_delimiter
            EXCEPTIONS
              fieldname_not_found = 1
              OTHERS              = 2.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          IF lv_ans <> 'C'.

            CALL METHOD show_file
              EXPORTING
                file_name = gv_last_file
                delimiter = lv_delimiter.
          ENDIF.

*       open a tabulated file
        WHEN gc_fcode_open_file_tab.
          CALL METHOD show_file
            EXPORTING
              file_name = gv_last_file
              tabbed    = 'X'.

*       open a PDF file
        WHEN gc_fcode_open_file_pdf.
          CALL METHOD show_bin_file
            EXPORTING
              file_name = gv_last_file.

*       open a HTML file
        WHEN gc_fcode_open_file_html.
          CALL METHOD show_html
            EXPORTING
              file_name = gv_last_file.

*       open a Editor file
        WHEN gc_fcode_open_file_edit.
          CALL METHOD show_editor
            EXPORTING
              file_name = gv_last_file.

*       open a file with no parsing
        WHEN gc_fcode_open_file.
          CALL METHOD show_file
            EXPORTING
              file_name = gv_last_file
              regular   = 'X'.

*       download file to PC
        WHEN gc_fcode_download_file.
          CALL METHOD download_file
            EXPORTING
              file_name = gv_last_file.

*       Upload File
        WHEN gc_fcode_upload_file.

          PERFORM upload_file USING '' ''.
          PERFORM update_dir_files USING 'X' ''.
      ENDCASE.

    ENDMETHOD.                           "handle_user_command




*&---------------------------------------------------------------------*
*&      Method  show_editor
*&---------------------------------------------------------------------*
    METHOD  show_editor.

      DATA: line(256)        TYPE c,
            lt_data          TYPE STANDARD TABLE OF line,
            l_event_receiver TYPE REF TO lcl_popup_evt_rcv,
            lo_text          TYPE REF TO cl_gui_textedit
            .

      IF NOT g_alv_popup IS INITIAL.
        CALL METHOD g_alv_popup->free.
        CLEAR: g_alv_popup, g_html_viewer.
        FREE:  g_alv_popup, g_html_viewer.
      ENDIF.

      OPEN DATASET file_name FOR INPUT
                   IN TEXT MODE ENCODING DEFAULT
                   .
      WHILE sy-subrc IS INITIAL.
        READ DATASET  file_name INTO line.
        IF NOT sy-subrc IS INITIAL.
          EXIT.
        ENDIF.
        APPEND line TO lt_data.
      ENDWHILE.
      CLOSE DATASET file_name.

      IF g_alv_popup IS INITIAL.
        CREATE OBJECT dialog_contnr
          EXPORTING
            top      = 80
            left     = 120
            lifetime = cntl_lifetime_dynpro
            caption  = 'File Viewer'(viw)
            width    = 1000
            height   = 300.

        CREATE OBJECT lo_text
          EXPORTING
            wordwrap_to_linebreak_mode = cl_gui_textedit=>true
            parent                     = dialog_contnr
          EXCEPTIONS
            error_cntl_create          = 1
            error_cntl_init            = 2
            error_cntl_link            = 3
            error_dp_create            = 4
            gui_type_not_supported     = 5
            OTHERS                     = 6.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        CREATE OBJECT l_event_receiver.
        SET HANDLER l_event_receiver->handle_close_popup
                    FOR dialog_contnr.

        CALL METHOD cl_gui_control=>set_focus
          EXPORTING
            control = lo_text.

        CALL METHOD lo_text->set_font_fixed
          EXCEPTIONS
            error_cntl_call_method = 1
            invalid_parameter      = 2
            OTHERS                 = 3.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        CALL METHOD lo_text->set_text_as_stream
          EXPORTING
            text            = lt_data
          EXCEPTIONS
            error_dp        = 1
            error_dp_create = 2
            OTHERS          = 3.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ENDIF.

    ENDMETHOD.                    "show_editor



*&---------------------------------------------------------------------*
*&      Method  show_html
*&---------------------------------------------------------------------*
    METHOD  show_html.

      DATA: line(256)         TYPE c,
            lt_data           TYPE STANDARD TABLE OF line,
            l_event_receiver  TYPE REF TO lcl_popup_evt_rcv,
            assigned_url(255) TYPE c
            .

      IF NOT g_alv_popup IS INITIAL.
        CALL METHOD g_alv_popup->free.
        CLEAR: g_alv_popup, g_html_viewer.
        FREE:  g_alv_popup, g_html_viewer.
      ENDIF.

      OPEN DATASET file_name FOR INPUT
                   IN TEXT MODE ENCODING DEFAULT
                   .
      WHILE sy-subrc IS INITIAL.
        READ DATASET  file_name INTO line.
        IF NOT sy-subrc IS INITIAL.
          EXIT.
        ENDIF.
        APPEND line TO lt_data.
      ENDWHILE.
      CLOSE DATASET file_name.

      IF g_html_viewer IS INITIAL.
        CREATE OBJECT dialog_contnr
          EXPORTING
            top      = 80
            left     = 120
            lifetime = cntl_lifetime_dynpro
            caption  = 'File Viewer'(viw)
            width    = 1000
            height   = 300.

        CREATE OBJECT g_html_viewer
          EXPORTING
            parent             = dialog_contnr
          EXCEPTIONS
            cntl_error         = 1
            cntl_install_error = 2
            dp_install_error   = 3
            dp_error           = 4.

        CALL METHOD g_html_viewer->load_data
          IMPORTING
            assigned_url         = assigned_url
          CHANGING
            data_table           = lt_data
          EXCEPTIONS
            dp_invalid_parameter = 1
            dp_error_general     = 2
            cntl_error           = 3
            OTHERS               = 4.

        CALL METHOD g_html_viewer->show_data
          EXPORTING
            url = assigned_url.

        CREATE OBJECT l_event_receiver.
        SET HANDLER l_event_receiver->handle_close_popup
                    FOR dialog_contnr.
      ENDIF.

    ENDMETHOD.                    "show_html



*&---------------------------------------------------------------------*
*&      Method  show_bin_file
*&---------------------------------------------------------------------*
    METHOD  show_bin_file.

      DATA: l_bin(1000)      TYPE x,
            lt_bin           LIKE TABLE OF l_bin,
            l_bin_size       TYPE i,
            l_event_receiver TYPE REF TO lcl_popup_evt_rcv,
            l_len            TYPE i,
            lv_file          TYPE rlgrap-filename,
            lv_ext           TYPE string,
            lv_sub           TYPE char10
            .
      IF NOT g_alv_popup IS INITIAL.
        CALL METHOD g_alv_popup->free.
        CLEAR: g_alv_popup, g_html_viewer.
        FREE:  g_alv_popup, g_html_viewer.
      ENDIF.

      CREATE OBJECT dialog_contnr
        EXPORTING
          top      = 80
          left     = 120
          lifetime = cntl_lifetime_dynpro
          caption  = 'File Viewer'(viw)
          width    = 900
          height   = 300.
      CREATE OBJECT g_html_viewer
        EXPORTING
          parent             = dialog_contnr
        EXCEPTIONS
          cntl_error         = 1
          cntl_install_error = 2
          dp_install_error   = 3
          dp_error           = 4
          OTHERS             = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD cl_gui_cfw=>flush
        EXCEPTIONS
          cntl_system_error = 1
          cntl_error        = 2.

      CREATE OBJECT l_event_receiver.
      SET HANDLER l_event_receiver->handle_close_popup
                  FOR dialog_contnr.

      CALL METHOD cl_gui_control=>set_focus
        EXPORTING
          control = g_html_viewer.

      OPEN DATASET file_name FOR INPUT
                   IN BINARY MODE
                   .
      WHILE sy-subrc IS INITIAL.
        READ DATASET file_name  INTO l_bin.
        IF NOT sy-subrc IS INITIAL.
          EXIT.
        ENDIF.

        l_len = xstrlen( l_bin ).
        APPEND l_bin TO lt_bin.
        ADD l_len TO l_bin_size.
      ENDWHILE.

      CLOSE DATASET file_name.

      lv_file = file_name.
      PERFORM get_file_ext USING    lv_file
                           CHANGING lv_ext
                           .
      lv_sub = lv_ext.
      CALL METHOD g_html_viewer->load_data
        EXPORTING
          size                 = l_bin_size
          type                 = 'application'
          subtype              = lv_sub
        IMPORTING
          assigned_url         = g_url
        CHANGING
          data_table           = lt_bin
        EXCEPTIONS
          dp_invalid_parameter = 1
          dp_error_general     = 2
          cntl_error           = 3
          OTHERS               = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD g_html_viewer->show_url
        EXPORTING
          url                    = g_url
        EXCEPTIONS
          cntl_error             = 1
          cnht_error_not_allowed = 2
          cnht_error_parameter   = 3
          dp_error_general       = 4
          OTHERS                 = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDMETHOD.                    "show_bin_file




*&---------------------------------------------------------------------*
*&      METHOD  rename_file
*&---------------------------------------------------------------------*
    METHOD  rename_file.

      DATA: lv_phyfile    TYPE rlgrap-filename,
            lv_new_path   TYPE rlgrap-filename,
            lv_ans        TYPE c,
            lv_file_from  TYPE string,
            lv_file_to    TYPE string,
            lt_err        TYPE STANDARD TABLE OF btcxpm,
            wa_err        TYPE btcxpm,
            lv_add_param  TYPE btcxpgpar,
            lt_fields     TYPE STANDARD TABLE OF sval,
            lv_str        TYPE string,
            lv_len        TYPE i,
            lt_data       TYPE STANDARD TABLE OF string,
            lv_file_len   TYPE i,
            lv_strx(1000) TYPE x,
            lt_datax      LIKE TABLE OF lv_strx
            .
      FIELD-SYMBOLS: <table> TYPE STANDARD TABLE,
                     <field> TYPE sval
                     .

      lv_file_from = file_name.
      CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
        EXPORTING
          full_name     = file_name
        IMPORTING
          stripped_name = lv_phyfile
          file_path     = lv_new_path
        EXCEPTIONS
          x_error       = 0
          OTHERS        = 0.

      APPEND INITIAL LINE TO lt_fields ASSIGNING <field>.
      <field>-fieldname = 'FILENAME'.
      <field>-tabname   = 'RLGRAP'.
      <field>-value     = lv_phyfile.

      CALL FUNCTION 'POPUP_GET_VALUES'
        EXPORTING
          popup_title     = 'File Rename'(ren)
        IMPORTING
          returncode      = lv_ans
        TABLES
          fields          = lt_fields
        EXCEPTIONS
          error_in_fields = 0
          OTHERS          = 0.
      CHECK lv_ans <> 'C'.

      IF <field>-value+0(1) = space.
        MESSAGE i398(00) WITH
        'Space is not allowed a position 1 of a file name'(ms7)
        '' '' ''.
        EXIT.
      ENDIF.

*     build the rename string according to the OP System
      CONCATENATE lv_new_path
                  gv_delimiter
                  <field>-value
                  INTO lv_file_to
                  .
      CONCATENATE lv_file_from
                  lv_file_to
                  INTO lv_str
                  SEPARATED BY space
                  .
*     The parameter is up to 255 char. If longer move the file via SAP (just takes longer)
      lv_len = strlen( lv_str ).
      IF lv_len <= 255.
        lv_add_param = lv_str.
        CALL FUNCTION 'SXPG_CALL_SYSTEM'
          EXPORTING
            commandname                = gc_sxpg_rename
            additional_parameters      = lv_add_param
          TABLES
            exec_protocol              = lt_err
          EXCEPTIONS
            no_permission              = 1
            command_not_found          = 2
            parameters_too_long        = 3
            security_risk              = 4
            wrong_check_call_interface = 5
            program_start_error        = 6
            program_termination_error  = 7
            x_error                    = 8
            parameter_expected         = 9
            too_many_parameters        = 10
            illegal_command            = 11
            OTHERS                     = 12.
        IF NOT sy-subrc IS INITIAL.
          MESSAGE e101(lvc) WITH gc_sxpg_rename.
        ELSE.
          LOOP AT lt_err INTO wa_err.
            MESSAGE i398(00) WITH wa_err-message '' '' ''.
          ENDLOOP.
        ENDIF.
      ELSE.

        lv_phyfile = lv_file_from.
        PERFORM get_transfer_mode USING lv_phyfile.
*       Read File
        CASE trans_mode.
          WHEN gc_ascii.
            ASSIGN lt_data TO <table>.
            OPEN DATASET lv_file_from FOR INPUT IN TEXT MODE
                         ENCODING DEFAULT IGNORING CONVERSION ERRORS.
            IF sy-subrc IS NOT INITIAL.
              MESSAGE e008(cq99).
*             File open error
            ENDIF.
            WHILE sy-subrc IS INITIAL.
              READ DATASET lv_file_from INTO lv_str.
              IF NOT sy-subrc IS INITIAL.
                EXIT.
              ENDIF.
              lv_len = strlen( lv_str ).
              ADD lv_len TO lv_file_len.
              APPEND lv_str TO <table>.
            ENDWHILE.

          WHEN gc_binary.
            OPEN DATASET lv_file_from FOR INPUT IN BINARY MODE.
            IF sy-subrc IS NOT INITIAL.
              MESSAGE e008(cq99).
*             File open error
            ENDIF.
            ASSIGN lt_datax TO <table>.
            WHILE sy-subrc IS INITIAL.
              READ DATASET lv_file_from INTO lv_strx.
              IF NOT sy-subrc IS INITIAL.
                EXIT.
              ENDIF.
              lv_len = xstrlen( lv_strx ).
              ADD lv_len TO lv_file_len.
              APPEND lv_strx TO <table>.
            ENDWHILE.
        ENDCASE.
        CLOSE DATASET lv_file_from.

*       Write File
        CASE trans_mode.
          WHEN gc_ascii.
            OPEN DATASET lv_file_to FOR OUTPUT
                         IN TEXT MODE ENCODING DEFAULT.
            IF sy-subrc IS NOT INITIAL.
              MESSAGE s117(lx) WITH lv_file_to.
              EXIT.
            ENDIF.
            LOOP AT <table> INTO lv_str.
              TRANSFER lv_str TO lv_file_to.
            ENDLOOP.

          WHEN gc_binary.
            OPEN DATASET lv_file_to FOR OUTPUT IN BINARY MODE.
            IF sy-subrc IS NOT INITIAL.
              MESSAGE s117(lx) WITH lv_file_to.
              EXIT.
            ENDIF.
            LOOP AT <table> INTO lv_strx.
              IF lv_file_len > 1000.
                lv_len = 1000.
                lv_file_len = lv_file_len - 1000.
              ELSE.
                lv_len = lv_file_len.
              ENDIF.
              TRANSFER lv_strx TO lv_file_to  LENGTH lv_len.
            ENDLOOP.
        ENDCASE.

        CLOSE DATASET lv_file_to.

*       Delete original file
        DELETE DATASET lv_file_from.

      ENDIF.
      PERFORM update_dir_files USING 'X' ''.

    ENDMETHOD.                    " rename_file



*&---------------------------------------------------------------------*
*&      METHOD  download_file
*&---------------------------------------------------------------------*
    METHOD download_file.

      PERFORM download_file USING file_name ''.

    ENDMETHOD.                    " download_file



*&---------------------------------------------------------------------*
*&      METHOD  copy
*&---------------------------------------------------------------------*
    METHOD copy.

      DATA: gv_rc        TYPE i,
            gt_clip_data TYPE STANDARD TABLE OF file_name   "#EC NEEDED
            .
      IF gv_last_file IS NOT INITIAL.
        APPEND gv_last_file TO gt_clip_data.
      ELSE.
        APPEND gv_last_dir_server TO gt_clip_data.
      ENDIF.
      CALL METHOD cl_gui_frontend_services=>clipboard_export
        IMPORTING
          data         = gt_clip_data
        CHANGING
          rc           = gv_rc
        EXCEPTIONS
          cntl_error   = 1
          error_no_gui = 2
          OTHERS       = 3.
      IF sy-subrc <> 0.
        MESSAGE s829(ed).
*       Error when copying to clipboard
      ELSE.
        MESSAGE s005(lxe_se63).
*       Data was copied to clipboard
      ENDIF.

    ENDMETHOD.                    " copy

*&---------------------------------------------------------------------*
*&      Method  show_file
*&---------------------------------------------------------------------*
    METHOD  show_file.

      TYPES: BEGIN OF tp_size,
               len TYPE i,
             END OF tp_size,
             tp_size_tbl TYPE STANDARD TABLE OF tp_size.

      DATA: lt_file             TYPE STANDARD TABLE OF string,
            wa_file             TYPE text1000,
            ls_fcat             TYPE lvc_s_fcat,
            lv_len              TYPE i,
            lv_max_len          TYPE i,
            lv_tabix(2)         TYPE n,
            eof                 TYPE c,
            lv_str              TYPE string,
            auth_check_filename TYPE authb-filename,
            lv_ans              TYPE c,
            lv_column(4)        TYPE c,
            lv_exit             TYPE c,
            l_event_receiver    TYPE REF TO lcl_popup_evt_rcv,
            new_table           TYPE REF TO data,
            new_line            TYPE REF TO data,
            lt_size             TYPE tp_size_tbl,
            wa_size             TYPE tp_size,
            lt_fcat             TYPE lvc_t_fcat
            .

      TYPES: BEGIN OF itab_type,
               word(200) TYPE c,
             END   OF itab_type.

      DATA: itab TYPE STANDARD TABLE OF itab_type
                      WITH NON-UNIQUE DEFAULT KEY
                      .

      FIELD-SYMBOLS: <wa>     TYPE string,
                     <field>  TYPE any,
                     <data>   TYPE itab_type,
                     <dlimit> TYPE any
                     .

      IF NOT delimiter IS INITIAL.
        ASSIGN delimiter TO <dlimit>.
      ELSEIF regular = 'X'.
        ASSIGN space TO <dlimit>.
      ELSEIF tabbed = 'X'.
*        ASSIGN lc_tab_delimiter TO <dlimit>.
        ASSIGN cl_abap_char_utilities=>horizontal_tab TO <dlimit>.
      ENDIF.

      IF NOT g_alv_popup IS INITIAL.
        CALL METHOD g_alv_popup->free.
        CLEAR: g_alv_popup, g_html_viewer, lt_fcat.
        FREE:  g_alv_popup, g_html_viewer.
        UNASSIGN: <line>, <table>.
      ENDIF.

*     here we have to do an authority check,
*     because OPEN_DATASET raises a ABAP-DUMP
*     in case of no authorization
      auth_check_filename = file_name.
      CALL FUNCTION 'AUTHORITY_CHECK_DATASET'
        EXPORTING
          activity         = 'READ'
          filename         = auth_check_filename
        EXCEPTIONS
          no_authority     = 1
          activity_unknown = 2
          OTHERS           = 3.

      IF sy-subrc = 1.
        MESSAGE e149(00) WITH file_name.
      ENDIF.

      OPEN DATASET file_name FOR INPUT IN TEXT MODE ENCODING DEFAULT
                   IGNORING CONVERSION ERRORS.

      IF sy-subrc <> 0.
        MESSAGE s106(26) WITH file_name.
        EXIT.
      ENDIF.

      WHILE  eof  IS  INITIAL.
        READ DATASET  file_name  INTO wa_file.
        IF  sy-subrc  NE  0.
          eof = 'X'.
          EXIT.
        ENDIF.
        lv_len = strlen( wa_file ).
        IF lv_len > ls_fcat-intlen.
          ls_fcat-intlen = lv_len.
        ENDIF.
        APPEND wa_file TO lt_file.
        CLEAR wa_file.
      ENDWHILE.
      CLOSE DATASET file_name.

      CASE <dlimit>.
        WHEN space.
*         only one column in the ALV
          ls_fcat-fieldname = 'TEXT'.
          ls_fcat-datatype  = 'CHAR'.
          ls_fcat-inttype   = 'C'.
          ls_fcat-scrtext_l = ls_fcat-scrtext_m =
          ls_fcat-scrtext_s = ls_fcat-tooltip   = 'File Text'.
*         ls_fcat-emphasize = 'C311'.
          APPEND ls_fcat TO lt_fcat.

        WHEN gc_use_columns.
*         get the column markers
          WHILE lv_ans IS INITIAL.
            CLEAR: lv_exit.
            CALL FUNCTION 'POPUP_TO_GET_VALUE'              "#EC *
              EXPORTING
                fieldname           = 'COLCT'
                tabname             = 'RCCSCP01'
                titel               = 'Please enter Column Marker'(t06)
                valuein             = lv_column
              IMPORTING
                answer              = lv_ans
                valueout            = lv_column
              EXCEPTIONS
                fieldname_not_found = 1
                OTHERS              = 2.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.
            CHECK lv_ans <> 'C'.
            IF lv_column = '0' OR lv_column IS INITIAL.
              MESSAGE i398(00) WITH
              'Enter number > 0 or press Cancel to continue'(ms2)
                                    '' '' ''.
              MESSAGE s633(f4) WITH lv_str.
              CONTINUE.
            ENDIF.
            IF NOT lv_column CA '0123456789'.
              MESSAGE i398(00) WITH
              'Enter only numbers or press Cancel to continue'(ms3)
                                    '' '' ''.
              MESSAGE s633(f4) WITH lv_str.
              CONTINUE.
            ENDIF.

            LOOP AT lt_size INTO wa_size.
              IF lv_column < wa_size-len.
                MESSAGE i398(00) WITH
                'Enter a bigger than'(big) wa_size-len  'or press Cancel to continue'(can) ''.
                MESSAGE s633(f4) WITH lv_str.
                lv_exit = 'X'.
                EXIT.
              ENDIF.
            ENDLOOP.
            CHECK lv_exit IS INITIAL.

            wa_size-len = lv_column.
            APPEND wa_size TO lt_size.
            IF lv_str IS INITIAL.
              lv_str = lv_column.
            ELSE.
              CONCATENATE lv_str
                          lv_column
                          INTO lv_str
                          SEPARATED BY ','.
            ENDIF.
            MESSAGE s633(f4) WITH lv_str.
          ENDWHILE.

*         after the parsing is done, build the fcat for presentation
          LOOP AT lt_size INTO wa_size.
            lv_tabix = sy-tabix.
            CONCATENATE 'COLUMN'
                        lv_tabix
                        INTO ls_fcat-fieldname.
            ls_fcat-datatype  = 'CHAR'.
            ls_fcat-inttype   = 'C'.
            IF sy-tabix = 1.
              ls_fcat-intlen = wa_size-len.
            ELSE.
              ls_fcat-intlen = wa_size-len - ls_fcat-intlen.
            ENDIF.

            CONCATENATE 'Column'
                        lv_tabix
                        INTO ls_fcat-scrtext_l
                        SEPARATED BY space
                        .
            ls_fcat-scrtext_m = ls_fcat-scrtext_s =
            ls_fcat-tooltip   = ls_fcat-scrtext_l.
            APPEND ls_fcat TO lt_fcat.
          ENDLOOP.

*         find the maximumlength and add last column
          LOOP AT lt_file INTO wa_file.
            lv_len = strlen( wa_file ).
            IF lv_max_len < lv_len.
              lv_max_len = lv_len.
            ENDIF.
          ENDLOOP.
          IF ls_fcat-intlen < lv_max_len.
            ADD 1 TO lv_tabix.
            CONCATENATE 'COLUMN'
                        lv_tabix
                        INTO ls_fcat-fieldname.
            ls_fcat-datatype  = 'CHAR'.
            ls_fcat-inttype   = 'C'.
            ls_fcat-intlen = lv_max_len - ls_fcat-intlen.
            CONCATENATE 'Column'
                        lv_tabix
                        INTO ls_fcat-scrtext_l
                        SEPARATED BY space
                        .
            ls_fcat-scrtext_m = ls_fcat-scrtext_s =
            ls_fcat-tooltip   = ls_fcat-scrtext_l.
            APPEND ls_fcat TO lt_fcat.
          ENDIF.

        WHEN OTHERS.
          lv_str = <dlimit>.
*         build all the columns in the table
          LOOP AT lt_file INTO wa_file.
            REFRESH: itab.
            SPLIT wa_file AT lv_str INTO TABLE itab.

            LOOP AT itab ASSIGNING <data>.
              lv_tabix = sy-tabix.
              CONCATENATE 'COLUMN'
                          lv_tabix
                          INTO ls_fcat-fieldname.
              lv_len  = strlen( <data>-word ).
              READ TABLE lt_size INTO wa_size INDEX lv_tabix.
              IF sy-subrc IS INITIAL.
                IF wa_size-len < lv_len.
                  wa_size-len = lv_len.
                  MODIFY lt_size FROM wa_size INDEX lv_tabix.
                ENDIF.
              ELSE.
                wa_size-len = lv_len.
                APPEND wa_size TO lt_size.
              ENDIF.
            ENDLOOP.
          ENDLOOP.

          LOOP AT lt_size INTO wa_size.
            lv_tabix = sy-tabix.
            CONCATENATE 'COLUMN'
                        lv_tabix
                        INTO ls_fcat-fieldname.
            ls_fcat-datatype  = 'CHAR'.
            ls_fcat-inttype   = 'C'.
            ls_fcat-intlen    = wa_size-len.

            CONCATENATE 'Column'
                        lv_tabix
                        INTO ls_fcat-scrtext_l
                        SEPARATED BY space
                        .
            ls_fcat-scrtext_m = ls_fcat-scrtext_s =
            ls_fcat-tooltip   = ls_fcat-scrtext_l.
            APPEND ls_fcat TO lt_fcat.
          ENDLOOP.

      ENDCASE.

*     add a line for coloring
      ls_fcat-fieldname = gc_line_color.
      ls_fcat-datatype  = 'CHAR'.
      ls_fcat-intlen    = 4.
      ls_fcat-inttype   = 'C'.
      ls_fcat-scrtext_l = ls_fcat-scrtext_m =
      ls_fcat-scrtext_s = ls_fcat-tooltip   = 'Color'.
      APPEND ls_fcat TO lt_fcat.

      gs_layo_seg-info_fname = gc_line_color.

*     create dynamic data table
      CALL METHOD cl_alv_table_create=>create_dynamic_table
        EXPORTING
          it_fieldcatalog = lt_fcat
        IMPORTING
          ep_table        = new_table.

*     Create a new Line with the same structure of the table.
      ASSIGN new_table->* TO <table>.
      CREATE DATA new_line LIKE LINE OF <table>.
      ASSIGN new_line->* TO <line>.

      LOOP AT lt_file ASSIGNING <wa>.
        CASE <dlimit>.
          WHEN space OR gc_use_columns.
            <line> = <wa>.
          WHEN OTHERS.
            lv_str = <dlimit>.
            REFRESH itab.
            CLEAR <line>.
*           build all the columns in the table
            SPLIT <wa> AT lv_str INTO TABLE itab.

            LOOP AT itab ASSIGNING <data>.
              lv_tabix = sy-tabix.
              CONCATENATE 'COLUMN'
                          lv_tabix
                          INTO lv_str.
              ASSIGN COMPONENT lv_str OF STRUCTURE <line> TO <field>.
              <field> = <data>-word.
            ENDLOOP.
        ENDCASE.


*       add some color to the table
        CASE <line>+0(1).
          WHEN 'H'.
*           header line
            ASSIGN COMPONENT gc_line_color OF STRUCTURE <line> TO <field>.
            <field> = 'C311'.
          WHEN 'C'.
*           Control line
            ASSIGN COMPONENT gc_line_color OF STRUCTURE <line> TO <field>.
            <field> = 'C511'.
        ENDCASE.

        APPEND <line> TO <table>.

      ENDLOOP.
      gs_layo_seg-grid_title = file_name.

      IF g_alv_popup IS INITIAL.
        CREATE OBJECT dialog_contnr
          EXPORTING
            top      = 80
            left     = 120
            lifetime = cntl_lifetime_dynpro
            caption  = 'View File'(viw)
            width    = 900
            height   = 300.
        CREATE OBJECT g_alv_popup
          EXPORTING
            i_parent = dialog_contnr.
        CREATE OBJECT l_event_receiver.
        SET HANDLER l_event_receiver->handle_close_popup
                    FOR dialog_contnr.
        SET HANDLER l_event_receiver->handle_dbl_click_data
                    FOR g_alv_popup.

        CALL METHOD g_alv_popup->set_table_for_first_display
          EXPORTING
            is_layout                     = gs_layo_seg
          CHANGING
            it_outtab                     = <table>
            it_fieldcatalog               = lt_fcat
          EXCEPTIONS
            invalid_parameter_combination = 0
            program_error                 = 0
            too_many_lines                = 0
            OTHERS                        = 0.

        CALL METHOD cl_gui_control=>set_focus
          EXPORTING
            control = g_alv_popup.
      ELSE.
        CALL METHOD g_alv_popup->refresh_table_display.
        CALL METHOD g_alv_popup->set_frontend_layout
          EXPORTING
            is_layout = gs_layo_seg.
        CALL METHOD dialog_contnr->set_visible
          EXPORTING
            visible = 'X'.
      ENDIF.

    ENDMETHOD.                    " show_file


  ENDCLASS.                    "lcl_grid_evt_rcv IMPLEMENTATION



*---------------------------------------------------------------------*
*    CLASS lcl_dnd_evt_rcv    IMPLEMENTATION
*---------------------------------------------------------------------*
  CLASS lcl_dnd_evt_rcv IMPLEMENTATION.

*---------------------------------------------------------------------*
*    METHOD handle_alv_drag IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_alv_drag.

      DATA: dataobj   TYPE REF TO lcl_dragdropobj,
            ls_layout TYPE lvc_s_layo.

      FIELD-SYMBOLS: <dir_t> TYPE STANDARD TABLE,
                     <dir>   TYPE tp_al11
                     .

      CALL METHOD sender->get_frontend_layout
        IMPORTING
          es_layout = ls_layout.

      CREATE OBJECT dataobj.

      ASSIGN (ls_layout-countfname) TO <dir_t>.

      READ TABLE <dir_t> INDEX e_row-index ASSIGNING <dir>.
      dataobj->full_path = <dir>-full_path.
      dataobj->name      = <dir>-name.
      dataobj->index     = sy-tabix.
      IF ls_layout-countfname = 'GT_DIR_LOCAL'.
        dataobj->upload = 'X'.
      ENDIF.

      e_dragdropobj->object = dataobj.
    ENDMETHOD.                    "handle_alv_drag



*---------------------------------------------------------------------*
*    METHOD handle_line_drop_server           IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_line_drop_server.

      DATA: dataobj       TYPE REF TO lcl_dragdropobj,
            lv_file_to    TYPE string,
            ls_layout     TYPE lvc_s_layn,
            lv_ans        TYPE c,
            lv_add_param  TYPE btcxpgpar,
            lt_err        TYPE STANDARD TABLE OF btcxpm,
            wa_err        TYPE btcxpm,
            lv_question   TYPE string,
            lv_subrc      LIKE sy-subrc,
            wa_dir        TYPE tp_al11,
            lv_dest       TYPE string,
            lv_str        TYPE string,
            lv_len        TYPE i,
            lv_phyfile    TYPE rlgrap-filename,
            lt_data       TYPE STANDARD TABLE OF string,
            lv_file_len   TYPE i,
            lv_strx(1000) TYPE x,
            lt_datax      LIKE TABLE OF lv_strx
            .
      FIELD-SYMBOLS: <table> TYPE STANDARD TABLE.

      CALL METHOD sender->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
          es_node_layout = ls_layout.

      CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
        dataobj ?= drag_drop_object->object.

        IF dataobj->upload IS INITIAL.
*       This is a move between folders.

*       Check authority
          AUTHORITY-CHECK OBJECT 'S_LOG_COM'
                   ID 'COMMAND'  FIELD gc_sxpg_rename
                   ID 'OPSYSTEM' FIELD sy-opsys
                   ID 'HOST'     FIELD sy-sysid
                   .
          IF sy-subrc <> 0.
            MESSAGE e344(42).
          ENDIF.

          CASE ls_layout-n_image.

            WHEN gc_icon_folder_close OR gc_icon_folder_open.

              CONCATENATE 'Are you sure you want to move the file:'(q01)
                          dataobj->name
                          INTO lv_question
                          SEPARATED BY space
                          .
              IF drag_drop_object->effect = cl_dragdrop=>move.
                CALL FUNCTION 'POPUP_TO_CONFIRM'
                  EXPORTING
                    titlebar              = 'File Move Confirmation'(t01)
                    text_question         = lv_question
                    text_button_1         = 'Yes'(yes)
                    text_button_2         = 'No'(nop)
                    default_button        = '2'
                    display_cancel_button = space
                  IMPORTING
                    answer                = lv_ans
                  EXCEPTIONS
                    text_not_found        = 0
                    OTHERS                = 0.

                CHECK lv_ans = '1'.
              ENDIF.

*             Build 'to' file name
              CONCATENATE wa_dir-full_path "gv_last_dir_server
*                          gv_delimiter
*                          ls_node_text
                          gv_delimiter
                          dataobj->name
                          INTO lv_file_to
                          .

*             Build the rename string according to the OP System
              CONCATENATE dataobj->full_path
                          lv_file_to
                          INTO lv_str
                          SEPARATED BY space
                          .

*             The parameter is up to 255 char. If longer move the file via SAP (just takes longer)
              lv_len = strlen( lv_str ).
              IF lv_len <= 255.
                lv_add_param = lv_str.
                CALL FUNCTION 'SXPG_CALL_SYSTEM'
                  EXPORTING
                    commandname                = gc_sxpg_rename
                    additional_parameters      = lv_add_param
                  TABLES
                    exec_protocol              = lt_err
                  EXCEPTIONS
                    no_permission              = 1
                    command_not_found          = 2
                    parameters_too_long        = 3
                    security_risk              = 4
                    wrong_check_call_interface = 5
                    program_start_error        = 6
                    program_termination_error  = 7
                    x_error                    = 8
                    parameter_expected         = 9
                    too_many_parameters        = 10
                    illegal_command            = 11
                    OTHERS                     = 12.
                IF NOT sy-subrc IS INITIAL.
                  MESSAGE e101(lvc) WITH gc_sxpg_rename.
                ELSE.
                  LOOP AT lt_err INTO wa_err.
                    MESSAGE i398(00) WITH wa_err-message '' '' ''.
                  ENDLOOP.
                ENDIF.
              ELSE.

                lv_phyfile = dataobj->full_path.
                PERFORM get_transfer_mode USING lv_phyfile.
*               Read File
                CASE trans_mode.
                  WHEN gc_ascii.
                    ASSIGN lt_data TO <table>.
                    OPEN DATASET dataobj->full_path FOR INPUT IN TEXT MODE
                                 ENCODING DEFAULT IGNORING CONVERSION ERRORS.
                    IF sy-subrc IS NOT INITIAL.
                      MESSAGE e008(cq99).
*                   File open error
                    ENDIF.
                    WHILE sy-subrc IS INITIAL.
                      READ DATASET dataobj->full_path INTO lv_str.
                      IF NOT sy-subrc IS INITIAL.
                        EXIT.
                      ENDIF.
                      lv_len = strlen( lv_str ).
                      ADD lv_len TO lv_file_len.
                      APPEND lv_str TO <table>.
                    ENDWHILE.

                  WHEN gc_binary.
                    OPEN DATASET dataobj->full_path FOR INPUT IN BINARY MODE.
                    IF sy-subrc IS NOT INITIAL.
                      MESSAGE e008(cq99).
*                     File open error
                    ENDIF.
                    ASSIGN lt_datax TO <table>.
                    WHILE sy-subrc IS INITIAL.
                      READ DATASET dataobj->full_path INTO lv_strx.
                      IF NOT sy-subrc IS INITIAL.
                        EXIT.
                      ENDIF.
                      lv_len = xstrlen( lv_strx ).
                      ADD lv_len TO lv_file_len.
                      APPEND lv_strx TO <table>.
                    ENDWHILE.
                ENDCASE.
                CLOSE DATASET dataobj->full_path.

*               Write File
                CASE trans_mode.
                  WHEN gc_ascii.
                    OPEN DATASET lv_file_to FOR OUTPUT
                                 IN TEXT MODE ENCODING DEFAULT.
                    IF sy-subrc IS NOT INITIAL.
                      MESSAGE s117(lx) WITH lv_file_to.
                      EXIT.
                    ENDIF.
                    LOOP AT <table> INTO lv_str.
                      TRANSFER lv_str TO lv_file_to.
                    ENDLOOP.

                  WHEN gc_binary.
                    OPEN DATASET lv_file_to FOR OUTPUT IN BINARY MODE.
                    IF sy-subrc IS NOT INITIAL.
                      MESSAGE s117(lx) WITH lv_file_to.
                      EXIT.
                    ENDIF.
                    LOOP AT <table> INTO lv_strx.
                      IF lv_file_len > 1000.
                        lv_len = 1000.
                        lv_file_len = lv_file_len - 1000.
                      ELSE.
                        lv_len = lv_file_len.
                      ENDIF.
                      TRANSFER lv_strx TO lv_file_to  LENGTH lv_len.
                    ENDLOOP.
                ENDCASE.

                CLOSE DATASET lv_file_to.

*               Delete original file
                DELETE DATASET dataobj->full_path.

              ENDIF.
*             Delete file from ALV Grid
              DELETE gt_dir_server INDEX dataobj->index.
              IF sy-subrc EQ 0.
                CALL METHOD g_alv_grid_server->refresh_table_display.
              ENDIF.
          ENDCASE.
        ELSE.
*         This is an upload file
          CONCATENATE wa_dir-full_path gv_delimiter
                      dataobj->name
                      INTO lv_dest.
          gv_last_dir_server = wa_dir-full_path.

          PERFORM upload_file USING dataobj->full_path
                                    lv_dest
                                    .

**         Refresh the current dir
*          CALL METHOD handle_select_server
*            EXPORTING
*              node_key = node_key.

        ENDIF.

      ENDCATCH.
      IF lv_subrc <> 0.
        CALL METHOD drag_drop_object->abort.
      ENDIF.

    ENDMETHOD.                    "handle_line_drop_server



*---------------------------------------------------------------------*
*    METHOD handle_line_drop_local           IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_line_drop_local.

      DATA: dataobj      TYPE REF TO lcl_dragdropobj,
            lv_file_from TYPE string,
            lv_file_to   TYPE string,
            lv_subrc     LIKE sy-subrc,
            wa_dir       TYPE tp_al11
            .
      CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
        dataobj ?= drag_drop_object->object.

        CHECK dataobj->upload IS INITIAL.
*       Do not download a file from the local folders
        CALL METHOD sender->get_outtab_line
          EXPORTING
            i_node_key    = node_key
          IMPORTING
            e_outtab_line = wa_dir.

*       Build 'to' file name
        CONCATENATE gv_last_dir_server
                    gv_delimiter
                    dataobj->name
                    INTO lv_file_from
                    .
        CONCATENATE wa_dir-full_path
                    gv_delimiter_local
                    dataobj->name
                    INTO lv_file_to
                    .
        PERFORM download_file USING lv_file_from
                                    lv_file_to
                                    .
      ENDCATCH.
      IF lv_subrc <> 0.
        CALL METHOD drag_drop_object->abort.
      ENDIF.

    ENDMETHOD.                    "handle_line_drop_local

  ENDCLASS.                    "lcl_dnd_evt_rcv IMPLEMENTATION




*---------------------------------------------------------------------*
*       CLASS lcl_popup_evt_rcv     IMPLEMENTATION
*---------------------------------------------------------------------*
  CLASS lcl_popup_evt_rcv IMPLEMENTATION.


*---------------------------------------------------------------------*
*    METHOD handle_close_popup                IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_close_popup.
      CALL METHOD sender->set_visible
        EXPORTING
          visible = space.
      FREE g_html_viewer.

    ENDMETHOD.                    "handle_close_popup



*---------------------------------------------------------------------*
*    METHOD handle_dbl_click_data            IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_dbl_click_data.

      TYPES: BEGIN OF tp_data,
               line    LIKE sy-tabix,
               data(1) TYPE c,
             END OF tp_data.

      DATA: lv_len    TYPE i,
            lt_data   TYPE STANDARD TABLE OF tp_data,
            wa_data   TYPE tp_data,
            ls_layout TYPE slis_layout_alv,
            lt_fcat   TYPE slis_t_fieldcat_alv,
            ls_fcat   TYPE slis_fieldcat_alv
            .


      READ TABLE <table> ASSIGNING <line> INDEX e_row.
      lv_len = strlen( <line> ).

      DO lv_len TIMES.
        lv_len = sy-index - 1.
        wa_data-line = sy-index.
        wa_data-data = <line>+lv_len(1).
        APPEND wa_data TO lt_data.
      ENDDO.

      ls_fcat-col_pos       = 1.
      ls_fcat-fieldname     = 'LINE'.
      ls_fcat-ref_fieldname = 'TABIX'.
      ls_fcat-ref_tabname   = 'SYST'.
      APPEND ls_fcat TO lt_fcat.

      ls_fcat-col_pos   = 2.
      ls_fcat-fieldname = 'DATA'.
      ls_fcat-outputlen = 1.
      ls_fcat-datatype  = 'CHAR'.
      ls_fcat-inttype   = 'C'.
      ls_fcat-intlen    = 1.
      ls_fcat-seltext_l = ls_fcat-seltext_s = ls_fcat-seltext_m = 'Data'.
      APPEND ls_fcat TO lt_fcat.


      ls_layout-window_titlebar   = 'File Parser'(t03).
      ls_layout-zebra             = 'X'.
      ls_layout-no_input          = 'X'.
      ls_layout-colwidth_optimize = 'X'.
      ls_layout-no_subtotals      = 'X'.
      ls_layout-no_sumchoice      = 'X'.
      ls_layout-no_subchoice      = 'X'.
      ls_layout-no_totalline      = 'X'.
      ls_layout-no_unit_splitting = 'X'.

      CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
        EXPORTING
          is_layout             = ls_layout
          it_fieldcat           = lt_fcat
          i_screen_start_column = 10
          i_screen_start_line   = 1
          i_screen_end_column   = 30
          i_screen_end_line     = 25
        TABLES
          t_outtab              = lt_data
        EXCEPTIONS
          program_error         = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDMETHOD.                    "handle_dbl_click_data


  ENDCLASS.                    "lcl_popup_evt_rcv IMPLEMENTATION




*---------------------------------------------------------------------*
*       CLASS lcl_tree_evt_rcv       IMPLEMENTATION
*---------------------------------------------------------------------*
  CLASS lcl_tree_evt_rcv IMPLEMENTATION.

*---------------------------------------------------------------------*
*    METHOD handle_node_cm_req_server            IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_node_cm_req_server.

      CALL METHOD handle_cm_req
        EXPORTING
          server   = 'X'
          node_key = node_key
          menu     = menu.

    ENDMETHOD.                    "handle_node_cm_req_server


*---------------------------------------------------------------------*
*    METHOD handle_node_cm_req_local            IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_node_cm_req_local.

      CALL METHOD handle_cm_req
        EXPORTING
          server   = ''
          node_key = node_key
          menu     = menu.

    ENDMETHOD.                    "handle_node_cm_req_local



*---------------------------------------------------------------------*
*    METHOD handle_node_cm_sel_server            IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_node_cm_sel_server.

      CALL METHOD handle_cm_sel
        EXPORTING
          server   = 'X'
          node_key = node_key
          fcode    = fcode.

    ENDMETHOD.                    "handle_node_cm_sel_server



*---------------------------------------------------------------------*
*    METHOD handle_node_cm_sel_local            IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_node_cm_sel_local.

      CALL METHOD handle_cm_sel
        EXPORTING
          server   = ''
          node_key = node_key
          fcode    = fcode.

    ENDMETHOD.                    "handle_node_cm_sel_server

*---------------------------------------------------------------------*
*    METHOD handle_expand_node_nc_server        IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_expand_node_nc_server.

      DATA: lv_last_dir TYPE string,
            wa_dir      TYPE tp_al11
            .
      CALL METHOD g_tree_server->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.

      lv_last_dir = wa_dir-full_path.
      PERFORM create_hier_server USING lv_last_dir
                                       node_key
                                       .
    ENDMETHOD.                    "handle_expand_node_nc_server


*---------------------------------------------------------------------*
*    METHOD handle_expand_node_nc_local        IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD handle_expand_node_nc_local.

      DATA: lv_last_dir TYPE string,
            wa_dir      TYPE tp_al11
            .
      CALL METHOD g_tree_local->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.

      lv_last_dir = wa_dir-full_path.
      PERFORM create_hier_local USING lv_last_dir
                                       node_key
                                       .
    ENDMETHOD.                    "handle_expand_node_nc_local



*&---------------------------------------------------------------------*
*&      METHOD  upload_file
*&---------------------------------------------------------------------*
    METHOD upload_file.

      DATA: wa_dir TYPE tp_al11.

      CALL METHOD g_tree_server->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.
      gv_last_file = wa_dir-full_path.

      PERFORM upload_file USING '' ''.

*     Refresh the current dir
      CALL METHOD handle_select_server
        EXPORTING
          node_key = node_key.

    ENDMETHOD.                    " upload_file



*&---------------------------------------------------------------------*
*&      method  add_to_fav
*&---------------------------------------------------------------------*
    METHOD add_to_fav.

      DATA: wa_dir   TYPE tp_al11,
            lv_name  TYPE rvari_vnam,
            lv_path  TYPE string,
            lv_key   TYPE lvc_nkey,
            lt_param TYPE STANDARD TABLE OF tvarvc,
            lv_index TYPE i,
            lv_mod   TYPE i
            .
      FIELD-SYMBOLS: <node_key> TYPE lvc_nkey,
                     <param>    TYPE tvarvc,
                     <tree>     TYPE REF TO cl_gui_alv_tree,
                     <fav_key>  TYPE lvc_nkey
                     .
      IF server = 'X'.
        CONCATENATE 'ZAL11_FAV_S_' sy-uname INTO lv_name.
        ASSIGN g_tree_server TO <tree>.
        ASSIGN gv_fav_key_server TO <fav_key>.
      ELSE.
        CONCATENATE 'ZAL11_FAV_L_' sy-uname INTO lv_name.
        ASSIGN g_tree_local TO <tree>.
        ASSIGN gv_fav_key_local TO <fav_key>.
      ENDIF.
      SELECT * FROM tvarvc
             INTO TABLE lt_param
             WHERE name = lv_name
             ORDER BY name.
      LOOP AT lt_param ASSIGNING <param>.
        AT FIRST.
          IF <param>-numb > 10.
            lv_index = 10.
            EXIT.
          ENDIF.
        ENDAT.
        lv_mod = <param>-numb MOD 10.
        IF lv_mod IS NOT INITIAL.
          CONTINUE.
        ELSE.
          lv_index = <param>-numb.
        ENDIF.
      ENDLOOP.
      IF sy-subrc IS NOT INITIAL.
        lv_index = 10.
      ELSE.
        ADD 10 TO lv_index.
      ENDIF.

      LOOP AT from_nodes ASSIGNING <node_key>.
        CALL METHOD <tree>->get_outtab_line
          EXPORTING
            i_node_key    = <node_key>
          IMPORTING
            e_outtab_line = wa_dir.
        lv_path = wa_dir-full_path.

        PERFORM add_node_to_tree USING    <fav_key>
                                          gc_icon_favorite
                                          gc_icon_favorite
                                          'X'
                                          wa_dir
                                          lv_path
                                          <tree>
                                 CHANGING lv_key
                                 .

        WHILE wa_dir-full_path IS NOT INITIAL.
          APPEND INITIAL LINE TO lt_param ASSIGNING <param>.
          <param>-name = lv_name.
          <param>-numb = lv_index.
          <param>-low  = wa_dir-full_path.
          SHIFT wa_dir-full_path LEFT BY 255 PLACES.
          <param>-high  = wa_dir-full_path.
          SHIFT wa_dir-full_path LEFT BY 255 PLACES.
          ADD 1 TO lv_index.
        ENDWHILE.
      ENDLOOP.

      DELETE FROM tvarvc
             WHERE name = lv_name
             .
      INSERT tvarvc FROM TABLE lt_param.

      CALL METHOD <tree>->expand_node
        EXPORTING
          i_node_key = to_node.
      CALL METHOD <tree>->frontend_update.

    ENDMETHOD.    "add_to_fav



*&---------------------------------------------------------------------*
*&      METHOD  find_logical_path
*&---------------------------------------------------------------------*
    METHOD find_logical_path.

      DATA: lv_file      TYPE string,
            lv_tabix     TYPE sy-tabix,
            lv_len       TYPE i,
            wa_dir       TYPE tp_al11,
            gt_clip_data TYPE STANDARD TABLE OF file_name   "#EC NEEDED
            .
      FIELD-SYMBOLS: <path> TYPE tp_path.

      CALL METHOD g_tree_server->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.

      IF gt_path IS INITIAL.
        SELECT *
               FROM filepath
               INTO CORRESPONDING FIELDS OF TABLE gt_path
               where PATHINTERN like 'Z%'.
        CHECK sy-subrc IS INITIAL.
*       Decipher each logical path to a folder name
        LOOP AT gt_path ASSIGNING <path>.
          lv_tabix = sy-tabix.
          CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
            EXPORTING
              logical_path               = <path>-pathintern
              file_name                  = '1'
            IMPORTING
              file_name_with_path        = lv_file
            EXCEPTIONS
              path_not_found             = 1
              missing_parameter          = 2
              operating_system_not_found = 3
              file_system_not_found      = 4
              OTHERS                     = 5.
          IF sy-subrc <> 0.
            DELETE gt_path INDEX lv_tabix.
          ELSE.
            lv_len = strlen( lv_file ) - 1.
            <path>-folder = lv_file+0(lv_len).
          ENDIF.
        ENDLOOP.

        SORT gt_path BY folder.
      ENDIF.

      READ TABLE gt_path ASSIGNING <path>
                 WITH KEY folder = wa_dir-full_path
                 BINARY SEARCH
                 .
      IF NOT sy-subrc IS INITIAL.
        CONCATENATE wa_dir-full_path
                    gv_delimiter
                    INTO wa_dir-full_path.
        READ TABLE gt_path ASSIGNING <path>
                   WITH KEY folder = wa_dir-full_path
                   BINARY SEARCH
                   .
        IF NOT sy-subrc IS INITIAL.
          MESSAGE s171(ba) WITH wa_dir-full_path.
          EXIT.
        ENDIF.
      ENDIF.

      MESSAGE i055(xw) WITH wa_dir-full_path
                            <path>-pathintern ''.
      APPEND <path>-pathintern TO gt_clip_data.

      CALL METHOD cl_gui_frontend_services=>clipboard_export
        IMPORTING
          data         = gt_clip_data
        CHANGING
          rc           = gv_rc
        EXCEPTIONS
          cntl_error   = 1
          error_no_gui = 2
          OTHERS       = 3.
      IF sy-subrc <> 0.
        MESSAGE s829(ed).
*       Error when copying to clipboard
      ELSE.
        MESSAGE s005(lxe_se63).
*       Data was copied to clipboard
      ENDIF.

    ENDMETHOD.                    " find_logical_path




*&---------------------------------------------------------------------*
*&      METHOD  handle_cm_sel
*&---------------------------------------------------------------------*
    METHOD handle_cm_sel.

      DATA: lt_selected_nodes TYPE lvc_t_nkey,
            wa_selected_node  TYPE lvc_nkey,
            wa_dir            TYPE tp_al11,
            lv_name           TYPE rvari_vnam,
            lv_numb           TYPE tvarv_numb
            .
      FIELD-SYMBOLS: <tree>    TYPE REF TO cl_gui_alv_tree,
                     <fav_key> TYPE lvc_nkey
                     .
      IF server = 'X'.
        ASSIGN g_tree_server TO <tree>.
        ASSIGN gv_fav_key_server TO <fav_key>.
      ELSE.
        ASSIGN g_tree_local TO <tree>.
        ASSIGN gv_fav_key_local TO <fav_key>.
      ENDIF.

      CLEAR: gv_last_file.

*     if only one node is selected than table lt_selected_nodes is empty
      CALL METHOD <tree>->get_selected_nodes
        CHANGING
          ct_selected_nodes = lt_selected_nodes
        EXCEPTIONS
          cntl_system_error = 1
          dp_error          = 2
          failed            = 3
          OTHERS            = 4.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

      IF lt_selected_nodes IS INITIAL.
*     in a case when user has selected another node to add/remove, store
*     the worked-on node in a temp var
        APPEND node_key TO lt_selected_nodes.
      ENDIF.

*     single node user commands
      LOOP AT lt_selected_nodes INTO wa_selected_node.
        CALL METHOD <tree>->get_outtab_line
          EXPORTING
            i_node_key     = wa_selected_node
          IMPORTING
            e_outtab_line  = wa_dir
          EXCEPTIONS
            node_not_found = 1
            OTHERS         = 2.

        IF server = 'X'.
          CASE fcode.
            WHEN gc_fcode_upload_file_asc.
              trans_mode = gc_ascii.
              CALL METHOD upload_file
                EXPORTING
                  node_key = wa_selected_node.

            WHEN gc_fcode_upload_file_bin.
              trans_mode = gc_binary.
              CALL METHOD upload_file
                EXPORTING
                  node_key = wa_selected_node.

            WHEN gc_fcode_logcl_path.
              CALL METHOD find_logical_path
                EXPORTING
                  node_key = wa_selected_node.

            WHEN gc_fcode_fav_add.
              CALL METHOD add_to_fav
                EXPORTING
                  server     = 'X'
                  from_nodes = lt_selected_nodes
                  to_node    = <fav_key>.

            WHEN gc_fcode_fav_del.
              CONCATENATE 'ZAL11_FAV_S_' sy-uname INTO lv_name.
              lv_numb = wa_dir-numb + 9.
              DELETE FROM tvarvc
                     WHERE name = lv_name
                       AND numb BETWEEN wa_dir-numb AND lv_numb.

              CALL METHOD <tree>->delete_subtree
                EXPORTING
                  i_node_key                = wa_selected_node
                  i_update_parents_expander = 'X'
                  i_update_parents_folder   = 'X'.
              CALL METHOD <tree>->frontend_update.

          ENDCASE.
        ELSE.
          CASE fcode.

            WHEN gc_fcode_fav_add.
              CALL METHOD add_to_fav
                EXPORTING
                  server     = ''
                  from_nodes = lt_selected_nodes
                  to_node    = <fav_key>.

            WHEN gc_fcode_fav_del.
              CONCATENATE 'ZAL11_FAV_L_' sy-uname INTO lv_name.
              lv_numb = wa_dir-numb + 9.
              DELETE FROM tvarvc
                     WHERE name = lv_name
                       AND numb BETWEEN wa_dir-numb AND lv_numb.

              CALL METHOD <tree>->delete_subtree
                EXPORTING
                  i_node_key                = wa_selected_node
                  i_update_parents_expander = 'X'
                  i_update_parents_folder   = 'X'.
              CALL METHOD <tree>->frontend_update.

          ENDCASE.
        ENDIF.
      ENDLOOP.

    ENDMETHOD.                    " handle_cm_sel



*&---------------------------------------------------------------------*
*&      METHOD  handle_cm_req
*&---------------------------------------------------------------------*
    METHOD handle_cm_req.

      DATA: lt_selected_nodes       TYPE lvc_t_nkey,
            wa_selected_node        TYPE lvc_nkey,
            ls_node_layout          TYPE lvc_s_layn,
            ls_node_selected_layout TYPE lvc_s_layn,
            lv_exit                 TYPE c
            .

      FIELD-SYMBOLS: <tree>     TYPE REF TO cl_gui_alv_tree
                     .
      IF server = 'X'.
        ASSIGN g_tree_server TO <tree>.
      ELSE.
        ASSIGN g_tree_local TO <tree>.
      ENDIF.

*     In this case the standard menu is cleared.
      CALL METHOD menu->clear.

      CALL METHOD <tree>->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          es_node_layout = ls_node_layout.

*     Check that all the nodes changed are of the same action
      CALL METHOD <tree>->get_selected_nodes
        CHANGING
          ct_selected_nodes = lt_selected_nodes
        EXCEPTIONS
          cntl_system_error = 1
          dp_error          = 2
          failed            = 3
          OTHERS            = 4.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

*     Do not allow multipe actions when selecting a file and a folder
*     (different functionality)
      LOOP AT lt_selected_nodes INTO wa_selected_node.
        CALL METHOD <tree>->get_outtab_line
          EXPORTING
            i_node_key     = wa_selected_node
          IMPORTING
            es_node_layout = ls_node_selected_layout.
        IF ls_node_selected_layout-n_image <> ls_node_layout-n_image.
          MESSAGE i070(ds).
          lv_exit = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.

      CHECK lv_exit IS INITIAL.

      DESCRIBE TABLE lt_selected_nodes LINES sy-tfill.
*     add the option to add the IDoc to the list only if it is in status
*     error
      IF server = 'X'.
        CASE ls_node_layout-n_image.
          WHEN gc_icon_folder_close OR gc_icon_folder_open.
*         you cannot upload file to more than one folder
            IF sy-tfill > 1.
              MESSAGE i304(42).
              EXIT.
            ENDIF.

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_upload_file_asc
                text  = 'Upload file (Text)'(fua).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_upload_file_bin
                text  = 'Upload file (Binary)'(fub).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_fav_add
                text  = 'Add to Favorites'(faf).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_logcl_path
                text  = 'Find Logical Path'(flp).

          WHEN gc_icon_favorite.

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_upload_file_asc
                text  = 'Upload file (Text)'(fua).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_upload_file_bin
                text  = 'Upload file (Binary)'(fub).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_fav_del
                text  = 'Delete Favorite'(fdf).

            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_logcl_path
                text  = 'Find Logical Path'(flp).

        ENDCASE.
      ELSE.
        CASE ls_node_layout-n_image.
          WHEN gc_icon_folder_close OR gc_icon_folder_open.
            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_fav_add
                text  = 'Add to Favorites'(faf).

          WHEN gc_icon_favorite.
            CALL METHOD menu->add_function
              EXPORTING
                fcode = gc_fcode_fav_del
                text  = 'Delete Favorite'(fdf).

        ENDCASE.
      ENDIF.

    ENDMETHOD.                    " handle_cm_req



*&---------------------------------------------------------------------*
*&      method  handle_select_server
*&---------------------------------------------------------------------*
    METHOD handle_select_server.

      DATA: wa_dir  TYPE tp_al11.

      CALL METHOD g_tree_server->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.

      gv_last_dir_server = wa_dir-full_path.
      gv_last_node_server = node_key.

      PERFORM update_dir_files USING 'X' wa_dir-name.

    ENDMETHOD.      "handle_select_server



*&---------------------------------------------------------------------*
*&      method  handle_select_local
*&---------------------------------------------------------------------*
    METHOD handle_select_local.

      DATA: wa_dir  TYPE tp_al11.

      CALL METHOD g_tree_local->get_outtab_line
        EXPORTING
          i_node_key     = node_key
        IMPORTING
          e_outtab_line  = wa_dir
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2.

      CHECK wa_dir-full_path <> 'ROOT'.
      CHECK wa_dir-name IS NOT INITIAL.

      gv_last_dir_local = wa_dir-full_path.
      gv_last_node_local = node_key.

      PERFORM update_dir_files USING '' wa_dir-name.

    ENDMETHOD.      "handle_select_local



*---------------------------------------------------------------------*
*    METHOD   on_function_selected   IMPLEMENTATION.
*---------------------------------------------------------------------*
    METHOD on_function_selected.

      CASE fcode.
        WHEN gc_toolbar_change_dir.
          CALL METHOD change_dir( '' ).

        WHEN gc_toolbar_chg_logfld.
          CALL METHOD change_dir( 'X' ).

      ENDCASE.
    ENDMETHOD.                    "on_function_selected



*&---------------------------------------------------------------------*
*&      Method  get_open_directories
*&---------------------------------------------------------------------*
    METHOD get_open_directories.


      DATA: lt_children   TYPE lvc_t_nkey,
            lv_node_index TYPE sy-tabix,
            wa_folder     TYPE lvc_value,
            lv_last_dir   TYPE string
            .

      FIELD-SYMBOLS: <child>     TYPE lvc_nkey,
                     <key_child> TYPE lvc_nkey
                     .

      CALL METHOD g_tree_server->get_children
        EXPORTING
          i_node_key  = parent_node
        IMPORTING
          et_children = lt_children.
      LOOP AT lt_children ASSIGNING <child>.
        lv_last_dir = last_dir.

        SEARCH node_table FOR <child>.
        IF sy-subrc IS INITIAL.
          lv_node_index = sy-tabix.
          READ TABLE node_table ASSIGNING <key_child>
                     INDEX lv_node_index.
          CALL METHOD g_tree_server->get_outtab_line
            EXPORTING
              i_node_key  = <key_child>
            IMPORTING
              e_node_text = wa_folder.
          DELETE node_table INDEX lv_node_index.
          CONCATENATE lv_last_dir '/' wa_folder INTO lv_last_dir.
          APPEND lv_last_dir TO folder.

          CALL METHOD get_open_directories
            EXPORTING
              parent_node = <child>
            CHANGING
              folder      = folder
              node_table  = node_table
              last_dir    = lv_last_dir.
        ENDIF.
        CALL METHOD g_tree_server->delete_subtree
          EXPORTING
            i_node_key = <child>.
      ENDLOOP.

    ENDMETHOD.                    " get_open_directories



*&---------------------------------------------------------------------*
*&      METHOD  change_dir
*&---------------------------------------------------------------------*
    METHOD change_dir.

      DATA: lv_ans     TYPE c,
            lt_options TYPE STANDARD TABLE OF spopli,
            wa_options TYPE spopli,
            lv_dir     TYPE string,
            lv_len     TYPE i,
            lv_dup(2)  TYPE c,
            lv_line    TYPE i
            .
      FIELD-SYMBOLS: <param> TYPE tvarvc,
                     <file>  TYPE filetextci
                     .

      IF logical_folder IS INITIAL.
*       read all available directories from table TVARVC

        LOOP AT gt_param ASSIGNING <param>.
          lv_dir = <param>-low.
          IF gv_main_dir = lv_dir.
*            CONTINUE.
            lv_line = sy-tabix.
          ENDIF.
          wa_options-varoption = <param>-high.
          APPEND wa_options TO lt_options.
        ENDLOOP.
      ELSE.
        LOOP AT gt_file ASSIGNING <file>.
          wa_options-varoption = <file>-filename.
          APPEND wa_options TO lt_options.
        ENDLOOP.

      ENDIF.
      CALL FUNCTION 'POPUP_TO_DECIDE_LIST'
        EXPORTING
          textline1          = 'Please select file system of one of the following systems:'(psy)
          titel              = 'Change Directory'(cdr)
          cursorline         = lv_line
        IMPORTING
          answer             = lv_ans
        TABLES
          t_spopli           = lt_options
        EXCEPTIONS
          not_enough_answers = 1
          too_much_answers   = 2
          too_much_marks     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

      CHECK lv_ans <> 'A'.

      READ TABLE lt_options INTO wa_options WITH KEY selflag = 'X'.
      IF logical_folder IS INITIAL.
        READ TABLE gt_param ASSIGNING <param>               "#EC *
                   WITH KEY high = wa_options-varoption.
        lv_len = strlen( <param>-low ) - 1.
        IF <param>-low+lv_len(1) = '\' OR <param>-low+lv_len(1) = '/'.
          <param>-low = <param>-low+0(lv_len).
        ENDIF.
        gv_main_dir = <param>-low.

      ELSE.
        READ TABLE gt_file ASSIGNING <file>
             WITH KEY fileintern = wa_options-varoption.
*       Set initial folder
        CALL FUNCTION 'FILE_GET_NAME'
          EXPORTING
            logical_filename        = <file>-fileintern
            use_presentation_server = 'X'
          IMPORTING
            file_name               = lv_dir
          EXCEPTIONS
            file_not_found          = 1
            OTHERS                  = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          EXIT.
        ENDIF.

        lv_len = strlen( lv_dir ) - 1.
        DO.
          IF lv_dir+lv_len(1) = '\'.
            MESSAGE w398(00) WITH
            'Please use the local drive to open Windows folder:'(wnd)
            lv_dir '' ''.
            CLEAR lv_dir.
            EXIT.
          ELSEIF lv_dir+lv_len(1) = '/'.
            EXIT.
          ENDIF.
          lv_dir = lv_dir+0(lv_len).
          lv_len = lv_len - 1.
        ENDDO.
        CHECK lv_dir IS NOT INITIAL.

*       In case the logical file name has a sub folder (or more) as one of the parameters.
        CONCATENATE gv_delimiter gv_delimiter INTO lv_dup.
        DO.
          REPLACE ALL OCCURRENCES OF lv_dup IN lv_dir WITH gv_delimiter.
          IF sy-subrc IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDDO.

        lv_len = strlen( lv_dir ) - 1.
        IF lv_dir+lv_len(1) = '\' OR lv_dir+lv_len(1) = '/'.
          lv_dir = lv_dir+0(lv_len).
        ENDIF.
        gv_main_dir = lv_dir.
      ENDIF.

      CALL METHOD g_tree_server->delete_all_nodes.

      lv_dir = gv_main_dir.
      PERFORM create_hier_fav    USING 'X'.
      PERFORM create_hier_server USING lv_dir
                                     ''
                                     .
      CALL METHOD g_tree_server->frontend_update.

    ENDMETHOD.                    " change_dir


  ENDCLASS.                    "LCL_APPLICATION IMPLEMENTATION



*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
  FORM download_file USING p_source TYPE string
                           p_dest   TYPE string.

    DATA: lv_file_save  TYPE string,
          lt_data       TYPE STANDARD TABLE OF string,
          lv_file_len   TYPE i,
          lv_str        TYPE string,
          lv_strx(1000) TYPE x,
          lt_datax      LIKE TABLE OF lv_strx,
          lv_len        TYPE i,
          lv_phyfile    TYPE rlgrap-filename,
          lv_exist      TYPE char1,
          lv_ans        TYPE char1
          .
    FIELD-SYMBOLS: <table> TYPE STANDARD TABLE.

*   Get the download location
    IF p_dest IS INITIAL.
      PERFORM get_file_dialog USING    'Upload file'(fup)
                                       'X'
                                       lv_file_save
                              CHANGING lv_file_save
                              .
    ELSE.
      CALL METHOD cl_gui_frontend_services=>file_exist
        EXPORTING
          file                 = p_dest
        RECEIVING
          result               = lv_exist
        EXCEPTIONS
          cntl_error           = 0
          error_no_gui         = 0
          wrong_parameter      = 0
          not_supported_by_gui = 0
          OTHERS               = 0.
      IF lv_exist = 'X'.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'File Download Confirmation'(td5)
            text_question         = 'A similar file already exists. Do you want to overwrite?'(q02)
            text_button_1         = 'Yes'(yes)
            text_button_2         = 'No'(nop)
            default_button        = '2'
            display_cancel_button = space
          IMPORTING
            answer                = lv_ans
          EXCEPTIONS
            text_not_found        = 0
            OTHERS                = 0.
        CHECK lv_ans = '1'.
      ENDIF.
      lv_file_save = p_dest.
    ENDIF.

*   Check that the file does not exist

    IF trans_mode IS INITIAL.
      lv_phyfile = p_source.
      PERFORM get_transfer_mode USING lv_phyfile.
    ENDIF.

    CASE trans_mode.
      WHEN gc_ascii.
        ASSIGN lt_data TO <table>.
        OPEN DATASET p_source FOR INPUT IN TEXT MODE
                     ENCODING DEFAULT IGNORING CONVERSION ERRORS.
        IF sy-subrc IS NOT INITIAL.
          MESSAGE e008(cq99).
*         File open error
        ENDIF.
        WHILE sy-subrc IS INITIAL.
          READ DATASET p_source INTO lv_str.
          IF NOT sy-subrc IS INITIAL.
            EXIT.
          ENDIF.
          lv_len = strlen( lv_str ).
          ADD lv_len TO lv_file_len.
          APPEND lv_str TO <table>.
        ENDWHILE.

      WHEN gc_binary.
        OPEN DATASET p_source FOR INPUT IN BINARY MODE.
        IF sy-subrc IS NOT INITIAL.
          MESSAGE e008(cq99).
*         File open error
        ENDIF.
        ASSIGN lt_datax TO <table>.
        WHILE sy-subrc IS INITIAL.
          READ DATASET p_source INTO lv_strx.
          IF NOT sy-subrc IS INITIAL.
            EXIT.
          ENDIF.
          lv_len = xstrlen( lv_strx ).
          ADD lv_len TO lv_file_len.
          APPEND lv_strx TO <table>.
        ENDWHILE.
    ENDCASE.

    CLOSE DATASET p_source.

*   Download file
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename                = lv_file_save
        filetype                = trans_mode
      IMPORTING
        filelength              = lv_file_len
      CHANGING
        data_tab                = <table>
      EXCEPTIONS
        file_write_error        = 1
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
        OTHERS                  = 22.
    IF sy-subrc <> 0.
      MESSAGE e031(51) WITH sy-subrc.
    ENDIF.

    MESSAGE s411(3e) WITH lv_file_len.

  ENDFORM.                    " DOWNLOAD_FILE
