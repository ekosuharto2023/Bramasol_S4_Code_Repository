FUNCTION ZINSERT_VENDOR_ALT_PAYEE_GET.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SUPPLIER_ACCOUNT) TYPE  LIFNR
*"     VALUE(COMPANY_CODE) TYPE  BUKRS
*"     VALUE(VENDOR_PERMITTED) TYPE  EMPFK
*"  EXPORTING
*"     VALUE(ERROR_FLAG) TYPE  CHAR1
*"     VALUE(ERROR_MESSAGE) TYPE  CHAR40
*"  EXCEPTIONS
*"      VENDOR_NOT_FOUND
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
  CONSTANTS lc_update TYPE char1 VALUE 'U'.
  CONSTANTS lc_insert TYPE char1 VALUE 'I'.

  DATA: BEGIN OF result,
          supplier                 TYPE lifnr,
          companycode              TYPE bukrs,
          supplieralternativepayee TYPE empfk,
        END OF result.
  DATA ls_main             TYPE vmds_ei_main.
  DATA lv_recon_account    TYPE akont.
  DATA l_messages          TYPE cvis_message.
  DATA l_update_errors     TYPE cvis_message.
  DATA lv_supplier         TYPE lifnr.
  DATA lv_companycode      TYPE bukrs.
  DATA lv_vendor_permitted TYPE empfk.

    error_flag = ''.
    error_message = 'SUCCESS'.

ENDFUNCTION.
