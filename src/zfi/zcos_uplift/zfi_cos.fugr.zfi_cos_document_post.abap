*&---------------------------------------------------------------------*
*& Function Module: ZFI_COS_DOCUMENT_POST
*& Description: qRFC for Cost of Sales Auto Posting
*&---------------------------------------------------------------------*
*& Purpose: To create Cost of Sales Fi Document auto posting
*&          This function module is called asynchronously via qRFC
*&          to create COS documents based on supplier invoices
*&---------------------------------------------------------------------*
FUNCTION zfi_cos_document_post.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_DOCUMENTHEADER) TYPE  BAPIACHE09
*"  TABLES
*"      IT_ACCOUNTGL STRUCTURE  BAPIACGL09
*"      IT_CURRENCYAMOUNT STRUCTURE  BAPIACCR09
*"      IT_EXTENSION2 STRUCTURE  BAPIPAREX
*"----------------------------------------------------------------------

  DATA: lt_return TYPE STANDARD TABLE OF  bapiret2.

  CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
    EXPORTING
      documentheader = is_documentheader
    IMPORTING
      obj_type       = is_documentheader-obj_type
      obj_key        = is_documentheader-obj_key
      obj_sys        = is_documentheader-obj_sys
    TABLES
      accountgl      = it_accountgl
      currencyamount = it_currencyamount
      extension2     = it_extension2
      return         = lt_return.

*  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<return>).
*    IF sy-subrc EQ 0.
*      EXIT.
*    ENDIF.
*  ENDLOOP.

* Check for errors
*  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
*  IF sy-subrc = 0.
*    RAISE EXCEPTION
*  ENDIF.

  " Commit
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
ENDFUNCTION.
