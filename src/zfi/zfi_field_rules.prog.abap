*&---------------------------------------------------------------------*
*& Report ZFI_FIELD_RULES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_field_rules.

TYPES: BEGIN OF tp_data.
         INCLUDE STRUCTURE zfi_field_rules.
TYPES:   upd_flg  TYPE char1,
         open_exp TYPE icon_d,
       END OF tp_data.

DATA: gt_data        TYPE STANDARD TABLE OF tp_data,
      gt_rule        TYPE STANDARD TABLE OF tp_data,
      gs_rule        TYPE tp_data,
      gt_except      TYPE STANDARD TABLE OF tp_data,
      gt_comp        TYPE abap_compdescr_tab,
      g_dock         TYPE REF TO cl_gui_docking_container,
      g_splitter     TYPE REF TO cl_gui_easy_splitter_container,
      g_split_rule   TYPE REF TO cl_gui_container,
      g_split_except TYPE REF TO cl_gui_container,
      gv_progid      LIKE sy-repid,
      gv_dynnr       TYPE sy-dynnr,
      gr_rule        TYPE REF TO cl_salv_table,
      gr_except      TYPE REF TO cl_salv_table,
      gv_error       TYPE char1
      .
FIELD-SYMBOLS: <rule> TYPE tp_data.

CLASS lcl_events_rule DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_salv_gui_om_edit_strct_lstr.
    METHODS:
      on_link_click_rule FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column,
      on_user_command FOR EVENT added_function OF cl_salv_events_table
        IMPORTING e_salv_function.

  PRIVATE SECTION.
    METHODS: show_exceptions,
      update_exceptions
      .
ENDCLASS.                    "lcl_events DEFINITION

CLASS lcl_events_except DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_salv_gui_om_edit_strct_lstr.
    METHODS:
      on_link_click_except FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column,
      on_user_command FOR EVENT added_function OF cl_salv_events_table
        IMPORTING e_salv_function.

  PRIVATE SECTION.

ENDCLASS.                    "lcl_events_except DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_events_except IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_events_except IMPLEMENTATION.

  METHOD if_salv_gui_om_edit_strct_lstr~on_check_changed_data.
*https://community.sap.com/t5/application-development-and-automation-blog-posts/handling-data-changed-event-in-the-editable-salv-grid/ba-p/13559428

    FIELD-SYMBOLS: <field> TYPE any.

    o_ui_data_modify->get_ui_changes( IMPORTING t_modified_cells = DATA(lt_modified) ).
    CHECK lt_modified IS NOT INITIAL.

    LOOP AT lt_modified ASSIGNING FIELD-SYMBOL(<mod>)
                   GROUP BY ( value = <mod>-row_id )
                              INTO DATA(lt_group).
      LOOP AT GROUP lt_group ASSIGNING FIELD-SYMBOL(<grp>).
        READ TABLE gt_except ASSIGNING FIELD-SYMBOL(<exc>)
                   INDEX <grp>-row_id.
        "get the corresponding line in the data table
        IF <exc>-exc_productcode_cob    IS NOT INITIAL OR
           <exc>-exc_pricingelement_cob IS NOT INITIAL OR
           <exc>-exc_clientcode_cob     IS NOT INITIAL OR
           <exc>-exc_vehicleno_cob      IS NOT INITIAL.
          READ TABLE gt_data ASSIGNING FIELD-SYMBOL(<data>)
                     WITH KEY trans_type             = <exc>-trans_type
                              fsg_code               = <exc>-fsg_code
                              field_name             = <exc>-field_name
                              exc_bukrs              = <exc>-exc_bukrs
                              exc_productcode_cob    = <exc>-exc_productcode_cob
                              exc_pricingelement_cob = <exc>-exc_pricingelement_cob
                              exc_clientcode_cob     = <exc>-exc_clientcode_cob
                              exc_vehicleno_cob      = <exc>-exc_vehicleno_cob
                              .
          IF sy-subrc IS INITIAL.
            <data>-upd_flg = 'D'.
          ENDIF.
        ENDIF.
        ASSIGN COMPONENT <grp>-fieldname OF STRUCTURE <exc> TO <field>.
        <field> = <grp>-value.
        IF <exc>-upd_flg <> 'I'.
          <exc>-upd_flg = 'U'.
        ENDIF.
        o_ui_data_modify->modify_cell_value( row_id     = <grp>-row_id
                                             fieldname  = <grp>-fieldname
                                             cell_value = <grp>-value ).
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD on_user_command.

    CASE e_salv_function.
      WHEN 'ADD_EXCEPT'.
        APPEND gs_rule TO gt_except ASSIGNING FIELD-SYMBOL(<exp>).
        <exp>-upd_flg = 'I'.
        gr_except->refresh( ).

      WHEN 'DEL_EXCEPT'.
        DATA(lt_rows) = gr_except->get_selections( )->get_selected_rows( ).
        SORT lt_rows DESCENDING.
        LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<row>).
          READ TABLE gt_except INDEX <row> ASSIGNING <exp>.
          IF <exp>-upd_flg = 'I'.
            DELETE gt_except INDEX <row>.
          ELSE.
            READ TABLE gt_data ASSIGNING FIELD-SYMBOL(<data>)
                 WITH KEY trans_type             = <exp>-trans_type
                          fsg_code               = <exp>-fsg_code
                          field_name             = <exp>-field_name
                          exc_bukrs              = <exp>-exc_bukrs
                          exc_clientcode_cob     = <exp>-exc_clientcode_cob
                          exc_pricingelement_cob = <exp>-exc_pricingelement_cob
                          exc_productcode_cob    = <exp>-exc_productcode_cob
                          exc_vehicleno_cob      = <exp>-exc_vehicleno_cob.
            <data>-upd_flg = 'D'.
            DELETE gt_except INDEX <row>.
          ENDIF.
        ENDLOOP.
        gr_except->refresh( ).
    ENDCASE.

  ENDMETHOD.

  METHOD if_salv_gui_om_edit_strct_lstr~on_f4_request.
  ENDMETHOD.

  METHOD on_link_click_except.

    DATA: lo_column TYPE REF TO cl_salv_column_table,
          lr_struct TYPE REF TO cl_abap_structdescr
          .
    READ TABLE gt_except ASSIGNING FIELD-SYMBOL(<exp>) INDEX row.

    CASE column.
      WHEN 'REQUIRED' OR 'LOOKUP_VALIDATED'.
        ASSIGN COMPONENT column OF STRUCTURE <exp> TO FIELD-SYMBOL(<field>).
        IF <field> IS INITIAL.
          <field> = abap_true.
          IF column = 'LOOKUP_VALIDATED'.
            <exp>-required = abap_true.
          ENDIF.
        ELSE.
          CLEAR <field>.
        ENDIF.
        IF <exp>-upd_flg = 'I'.
          "Do nothing. we are updating an inserted entry
        ELSE.
          <exp>-upd_flg = 'U'.
        ENDIF.

        gr_except->refresh( ).
    ENDCASE.

  ENDMETHOD.                    "on_link_click_execpt

ENDCLASS.                    "lcl_events_except IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_events_rule IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_events_rule IMPLEMENTATION.

  METHOD if_salv_gui_om_edit_strct_lstr~on_check_changed_data.
    "more info on this listerner at:
    "https://community.sap.com/t5/application-development-and-automation-blog-posts/handling-data-changed-event-in-the-editable-salv-grid/ba-p/13559428

    FIELD-SYMBOLS: <field> TYPE any.

    "This method will change one of the key fields. the checkboxes are not key fields and are not changed in this method.
    o_ui_data_modify->get_ui_changes( IMPORTING t_modified_cells = DATA(lt_modified) ).
    CHECK lt_modified IS NOT INITIAL.
    LOOP AT lt_modified ASSIGNING FIELD-SYMBOL(<mod>)
                   GROUP BY ( value = <mod>-row_id )
                              INTO DATA(lt_group).
      LOOP AT GROUP lt_group ASSIGNING FIELD-SYMBOL(<grp>).
        READ TABLE gt_rule ASSIGNING <rule>
                   INDEX <grp>-row_id.
        LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<data>)
                WHERE trans_type = <rule>-trans_type
                  AND fsg_code   = <rule>-fsg_code
                  AND field_name = <rule>-field_name
                  .
*          ASSIGN COMPONENT <grp>-fieldname OF STRUCTURE <data> TO <field>.
*          <field> = to_upper( <grp>-value ).
          <data>-upd_flg = 'D'.
        ENDLOOP.
        ASSIGN COMPONENT <grp>-fieldname OF STRUCTURE <rule> TO <field>.
        <field> = <grp>-value.
        <rule>-upd_flg = 'I'.
        o_ui_data_modify->modify_cell_value( row_id     = <grp>-row_id
                                             fieldname  = <grp>-fieldname
                                             cell_value = <grp>-value ).
      ENDLOOP.
      IF <rule>-field_name IS NOT INITIAL.
        LOOP AT gt_rule TRANSPORTING NO FIELDS
                FROM ( <grp>-row_id + 1 )
             WHERE trans_type = <rule>-trans_type
               AND fsg_code = <rule>-fsg_code
               AND field_name = <rule>-field_name.
          EXIT.
        ENDLOOP.
        IF sy-subrc IS INITIAL.
          o_ui_edit_protocol->add_protocol_entry( msgid     = 'OIUX4'
                                                  msgty     = 'E'
                                                  msgno     = '007'
                                                  fieldname = 'FIELD_NAME' ). "A record already exists with the same key.
          RETURN.
        ELSE.
          "in case the user chnaged data and then changed back we want to update existing entries or add a new one
          LOOP AT gt_data ASSIGNING <data>
                  WHERE trans_type = <rule>-trans_type
                    AND fsg_code   = <rule>-fsg_code
                    AND field_name = <rule>-field_name
                    .
            <data>-upd_flg = 'I'.
          ENDLOOP.
          IF sy-subrc IS NOT INITIAL.
            APPEND <rule> TO gt_data.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
    "read the line again in order to set it up for the refresh
    READ TABLE gt_rule INTO gs_rule INDEX <grp>-row_id.
    update_exceptions( ).
    IF gr_except IS BOUND.
      gr_except->refresh( ).
    ENDIF.

  ENDMETHOD.

  METHOD on_user_command.

    DATA: lv_count TYPE i,
          lv_ans   TYPE c
          .
    CASE e_salv_function.
      WHEN 'ADD_LINE'.
        INSERT INITIAL LINE INTO gt_rule ASSIGNING <rule> INDEX 1.
        <rule>-upd_flg = 'I'.
        <rule>-open_exp = '@2S@'.
        gr_rule->extended_grid_api( )->editable_restricted( )->set_attributes_for_columnname(
                                                                columnname              = 'FSG_CODE'
                                                                all_cells_input_enabled = abap_true
                                                            ).
        gr_rule->extended_grid_api( )->editable_restricted( )->set_attributes_for_columnname(
                                                                columnname              = 'FIELD_NAME'
                                                                all_cells_input_enabled = abap_true
                                                            ).
        gr_rule->refresh( ).

      WHEN 'DEL_LINE'.
        DATA(lt_rows) = gr_rule->get_selections( )->get_selected_rows( ).
        SORT lt_rows DESCENDING.
        LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<row>).
          CLEAR: lv_count.
          READ TABLE gt_rule INDEX <row> ASSIGNING FIELD-SYMBOL(<data>).
          IF <data>-upd_flg = 'I'.
            DELETE gt_rule INDEX <row>.
          ELSE.
            LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<data2>)
              WHERE trans_type    = <data>-trans_type
                AND fsg_code      = <data>-fsg_code
                AND field_name    = <data>-field_name
                .
              ADD 1 TO lv_count.
            ENDLOOP.
            IF lv_count > 1.
              CALL FUNCTION 'POPUP_TO_CONFIRM'
                EXPORTING
                  text_question         = 'Exceptions Found for the rules to be deleted. Would you like to continue?'
                  default_button        = '2'
                  display_cancel_button = ''
                IMPORTING
                  answer                = lv_ans
                EXCEPTIONS
                  text_not_found        = 0
                  OTHERS                = 0.
              CHECK lv_ans = '1'.
            ENDIF.

            <data>-upd_flg = 'D'.
            LOOP AT gt_data ASSIGNING <data2>
              WHERE trans_type    = <data>-trans_type
                AND fsg_code      = <data>-fsg_code
                AND field_name    = <data>-field_name
                .
              <data2>-upd_flg = 'D'.
            ENDLOOP.
            DELETE gt_rule INDEX <row>.
            CLEAR: gt_except.
          ENDIF.
        ENDLOOP.
        gr_rule->refresh( ).
        IF gr_except IS BOUND.
          gr_except->refresh( ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD if_salv_gui_om_edit_strct_lstr~on_f4_request.
  ENDMETHOD.

  METHOD on_link_click_rule.

    DATA: lt_rows   TYPE salv_t_row.
    FIELD-SYMBOLS: <rule_field> TYPE any.

    APPEND row TO lt_rows.
    gr_rule->get_selections( )->set_selected_rows( lt_rows ).

    CASE column.
      WHEN 'REQUIRED' OR 'LOOKUP_VALIDATED'.
        READ TABLE gt_rule ASSIGNING <rule> INDEX row.
        "check if there are any exceptions for this line and if so, open them up and change them all
        ASSIGN COMPONENT column OF STRUCTURE <rule> TO <rule_field>.
        IF <rule_field> IS INITIAL.
          <rule_field> = abap_true.
          IF column = 'LOOKUP_VALIDATED'.
            <rule>-required = abap_true.
          ENDIF.
        ELSE.
          CLEAR <rule_field>.
        ENDIF.
        IF <rule>-upd_flg = 'I'.
          "Do nothing. we are updating an inserted entry
        ELSE.
          <rule>-upd_flg = 'U'.
        ENDIF.

        LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<data>)
                   WHERE trans_type = <rule>-trans_type
                     AND fsg_code   = <rule>-fsg_code
                     AND field_name = <rule>-field_name.
          ASSIGN COMPONENT column OF STRUCTURE <data> TO FIELD-SYMBOL(<field>).
          <field> = <rule_field>.

          IF <data>-upd_flg = 'I'.
            "Do nothing. we are updating an inserted entry
          ELSE.
            <data>-upd_flg = 'U'.
          ENDIF.
        ENDLOOP.

        gr_rule->refresh( ).

        IF gt_except IS NOT INITIAL.
          update_exceptions( ).
          gr_except->refresh( ).
          PERFORM check_data.
        ENDIF.

      WHEN 'OPEN_EXP'.
        READ TABLE gt_rule INTO gs_rule INDEX row.
        show_exceptions( ).
    ENDCASE.

  ENDMETHOD.                    "on_link_click_rule

  METHOD show_exceptions.

    DATA: lo_column               TYPE REF TO cl_salv_column_table,
          lr_event_handler_except TYPE REF TO lcl_events_except.

    "Before setting up new data, make sure the old one is updated in the main data table and reset.
    PERFORM check_data.
    PERFORM update_data.

    update_exceptions( ).

    IF gr_except IS INITIAL.
      TRY.
          cl_salv_table=>factory( EXPORTING r_container  = g_split_except
                                  IMPORTING r_salv_table = gr_except
                                  CHANGING  t_table      = gt_except
                                          ).
        CATCH cx_salv_msg.
      ENDTRY.

      LOOP AT gt_comp ASSIGNING FIELD-SYMBOL(<comp>).
        lo_column ?= gr_except->get_columns( )->get_column( <comp>-name ).
        CASE <comp>-name.
          WHEN 'EXC_BUKRS' OR 'EXC_PRODUCTCODE_COB' OR 'EXC_PRICINGELEMENT_COB' OR 'EXC_CLIENTCODE_COB' OR 'EXC_VEHICLENO_COB'.
            gr_except->extended_grid_api( )->editable_restricted( )->set_attributes_for_columnname(
                                                                    columnname              = <comp>-name
                                                                    all_cells_input_enabled = abap_true
                                                                ).
          WHEN 'REQUIRED' OR 'LOOKUP_VALIDATED'.
            lo_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
            lo_column->set_alignment( if_salv_c_alignment=>centered ).

          WHEN OTHERS.
            lo_column->set_technical( abap_true ).

        ENDCASE.
      ENDLOOP.

      DATA(lr_events) = gr_except->get_event( ).
      CREATE OBJECT lr_event_handler_except.
      SET HANDLER lr_event_handler_except->on_link_click_except FOR lr_events.
      SET HANDLER lr_event_handler_except->on_user_command      FOR lr_events.

      DATA(mo_edit) = gr_except->extended_grid_api( )->editable_restricted( ).
      DATA(mo_listener) = NEW lcl_events_except( ).
      mo_edit->set_listener( mo_listener ).

      gr_except->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

      gr_except->get_functions( )->add_function( name     = 'ADD_EXCEPT'
                                                 icon     = '@XR@'
                                                 text     = 'Add Exception'
                                                 tooltip  = 'Add Exception'
                                                 position = if_salv_c_function_position=>right_of_salv_functions
                                                ).
      gr_except->get_functions( )->add_function( name     = 'DEL_EXCEPT'
                                                 icon     = '@XR@'
                                                 text     = 'Delete Exception'
                                                 tooltip  = 'Delete Exception'
                                                 position = if_salv_c_function_position=>right_of_salv_functions
                                               ).
      gr_except->get_display_settings( )->set_list_header( 'Exceptions' ).
      gr_except->get_functions( )->set_all( abap_true ).
      gr_except->get_columns( )->set_optimize( abap_true ). "Optimized column width
      gr_except->display( ).
    ELSE.
      gr_except->refresh( ).
    ENDIF.

  ENDMETHOD.

  METHOD update_exceptions.

    gt_except = gt_data.
    DELETE gt_except WHERE trans_type <> gs_rule-trans_type OR
                           fsg_code   <> gs_rule-fsg_code OR
                           field_name <> gs_rule-field_name
                           .
    DELETE gt_except WHERE exc_bukrs              IS INITIAL AND
                           exc_productcode_cob    IS INITIAL AND
                           exc_pricingelement_cob IS INITIAL AND
                           exc_clientcode_cob     IS INITIAL AND
                           exc_vehicleno_cob      IS INITIAL.
  ENDMETHOD.

ENDCLASS.                    "lcl_events IMPLEMENTATION

TABLES: zfi_field_rules.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  SELECT-OPTIONS: s_fstag  FOR zfi_field_rules-fsg_code.
SELECTION-SCREEN END OF BLOCK blk1.
SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-bl2.
  SELECT-OPTIONS: s_bukrs  FOR zfi_field_rules-exc_bukrs,
                  s_prod   FOR zfi_field_rules-exc_productcode_cob,
                  s_price  FOR zfi_field_rules-exc_pricingelement_cob,
                  s_client FOR zfi_field_rules-exc_clientcode_cob,
                  s_vehicl FOR zfi_field_rules-exc_vehicleno_cob
                  .
SELECTION-SCREEN END OF BLOCK blk2.

START-OF-SELECTION.
  PERFORM get_data.
  IF gt_data IS INITIAL.
    MESSAGE s829(63). "No data found
  ELSE.
    CALL SCREEN 100.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR: gt_data, gt_rule, gt_except.

  IF   s_bukrs IS NOT INITIAL OR s_prod IS NOT INITIAL
    OR s_price IS NOT INITIAL OR s_client IS NOT INITIAL
    OR s_vehicl IS NOT INITIAL.
    SELECT * FROM zfi_field_rules
           INTO TABLE gt_data
           WHERE fsg_code               IN s_fstag
             AND exc_bukrs              IN s_bukrs
             AND exc_productcode_cob    IN s_prod
             AND exc_pricingelement_cob IN s_price
             AND exc_clientcode_cob     IN s_client
             AND exc_vehicleno_cob      IN s_vehicl
           ORDER BY fsg_code field_name.
    IF sy-subrc IS INITIAL.
      DELETE ADJACENT DUPLICATES FROM gt_data COMPARING fsg_code field_name.
      SELECT * FROM zfi_field_rules
             INTO TABLE gt_data
             FOR ALL ENTRIES IN gt_data
             WHERE fsg_code = gt_data-fsg_code
               AND field_name = gt_data-field_name
             .
    ENDIF.
  ELSE.
    SELECT * FROM zfi_field_rules
           INTO TABLE gt_data
           WHERE fsg_code IN s_fstag
           .
  ENDIF.
  IF sy-subrc IS INITIAL.
    gt_rule = gt_data.
    DELETE gt_rule WHERE exc_bukrs              IS NOT INITIAL OR
                         exc_productcode_cob    IS NOT INITIAL OR
                         exc_pricingelement_cob IS NOT INITIAL OR
                         exc_clientcode_cob     IS NOT INITIAL OR
                         exc_vehicleno_cob      IS NOT INITIAL.
    LOOP AT gt_rule ASSIGNING FIELD-SYMBOL(<data>).
      <data>-open_exp = '@2S@'. "0F
    ENDLOOP.
  ENDIF.

  SORT gt_data BY trans_type DESCENDING fsg_code field_name.
  LOOP AT gt_data ASSIGNING <data>.
    AT NEW fsg_code.
      CALL FUNCTION 'ENQUEUE_EZFI_FIELD_RULES'
        EXPORTING
          trans_type     = <data>-trans_type
          fsg_code       = <data>-fsg_code
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid  TYPE 'E' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDAT.
  ENDLOOP.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS'.
  SET TITLEBAR  'DEFAULT'.

  IF g_dock IS INITIAL.
    PERFORM init_grid.

    cl_gui_cfw=>flush( ).
  ENDIF.

ENDMODULE.                 " status_0100  OUTPUT



*&---------------------------------------------------------------------*
*&      Form  init_grid
*&---------------------------------------------------------------------*
FORM init_grid.

  DATA: lo_column             TYPE REF TO cl_salv_column_table,
        lr_event_handler_rule TYPE REF TO lcl_events_rule,
        lr_struct             TYPE REF TO cl_abap_structdescr
        .
  gv_dynnr = sy-dynnr.
  gv_progid = sy-repid.
  CREATE OBJECT g_dock
    EXPORTING
*     repid     = gv_progid
*     dynnr     = gv_dynnr
      parent    = cl_gui_container=>default_screen
      side      = g_dock->dock_at_top
      extension = 1000.

  CREATE OBJECT g_splitter
    EXPORTING
      sash_position = 40
      parent        = g_dock
      orientation   = 1.

  g_split_rule   = g_splitter->top_left_container.
  g_split_except = g_splitter->bottom_right_container.

  TRY.
      cl_salv_table=>factory( EXPORTING r_container  = g_split_rule
                              IMPORTING r_salv_table = gr_rule
                              CHANGING  t_table      = gt_rule
                                      ).
    CATCH cx_salv_msg.
  ENDTRY.

  READ TABLE gt_data INDEX 1 ASSIGNING FIELD-SYMBOL(<data>).
  lr_struct ?= cl_abap_typedescr=>describe_by_data( <data> ).
  gt_comp = lr_struct->components .

  LOOP AT gt_comp ASSIGNING FIELD-SYMBOL(<comp>).
    lo_column ?= gr_rule->get_columns( )->get_column( <comp>-name ).
    CASE <comp>-name.
      WHEN 'MANDT' OR 'CONFIGDEPRECATIONCODE' OR 'LAST_CHANGED_AT' OR 'LOCAL_LAST_CHANGED_AT'.
        lo_column->set_technical( abap_true ).

      WHEN 'EXC_BUKRS' OR 'EXC_PRODUCTCODE_COB' OR 'EXC_PRICINGELEMENT_COB' OR 'EXC_CLIENTCODE_COB'
        OR 'EXC_VEHICLENO_COB' OR 'UPD_FLG'.
        lo_column->set_technical( abap_true ).

      WHEN 'REQUIRED' OR 'LOOKUP_VALIDATED'.
        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
        lo_column->set_alignment( if_salv_c_alignment=>centered ).

      WHEN 'OPEN_EXP'.
        lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
        lo_column->set_alignment( if_salv_c_alignment=>centered ).
        lo_column->set_icon( abap_true ).
        lo_column->set_short_text( 'ShowExcptn' ).
        lo_column->set_medium_text( 'Show Exception' ).
        lo_column->set_long_text( 'Show Exception' ).

      WHEN OTHERS.
        gr_rule->extended_grid_api( )->editable_restricted( )->set_attributes_for_columnname(
                                                                columnname              = <comp>-name
                                                                all_cells_input_enabled = abap_true
                                                            ).

    ENDCASE.
  ENDLOOP.

  DATA(lr_events) = gr_rule->get_event( ).
  CREATE OBJECT lr_event_handler_rule.
  SET HANDLER lr_event_handler_rule->on_link_click_rule FOR lr_events.
  SET HANDLER lr_event_handler_rule->on_user_command    FOR lr_events.

  DATA(mo_edit) = gr_rule->extended_grid_api( )->editable_restricted( ).
  DATA(mo_listener) = NEW lcl_events_rule( ).
  mo_edit->set_listener( mo_listener ).
*  mo_edit->set_application_log_container( g_dock ).

  gr_rule->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  gr_rule->get_functions( )->add_function( name     = 'ADD_LINE'
                                           icon     = '@XR@'
                                           text     = 'Add Line'
                                           tooltip  = 'Add Line'
                                           position = if_salv_c_function_position=>right_of_salv_functions
                                         ).
  gr_rule->get_functions( )->add_function( name     = 'DEL_LINE'
                                           icon     = '@XR@'
                                           text     = 'Delete Line'
                                           tooltip  = 'Delete Line'
                                           position = if_salv_c_function_position=>right_of_salv_functions
                                         ).
  TRY.
      gr_rule->get_sorts( )->add_sort( columnname = 'TRANS_TYPE'
                                       sequence = if_salv_c_sort=>sort_down ).
      gr_rule->get_sorts( )->add_sort( columnname = 'FSG_CODE' ).
      gr_rule->get_sorts( )->add_sort( columnname = 'FIELD_NAME' ).
      gr_rule->get_display_settings( )->set_list_header( 'Field Rules' ).
      gr_rule->get_functions( )->set_all( abap_true ).
      gr_rule->get_columns( )->set_optimize( ). "Optimized column width
    CATCH cx_salv_data_error.
    CATCH cx_salv_existing.
    CATCH cx_salv_not_found.
  ENDTRY.
  gr_rule->display( ).

ENDFORM.                               " init_grid



*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'CANC' OR 'BACK' OR 'QUIT'.
      PERFORM exit_program.

    WHEN 'SAVE'.
      PERFORM save_data.
  ENDCASE.

ENDMODULE.                 " user_command_0100  INPUT



*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
FORM save_data .

  DATA: lt_data  TYPE STANDARD TABLE OF tp_data,
        lt_rules TYPE STANDARD TABLE OF zfi_field_rules
        .
  PERFORM check_data.
  CHECK gv_error IS INITIAL.

  PERFORM update_data.

  DO 3 TIMES.
    CASE sy-index.
      WHEN 1.
        DATA(lv_update) = 'I'.
      WHEN 2.
        lv_update = 'U'.
      WHEN 3.
        lv_update = 'D'.
    ENDCASE.
    CLEAR: lt_rules.

    lt_data = gt_data.
    DELETE lt_data WHERE upd_flg <> lv_update.
    CHECK lt_data IS NOT INITIAL.
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<data>).
      APPEND <data> TO lt_rules.
    ENDLOOP.

    CASE sy-index.
      WHEN 1.
        INSERT zfi_field_rules FROM TABLE lt_rules.
      WHEN 2.
        MODIFY zfi_field_rules FROM TABLE lt_rules.
      WHEN 3.
        DELETE zfi_field_rules FROM TABLE lt_rules.
    ENDCASE.
  ENDDO.
  PERFORM get_data.
  gr_rule->refresh( ).
  IF gr_except IS BOUND.
    gr_except->refresh( ).
  ENDIF.

  MESSAGE s481(1e). "Data saved successfully

ENDFORM.



*&---------------------------------------------------------------------*
*& Form check_data
*&---------------------------------------------------------------------*
FORM check_data .

  DATA: lv_msg1 TYPE string,
        lv_msg2 TYPE string,
        lt_rows TYPE salv_t_row.

  CLEAR gv_error.
  LOOP AT gt_except ASSIGNING FIELD-SYMBOL(<exp>).
    DATA(lv_tabix) = sy-tabix.
    IF    <exp>-exc_bukrs              IS INITIAL
      AND <exp>-exc_clientcode_cob     IS INITIAL
      AND <exp>-exc_pricingelement_cob IS INITIAL
      AND <exp>-exc_productcode_cob    IS INITIAL
      AND <exp>-exc_vehicleno_cob      IS INITIAL.
      APPEND lv_tabix TO lt_rows.
      MESSAGE w001(hr99s00_daq_view).  "Please fill at least one field .
      gv_error = 'X'.
      CONTINUE.
    ENDIF.

    READ TABLE gt_rule TRANSPORTING NO FIELDS
               WITH KEY trans_type    = <exp>-trans_type
                        fsg_code      = <exp>-fsg_code
                        field_name    = <exp>-field_name
                        required      = <exp>-required
                        lookup_validated  = <exp>-lookup_validated.
    IF sy-subrc IS INITIAL.
      CONCATENATE <exp>-exc_bukrs <exp>-exc_productcode_cob <exp>-exc_pricingelement_cob
                  <exp>-exc_clientcode_cob <exp>-exc_vehicleno_cob
                  INTO lv_msg1 SEPARATED BY ','.
      CONCATENATE '(' lv_msg1 ')' INTO lv_msg1.

      CONCATENATE <exp>-trans_type <exp>-fsg_code <exp>-field_name
                  INTO lv_msg2 SEPARATED BY ','.
      CONCATENATE '(' lv_msg2 ')' INTO lv_msg2.
      APPEND lv_tabix TO lt_rows.

      MESSAGE i016(zpark) WITH lv_msg1 lv_msg2.
      gv_error = 'X'.
      "Exception &1 does not override rule &2. Exception not needed. Pls check.
    ENDIF.
  ENDLOOP.

  CHECK lt_rows IS NOT INITIAL.
  gr_except->get_selections( )->set_selected_rows( lt_rows ).

ENDFORM.



*&---------------------------------------------------------------------*
*& Form exit_program
*&---------------------------------------------------------------------*
FORM exit_program .

  DATA: lv_ans TYPE char1.

  LOOP AT gt_data TRANSPORTING NO FIELDS
       WHERE upd_flg IS NOT INITIAL.
    EXIT.
  ENDLOOP.
  IF sy-subrc IS NOT INITIAL.
    LOOP AT gt_except TRANSPORTING NO FIELDS
         WHERE upd_flg IS NOT INITIAL.
      EXIT.
    ENDLOOP.
  ENDIF.
  IF sy-subrc IS NOT INITIAL.
    LOOP AT gt_rule TRANSPORTING NO FIELDS
         WHERE upd_flg IS NOT INITIAL.
      EXIT.
    ENDLOOP.
  ENDIF.
  IF sy-subrc IS INITIAL.
    CALL FUNCTION 'POPUP_TO_CONFIRM_DATA_LOSS'
      EXPORTING
        titel  = 'Changes not saved'
      IMPORTING
        answer = lv_ans.
    CASE lv_ans.
      WHEN 'J'. "Yes
        PERFORM save_data.
      WHEN 'N'. "No
      WHEN 'A'. "Cancel
        EXIT.
    ENDCASE.
  ENDIF.
  LEAVE TO SCREEN 0.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form update_data
*&---------------------------------------------------------------------*
FORM update_data .

  IF gt_except IS NOT INITIAL.
    LOOP AT gt_except ASSIGNING FIELD-SYMBOL(<exp>).
      READ TABLE gt_data ASSIGNING FIELD-SYMBOL(<data>)
           WITH KEY trans_type             = <exp>-trans_type
                    fsg_code               = <exp>-fsg_code
                    field_name             = <exp>-field_name
                    exc_bukrs              = <exp>-exc_bukrs
                    exc_clientcode_cob     = <exp>-exc_clientcode_cob
                    exc_pricingelement_cob = <exp>-exc_pricingelement_cob
                    exc_productcode_cob    = <exp>-exc_productcode_cob
                    exc_vehicleno_cob      = <exp>-exc_vehicleno_cob.
      IF sy-subrc IS INITIAL.
        <data> = <exp>.
      ELSE.
        APPEND <exp> TO gt_data.
      ENDIF.
    ENDLOOP.
    CLEAR gt_except.
    gr_except->refresh( refresh_mode = if_salv_c_refresh=>full ).
  ENDIF.

  LOOP AT gt_rule ASSIGNING FIELD-SYMBOL(<rule>)
          WHERE upd_flg IS NOT INITIAL.
    READ TABLE gt_data ASSIGNING <data>
         WITH KEY trans_type = <rule>-trans_type
                  fsg_code   = <rule>-fsg_code
                  field_name = <rule>-field_name
                  .
    IF sy-subrc IS INITIAL.
      <data> = <rule>.
    ELSE.
      APPEND <rule> TO gt_data.
    ENDIF.
  ENDLOOP.

ENDFORM.
