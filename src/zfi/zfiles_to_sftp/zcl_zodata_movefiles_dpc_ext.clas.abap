CLASS zcl_zodata_movefiles_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zodata_movefiles_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action
        REDEFINITION .
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS fileset_get_entityset
        REDEFINITION .
  PRIVATE SECTION.
    METHODS get_tvarvc_data
      IMPORTING
        !iv_name         TYPE rvari_vnam
      RETURNING
        !VALUE(rv_value) TYPE rvari_val_255.
ENDCLASS.



CLASS zcl_zodata_movefiles_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    CONSTANTS c_mime_type TYPE rvari_vnam VALUE 'ZFI_MIME_TYPE'.

    DATA(lv_mime_type) = get_tvarvc_data( iv_name = c_mime_type ).

    DATA ls_stream  TYPE ty_s_media_resource.
    DATA lv_file    TYPE string.
    DATA lt_raw     TYPE solix_tab.

    DATA(it_keys) = io_tech_request_context->get_keys( ).
    lv_file = VALUE #( it_keys[ 1 ]-value OPTIONAL ).

    IF lv_file IS INITIAL.
      RETURN.
    ENDIF.

    OPEN DATASET lv_file FOR INPUT IN BINARY MODE.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DO.
      DATA(ls_raw_line) = VALUE solix( ).
      READ DATASET lv_file INTO ls_raw_line.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      APPEND ls_raw_line TO lt_raw.
    ENDDO.

    CLOSE DATASET lv_file.

    ls_stream-value     = cl_bcs_convert=>solix_to_xstring( it_solix = lt_raw ).
    ls_stream-mime_type = lv_mime_type.

    copy_data_to_ref(
      EXPORTING
        is_data = ls_stream
      CHANGING
        cr_data = er_stream ).

  ENDMETHOD.



  METHOD fileset_get_entityset.

    CONSTANTS:
      c_dot       TYPE string        VALUE '.',
      c_dotdot    TYPE string        VALUE '..',
      c_sep       TYPE c LENGTH 1    VALUE '/',
      c_mime_type TYPE rvari_vnam VALUE 'ZFI_MIME_TYPE'.
    DATA lit_dir_list TYPE STANDARD TABLE OF eps2fili WITH EMPTY KEY.
    DATA lv_dir_name  TYPE eps2filnam.
    DATA ls_row       TYPE zcl_zodata_movefiles_mpc=>ts_file.

    DATA(lv_mime_type) = get_tvarvc_data( iv_name = c_mime_type ).

    "Get directory from $filter (take first filter, first option low)
    DATA(lo_filter) = io_tech_request_context->get_filter( ).
    IF lo_filter IS BOUND.
      DATA(lt_filter_sel) = lo_filter->get_filter_select_options( ).
      IF line_exists( lt_filter_sel[ 1 ] )
         AND line_exists( lt_filter_sel[ 1 ]-select_options[ 1 ] ).
        lv_dir_name = lt_filter_sel[ 1 ]-select_options[ 1 ]-low.
      ENDIF.
    ENDIF.

    IF lv_dir_name IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'EPS2_GET_DIRECTORY_LISTING'
      EXPORTING
        iv_dir_name            = lv_dir_name
      TABLES
        dir_list               = lit_dir_list
      EXCEPTIONS
        invalid_eps_subdir     = 1
        sapgparam_failed       = 2
        build_directory_failed = 3
        no_authorization       = 4
        read_directory_failed  = 5
        too_many_read_errors   = 6
        empty_directory_list   = 7
        OTHERS                 = 8.

    IF sy-subrc <> 0 OR lit_dir_list IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lit_dir_list INTO DATA(ls_file)
      WHERE name <> c_dot AND name <> c_dotdot.

      CLEAR ls_row.
      ls_row-filename = |{ lv_dir_name }{ c_sep }{ ls_file-name }|.
      ls_row-mimetype = lv_mime_type.
      APPEND ls_row TO et_entityset.

    ENDLOOP.

  ENDMETHOD.



  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

    CONSTANTS:
      c_sep                    TYPE c LENGTH 1 VALUE '/',
      c_check_archive_action   TYPE rvari_vnam VALUE 'ZFI_CHECK_ARCHIVE_ACTION',
      c_remit_archive_action   TYPE rvari_vnam VALUE 'ZFI_REMIT_ARCHIVE_ACTION',
      c_check_file_archive_dir TYPE rvari_vnam VALUE 'ZFI_CHECK_FILE_ARCHIVE_DIR',
      c_remit_file_archive_dir TYPE rvari_vnam VALUE 'ZFI_REMIT_FILE_ARCHIVE_DIR'.

    DATA(lv_action_check) = get_tvarvc_data( iv_name = c_check_archive_action ).
    DATA(lv_action_remit) = get_tvarvc_data( iv_name = c_remit_archive_action ).
    DATA(lv_arch_check_dir) = get_tvarvc_data( iv_name = c_check_file_archive_dir ).
    DATA(lv_arch_remit_dir) = get_tvarvc_data( iv_name = c_remit_file_archive_dir ).
    "Extract filename
    DATA lt_parts TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA lt_raw TYPE solix_tab.
    "Get source from first parameter
    DATA(lv_src) = VALUE string( it_parameter[ 1 ]-value OPTIONAL ).
    IF lv_src IS INITIAL.
      RETURN.
    ENDIF.

    "Decide archive directory dynamically
    DATA(lv_arch_dir) = COND string(
      WHEN iv_action_name = lv_action_check THEN lv_arch_check_dir
      WHEN iv_action_name = lv_action_remit THEN lv_arch_remit_dir
      ELSE `` ).

    IF lv_arch_dir IS INITIAL.
      RETURN.
    ENDIF.

    SPLIT lv_src AT c_sep INTO TABLE lt_parts.
    DATA(lv_fname) = VALUE string( lt_parts[ lines( lt_parts ) ] OPTIONAL ).

    DATA(lv_tgt) = |{ lv_arch_dir }{ lv_fname }|.


    "---- Move = copy target + delete source ----
    OPEN DATASET lv_src FOR INPUT IN BINARY MODE.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DO.
      DATA(ls_raw) = VALUE solix( ).
      READ DATASET lv_src INTO ls_raw.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      APPEND ls_raw TO lt_raw.
    ENDDO.

    CLOSE DATASET lv_src.

    OPEN DATASET lv_tgt FOR OUTPUT IN BINARY MODE.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT lt_raw INTO DATA(ls_line).
      TRANSFER ls_line TO lv_tgt.
    ENDLOOP.

    CLOSE DATASET lv_tgt.

    DELETE DATASET lv_src.

  ENDMETHOD.

  METHOD get_TVARVC_data.

    SELECT SINGLE low FROM tvarvc INTO rv_value WHERE name = iv_name.
  ENDMETHOD.

ENDCLASS.
