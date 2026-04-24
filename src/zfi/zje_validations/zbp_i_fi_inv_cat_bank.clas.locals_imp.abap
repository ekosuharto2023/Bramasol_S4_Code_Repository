CLASS lhc_ZI_FI_INV_CAT_BANK DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_inv_cat_bank RESULT result.
*    METHODS validate_duplicate FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zi_fi_inv_cat_bank~validate_duplicate.

ENDCLASS.

CLASS lhc_ZI_FI_INV_CAT_BANK IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD validate_duplicate.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*
*      SELECT SINGLE company_code, invoice_category, payment_method
*        FROM zfi_inv_cat_bank
*        WHERE company_code     = @<key>-company_code
*          AND invoice_category = @<key>-InvoiceCategory
*          AND payment_method   = @<key>-payment_method
*        INTO @DATA(ls_existing).
*
*      IF sy-subrc = 0.
*        APPEND VALUE #(
*          %tky = <key>-%tky
*          %msg = new_message(
*          id       = 'ZFI_MSG'
*          number   = '006'
*          severity = if_abap_behv_message=>severity-error
*          )
*        ) TO reported-zi_fi_inv_cat_bank.
*
*        APPEND VALUE #( %tky = <key>-%tky )
*          TO failed-zi_fi_inv_cat_bank.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.
