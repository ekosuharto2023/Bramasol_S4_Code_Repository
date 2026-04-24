FUNCTION ZREMOVE_PAYMENT_BLOCK_GET.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INVOICENUMBER) TYPE  BELNR_D
*"     VALUE(FISCALYEAR) TYPE  GJAHR
*"     VALUE(COMPANYCODE) TYPE  BUKRS
*"  EXPORTING
*"     VALUE(RETURN) TYPE  CHAR1
*"     VALUE(ERRORMESSAGE) TYPE  CHAR256
*"----------------------------------------------------------------------

  DATA: lt_blk              TYPE mrm_tab_rbkp_blocked,
        lt_rbkp_blocked     TYPE mrm_tab_rbkp_blocked,
        lt_rbkp_blocked_mod TYPE mrm_tab_rbkp_blocked,
        lv_error            TYPE string.

  APPEND INITIAL LINE TO lt_blk ASSIGNING FIELD-SYMBOL(<blk>).
  <blk>-bukrs = companycode.
  <blk>-gjahr = fiscalyear.
  <blk>-belnr = invoicenumber.

  CALL FUNCTION 'MRM_INVOICE_RELEASE_UPDATE'
    EXPORTING
      ti_rbkp_blocked     = lt_blk
    IMPORTING
      te_rbkp_blocked     = lt_rbkp_blocked
      te_rbkp_blocked_mod = lt_rbkp_blocked_mod.


  IF line_exists( lt_rbkp_blocked[ subrc = 0 ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    return = 'X'.
  ELSE.
    DATA(ls_error) = VALUE #( lt_rbkp_blocked[ 1 ] OPTIONAL ).

    IF ls_error-text IS NOT INITIAL.
      lv_error = ls_error-text.
    ELSE.
      MESSAGE ID ls_error-arbgb TYPE ls_error-msgty NUMBER ls_error-txtnr
                  WITH ls_error-msgv1 ls_error-msgv2 ls_error-msgv3  INTO lv_error.
    ENDIF.
    errormessage = lv_error.
    return = 'E'.
  ENDIF.

ENDFUNCTION.
