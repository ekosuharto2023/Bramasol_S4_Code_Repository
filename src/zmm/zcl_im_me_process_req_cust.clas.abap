class ZCL_IM_ME_PROCESS_REQ_CUST definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_PROCESS_REQ_CUST .
protected section.
private section.

  methods CHECK_PR_CHANGED
    importing
      !IM_BANFN type BANFN
      !IM_HEADER type ref to IF_PURCHASE_REQUISITION
    returning
      value(R_CHANGED) type CHAR1 .
ENDCLASS.



CLASS ZCL_IM_ME_PROCESS_REQ_CUST IMPLEMENTATION.


  METHOD check_pr_changed.

    DATA: lt_account    TYPE mmpur_accounting_list,
          lv_table      TYPE tabname,
          lo_type_descr TYPE REF TO cl_abap_typedescr
          .
    FIELD-SYMBOLS: <account> TYPE mmpur_accounting_type,
                   <old_val> TYPE any,
                   <new_val> TYPE any,
                   <old>     TYPE any,
                   <new>     TYPE any
                   .
    SELECT * FROM eban "#EC CI_ALL_FIELDS_NEEDED - dynamic field call to compare old/new data
           WHERE banfn = @im_banfn
           INTO TABLE @DATA(lt_eban)
           .
    SELECT * FROM ebkn                        "#EC CI_ALL_FIELDS_NEEDED
           WHERE banfn = @im_banfn
           INTO TABLE @DATA(lt_ebkn)
           .
    DATA(lt_fields) = zcl_elect_approval=>get_fields_for_wf_restart( zcl_elect_approval=>gc_objtype_preq ).

    DATA(lt_items) = im_header->get_items( ).
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
      DATA(ls_mereq) = <item>-item->get_data( ).
      CHECK ls_mereq-loekz <> 'X'.
      CHECK ls_mereq-knttp <> 'U'.

      lt_account = <item>-item->if_acct_container_mm~get_items( ).
      LOOP AT lt_account ASSIGNING <account>.
        DATA(ls_acc) = <account>-model->get_exkn( ).
      ENDLOOP.

      READ TABLE lt_eban ASSIGNING FIELD-SYMBOL(<eban>)
           WITH KEY bnfpo = ls_mereq-bnfpo.
      IF sy-subrc IS NOT INITIAL.
        r_changed = 'X'.
        RETURN.
      ENDIF.
      READ TABLE lt_ebkn ASSIGNING FIELD-SYMBOL(<ebkn>)
           WITH KEY bnfpo = ls_mereq-bnfpo.

      DO 2 TIMES.
        CASE sy-index.
          WHEN 1.
            lv_table  = 'EBAN'.
            ASSIGN <eban>   TO <old>.
            ASSIGN ls_mereq TO <new>.

          WHEN 2.
            lv_table  = 'EBKN'.
            ASSIGN <ebkn> TO <old>.
            ASSIGN ls_acc TO <new>.
        ENDCASE.
        IF sy-subrc IS NOT INITIAL.
          "this is a new line.
          r_changed = 'X'.
          RETURN.
        ENDIF.

        LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<field>)
                WHERE tabname = lv_table.

          ASSIGN COMPONENT <field>-fieldname OF STRUCTURE <new> TO <new_val>.
          ASSIGN COMPONENT <field>-fieldname OF STRUCTURE <old> TO <old_val>.
          "do not check sy-subrc to allow dumps on wrong field name
          IF <old_val> <> <new_val>.
            lo_type_descr = cl_abap_typedescr=>describe_by_data( <new_val> ).
            IF lo_type_descr->type_kind = 'P'.
              IF <new_val> < <old_val>.
                DATA(lv_notif) = 'X'.
                CONTINUE.
              ENDIF.
            ENDIF.
            r_changed = 'X'.
            RETURN.
          ENDIF.
        ENDLOOP.
      ENDDO.
    ENDLOOP.

    IF lv_notif IS NOT INITIAL.
      zcl_elect_approval=>send_email( i_notice = 'X'
                                      i_commit = ''
                                      i_objtp  = zcl_elect_approval=>gc_objtype_preq
                                      i_banfn  = im_banfn ).
    ENDIF.

  ENDMETHOD.


  method IF_EX_ME_PROCESS_REQ_CUST~CHECK.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~CLOSE.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~FIELDSELECTION_ITEM_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~INITIALIZE.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~OPEN.
  endmethod.


  METHOD if_ex_me_process_req_cust~post.

    DATA: lv_key      TYPE swo_typeid,
          lt_msgs     TYPE swrtmstruc,
          lt_items    TYPE mmpur_requisition_items,
          lt_input    TYPE STANDARD TABLE OF swr_cont,
          lr_strategy TYPE REF TO if_release_strategy_mm,
          lv_frgsx    TYPE frgsx,
          ls_eban     TYPE eban,
          lv_change   TYPE char1,
          lv_no_wf    TYPE char1,
          lv_str      TYPE string,
          lv_name     TYPE tdobname,
          ls_doc_key  TYPE dms_doc_key,
          lt_return   TYPE STANDARD TABLE OF bapireturn
          .
* Raise the event for release strategy if there is a PO strategy
    im_header->if_releasable_mm~get_data(
      IMPORTING
        ex_strategy = lr_strategy ).
    IF lr_strategy IS NOT INITIAL.

      lr_strategy->get_info(
        IMPORTING
          ex_strategy = lv_frgsx
      ).
      CHECK lv_frgsx IS NOT INITIAL.
*   if there is a HOLD (Memory = 'X') do not allow WF
      lt_items = im_header->get_items( ).
      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
        DATA(ls_mereq) = <item>-item->get_data( ).
        IF ls_mereq-memory = 'X'.
          lv_no_wf = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.
      CHECK lv_no_wf IS INITIAL.

      SELECT SINGLE * FROM eban                             "#EC WARNOK
              INTO ls_eban
              WHERE banfn = im_banfn
                .
      CHECK sy-subrc IS INITIAL.

      LOOP AT lt_items ASSIGNING <item>.
        ls_mereq = <item>-item->get_data( ).
        IF ls_mereq-loekz = 'X' OR ls_mereq-knttp = 'U'.
          DELETE lt_items INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
      IF lt_items IS INITIAL.
        lv_key = im_banfn.
        CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'
          EXPORTING
            object_type    = 'BUS2105'
            object_key     = lv_key
            event          = 'CANCELED'
            commit_work    = ''
          TABLES
            message_struct = lt_msgs.
      ELSE.
        CHECK check_pr_changed( im_banfn   = im_banfn
                                im_header  = im_header ) IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_input ASSIGNING FIELD-SYMBOL(<input>).
        <input>-element = 'RELEASECODE'.
        <input>-value = lv_frgsx.

        lv_key = im_banfn.
        CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'
          EXPORTING
            object_type     = 'BUS2105'
            object_key      = lv_key
            event           = 'CHANGED'
            commit_work     = ''
          TABLES
            message_struct  = lt_msgs
            input_container = lt_input.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_ACCOUNT.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_REQ_CUST~PROCESS_ITEM.
  endmethod.
ENDCLASS.
