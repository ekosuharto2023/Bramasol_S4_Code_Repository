CLASS zcl_im_invoice_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_invoice_update .

    CONSTANTS mc_status_park TYPE rbstat VALUE 'A' ##NO_TEXT.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IM_INVOICE_UPDATE IMPLEMENTATION.


  METHOD if_ex_invoice_update~change_at_save.
    DATA lt_errors TYPE mrm_tab_errprot.
    DATA lt_items  TYPE zfi_t_coding_block.

    " - Begin of E004 S4 BRIM Synchronization
    " if its a reversal log in the BRIM Sync table
    IF s_rbkp_new-stblg IS NOT INITIAL.
      zcl_fi_reversal_sync=>process_from_supplier_invoice( s_rbkp_new ).
      "When doing a reversal we do not need to validate any field and we
      "do not want the accounting document to verify the ZZ fields which
      "will not be supplied on the reversal document in the validate client code substitution.
      EXPORT lv_no_check = 'X' TO MEMORY ID zcl_utility_fidoc_validator=>mc_verify_gje_memory_id.
      RETURN.
    ENDIF.
    " - End of E004 S4 BRIM Synchronization

    IF s_rbkp_new-rbstat = mc_status_park. " A
      "-- do not validate custom fields as document is already set to be PARKED
      RETURN.
    ENDIF.

    DATA(lo_validator) = NEW zcl_utility_fidoc_validator( ).
    lt_items = CORRESPONDING #( ti_rbco_new ).

    DATA(lt_parklog) = lo_validator->validate_document(
      EXPORTING
        is_hdr       = s_rbkp_new
        i_trans_type = zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice
      CHANGING
        ct_items     = lt_items ).

    IF lt_parklog IS NOT INITIAL.
      MOVE-CORRESPONDING lt_parklog TO lt_errors.
      EXPORT lt_errors = lt_errors TO MEMORY ID 'ZMRM_ERRORS'.
      READ TABLE lt_parklog INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_parklog>).
      IF sy-subrc = 0.
        MESSAGE ID <fs_parklog>-msgid
                TYPE 'W'
                NUMBER <fs_parklog>-msgno
                RAISING error_with_message.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_invoice_update~change_before_update.

    DATA: lt_items  TYPE zfi_t_coding_block.

    CHECK s_rbkp_new-rbstat = mc_status_park.  "'A'.

    DATA(lo_validator) = NEW zcl_utility_fidoc_validator( ).
    lt_items = CORRESPONDING #( ti_mrmrbco ).

    CALL METHOD lo_validator->validate_document
      EXPORTING
        is_hdr       = s_rbkp_new
        i_trans_type = zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice
      CHANGING
        ct_items     = lt_items
      RECEIVING
        rt_parklog   = DATA(lt_parklog).

    IF lt_parklog IS NOT INITIAL. " AND s_rbkp_new-rbstat = mc_status_park.  "'A'.
      MODIFY zfi_parklog FROM TABLE lt_parklog.
    ENDIF.

  ENDMETHOD.


  METHOD if_ex_invoice_update~change_in_update.
  ENDMETHOD.
ENDCLASS.
