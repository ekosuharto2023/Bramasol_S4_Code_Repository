class ZCL_FIN_ACDOC_CODBLOCK_VAL_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_FIN_COBL_VALIDATION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FIN_ACDOC_CODBLOCK_VAL_IMP IMPLEMENTATION.


  METHOD if_fin_cobl_validation~execute.
*--------------------------------------------------------------------*
*** BAdI usage
*-- Validate Coding Block
*
*** How to report validation message?
*-- Please check the BAdI documentation for standard messages from
*-- message class FIN_SUB_VAL. In case no proper message is found,
*-- you may use the generic placeholder message 000 '&1 &2 &3 &4'.
*-- For example, if you want to raise message 'Posting with document
*-- type ABC is not supported for transaction type XYZ', you can raise
*-- the message as follows:
*   validationmessage-msgid = 'FIN_SUB_VAL'.
*   validationmessage-msgty = 'E'.
*   validationmessage-msgno = '000'.
*   validationmessage-msgv1 = 'Posting with document type '.
*   validationmessage-msgv2 = accountingdocheader-accountingdocumenttype.
*   validationmessage-msgv3 = 'is not supported for transaction type '.
*   validationmessage-msgv4 = accountingdocheader-businesstransactiontype.
*
*-- Note: only message type E is allowed, others are ignored
*--------------------------------------------------------------------*

data: lv_num type i.
lv_num = 'A'.

** Use Case 1: For specific g/l accounts 61002000, personnel number must be provided.
** Check whether personnel number is provided
*    IF codingblockitem-glaccount = '0061002000'.
*      IF codingblockitem-personnelnumber IS INITIAL.
*        validationmessage-msgid = 'FIN_SUB_VAL'.
*        validationmessage-msgty = 'E'.
*        validationmessage-msgno = '004'.
*        validationmessage-msgv1 = '61002000'.
*        RETURN.
*      ENDIF.
*    ENDIF.
*
** Use Case 2: For posting to g/l account 61500000, internal order type Y090, it must be statistical order.
** And real posting should be assigned to a cost center CO object.
*    DATA lv_isstatisticalorder TYPE c LENGTH 1.
*    DATA lv_ordertype TYPE c LENGTH 4.
** Only check when it's assigned to an internal order and g/l account is 61500000
*    IF codingblockitem-orderid IS NOT INITIAL AND codingblockitem-glaccount = '0061500000'.
** Read OrderType from internal order master data view, check isStatisticalOrder only when OrderType = 'Y090'
*      SELECT SINGLE ordertype
*      FROM i_internalorder
*      WITH PRIVILEGED ACCESS
*     WHERE internalorder = @codingblockitem-orderid
*      INTO @lv_ordertype.
*      IF lv_ordertype = 'Y090'.
** Read IsStatisticalOrder from internal order master data view
*        SELECT SINGLE isstatisticalorder
*        FROM i_internalorder
*        WITH PRIVILEGED ACCESS
*       WHERE internalorder = @codingblockitem-orderid
*        INTO @lv_isstatisticalorder.
** Check whether it's a statistical internal order
*        IF lv_isstatisticalorder <> 'X'.
*          validationmessage-msgid = 'FIN_SUB_VAL'.
*          validationmessage-msgty = 'E'.
*          validationmessage-msgno = '005'.
*          validationmessage-msgv1 = 'Y090'.
*          validationmessage-msgv2 = '61500000'.
*          RETURN.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*
** Use Case 3: Ensure the Work Item can be used for the WBS Element
*    IF codingblockitem-workitem IS NOT INITIAL AND
*       codingblockitem-wbselementexternalid IS NOT INITIAL.
*      "check the assignment via the Work Item CDS view
*      SELECT *
*      FROM i_workpackageworkitem
*      WITH PRIVILEGED ACCESS
*      WHERE workitem = @codingblockitem-workitem
*        AND workpackage = @codingblockitem-wbselementexternalid
*       INTO TABLE @DATA(lt_data).
*      "raise error message if the Work Item was not assigned to the WBS Element
*      IF sy-subrc <> 0.
*        validationmessage-msgid = 'FIN_SUB_VAL'.
*        validationmessage-msgty = 'E'.
*        validationmessage-msgno = '022'.
*        validationmessage-msgv1 = codingblockitem-workitem.
*        validationmessage-msgv2 = codingblockitem-wbselementexternalid.
*        RETURN.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
