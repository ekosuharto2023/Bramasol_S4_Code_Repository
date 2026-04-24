class ZCL_USER_CHECK_BEFORE_DELETE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_IDENTITY_CHECK .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_USER_CHECK_BEFORE_DELETE IMPLEMENTATION.


  METHOD if_badi_identity_check~check.
* This BAdI is called for every user instance during the method CL_IDENTITY=>DO_CHECK.
* The example implemetation checks if the fields E-Mail address, Account number and
* Cost center is empty. In this case a permanent error message is added to the message
* buffer. This prevents the saving of the user master data.
*
* Importing parameters:
* - IS_BADI_IDENTITY_CHECK         Current Instance: Modus (Create, Modify, Delete), User name
*                                  and Instance reference of IF_IDENTITY
* - IO_BADI_MSG_BUFFER             Reference of message buffer
* - IS_BADI_IDENTITY_CUA_SYSTEMS   Relevant only in CUA central system.
*                                  List of new or deleted systems per user.
* - IS_BADI_IDENTITY_CUA_ROLES     Relevant only in CUA central system.
*                                  Actual and before image of cua role assignments of processed users.
* - IS_BADI_IDENTITY_ROLES         Actual and before image of role assignments of processed users.
* - IS_BADI_IDENTITY_GROUPS        Actual and before image of group assignments of processed users.
* --------------------------------------------------------------------------------------

    DATA: lv_user           TYPE syst-uname,
          lt_nodes_modified TYPE suid_tt_node,
          ls_logondata      TYPE suid_st_node_logondata,
          ls_msg            TYPE symsg
          .
    TRY.
        IF is_badi_identity_check-modus EQ cl_identity_persistence=>co_ta_modus_delete.
          "Check for active WF
          DATA(lv_check_wf) = 'X'.

        ELSEIF is_badi_identity_check-modus EQ cl_identity_persistence=>co_ta_modus_modify.
          " In Change mode: Check E-Mail and Logondata only if the corresponding node is modified
          CALL METHOD is_badi_identity_check-idref->get_admindata
            IMPORTING
              et_nodes_modified = lt_nodes_modified.

          " Check, if node ADDRS_EMAIL_ADDRESS is modified
          READ TABLE lt_nodes_modified
            WITH KEY nodename = if_identity_definition=>gc_node_logondata
            TRANSPORTING NO FIELDS.
          CALL METHOD is_badi_identity_check-idref->get_logondata
            IMPORTING
              es_logondata = ls_logondata.
          IF ls_logondata-gltgb <= sy-datum.
            lv_check_wf = 'X'.
          ENDIF.
        ENDIF.

        IF lv_check_wf EQ abap_true.
          "Check that user has no active WF
          SELECT FROM swwuserwi AS a JOIN swwwihead AS b ON a~wi_id = b~wi_id
                                     JOIN swwwihead AS h ON h~wi_id = b~parent_wi
               FIELDS a~wi_id", a~user_id, h~wi_text AS wf_text, b~wi_text
               WHERE a~user_id = @is_badi_identity_check-bname
                 AND a~no_sel  = ''
               ORDER BY a~task_obj, a~wi_id, a~user_id
               INTO TABLE @DATA(lt_wf).
          IF lt_wf IS NOT INITIAL.
            ls_msg-msgty = 'E'.
            ls_msg-msgid = 'ZPARK'.
            ls_msg-msgno = 017.
            "User cannot be deleted due to assigned workflows.

            io_badi_msg_buffer->add_object_message_symsg(
              EXPORTING
                iv_bname     = is_badi_identity_check-bname
                iv_nodename  = if_identity_definition=>gc_node_logondata
                iv_field     = if_identity_definition=>gc_field_logondata_accnt
                iv_lifetime  = if_suid_msg_buffer=>co_lifetime_permanent
                is_msg       = ls_msg
                iv_overwrite = if_identity=>co_true ).

          ENDIF.

          "Check that the user is still maintained in WF tables
          DO 2 TIMES.
            CASE sy-index.
              WHEN 1.
                DATA(lv_table) = 'ZEA_APPROVER_GRP'.
              WHEN 2.
                lv_table = 'ZEA_CODING_GRP'.
            ENDCASE.
            SELECT SINGLE FROM (lv_table)
                   FIELDS approver
                   WHERE approver = @is_badi_identity_check-bname
                   INTO @lv_user
                   .
            IF sy-subrc IS INITIAL.
              ls_msg-msgty = 'E'.
              ls_msg-msgid = 'ZPARK'.
              ls_msg-msgno = 018.
              ls_msg-msgv1 = lv_table.

              "Please remove user from workflow customization table &1 before deletion
              io_badi_msg_buffer->add_object_message_symsg(
                EXPORTING
                  iv_bname     = is_badi_identity_check-bname
                  iv_nodename  = if_identity_definition=>gc_node_logondata
                  iv_field     = if_identity_definition=>gc_field_logondata_accnt
                  iv_lifetime  = if_suid_msg_buffer=>co_lifetime_permanent
                  is_msg       = ls_msg
                  iv_overwrite = if_identity=>co_true ).
            ENDIF.
          ENDDO.
        ENDIF.

      CATCH cx_suid_identity.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
