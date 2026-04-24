class ZCL_IM_ME_PROCESS_PO_CUST definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_PROCESS_PO_CUST .
protected section.
private section.

  methods CHECK_PO_CHANGED
    importing
      !IM_EBELN type EBELN
      !IM_HEADER type ref to IF_PURCHASE_ORDER_MM
    returning
      value(R_CHANGED) type CHAR1 .
ENDCLASS.



CLASS ZCL_IM_ME_PROCESS_PO_CUST IMPLEMENTATION.


  METHOD check_po_changed.

* Raise the event for release strategy if there is a PO strategy
    DATA: ls_ekko_n     TYPE mepoheader,
          ls_ekpo_n     TYPE mepoitem,
          ls_eket_n     TYPE meposchedule,
          lt_ekkn_n     TYPE purchase_order_accountings,
          ls_acc        TYPE mepoaccounting,
          lv_table      TYPE tabname,
          lo_type_descr TYPE REF TO cl_abap_typedescr
          .
    FIELD-SYMBOLS: <old_val> TYPE any,
                   <new_val> TYPE any,
                   <old>     TYPE any,
                   <new>     TYPE any
                   .

    ls_ekko_n = im_header->get_data( ).
    SELECT SINGLE * FROM ekko                 "#EC CI_ALL_FIELDS_NEEDED - fields called dynamically
           WHERE ebeln = @im_ebeln
           INTO @DATA(ls_ekko).

    SELECT * FROM ekpo                        "#EC CI_ALL_FIELDS_NEEDED
           WHERE ebeln = @im_ebeln
           INTO TABLE @DATA(lt_ekpo)
           .
    SELECT * FROM ekkn                        "#EC CI_ALL_FIELDS_NEEDED
           WHERE ebeln = @im_ebeln
           INTO TABLE @DATA(lt_ekkn)
           .
    SELECT * FROM eket                        "#EC CI_ALL_FIELDS_NEEDED
           WHERE ebeln = @im_ebeln
           INTO TABLE @DATA(lt_eket)
           .
    DATA(lt_fields) = zcl_elect_approval=>get_fields_for_wf_restart( zcl_elect_approval=>gc_objtype_po ).

    DATA(lt_items) = im_header->get_items( ).
*   Remove deleted lines
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
      ls_ekpo_n = <item>-item->get_data( ).
      DATA(lv_tabix) = sy-tabix.

      DO 4 TIMES.
        CASE sy-index.
          WHEN 1.
            lv_table = 'EKKO'.
            ASSIGN ls_ekko_n TO <new>.
            ASSIGN ls_ekko TO <old>.

          WHEN 2.
            lv_table = 'EKPO'.
            ASSIGN ls_ekpo_n TO <new>.
            READ TABLE lt_ekpo WITH KEY ebelp = ls_ekpo_n-ebelp ASSIGNING <old>.

          WHEN 3.
            lv_table = 'EKET'.
            DATA(lt_sched) = <item>-item->get_schedules( ).
            LOOP AT lt_sched ASSIGNING FIELD-SYMBOL(<sched>).
              ls_eket_n = <sched>-schedule->get_data( ).
            ENDLOOP.
            ASSIGN ls_eket_n TO <new>.
            READ TABLE lt_eket WITH KEY ebelp = ls_ekpo_n-ebelp ASSIGNING <old>.
*                            etenr = ls_eket_n-etenr
          WHEN 4.
            lv_table = 'EKKN'.
            DATA(lt_account) = <item>-item->get_accountings( ).
            LOOP AT lt_account ASSIGNING FIELD-SYMBOL(<account>).
              ls_acc = <account>-accounting->get_data( ).
            ENDLOOP.
            ASSIGN ls_acc TO <new>.
            READ TABLE lt_ekkn WITH KEY ebelp = ls_ekpo_n-ebelp ASSIGNING <old>.
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
                                      i_objtp  = zcl_elect_approval=>gc_objtype_po
                                      i_ebeln  = im_ebeln ).
    ENDIF.
  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~CHECK.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~CLOSE.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~INITIALIZE.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~OPEN.
  endmethod.


  METHOD if_ex_me_process_po_cust~post.

    "Raise the event for release strategy if there is a PO strategy R3/R4
    DATA: lv_key    TYPE swo_typeid,
          lt_msgs   TYPE swrtmstruc,
          lt_input  TYPE STANDARD TABLE OF swr_cont,
          ls_header TYPE mepoheader,
          ls_ekko   TYPE ekko,
          lt_items  TYPE purchase_order_items
          .
    ls_header = im_header->get_data( ).

    "Do not raise the event if there is no release strategy
    CHECK ls_header-frgsx IS NOT INITIAL.

    "Check if this is the first post or a change
    SELECT SINGLE * FROM ekko
           INTO ls_ekko
           WHERE ebeln = im_ebeln.
    IF sy-subrc IS INITIAL.
      "PO found. This is a change. Check it is a deletion
      lt_items = im_header->get_items( ).
      "Remove deleted lines
      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
        DATA(lv_tabix) = sy-tabix.
        DATA(ls_mepo) = <item>-item->get_data( ).
        IF  ls_mepo-loekz = 'L'.
          DELETE lt_items INDEX lv_tabix.
        ENDIF.
      ENDLOOP.
      IF lt_items IS INITIAL.
        lv_key = im_ebeln.
        CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'
          EXPORTING
            object_type    = 'BUS2012'
            object_key     = lv_key
            event          = 'CANCELED'
            commit_work    = ''
          TABLES
            message_struct = lt_msgs.
      ELSE.
        IF check_po_changed( im_ebeln  = im_ebeln
                             im_header = im_header ) IS NOT INITIAL.
          lv_key = im_ebeln.
          CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'
            EXPORTING
              object_type    = 'BUS2012'
              object_key     = lv_key
              event          = 'CHANGED'
              commit_work    = ''
            TABLES
              message_struct = lt_msgs.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ACCOUNT.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_SCHEDULE.
  endmethod.
ENDCLASS.
