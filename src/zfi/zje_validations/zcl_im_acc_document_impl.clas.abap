CLASS zcl_im_acc_document_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_acc_document .
  PROTECTED SECTION.
private section.

*    TYPES: ty_zz1_source_rng TYPE RANGE OF acdoca-zz1_source.
ENDCLASS.



CLASS ZCL_IM_ACC_DOCUMENT_IMPL IMPLEMENTATION.


  METHOD if_ex_acc_document~change.
**--------------------------------------------------------------------------------*
**- E003 COS for supplier invoice # moving Custom Fields to COS Fi doc to be posted
**--------------------------------------------------------------------------------*
*    IF c_acchd-bktxt CS 'COS'.
*      zcl_cos_data_build=>update_accit_with_si_extension( EXPORTING it_extension2 = c_extension2
*                                                          CHANGING  ct_accit      = c_accit ).
*    ENDIF.
**- End of E003 COS for supplier invoice Custom Fields updation
**--------------------------------------------------------------------------------*
    CONSTANTS: lc_doc_type_integration TYPE blart VALUE 'Y2'.

    DATA: lt_items             TYPE zfi_t_coding_block,
          ls_custom_fields_tab TYPE zfi_s_coding_block,
          ls_hdr               TYPE rbkp,
          lv_belnr             TYPE belnr_d,
          lv_gjahr             TYPE gjahr,
          lt_parklog           TYPE zfi_parklog_tbltype,
          lv_bukrs             TYPE bukrs
          .

    DATA(lo_validator) = NEW zcl_utility_fidoc_validator( ).

    "Check the document type and if it is not Y2 and coming from integreation then park it.
    IF c_acchd-status_old IS INITIAL AND c_acchd-tcode IS INITIAL.
      LOOP AT c_accit ASSIGNING FIELD-SYMBOL(<accit>).
        IF <accit>-blart <> lc_doc_type_integration
         AND <accit>-zz1_transactionkey_cob IS NOT INITIAL. "The transaction key is filled only when coming from integration
          c_acchd-status_new = '2'. "2  Untested
          "If document is parked there is no need to validate any other data
          APPEND INITIAL LINE TO lt_parklog ASSIGNING FIELD-SYMBOL(<park>).
          <park> = CORRESPONDING #( <accit> MAPPING transaction_key = zz1_transactionkey_cob ).
          <park>-trans_type = zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.
          <park>-erdat    = sy-datum.
          <park>-erzet    = sy-uzeit.
          <park>-ernam    = sy-uname.
          "Integration document &1 &2 &3 is not type &4 and hence parked
          <park>-msgid    = 'ZPARK'.
          <park>-msgno    = 019.
          <park>-msgv1    = <accit>-belnr.
          <park>-msgv2    = <accit>-gjahr.
          <park>-msgv3    = <accit>-bukrs.
          <park>-msgv4    = lc_doc_type_integration.
          MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                     WITH <park>-msgv1 <park>-msgv2 <park>-msgv3 <park>-msgv4 INTO <park>-msg_text.
          EXPORT lt_zfi_parklog = lt_parklog TO MEMORY ID 'ZLOG'.
          " this table is imported in FM ZBTE_GET_JE_DOC_00005011
          " to get Fi Doc and upadate it in ZFI_PARKLOG table
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDIF.

    lt_items = CORRESPONDING #( c_accit MAPPING saknr = hkont ).

    MOVE-CORRESPONDING c_acchd TO ls_hdr.
    READ TABLE lt_items INDEX 1 ASSIGNING FIELD-SYMBOL(<item>).
    IF sy-subrc IS INITIAL.
      ls_hdr-bukrs = <item>-bukrs.
    ENDIF.

    CALL METHOD lo_validator->validate_document
      EXPORTING
        is_hdr       = ls_hdr
        i_trans_type = zcl_utility_fidoc_validator=>mc_trans_type_journal_entry
      CHANGING
        cs_header    = c_acchd
        ct_items     = lt_items
      RECEIVING
        rt_parklog   = lt_parklog.

    IF lt_parklog IS NOT INITIAL.
      EXPORT lt_zfi_parklog = lt_parklog TO MEMORY ID 'ZLOG'.
      " this table is imported in FM ZBTE_GET_JE_DOC_00005011
      " to get Fi Doc and upadate it in ZFI_PARKLOG table
      RETURN.
    ENDIF.

    "The below code is needed to blow up COS when coming from an API
    IF zcl_cos_data_build=>check_doc_to_be_exploded( i_trans_type = zcl_utility_fidoc_validator=>mc_trans_type_journal_entry
                                                     it_accit = c_accit
                                                     it_acccr = c_acccr )
       IS INITIAL.
      zcl_cos_data_build=>cos_proccessor( EXPORTING is_rbkp_new = ls_hdr
                                          CHANGING  ct_accit    = c_accit
                                                    ct_acccr    = c_acccr ).
    ENDIF.

  ENDMETHOD.                    "IF_EX_ACC_DOCUMENT~CHANGE


  METHOD if_ex_acc_document~fill_accit.
  ENDMETHOD.
ENDCLASS.
