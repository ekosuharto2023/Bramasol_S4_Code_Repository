REPORT z_al11_new.
*&---------------------------------------------------------------------*
*& Program name: ZBC_AL11                                              *
*& This program is the property of Itay Avni. Previously developed and *
*& not billed for. This program allows the user to move files in       *
*& production server. Use at your own risk.                            *
*&---------------------------------------------------------------------*
*&   ------ PURPOSE -------                                            *
*& 1. view files on SAP application server & Local Machine             *
*& 2. upload & download files to application server                    *
*&                                                                     *
*&   ------ SETUP -------                                              *
*& - Main folder and other folders you can view are maintained in table*
*&   TVARVC.                                                           *
*& - If you have authorization for more than one company code you will *
*&   see only folders under parameter ZAL11_FLDR.                      *
*& - If you have only one authority for a company code you will see the*
*&   folders in parameter  ZAL11_FLDR_<BUKRS>.                         *
*& - Field LOW is the folder. Field HIGH is the description.           *
*& - If you have no company codes assigned to your profile (it means you
*&   cannot do any modification in FI) you will get the folders that are
*&   assigned to the company code that you belong to in PA0001. If you *
*&   have no such assignment (not an employee), it will use your PID BUK
*& - The button Change Directory will appear only if there is more than*
*&   1 main folder you can see.                                        *
*&----------------------------------------------------------------------
*&                            Modification Log                         *
*&----------------------------------------------------------------------
*& Date    |Changed By| Change                                         *
*&----------------------------------------------------------------------
*& Oct 2025|Itay Avni | Created                                        *
*&---------------------------------------------------------------------*

TYPES: BEGIN OF tp_al11,
         icon      TYPE aqicon,
         dirname   TYPE ech_file_path,
         name      TYPE string,
         type      TYPE char10,
         len       TYPE rspobytes,
         owner     TYPE epsfilown,
         umode     TYPE epsfilmod,
         errno     TYPE symsgno,
         errmsg    TYPE char40,
         mod_date  TYPE datum,
         mod_time  TYPE uzeit,
         full_path TYPE ech_file_path,
         numb      TYPE tvarv_numb,
       END OF tp_al11.

CONSTANTS: gc_file_system           TYPE sobj_name   VALUE 'ZAL11_FLDR',
           gc_sxpg_rename           TYPE sxpgcostab-name
                                                     VALUE 'Z_RENAME_FILE',
           gc_ascii                 TYPE char10      VALUE 'ASC',
           gc_binary                TYPE char10      VALUE 'BIN',
           gc_icon_file             TYPE aqicon      VALUE '@0Y@',
           gc_icon_favorite         TYPE aqicon      VALUE '@6D@',
           gc_icon_folder_close     TYPE aqicon      VALUE '@FN@',
           gc_icon_folder_open      TYPE aqicon      VALUE '@FO@',
           gc_icon_folder_pc        TYPE aqicon      VALUE '@MV@',
           gc_icon_folder_desktop   TYPE aqicon      VALUE '@JF@',
           gc_icon_folder_my_docs   TYPE aqicon      VALUE '@F8@',
           gc_icon_folder_local     TYPE aqicon      VALUE '@4V@',
           gc_icon_folder_cd        TYPE aqicon      VALUE '@4W@',
           gc_icon_folder_remote    TYPE aqicon      VALUE '@53@',
           gc_icon_folder_usb       TYPE aqicon      VALUE '@63@',
           gc_icon_down             TYPE aqicon      VALUE '@49@',
           gc_icon_up               TYPE aqicon      VALUE '@48@',
           gc_icon_file_open        TYPE aqicon      VALUE '@10@',
           gc_icon_rename           TYPE aqicon      VALUE '@4F@',
           gc_icon_folder_fav       TYPE aqicon      VALUE '@FU@',
           gc_icon_excel            TYPE aqicon      VALUE '@J2@',
           gc_icon_copy             TYPE aqicon      VALUE '@BQ@',
           gc_icon_transfer         TYPE aqicon      VALUE '@AA@',
           gc_icon_html             TYPE aqicon      VALUE '@J4@',
           gc_icon_word             TYPE aqicon      VALUE '@J7@',
           gc_icon_ppt              TYPE aqicon      VALUE '@J5@',
           gc_icon_pdf              TYPE aqicon      VALUE '@IT@',
           gc_icon_vsd              TYPE aqicon      VALUE '@JE@',
           gc_icon_text             TYPE aqicon      VALUE '@TE@',
           gc_icon_gif              TYPE aqicon      VALUE '@IW@',
           gc_icon_zip              TYPE aqicon      VALUE '@KA@',
           gc_icon_change_dir       TYPE aqicon      VALUE '@2Q@',
           gc_x                     TYPE c           VALUE 'X',
           gc_has_sons              TYPE c           VALUE 'X',
           gc_fcode_tm_auto         LIKE sy-ucomm    VALUE 'TM_AUTO',
           gc_fcode_tm_ascii        LIKE sy-ucomm    VALUE 'TM_ASCII',
           gc_fcode_tm_bin          LIKE sy-ucomm    VALUE 'TM_BIN',
           gc_fcode_open_file       LIKE sy-ucomm    VALUE 'SHOW',
           gc_fcode_open_file_parse LIKE sy-ucomm    VALUE 'SHOW_P',
           gc_fcode_open_file_tab   LIKE sy-ucomm    VALUE 'SHOW_T',
           gc_fcode_open_file_pdf   LIKE sy-ucomm    VALUE 'SHOW_PDF',
           gc_fcode_open_file_html  LIKE sy-ucomm    VALUE 'SHOW_HTML',
           gc_fcode_open_file_edit  LIKE sy-ucomm    VALUE 'SHOW_EDITOR',
           gc_fcode_column_marker   LIKE sy-ucomm    VALUE 'SET_COLUMN',
           gc_fcode_rename_file     LIKE sy-ucomm    VALUE 'RENAME',
           gc_fcode_download_file   LIKE sy-ucomm    VALUE 'DOWNLOAD',
           gc_fcode_copy            LIKE sy-ucomm    VALUE 'COPY',
           gc_fcode_transfer        LIKE sy-ucomm    VALUE 'TRANSFER',
           gc_fcode_fav_del         LIKE sy-ucomm    VALUE 'FAV_DEL',
           gc_fcode_fav_add         LIKE sy-ucomm    VALUE 'FAV_ADD',
           gc_fcode_upload_file_asc LIKE sy-ucomm    VALUE 'UPLOAD_ASCII',
           gc_fcode_upload_file_bin LIKE sy-ucomm    VALUE 'UPLOAD_BINARY',
           gc_fcode_upload_file     LIKE sy-ucomm    VALUE 'UPLOAD',
           gc_fcode_logcl_path      LIKE sy-ucomm    VALUE 'LOG_PATH',
           gc_toolbar_open_file     LIKE sy-ucomm    VALUE 'OPEN_FILE',
           gc_toolbar_change_dir    LIKE sy-ucomm    VALUE 'CHANGE_DIR',
           gc_toolbar_chg_logfld    TYPE sy-ucomm    VALUE 'CHANGE_LODG_FLD',
           gc_directory(10)         TYPE c           VALUE 'directory',
           gc_line_color            TYPE fieldname   VALUE 'LINECOLOR',
           gc_use_columns           TYPE tgsut-separator VALUE 'C'
           .
FIELD-SYMBOLS: <table> TYPE STANDARD TABLE,
               <line>  TYPE any
               .
DATA: gv_main_dir         TYPE string,
      g_dock_left         TYPE REF TO cl_gui_docking_container,
      g_html_viewer       TYPE REF TO cl_gui_html_viewer,
      g_url(2048)         TYPE c,
      g_alv_grid_server   TYPE REF TO cl_gui_alv_grid,      "#EC NEEDED
      g_alv_grid_local    TYPE REF TO cl_gui_alv_grid,      "#EC NEEDED
      g_tree_server       TYPE REF TO cl_gui_alv_tree,
      g_tree_local        TYPE REF TO cl_gui_alv_tree,
      gv_progid           LIKE sy-repid,
      gv_dynnr            TYPE sy-dynnr,
      g_tree_toolbar      TYPE REF TO cl_gui_toolbar,
      gt_fieldcat         TYPE lvc_t_fcat,
      gs_layo_seg         TYPE lvc_s_layo,
      gt_tree_server      TYPE STANDARD TABLE OF tp_al11,
      gt_tree_local       TYPE STANDARD TABLE OF tp_al11,
      gv_delimiter        TYPE c,
      gv_delimiter_local  TYPE c,
      gv_last_node_server TYPE lvc_nkey,
      gv_last_node_local  TYPE lvc_nkey,
      trans_mode          TYPE char10,
      gv_rc               TYPE i,
      gv_last_file        TYPE string,  "used for column parsing
      gv_last_dir_server  TYPE string,
      gv_last_dir_local   TYPE string,
      g_drag_behaviour    TYPE REF TO cl_dragdrop,
      g_drop_behaviour    TYPE REF TO cl_dragdrop,
      gv_fav_key_server   TYPE lvc_nkey,
      gv_fav_key_local    TYPE lvc_nkey,
      g_splitter          TYPE REF TO cl_gui_easy_splitter_container,
      g_split_server      TYPE REF TO cl_gui_container,
      g_split_local       TYPE REF TO cl_gui_container,
      g_split_sr          TYPE REF TO cl_gui_container,
      g_split_sl          TYPE REF TO cl_gui_container,
      g_split_lr          TYPE REF TO cl_gui_container,
      g_split_ll          TYPE REF TO cl_gui_container,
      gt_dir_server       TYPE STANDARD TABLE OF tp_al11,
      gt_dir_local        TYPE STANDARD TABLE OF tp_al11,
      gs_toolbar          TYPE stb_button,
      gt_file             TYPE STANDARD TABLE OF filetextci,
      gt_param            TYPE STANDARD TABLE OF tvarvc
      .
INCLUDE z_al11n_cls.

INITIALIZATION.
  PERFORM initialize_report.

START-OF-SELECTION.
  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*&      Form  initialize_report
*&---------------------------------------------------------------------*
FORM initialize_report.

  DATA: lt_bukrs TYPE STANDARD TABLE OF t001,
        lv_found TYPE char1,
        lv_name  TYPE string,
        lv_bukrs TYPE bukrs
        .
  FIELD-SYMBOLS: <bukrs> TYPE t001,
                 <param> TYPE tvarvc
                 .

  CONCATENATE gc_file_system '%' INTO lv_name.
  SELECT * FROM tvarvc
         INTO TABLE gt_param
         WHERE name LIKE lv_name
         ORDER BY name
         .
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e519(bca_us_general) WITH 'TVARVC' gc_file_system.
*   Please maintain table & for the entries: & &
  ENDIF.
  DESCRIBE TABLE lt_bukrs LINES sy-tfill.

  LOOP AT gt_param ASSIGNING <param>.
    AT NEW name.
      CLEAR lv_found.
      LOOP AT lt_bukrs ASSIGNING <bukrs>.
        IF <param>-name CS <bukrs>-bukrs.
          lv_found = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_found IS INITIAL.
        IF <param>-name = gc_file_system.
*         This is the main parent folder
          IF sy-tfill = 1.
*           User is allowed for only one company code - do not show the
*           genral link
            DELETE gt_param WHERE name = gc_file_system.
          ELSE.
*           If the user is allowed to see all the company codes, do not
*           show the links that belong to a spacific comp (the main link
*           is at a higher node)
            DELETE gt_param WHERE name <> gc_file_system.
            EXIT.
          ENDIF.
        ELSE.
*         This is not the main folder and there is no authorization to
*         see this compa code folders
          DELETE gt_param WHERE name = <param>-name.
        ENDIF.
      ENDIF.
    ENDAT.
  ENDLOOP.

  gs_layo_seg-cwidth_opt = gs_layo_seg-col_opt =
  gs_layo_seg-zebra      = gs_layo_seg-smalltitle = 'X'.

  gv_progid  = sy-repid.

  CASE sy-opsys.
    WHEN 'AIX' OR 'Linux' OR 'SunOS' OR 'HP-UX'.
      gv_delimiter = '/'.
    WHEN OTHERS.
      gv_delimiter = '\'.
  ENDCASE.
  CALL METHOD cl_gui_frontend_services=>get_file_separator
    CHANGING
      file_separator = gv_delimiter_local.

  READ TABLE gt_param INDEX 1 ASSIGNING <param>.
  gv_main_dir = <param>-low.

ENDFORM.                    " initialize_report



*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS'.
  SET TITLEBAR  'DEFAULT'.

  IF g_tree_server IS INITIAL.
    PERFORM init_tree.

    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDMODULE.                 " status_0100  OUTPUT




*&---------------------------------------------------------------------*
*&      Form  init_tree
*&---------------------------------------------------------------------*
FORM init_tree.

  DATA: ls_hier_hdr   TYPE treev_hhdr,
        l_dnd_evt_rec TYPE REF TO lcl_dnd_evt_rcv
        .

  IF g_dock_left IS INITIAL.

    gv_dynnr = sy-dynnr.
    CREATE OBJECT g_dock_left
      EXPORTING
        repid     = gv_progid
        dynnr     = gv_dynnr
        side      = g_dock_left->dock_at_top
        extension = 1000.

    CREATE OBJECT g_splitter
      EXPORTING
        sash_position = 60
        parent        = g_dock_left
        orientation   = 0.

    g_split_server  = g_splitter->top_left_container.
    g_split_local = g_splitter->bottom_right_container.
    CREATE OBJECT g_splitter
      EXPORTING
        sash_position = 35
        parent        = g_split_server
        orientation   = 1.
    g_split_sl = g_splitter->top_left_container.
    g_split_sr = g_splitter->bottom_right_container.

    CREATE OBJECT g_splitter
      EXPORTING
        sash_position = 35
        parent        = g_split_local
        orientation   = 1.
    g_split_ll = g_splitter->top_left_container.
    g_split_lr = g_splitter->bottom_right_container.
  ENDIF.

  CREATE OBJECT g_tree_server
    EXPORTING
      parent                      = g_split_sl
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = ''
      no_html_header              = 'X'
      no_toolbar                  = ''
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  ls_hier_hdr-heading   = ls_hier_hdr-tooltip = 'Directory'(dir).
  ls_hier_hdr-width     = 120.
  ls_hier_hdr-width_pix = ' '.

  PERFORM build_fieldcat USING    'X'
                         CHANGING gt_fieldcat.

  CALL METHOD g_tree_server->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = ls_hier_hdr
    CHANGING
      it_outtab           = gt_tree_server "table must be empty !
      it_fieldcatalog     = gt_fieldcat.

  PERFORM define_dnd_behaviour.
  PERFORM create_hier_fav    USING 'X'.
  PERFORM create_hier_server USING  gv_main_dir
                                    ''
                                    .
  CALL METHOD g_tree_server->get_toolbar_object
    IMPORTING
      er_toolbar = g_tree_toolbar.

  CHECK NOT g_tree_toolbar IS INITIAL.

* Remove unneccessary buttons
  CALL METHOD g_tree_toolbar->delete_all_buttons.

* Add Standard 'Search' Button to toolbar
  CALL METHOD g_tree_toolbar->add_button
    EXPORTING
      fcode     = '&FIND'
      icon      = '@13@'
      butn_type = cntb_btype_button
      text      = ''
      quickinfo = 'Find'(fin).

  CALL METHOD g_tree_toolbar->add_button
    EXPORTING
      fcode     = ''
      icon      = ''
      butn_type = cntb_btype_sep.

* append a 'Change Dir' icon if there is more than 1 main folder to see
  DESCRIBE TABLE gt_param LINES sy-tfill.
  IF sy-tfill > 1.
    CALL METHOD g_tree_toolbar->add_button
      EXPORTING
        fcode     = gc_toolbar_change_dir
        icon      = gc_icon_change_dir
        butn_type = cntb_btype_button
        text      = 'Change Directory'(cdr)
        quickinfo = 'Change Directory'(cdr).
  ENDIF.

* Check if there are logical folders in the sysmet and then add switch button
  IF sy-sysid = 'HDV'.
    SELECT * FROM filetextci
           INTO TABLE gt_file
           WHERE langu = sy-langu
             AND fileintern LIKE 'Z%'
             .
    IF sy-subrc IS INITIAL.
*   append a 'Change Dir' icon
      CALL METHOD g_tree_toolbar->add_button
        EXPORTING
          fcode     = gc_toolbar_chg_logfld
          icon      = gc_icon_change_dir
          butn_type = cntb_btype_button
          text      = 'Change Logical Folder'(clf)
          quickinfo = 'Change Logical Folder'(clf).
    ENDIF.
  ENDIF.

  CREATE OBJECT l_dnd_evt_rec.
  SET HANDLER l_dnd_evt_rec->handle_line_drop_server
                                    FOR g_tree_server.

  CALL METHOD g_tree_server->set_has_3d_frame
    EXPORTING
      i_has_3d_frame = gc_x.

  CREATE OBJECT g_tree_local
    EXPORTING
      parent                      = g_split_ll
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = ''
      no_html_header              = 'X'
      no_toolbar                  = 'X'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  ls_hier_hdr-heading   = ls_hier_hdr-tooltip = 'Directory'(dir).
  ls_hier_hdr-width     = 120.
  ls_hier_hdr-width_pix = ' '.

  CALL METHOD g_tree_local->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = ls_hier_hdr
    CHANGING
      it_outtab           = gt_tree_local "table must be empty !
      it_fieldcatalog     = gt_fieldcat.

  PERFORM create_hier_fav   USING ''.
  PERFORM create_hier_local USING '' ''.

  PERFORM register_events.
  SET HANDLER l_dnd_evt_rec->handle_line_drop_local
                                    FOR g_tree_local.

ENDFORM.                               " init_tree




*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'CANC' OR 'BACK' OR 'QUIT'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_0100  INPUT




*&---------------------------------------------------------------------*
*&      Form  register_events
*&---------------------------------------------------------------------*
FORM register_events .

  DATA: lt_events        TYPE cntl_simple_events,
        l_event          TYPE cntl_simple_event,
        l_event_receiver TYPE REF TO lcl_tree_evt_rcv
        .

  CALL METHOD g_tree_server->get_registered_events
    IMPORTING
      events = lt_events.

  l_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_selection_changed.
  l_event-appl_event = 'X'.
  APPEND l_event TO lt_events.

  CALL METHOD g_tree_server->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  CREATE OBJECT l_event_receiver.

  SET HANDLER l_event_receiver->handle_expand_node_nc_server FOR g_tree_server.
  SET HANDLER l_event_receiver->handle_node_cm_req_server    FOR g_tree_server.
  SET HANDLER l_event_receiver->handle_node_cm_sel_server    FOR g_tree_server.
  SET HANDLER l_event_receiver->handle_select_server         FOR g_tree_server.
  SET HANDLER l_event_receiver->on_function_selected         FOR g_tree_toolbar.

  CLEAR: lt_events, l_event.
  CALL METHOD g_tree_local->get_registered_events
    IMPORTING
      events = lt_events.

  l_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_selection_changed.
  l_event-appl_event = 'X'.
  APPEND l_event TO lt_events.

  CALL METHOD g_tree_local->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  SET HANDLER l_event_receiver->handle_expand_node_nc_local FOR g_tree_local.
  SET HANDLER l_event_receiver->handle_select_local         FOR g_tree_local.
  SET HANDLER l_event_receiver->handle_node_cm_req_local    FOR g_tree_local.
  SET HANDLER l_event_receiver->handle_node_cm_sel_local    FOR g_tree_local.

ENDFORM.                    " register_events


*&---------------------------------------------------------------------*
*&      Form  build_fieldcat
*&---------------------------------------------------------------------*
FORM build_fieldcat  USING    p_tech TYPE char1
                     CHANGING pt_fcat TYPE lvc_t_fcat.

  FIELD-SYMBOLS <fcat> TYPE lvc_s_fcat.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'ICON'.
  <fcat>-ref_table = '/SPE/RESEND_TMPDLV'.
  <fcat>-icon = 'X'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'DIRNAME'.
  <fcat>-ref_table = 'USER_DIR'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'NAME'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = 'TYPE'.
  <fcat>-ref_field = 'TYPEE_TXT'.
  <fcat>-ref_table = 'HCMT_BSP_PA_ES_R0714'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'LEN'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'OWNER'.
  <fcat>-ref_table = 'FILEINFO'.

*  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
*  <fcat>-fieldname = <fcat>-ref_field = 'UMODE'.
*  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'ERRNO'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'ERRMSG'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'MOD_DATE'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = <fcat>-ref_field = 'MOD_TIME'.
  <fcat>-ref_table = 'FILEINFO'.

  APPEND INITIAL LINE TO pt_fcat ASSIGNING <fcat>.
  <fcat>-fieldname = 'FULL_PATH'.
  <fcat>-ref_field = 'FILE_PATH'.
  <fcat>-ref_table = 'ECH_FILE_ATTRIBUTES'.

  IF p_tech = 'X'.
    LOOP AT pt_fcat ASSIGNING <fcat>.
      <fcat>-tech   = 'X'.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " build_fieldcat




*&---------------------------------------------------------------------*
*&      Form  create_hier_server
*&---------------------------------------------------------------------*
FORM create_hier_server USING  p_path        TYPE string
                               p_parent_node TYPE lvc_nkey
                               .

  DATA: lv_key            TYPE lvc_nkey,
        lv_top_node       TYPE lvc_nkey,
        lv_icon_open(4)   TYPE c,
        lv_icon_closed(4) TYPE c,
        lt_dir            TYPE STANDARD TABLE OF tp_al11,
        wa_dir            TYPE tp_al11,
        lv_path           TYPE string,
        lv_has_sons       TYPE c,
        lv_not_found      TYPE char1
        .

  PERFORM read_directory USING    p_path
                                  'X'
                         CHANGING lt_dir
                                  lv_not_found
                                  .
  DELETE lt_dir WHERE type <> gc_directory AND type IS NOT INITIAL.
  SORT lt_dir BY type name.
* put an empty node only on the first folder
  IF p_parent_node IS INITIAL.
    wa_dir-full_path = p_path.
    PERFORM add_node_to_tree USING    ''
                                      gc_icon_folder_open
                                      gc_icon_folder_close
                                      gc_has_sons
                                      wa_dir
                                      p_path
                                      g_tree_server
                             CHANGING lv_top_node
                                      .
  ELSE.
    lv_top_node = p_parent_node.
  ENDIF.
  LOOP AT lt_dir INTO wa_dir.
    PERFORM get_icon USING    wa_dir-type
                              wa_dir-name
                     CHANGING lv_icon_open
                              lv_icon_closed
                              lv_has_sons
                              .
    lv_path = wa_dir-name.
    PERFORM add_node_to_tree USING    lv_top_node
                                      lv_icon_open
                                      lv_icon_closed
                                      lv_has_sons
                                      wa_dir
                                      lv_path
                                      g_tree_server
                             CHANGING lv_key
                                      .
  ENDLOOP.

  CALL METHOD g_tree_server->frontend_update.

  CALL METHOD g_tree_server->expand_node
    EXPORTING
      i_node_key = lv_top_node.

  CALL METHOD g_tree_server->column_optimize
    EXPORTING
      i_include_heading      = gc_x
    EXCEPTIONS
      start_column_not_found = 0
      end_column_not_found   = 0
      OTHERS                 = 0.

  CALL METHOD g_tree_server->frontend_update.

ENDFORM.                    " create_hier_server


*&---------------------------------------------------------------------*
*&      Form  create_hier_local
*&---------------------------------------------------------------------*
FORM create_hier_local  USING  p_path        TYPE string
                               p_parent_node TYPE lvc_nkey
                               .
  DATA: lv_pcname         TYPE string,
        lv_key            TYPE lvc_nkey,
        lv_top_node       TYPE lvc_nkey,
        lv_icon_open(4)   TYPE c,
        lv_icon_closed(4) TYPE c,
        lt_dir            TYPE STANDARD TABLE OF tp_al11,
        wa_dir            TYPE tp_al11,
        lv_path           TYPE string,
        lv_has_sons       TYPE c,
        lv_not_found      TYPE char1,
        lv_icon           TYPE aqicon,
        lv_abcde          TYPE syabcde,
        lv_drivetemplate  TYPE char3 VALUE ' :\',
        lv_drivetotest    TYPE string,
        lv_type           TYPE string
        .

  IF p_path IS INITIAL.
*   Get the name of the local PC
    CALL METHOD cl_gui_frontend_services=>get_computer_name
      CHANGING
        computer_name        = lv_pcname
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    CALL METHOD cl_gui_cfw=>flush.

    CONCATENATE 'Local PC' lv_pcname INTO lv_path SEPARATED BY space.
    wa_dir-full_path = 'ROOT'.
    PERFORM add_node_to_tree USING    ''
                                      gc_icon_folder_pc
                                      gc_icon_folder_pc
                                      'X'
                                      wa_dir
                                      lv_path
                                      g_tree_local
                             CHANGING lv_top_node
                                      .
*   Get desktop
    CALL METHOD cl_gui_frontend_services=>get_desktop_directory
      CHANGING
        desktop_directory    = lv_path
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    CALL METHOD cl_gui_cfw=>flush.

    wa_dir-full_path = lv_path.
    lv_path = wa_dir-name = 'Desktop'.
    PERFORM add_node_to_tree USING    lv_top_node
                                      gc_icon_folder_desktop
                                      gc_icon_folder_desktop
                                      'X'
                                      wa_dir
                                      lv_path
                                      g_tree_local
                             CHANGING lv_key
                                      .

*   Add my documents
    CALL METHOD cl_gui_frontend_services=>registry_get_value
      EXPORTING
        root                 = cl_gui_frontend_services=>hkey_current_user
        key                  = 'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' "#EC NOTEXT
        value                = 'Personal'
      IMPORTING
        reg_value            = lv_path
      EXCEPTIONS
        get_regvalue_failed  = 1
        cntl_error           = 2
        error_no_gui         = 3
        not_supported_by_gui = 4
        OTHERS               = 5.
    IF sy-subrc NE 0 OR lv_path IS INITIAL.
      CALL METHOD cl_gui_frontend_services=>registry_get_value
        EXPORTING
          root                 = cl_gui_frontend_services=>hkey_current_user
          key                  = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' "#EC NOTEXT
          value                = 'Personal'
        IMPORTING
          reg_value            = lv_path
        EXCEPTIONS
          get_regvalue_failed  = 1
          cntl_error           = 2
          error_no_gui         = 3
          not_supported_by_gui = 4
          OTHERS               = 5.
    ENDIF.

    wa_dir-full_path = lv_path.
    lv_path = wa_dir-name = 'My Douments'.
    PERFORM add_node_to_tree USING    lv_top_node
                                      gc_icon_folder_my_docs
                                      gc_icon_folder_my_docs
                                      'X'
                                      wa_dir
                                      lv_path
                                      g_tree_local
                             CHANGING lv_key
                                      .

* Get all letters, remove AB which is assumed as floppy disk
    lv_abcde = sy-abcde.
    SHIFT lv_abcde BY 2 PLACES.
    CONDENSE lv_abcde NO-GAPS.

* Check if each letter is mounted
    WHILE lv_abcde IS NOT INITIAL.
      lv_drivetemplate(1) = lv_abcde(1).
      lv_drivetotest = lv_drivetemplate.
      SHIFT lv_abcde BY 1 PLACES.
      CLEAR lv_type.
* Get Drive Type
      CALL METHOD cl_gui_frontend_services=>get_drive_type
        EXPORTING
          drive                = lv_drivetotest
        CHANGING
          drive_type           = lv_type
        EXCEPTIONS
          cntl_error           = 1
          bad_parameter        = 2
          error_no_gui         = 3
          not_supported_by_gui = 4
          OTHERS               = 5.
      IF sy-subrc = 0.
        CALL METHOD cl_gui_cfw=>flush.
* If letter exist on local PC, get drive type
        IF lv_type IS NOT INITIAL.
          CASE lv_type.
            WHEN 'FIXED'.
              lv_path = 'Local Disk (#:)'(c02).
              lv_icon = gc_icon_folder_local.
            WHEN 'CDROM'.
              lv_path = 'CDROM Drive (#:)'(c03).
              lv_icon = gc_icon_folder_cd.
            WHEN 'REMOTE'.
              lv_path = 'Remote Drive (#:)'(c04).
              lv_icon = gc_icon_folder_remote.
            WHEN 'REMOVEABLE'.
              lv_path = 'Removable Drive (#:)'(c05).
              lv_icon = gc_icon_folder_usb.
            WHEN OTHERS.
              ASSERT 1 = 2.
          ENDCASE.
          wa_dir-full_path = lv_drivetotest.
          REPLACE '#' WITH lv_drivetotest+0(1) INTO lv_path.
          PERFORM add_node_to_tree USING    lv_top_node
                                            lv_icon
                                            lv_icon
                                            'X'
                                            wa_dir
                                            lv_path
                                            g_tree_local
                                   CHANGING lv_key
                                            .
        ENDIF.
      ENDIF.
    ENDWHILE.
  ELSE.
    PERFORM read_directory USING    p_path
                                    ''
                           CHANGING lt_dir
                                    lv_not_found
                                    .
    DELETE lt_dir WHERE type <> gc_directory AND type IS NOT INITIAL.
    SORT lt_dir BY type name.
    LOOP AT lt_dir INTO wa_dir.
      PERFORM get_icon USING    wa_dir-type
                                wa_dir-name
                       CHANGING lv_icon_open
                                lv_icon_closed
                                lv_has_sons
                                .
      lv_path = wa_dir-name.
      PERFORM add_node_to_tree USING    p_parent_node
                                        lv_icon_open
                                        lv_icon_closed
                                        lv_has_sons
                                        wa_dir
                                        lv_path
                                        g_tree_local
                               CHANGING lv_key
                                        .
    ENDLOOP.
    lv_top_node = p_parent_node.

  ENDIF.

  CALL METHOD g_tree_local->frontend_update.

  CALL METHOD g_tree_local->expand_node
    EXPORTING
      i_node_key = lv_top_node.

  CALL METHOD g_tree_local->column_optimize
    EXPORTING
      i_include_heading      = gc_x
    EXCEPTIONS
      start_column_not_found = 0
      end_column_not_found   = 0
      OTHERS                 = 0.

  CALL METHOD g_tree_local->frontend_update.

ENDFORM.                    " create_hier_local


*&---------------------------------------------------------------------*
*&      Form  add_node_to_tree
*&---------------------------------------------------------------------*
FORM add_node_to_tree  USING     p_parent_key TYPE lvc_nkey
                                 p_icon_open  TYPE c
                                 p_icon_close TYPE c
                                 p_has_sons   TYPE c
                                 ps_dir       TYPE tp_al11
                                 p_text       TYPE string
                                 tree         TYPE REF TO cl_gui_alv_tree
                       CHANGING  p_node_key   TYPE lvc_nkey
                                  .

  DATA: lv_node_text   TYPE lvc_value,
        ls_node_layout TYPE lvc_s_layn,
        lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi,
        l_handle_line  TYPE i
        .

  lv_node_text              = p_text.
  ls_node_layout-isfolder   = p_has_sons.
  ls_node_layout-expander   = p_has_sons.
  ls_node_layout-n_image    = p_icon_close.
  ls_node_layout-exp_image  = p_icon_open.

  ls_item_layout-fieldname = '&Hierarchy'.
  ls_item_layout-class = cl_gui_column_tree=>item_class_link.
  APPEND ls_item_layout TO lt_item_layout.

  CASE p_icon_open.
    WHEN gc_icon_favorite     OR gc_icon_folder_close   OR gc_icon_folder_open
    OR gc_icon_folder_desktop OR gc_icon_folder_my_docs OR gc_icon_folder_local
    OR gc_icon_folder_cd      OR gc_icon_folder_remote  OR gc_icon_folder_usb
    .
*     allow DROP when it is a FAV FOLDER
      CALL METHOD g_drop_behaviour->get_handle
        IMPORTING
          handle = l_handle_line.
      ls_node_layout-dragdropid = l_handle_line.

  ENDCASE.

  CALL METHOD tree->add_node
    EXPORTING
      i_relat_node_key = p_parent_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = lv_node_text
      it_item_layout   = lt_item_layout
      is_outtab_line   = ps_dir
      is_node_layout   = ls_node_layout
    IMPORTING
      e_new_node_key   = p_node_key.
ENDFORM.                    " add_node_to_tree




*&---------------------------------------------------------------------*
*&      Form  read_directory
*&---------------------------------------------------------------------*
FORM read_directory USING    p_path      TYPE string
                             p_server    TYPE char1
                    CHANGING pt_dir      TYPE tp_zal11_t
                             e_not_found TYPE char1
                             .
  DATA: lv_subrc            TYPE sy-subrc,
        lv_timezone_sec(5)  TYPE p, " seconds local time is later than GMT
        wa_dir              TYPE tp_al11,
        lv_mtime            TYPE p,
        lv_date             TYPE d,
        lv_time(8)          TYPE c,
        lv_timezone_name(7) TYPE c,
        lt_files            TYPE STANDARD TABLE OF file_info,
        lv_count            TYPE i,
        lv_dir              TYPE dirname,
        lv_name             TYPE filename75
        .
  FIELD-SYMBOLS: <file> TYPE file_info.

  CLEAR: e_not_found, pt_dir.
  IF p_server = 'X'.
    CALL 'C_DIR_READ_FINISH'
          ID 'ERRNO'  FIELD wa_dir-errno
          ID 'ERRMSG' FIELD wa_dir-errmsg.

    lv_dir = p_path.
    CALL 'C_DIR_READ_START'
          ID 'DIR'    FIELD lv_dir
          ID 'FILE'   FIELD '*'
          ID 'ERRNO'  FIELD wa_dir-errno
          ID 'ERRMSG' FIELD wa_dir-errmsg
          .
    IF sy-subrc <> 0.
      CALL 'C_DIR_READ_FINISH'
            ID 'ERRNO'  FIELD wa_dir-errno
            ID 'ERRMSG' FIELD wa_dir-errmsg.
      e_not_found = 'X'.
      EXIT.
    ENDIF.
    wa_dir-dirname = lv_dir.
    WHILE lv_subrc IS INITIAL.
      CLEAR wa_dir.

      CALL 'C_DIR_READ_NEXT'
            ID 'TYPE'   FIELD wa_dir-type
            ID 'NAME'   FIELD lv_name
            ID 'LEN'    FIELD wa_dir-len
            ID 'OWNER'  FIELD wa_dir-owner
            ID 'MTIME'  FIELD lv_mtime
            ID 'MODE'   FIELD wa_dir-umode
            ID 'ERRNO'  FIELD wa_dir-errno
            ID 'ERRMSG' FIELD wa_dir-errmsg.
      IF sy-subrc = 0.
      ELSEIF sy-subrc EQ 3 OR sy-subrc = 5.
        CLEAR sy-subrc.
      ELSEIF sy-subrc = 1.
        EXIT.
      ELSE.
        CONTINUE.
      ENDIF.
      wa_dir-name = lv_name.
      lv_subrc = sy-subrc.
      IF sy-subrc <> 0.
        CALL 'C_DIR_READ_FINISH'
              ID 'ERRNO'  FIELD wa_dir-errno
              ID 'ERRMSG' FIELD wa_dir-errmsg.
      ELSE.
        IF wa_dir-name = '.' OR wa_dir-name = '..'.
          CONTINUE.
        ENDIF.
        IF wa_dir-type = gc_directory.
          CLEAR wa_dir-len.
        ELSE.
          CLEAR wa_dir-type.
        ENDIF.
*     prepare time zone correction.
        CALL 'C_GET_TIMEZONE' ID 'NAME' FIELD lv_timezone_name
              ID 'SEC'  FIELD lv_timezone_sec.

        lv_timezone_sec  = 0 - sy-tzone.
        IF sy-dayst = 'X'.
          SUBTRACT 3600 FROM lv_timezone_sec.
        ENDIF.
        PERFORM p6_to_date_time IN PROGRAM rstr0400
                                USING lv_mtime
                                      lv_timezone_sec
                                      lv_time
                                      lv_date.
        REPLACE ':' WITH '' INTO lv_time.
        REPLACE ':' WITH '' INTO lv_time.
        CONDENSE lv_time NO-GAPS.

        MOVE lv_date TO wa_dir-mod_date.
        MOVE lv_time TO wa_dir-mod_time.
        wa_dir-dirname = p_path.
        CONCATENATE wa_dir-dirname
                    gv_delimiter
                    wa_dir-name
                    INTO wa_dir-full_path.
        APPEND wa_dir TO pt_dir.
      ENDIF.
    ENDWHILE.
  ELSE.
*   Get Folders in a Given Directory
    CALL METHOD cl_gui_frontend_services=>directory_list_files
      EXPORTING
        directory                   = p_path
      CHANGING
        file_table                  = lt_files
        count                       = lv_count
      EXCEPTIONS
        cntl_error                  = 1
        directory_list_files_failed = 2
        wrong_parameter             = 3
        error_no_gui                = 4
        not_supported_by_gui        = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    DELETE lt_files WHERE issystem = 1 OR ishidden = 1.
    LOOP AT lt_files ASSIGNING <file>.
      CLEAR wa_dir.
      wa_dir-dirname = wa_dir-name = <file>-filename.
      IF <file>-isdir = 1.
        wa_dir-type = gc_directory.
      ELSE.
        wa_dir-len = <file>-filelength.
      ENDIF.

      wa_dir-mod_date = <file>-createdate.
      wa_dir-mod_time = <file>-createtime.
      wa_dir-dirname = p_path.
      CONCATENATE wa_dir-dirname
                  gv_delimiter_local
                  wa_dir-name
                  INTO wa_dir-full_path.
      APPEND wa_dir TO pt_dir.
    ENDLOOP.
  ENDIF.

  SORT pt_dir BY type DESCENDING name.

ENDFORM.                    " read_directory




*&---------------------------------------------------------------------*
*&      Form  define_DND_behaviour
*&---------------------------------------------------------------------*
FORM define_dnd_behaviour.

  DATA: lv_effect   TYPE i.

  CREATE OBJECT g_drag_behaviour.
  lv_effect = cl_dragdrop=>move + cl_dragdrop=>copy.

  CALL METHOD g_drag_behaviour->add
    EXPORTING
      flavor     = 'FILE'                                   "#EC NOTEXT
      dragsrc    = 'X'
      droptarget = ' '
      effect     = lv_effect.

  CREATE OBJECT g_drop_behaviour.
  CALL METHOD g_drop_behaviour->add
    EXPORTING
      flavor     = 'FILE'                                   "#EC NOTEXT
      dragsrc    = ' '
      droptarget = 'X'
      effect     = lv_effect.

ENDFORM.                    " define_DND_behaviour



*&---------------------------------------------------------------------*
*&      Form  get_icon
*&---------------------------------------------------------------------*
FORM get_icon USING    p_dir_type     TYPE c
                       p_dir_name     TYPE string
              CHANGING p_icon_open    TYPE c
                       p_icon_closed  TYPE c
                       p_has_sons     TYPE c
                       .

  DATA: lv_file TYPE string,                                "#EC NEEDED
        lv_ext  TYPE string
        .
  CASE p_dir_type.
    WHEN gc_directory.
      p_has_sons    = gc_has_sons.
      p_icon_open   = gc_icon_folder_open.
      p_icon_closed = gc_icon_folder_close.
    WHEN OTHERS.
*     get file type
      lv_ext = p_dir_name.
      DO.
        IF NOT lv_ext CA '.'.
          EXIT.
        ENDIF.
        SPLIT lv_ext AT '.'
        INTO lv_file lv_ext.
      ENDDO.
      TRANSLATE lv_ext TO UPPER CASE.
      CASE lv_ext.
        WHEN 'XLS'.
          p_icon_open   = gc_icon_excel.
          p_icon_closed = gc_icon_excel.
        WHEN 'HTM' OR 'HTML'.
          p_icon_open   = gc_icon_html.
          p_icon_closed = gc_icon_html.
        WHEN 'DOC' OR 'DOT' OR 'RTF'.
          p_icon_open   = gc_icon_word.
          p_icon_closed = gc_icon_word.
        WHEN 'PPS' OR 'PPT'.
          p_icon_open   = gc_icon_ppt.
          p_icon_closed = gc_icon_ppt.
        WHEN 'ZIP'.
          p_icon_open   = gc_icon_zip.
          p_icon_closed = gc_icon_zip.
        WHEN 'PDF'.
          p_icon_open   = gc_icon_pdf.
          p_icon_closed = gc_icon_pdf.
        WHEN 'VSD'.
          p_icon_open   = gc_icon_vsd.
          p_icon_closed = gc_icon_vsd.
        WHEN OTHERS.
          p_icon_open   = gc_icon_file.
          p_icon_closed = gc_icon_file.
      ENDCASE.
      p_has_sons = space.
  ENDCASE.

ENDFORM.                    " get_icon



*&---------------------------------------------------------------------*
*&      Form  create_hier_fav
*&---------------------------------------------------------------------*
FORM create_hier_fav USING p_server TYPE char1.

  TYPES: BEGIN OF tp_string,
           path TYPE string,
           numb TYPE tvarvc-numb,
         END OF tp_string.

  DATA: wa_dir    TYPE tp_al11,
        lt_param  TYPE STANDARD TABLE OF tvarvc,
        lv_name   TYPE rvari_vnam,
        lv_key    TYPE lvc_nkey,
        lv_text   TYPE string,
        lv_mod    TYPE i,
        lt_string TYPE STANDARD TABLE OF tp_string,
        ls_string TYPE tp_string
        .
  FIELD-SYMBOLS: <param>   TYPE tvarvc,
                 <tree>    TYPE REF TO cl_gui_alv_tree,
                 <fav_key> TYPE lvc_nkey,
                 <string>  TYPE tp_string
                 .
  IF p_server = 'X'.
    CONCATENATE 'ZAL11_FAV_S_' sy-uname INTO lv_name.
    ASSIGN g_tree_server TO <tree>.
    ASSIGN gv_fav_key_server TO <fav_key>.
  ELSE.
    CONCATENATE 'ZAL11_FAV_L_' sy-uname INTO lv_name.
    ASSIGN g_tree_local TO <tree>.
    ASSIGN gv_fav_key_local TO <fav_key>.
  ENDIF.

  PERFORM add_node_to_tree USING    ''
                                    gc_icon_folder_fav
                                    gc_icon_folder_fav
                                    ''
                                    wa_dir
                                    'Favorites'(fav)
                                    <tree>
                           CHANGING <fav_key>
                           .
  SELECT * FROM tvarvc
          INTO TABLE lt_param
          WHERE name = lv_name
          .
  CHECK sy-subrc IS INITIAL.

  LOOP AT lt_param ASSIGNING <param>.
    lv_mod = <param>-numb MOD 10.
    IF lv_mod IS INITIAL.
      ls_string-numb = <param>-numb.
      IF ls_string-path IS NOT INITIAL.
        APPEND ls_string TO lt_string.
        CLEAR ls_string.
      ENDIF.
    ENDIF.
    CONCATENATE ls_string-path <param>-low <param>-high
                INTO ls_string-path.
  ENDLOOP.
  APPEND ls_string TO lt_string.

  LOOP AT lt_string ASSIGNING <string>.
    wa_dir-dirname = gv_main_dir.
    wa_dir-full_path = <string>-path.
    wa_dir-numb = <string>-numb.
    wa_dir-name = lv_text = wa_dir-full_path.
    PERFORM add_node_to_tree USING    <fav_key>
                                      gc_icon_favorite
                                      gc_icon_favorite
                                      'X'
                                      wa_dir
                                      lv_text
                                      <tree>
                             CHANGING lv_key
                                    .
  ENDLOOP.

  CALL METHOD <tree>->expand_node
    EXPORTING
      i_node_key = <fav_key>.

ENDFORM.                    " create_hier_server_fav



*&---------------------------------------------------------------------*
*&      Form  UPDATE_DIR_FILES
*&---------------------------------------------------------------------*
FORM update_dir_files USING p_server     TYPE char1
                            p_parent_dir TYPE string
                            .

  DATA: ls_layo        TYPE lvc_s_layo,
        lt_fcat        TYPE lvc_t_fcat,
        handle_drag    TYPE i,
        event_receiver TYPE REF TO lcl_grid_evt_rcv,
        l_dnd_evt_rcv  TYPE REF TO lcl_dnd_evt_rcv,
        lv_not_found   TYPE char1,
        lv_dummy       TYPE string,                         "#EC NEEDED
        lv_ext         TYPE string
        .

  FIELD-SYMBOLS: <fcat>     TYPE lvc_s_fcat,
                 <grid>     TYPE REF TO cl_gui_alv_grid,
                 <cont>     TYPE REF TO cl_gui_container,
                 <dir>      TYPE STANDARD TABLE,
                 <file>     LIKE LINE OF gt_dir_local,
                 <last_dir> TYPE string
                 .

  IF p_server = 'X'.
    ASSIGN g_alv_grid_server TO <grid>.
    ASSIGN g_split_sr TO <cont>.
    ASSIGN gt_dir_server TO <dir>.
    ASSIGN gv_last_dir_server TO <last_dir>.
    ls_layo-countfname = 'GT_DIR_SERVER'.
  ELSE.
    ASSIGN g_alv_grid_local TO <grid>.
    ASSIGN g_split_lr TO <cont>.
    ASSIGN gt_dir_local TO <dir>.
    ASSIGN gv_last_dir_local TO <last_dir>.
    ls_layo-countfname = 'GT_DIR_LOCAL'.
  ENDIF.

  PERFORM read_directory USING    <last_dir>
                                  p_server
                         CHANGING <dir>
                                  lv_not_found
                                  .
  IF p_parent_dir IS NOT INITIAL.
    INSERT INITIAL LINE INTO <dir> INDEX 1 ASSIGNING <file>.
    <file>-name = '..'.
    <file>-type = gc_directory.
  ENDIF.
  LOOP AT <dir> ASSIGNING <file>.                           "#EC GEN_OK
    IF <file>-type = gc_directory.
      <file>-icon = gc_icon_folder_close.
    ELSE.
      SPLIT <file>-name AT '.' INTO lv_dummy lv_ext.
      TRANSLATE lv_ext TO UPPER CASE.
      CASE lv_ext.
        WHEN 'XLS' OR 'XLSX' OR 'LNK'.
          <file>-icon = gc_icon_excel.
        WHEN 'HTM' OR 'HTML' OR 'XML'.
          <file>-icon = gc_icon_html.
        WHEN 'DOC' OR 'DOT' OR 'RTF' OR 'DOCX'.
          <file>-icon = gc_icon_word.
        WHEN 'PPS' OR 'PPT' OR 'PPTX'.
          <file>-icon = gc_icon_ppt.
        WHEN 'ZIP'.
          <file>-icon = gc_icon_zip.
        WHEN 'PDF'.
          <file>-icon = gc_icon_pdf.
        WHEN 'VSD' OR 'VSDX'.
          <file>-icon = gc_icon_vsd.
        WHEN 'TXT' OR 'TRC'.
          <file>-icon = gc_icon_text.
        WHEN 'JPG' OR 'JPEG' OR 'BMP'.
          <file>-icon = gc_icon_gif.
        WHEN OTHERS.
          <file>-icon = gc_icon_file.
      ENDCASE.
    ENDIF.
  ENDLOOP.

  ls_layo-zebra      =
  ls_layo-no_rowmark = ls_layo-smalltitle = ls_layo-col_opt = 'X'.
  ls_layo-grid_title = <last_dir>.

  CALL METHOD g_drag_behaviour->get_handle
    IMPORTING
      handle = handle_drag.
  ls_layo-s_dragdrop-row_ddid = handle_drag.

  IF <grid> IS INITIAL.
*   Build the container where the files are to be
    CREATE OBJECT <grid>
      EXPORTING
        i_parent = <cont>.

    PERFORM build_fieldcat USING    ''
                           CHANGING lt_fcat
                           .
    LOOP AT lt_fcat ASSIGNING <fcat>.
      CASE <fcat>-fieldname.
        WHEN 'DIRNAME' OR 'TYPE' OR 'OWNER' OR 'FULL_PATH' OR 'ERRNO'
        OR 'ERRMSG'  OR 'MODE'.
          <fcat>-tech = 'X'.
        WHEN 'ICON'.
          <fcat>-icon = 'X'.
        WHEN OTHERS.
          <fcat>-col_opt = 'X'.
      ENDCASE.
    ENDLOOP.

    CALL METHOD <grid>->set_table_for_first_display
      EXPORTING
        is_layout       = ls_layo
      CHANGING
        it_outtab       = <dir>
        it_fieldcatalog = lt_fcat.

    CREATE OBJECT event_receiver.
    SET HANDLER event_receiver->handle_user_command
    event_receiver->handle_menu_button
    event_receiver->handle_double_click
    event_receiver->handle_toolbar FOR <grid>.
    CALL METHOD <grid>->set_toolbar_interactive.

    CREATE OBJECT l_dnd_evt_rcv.
    SET HANDLER l_dnd_evt_rcv->handle_alv_drag FOR <grid>.

  ELSE.
    CALL METHOD <grid>->refresh_table_display.
    CALL METHOD <grid>->set_frontend_layout
      EXPORTING
        is_layout = ls_layo.
  ENDIF.

ENDFORM.                    " UPDATE_DIR_FILES



*&---------------------------------------------------------------------*
*&      Form  UPLOAD_FILE
*&---------------------------------------------------------------------*
FORM upload_file USING p_source TYPE string
                       p_dest   TYPE string
                       .

  DATA: lv_file_load TYPE string,
        lv_file2     TYPE rlgrap-filename,
        lt_data      TYPE STANDARD TABLE OF string,
        wa_dir       TYPE tp_al11,
        lt_dir       TYPE STANDARD TABLE OF tp_al11,
        lv_phyfile   TYPE rlgrap-filename,
        lv_new_path  TYPE rlgrap-filename,
        lv_ans       TYPE c,
        lv_not_found TYPE char1,
        lv_str       TYPE string,
        lt_bin       TYPE TABLE OF x255,
        lv_len       TYPE i,
        lv_file_len  TYPE i
        .
* get the download location
  IF p_source IS INITIAL.
    PERFORM get_file_dialog USING    'Document Upload'(t04)
                                     ''
                                     ''
                            CHANGING lv_file_load
                            .
  ELSE.
    lv_file_load = p_source.
  ENDIF.
  CHECK lv_file_load IS NOT INITIAL.

* get the filename
  CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = lv_file_load
    IMPORTING
      stripped_name = lv_phyfile
      file_path     = lv_new_path
    EXCEPTIONS
      x_error       = 0
      OTHERS        = 0.
* check if there is a file with the same name in the current dir
  PERFORM read_directory USING    gv_last_dir_server
                                  'X'
                         CHANGING lt_dir
                                  lv_not_found
                                  .
  SORT lt_dir BY type name.
  READ TABLE lt_dir INTO wa_dir WITH KEY name = lv_phyfile. "#EC *
* same file is found. ask to overwrite
  IF sy-subrc IS INITIAL.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'File Upload Confirmation'(t05)
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

  IF trans_mode IS INITIAL.
    PERFORM get_transfer_mode USING lv_phyfile.
  ENDIF.

* upload file to memory
  CASE trans_mode.
    WHEN '' OR gc_ascii.
      CALL METHOD cl_gui_frontend_services=>gui_upload
        EXPORTING
          filename                = lv_file_load
        CHANGING
          data_tab                = lt_data
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          OTHERS                  = 17.
      IF sy-subrc <> 0.
        MESSAGE e048(gc) WITH lv_phyfile.
      ENDIF.
  ENDCASE.

  IF trans_mode = gc_binary.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = lv_file_load
        filetype                = gc_binary
      IMPORTING
        filelength              = lv_file_len
      CHANGING
        data_tab                = lt_bin
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        OTHERS                  = 17.
  ENDIF.

* download file to SAP server
  IF p_dest IS NOT INITIAL.
    lv_file2 = p_dest.
  ELSE.
    CONCATENATE gv_last_dir_server
                gv_delimiter
                lv_phyfile
                INTO lv_file2.
  ENDIF.


  CASE trans_mode.
    WHEN gc_ascii.
      OPEN DATASET lv_file2 FOR OUTPUT
                   IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE s117(lx) WITH lv_file2.
        EXIT.
      ENDIF.
      LOOP AT lt_data INTO lv_str.
        TRANSFER lv_str TO lv_file2.
      ENDLOOP.

    WHEN gc_binary.
      OPEN DATASET lv_file2 FOR OUTPUT IN BINARY MODE.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE s117(lx) WITH lv_file2.
        EXIT.
      ENDIF.
      LOOP AT lt_bin ASSIGNING FIELD-SYMBOL(<bin>).
        TRANSFER <bin> TO lv_file2.
      ENDLOOP.
  ENDCASE.

  CLOSE DATASET lv_file2.

  MESSAGE s006(alsmex) WITH lv_phyfile.

  PERFORM update_dir_files USING 'X' ''.

ENDFORM.                    " UPLOAD_FILE



*&---------------------------------------------------------------------*
*&      Form  GET_TRANSFER_MODE
*&---------------------------------------------------------------------*
FORM get_transfer_mode USING p_file TYPE rlgrap-filename.

  DATA: lv_ext   TYPE string.

  PERFORM get_file_ext USING    p_file
                       CHANGING lv_ext
                       .
  CASE lv_ext.
    WHEN 'SAP' OR 'DOC' OR 'CAT' OR 'DLL' OR 'DRV' OR 'TTF' OR 'EXE'
      OR 'PPT' OR 'PPTX' OR 'TIF' OR 'ICO' OR 'GIF' OR 'BMP' OR 'JPG'
      OR 'JPEG' OR 'OTF' OR 'VSD' OR 'VSDX' OR 'AVI' OR 'WAV' OR 'ZIP'
      OR 'RAR' OR 'SND' OR 'MP3' OR 'JAR' OR 'PDF' OR 'N8D'.
      trans_mode = gc_binary.
    WHEN OTHERS.
      trans_mode = gc_ascii.
  ENDCASE.
ENDFORM.                    " GET_TRANSFER_MODE



*&---------------------------------------------------------------------*
*&      Form  get_file_ext
*&---------------------------------------------------------------------*
FORM get_file_ext USING    p_file TYPE rlgrap-filename
                  CHANGING p_ext  TYPE string
                  .

  DATA: lv_dummy TYPE string.

  lv_dummy = p_file.
  DO.
    SPLIT lv_dummy AT '.' INTO lv_dummy p_ext.
    IF p_ext CS '.'.
      lv_dummy = p_ext.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  TRANSLATE p_ext TO UPPER CASE.

ENDFORM.                    " GET_TRANSFER_MODE



*&---------------------------------------------------------------------*
*& Form get_file_dialog
*&---------------------------------------------------------------------*
FORM get_file_dialog USING ip_window_title TYPE  string
                           ip_save  TYPE  char1
                           ip_default_file_name TYPE string
                     CHANGING ep_file TYPE  string
                     .

  DATA: lt_file_table            TYPE filetable WITH HEADER LINE,
        lv_file_path_memory(250) TYPE c,  " path for SAP memory
        lv_file_path_length      TYPE i,       " length of the file_path
        l_rc                     TYPE i,
        lv_action                TYPE i,
        lv_file_name             TYPE string,
        lv_file_path             TYPE string,
        lv_file                  TYPE char255
        .

* check if path variable is set
  GET PARAMETER ID 'OAP' FIELD lv_file.
  lv_file_path = lv_file.

* decide on the open/save method
  IF ip_save IS INITIAL.
* open file dialog
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = ip_window_title
        initial_directory       = lv_file_path
      CHANGING
        file_table              = lt_file_table[]
        rc                      = l_rc
        user_action             = lv_action
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        OTHERS                  = 4.
    CASE sy-subrc.
      WHEN 1.
        RAISE file_open_dialog_failed .
      WHEN 2.
        RAISE cntl_error              .
      WHEN 3.
        RAISE error_no_gui            .
      WHEN 4.
        RAISE others                  .
    ENDCASE.
  ELSE.
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title      = ip_window_title
        initial_directory = lv_file_path
        default_file_name = ip_default_file_name
      CHANGING
        filename          = lv_file_name
        path              = lv_file_path
        fullpath          = ep_file
        user_action       = lv_action
      EXCEPTIONS
        cntl_error        = 1
        error_no_gui      = 2
        OTHERS            = 3.
    lv_file_name = lv_file_name.
  ENDIF.

  IF lv_action = cl_gui_frontend_services=>action_cancel.
    RAISE action_canceled.
  ENDIF.

* split filename
  READ TABLE lt_file_table INDEX 1.
  IF sy-subrc IS INITIAL.
    ep_file      = lt_file_table.
    lv_file_name = lt_file_table.
    PERFORM split_path(oaall) USING lv_file_name
                                    lv_file_path
                                    lv_file_name
                                    .
  ENDIF.

* set new file_path to SAP memory
  lv_file_path_length = strlen( lv_file_path ).

  IF lv_file_path <> space AND lv_file_path_length < 250.
    lv_file_path_memory = lv_file_path.
    SET PARAMETER ID 'OAP' FIELD lv_file_path_memory.
  ELSE.
    lv_file_path_memory = space.
    SET PARAMETER ID 'OAP' FIELD lv_file_path_memory.
  ENDIF.

ENDFORM.
