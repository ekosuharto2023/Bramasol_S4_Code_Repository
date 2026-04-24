class ZCL_UTILITY_FIDOC_VALIDATOR definition
  public
  create public .

public section.

  types:
      " === Common Validation Context ===
    BEGIN OF ty_err_log_context,
        transaction_key TYPE char20,
        company_code    TYPE bukrs,
        fiscal_year     TYPE gjahr,
        period          TYPE monat,
        accounting_doc  TYPE belnr_d,
        field_value     TYPE string,
        is_supplier_inv TYPE abap_boolean,
      END OF ty_err_log_context .

    " === Constants ===
  constants MC_GL_ACCOUNT_TO_PARK type HKONT value '0099999999' ##NO_TEXT.
  constants MC_TRANS_TYPE_JOURNAL_ENTRY type ZTRANS_TYPE value 'BK' ##NO_TEXT.
  constants MC_TRANS_TYPE_SUPPLIER_INVOICE type ZTRANS_TYPE value 'RB' ##NO_TEXT.
  constants MC_JE_STATUS_PARKED type ACC_STATUS_NEW value '2' ##NO_TEXT.
  constants MC_JE_CHECKED_AND_COMPLETE type ACC_STATUS_NEW value '3' ##NO_TEXT.
  constants MC_SUPPL_INV_STATUS_PARK type RBSTAT value 'A' ##NO_TEXT.
  constants MC_VERIFY_GJE_MEMORY_ID type CHAR20 value 'GJE_ZZ1_VALIDATION' ##NO_TEXT.

  class-methods INCLUDE_BADI_ERROR_IN_OUTPUT
    importing
      !IO_LOG type ref to CL_MMIV_SI_LOG .
  class-methods VALIDATE_CLIENT_CODE
    importing
      !IT_ITEMS type ZFI_T_CODING_BLOCK
      !I_TRANS_TYPE type ZTRANS_TYPE
    returning
      value(R_ERROR) type XFELD .
    " === Entry Point ===
  class-methods VALIDATE_DOCUMENT
    importing
      !IS_HDR type RBKP
      !I_TRANS_TYPE type ZTRANS_TYPE
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
      !CS_HEADER type ACCHD optional
    returning
      value(RT_PARKLOG) type ZFI_PARKLOG_TBLTYPE .
private section.

  class-methods COMPLETE_ERROR_LOG
    importing
      !IT_ITEMS type ZFI_T_CODING_BLOCK
      !I_TRANS_TYPE type ZTRANS_TYPE
      !IS_HDR type RBKP
    returning
      value(RT_PARK_LOG) type ZFI_PARKLOG_TBLTYPE .
  class-methods GET_VALIDATION_RULES
    importing
      !I_TRANS_TYPE type ZTRANS_TYPE optional
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(RT_FIELD_RULES) type ZFI_TT_FIELD_RULE_SELECTION .
  class-methods VALIDATE_DUPLICATE_INVOICE
    importing
      !IS_HDR type RBKP
      !I_TRANS_TYPE type ZTRANS_TYPE
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(RT_PARK_LOG) type ZFI_PARKLOG_TBLTYPE .
  class-methods VALIDATE_FIELDS
    importing
      !IT_FIELD_RULES type ZFI_TT_FIELD_RULE_SELECTION
      !IS_HDR type RBKP optional
      !I_TRANS_TYPE type ZTRANS_TYPE optional
    exporting
      !E_ERROR type CHAR1
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(RT_PARK_LOG) type ZFI_PARKLOG_TBLTYPE .
  class-methods VALIDATE_REFERENCE_INVOICE
    importing
      !IS_HDR type RBKP
      !I_TRANS_TYPE type ZTRANS_TYPE
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(RT_PARK_LOG) type ZFI_PARKLOG_TBLTYPE .
  class-methods VALIDATE_REQUIRED
    importing
      !IT_FIELD_RULES type ZFI_TT_FIELD_RULE_SELECTION
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(R_ERROR) type XFELD .
  class-methods VALIDATE_VALID_AMDP_VEHICLE
    importing
      !IT_FIELD_RULES type ZFI_TT_FIELD_RULE_SELECTION
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(R_ERROR) type XFELD .
  class-methods VALIDATE_VALID_FIELD
    importing
      !IT_FIELD_RULES type ZFI_TT_FIELD_RULE_SELECTION
    changing
      !CT_ITEMS type ZFI_T_CODING_BLOCK
    returning
      value(R_ERROR) type XFELD .
  class-methods VALIDATE_HEADER_FIELDS
    importing
      !IS_HDR type RBKP
      !I_TRANS_TYPE type ZTRANS_TYPE
    returning
      value(RT_PARK_LOG) type ZFI_PARKLOG_TBLTYPE .
ENDCLASS.



CLASS ZCL_UTILITY_FIDOC_VALIDATOR IMPLEMENTATION.


  METHOD validate_document.

    DATA: lt_errors TYPE mrm_tab_errprot,
          ls_rbkpv  TYPE mrm_rbkpv
          .
    CHECK ct_items IS NOT INITIAL AND is_hdr-stblg IS INITIAL. "Check this is not a reversal
    IF rt_parklog IS INITIAL AND is_hdr-stblg IS INITIAL. "not a reversal
      rt_parklog = validate_duplicate_invoice( EXPORTING i_trans_type = i_trans_type
                                                         is_hdr       = is_hdr
                                               CHANGING  ct_items     = ct_items
                                                       ).
    ENDIF.
    IF rt_parklog IS INITIAL.
      rt_parklog = validate_header_fields( i_trans_type = i_trans_type
                                           is_hdr       = is_hdr ).
    ENDIF.
    IF rt_parklog IS INITIAL.
      rt_parklog = validate_reference_invoice( EXPORTING i_trans_type = i_trans_type
                                                         is_hdr       = is_hdr
                                               CHANGING  ct_items     = ct_items
                                                       ).
    ENDIF.
    IF rt_parklog IS INITIAL.
      DATA(lt_rules) = get_validation_rules( EXPORTING i_trans_type = i_trans_type
                                             CHANGING  ct_items     = ct_items
                                                     ).
      rt_parklog = validate_fields( EXPORTING i_trans_type   = i_trans_type
                                              is_hdr         = is_hdr
                                              it_field_rules = lt_rules
                                    CHANGING  ct_items       = ct_items
                                            ).
    ENDIF.

    "When a all the document lines ar validated at once, there is no need
    "to validate again each line using interface if_fin_re_custom_function~execute
    EXPORT lv_no_check = 'X' TO MEMORY ID mc_verify_gje_memory_id.
    IF rt_parklog IS INITIAL.
      IF cs_header-status_new = mc_je_status_parked.
        cs_header-status_new = mc_je_checked_and_complete. "'3'.
        cs_header-status_old = mc_je_status_parked.
      ENDIF.
    ELSE.
      cs_header-status_new = mc_je_status_parked.
      IF i_trans_type = mc_trans_type_supplier_invoice
          AND sy-tcode+0(3) = 'MIR'.
        lt_errors = CORRESPONDING #( rt_parklog ).
        CALL FUNCTION 'MRM_PROT_FILL'
          TABLES
            t_errprot = lt_errors.
        MOVE-CORRESPONDING is_hdr TO ls_rbkpv.
        CALL FUNCTION 'MRM_PROTOCOL_DISPLAY'
          EXPORTING
            i_rbkpv = ls_rbkpv.
      ENDIF.
    ENDIF.

    IF is_hdr-belnr IS NOT INITIAL.
      DELETE FROM zfi_parklog
             WHERE bukrs = is_hdr-bukrs
               AND belnr = is_hdr-belnr
               AND gjahr = is_hdr-gjahr
               .
    ENDIF.

  ENDMETHOD.


  METHOD get_validation_rules.

    DATA: lt_items TYPE STANDARD TABLE OF zfi_s_coding_block.

    "we move ct_items to lt_items and back since we change the key on a sorted table
    lt_items = ct_items.
    DELETE ADJACENT DUPLICATES FROM ct_items COMPARING bukrs fstag saknr.
    SELECT DISTINCT a~bukrs, a~saknr, a~fstag,
           b~field_name, b~exc_bukrs, b~exc_productcode_cob, b~exc_pricingelement_cob,
           b~exc_clientcode_cob, b~exc_vehicleno_cob, b~required, b~lookup_validated
           FROM skb1 AS a INNER JOIN zfi_field_rules AS b ON a~fstag = b~fsg_code
           INTO CORRESPONDING FIELDS OF TABLE @rt_field_rules     ##TOO_MANY_ITAB_FIELDS
           FOR ALL ENTRIES IN @ct_items
           WHERE a~bukrs      = @ct_items-bukrs
             AND a~saknr      = @ct_items-saknr
             AND b~trans_type IN ( '', @i_trans_type )
             .                                        "#EC CI_BUFFJOIN.
    SELECT field_name, exc_bukrs, exc_productcode_cob, exc_pricingelement_cob,
           exc_clientcode_cob, exc_vehicleno_cob, required, lookup_validated   ##TOO_MANY_ITAB_FIELDS
           FROM zfi_field_rules
           APPENDING CORRESPONDING FIELDS OF TABLE @rt_field_rules
           WHERE fsg_code   = ''
             AND trans_type IN ( '', @i_trans_type )
             .
    CHECK rt_field_rules IS NOT INITIAL.
    SORT rt_field_rules BY bukrs saknr.
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
      DATA(lv_tabix) = sy-tabix.
      AT NEW saknr.
        READ TABLE rt_field_rules ASSIGNING FIELD-SYMBOL(<rule>)
                   WITH KEY bukrs = <item>-bukrs
                            saknr = <item>-saknr
                            BINARY SEARCH
                            .
        IF sy-subrc IS NOT INITIAL.
          UNASSIGN <rule>.
        ENDIF.
      ENDAT.
      IF <rule> IS ASSIGNED.
        <item>-fstag = <rule>-fstag.
      ELSE.
        DELETE lt_items INDEX lv_tabix.
      ENDIF.
    ENDLOOP.

    ct_items = lt_items.

    LOOP AT rt_field_rules ASSIGNING <rule>.
      CLEAR <rule>-saknr.
      "count the exceptions per line
      IF <rule>-exc_bukrs IS NOT INITIAL.
        ADD 1 TO <rule>-count.
      ENDIF.
      IF <rule>-exc_productcode_cob IS NOT INITIAL.
        ADD 1 TO <rule>-count.
      ENDIF.
      IF <rule>-exc_pricingelement_cob IS NOT INITIAL.
        ADD 1 TO <rule>-count.
      ENDIF.
      IF <rule>-exc_clientcode_cob IS NOT INITIAL.
        ADD 1 TO <rule>-count.
      ENDIF.
      IF <rule>-exc_vehicleno_cob IS NOT INITIAL.
        ADD 1 TO <rule>-count.
      ENDIF.
      IF    <rule>-required IS INITIAL
        AND <rule>-lookup_validated IS INITIAL
        AND <rule>-count IS INITIAL.
        DELETE rt_field_rules INDEX sy-tabix.
      ENDIF.
    ENDLOOP.
    SORT rt_field_rules BY bukrs saknr fstag field_name count DESCENDING
                           exc_bukrs              exc_productcode_cob
                           exc_pricingelement_cob exc_clientcode_cob
                           exc_vehicleno_cob.
    DELETE ADJACENT DUPLICATES FROM rt_field_rules COMPARING bukrs saknr fstag field_name
                            exc_bukrs              exc_productcode_cob
                            exc_pricingelement_cob exc_clientcode_cob
                            exc_vehicleno_cob.
  ENDMETHOD.


  METHOD validate_fields.

    CHECK ct_items IS NOT INITIAL. "Check again in case that we deleted all lines with empty FSG
    READ TABLE ct_items ASSIGNING FIELD-SYMBOL(<item>)
               WITH KEY saknr = mc_gl_account_to_park.  "#EC CI_SORTSEQ
    IF sy-subrc IS INITIAL.
      APPEND INITIAL LINE TO rt_park_log ASSIGNING FIELD-SYMBOL(<park>).
      <park>-transaction_key = <item>-zz1_transactionkey_cob.
      <park>-trans_type = i_trans_type.
      <park>-bukrs    = is_hdr-bukrs.
      <park>-gjahr    = is_hdr-gjahr.
      <park>-belnr    = is_hdr-belnr.
      <park>-erdat    = sy-datum.
      <park>-erzet    = sy-uzeit.
      <park>-ernam    = sy-uname.
      "Invoice document & was parked ( & & )
      <park>-msgid    = 'ZPARK'.
      <park>-msgno    = 012.
      <park>-msgv1    = mc_gl_account_to_park.
      MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                 WITH <park>-msgv1 <park>-msgv2 <park>-msgv3  INTO <park>-msg_text.
      "G/L Account & does not allow posting of the document. Park only.
      RETURN.
    ENDIF.

    "Copy the header fields to the line items.
    LOOP AT ct_items ASSIGNING <item>.
      <item>-zz1_invoicecategory_mih = is_hdr-zz1_invoicecategory_mih.
      <item>-zz1_invoiceno_mih       = is_hdr-zz1_invoiceno_mih.
    ENDLOOP.

    e_error = validate_required( EXPORTING it_field_rules = it_field_rules
                                 CHANGING  ct_items       = ct_items ).
    IF e_error IS INITIAL.
      e_error = validate_valid_amdp_vehicle( EXPORTING it_field_rules = it_field_rules
                                             CHANGING  ct_items       = ct_items ).
    ENDIF.
    IF e_error IS INITIAL.
      e_error = validate_valid_field( EXPORTING it_field_rules = it_field_rules
                                      CHANGING  ct_items       = ct_items ).
    ENDIF.
    "Complete the error message text
    IF e_error IS NOT INITIAL.
      rt_park_log = complete_error_log( EXPORTING is_hdr       = is_hdr
                                                  i_trans_type = i_trans_type
                                                  it_items     = ct_items ).
    ENDIF.

  ENDMETHOD.


  METHOD validate_required.

    DATA: lv_msg TYPE n.

    FIELD-SYMBOLS: <field> TYPE any.

    LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<item>).
      CLEAR lv_msg.
      "Loop at all the field rules for the specific GL or where the
      "field group is empty since that will apply to all GL types
      DATA(lt_rules) = it_field_rules.
      LOOP AT lt_rules ASSIGNING FIELD-SYMBOL(<rule>)
              WHERE ( ( bukrs = <item>-bukrs AND fstag = <item>-fstag )
                   OR ( bukrs = '' AND fstag = '' )  ).
        IF <rule>-count IS NOT INITIAL.
          "This is an exception - check the fields to see if it is applicable
          IF <rule>-exc_bukrs IS NOT INITIAL.
            CHECK <rule>-exc_bukrs = <item>-bukrs.
          ENDIF.
          IF <rule>-exc_clientcode_cob IS NOT INITIAL.
            CHECK <rule>-exc_clientcode_cob = <item>-zz1_clientcode_cob.
          ENDIF.
          IF <rule>-exc_pricingelement_cob IS NOT INITIAL.
            CHECK <rule>-exc_pricingelement_cob = <item>-zz1_pricingelement_cob.
          ENDIF.
          IF <rule>-exc_productcode_cob IS NOT INITIAL.
            CHECK <rule>-exc_productcode_cob = <item>-zz1_productcode_cob.
          ENDIF.
          IF <rule>-exc_vehicleno_cob IS NOT INITIAL.
            CHECK <rule>-exc_vehicleno_cob = <item>-zz1_vehicleno_cob.
          ENDIF.
          "exception found - remove the "regular rule"
          DELETE lt_rules WHERE bukrs = <rule>-bukrs
                            AND fstag = <rule>-fstag
                            AND saknr = <rule>-saknr
                            AND field_name = <rule>-field_name
                            AND count IS INITIAL.
        ENDIF.
        IF <rule>-required = abap_true.
          ASSIGN COMPONENT <rule>-field_name OF STRUCTURE <item> TO <field>.
          " we do not check sy-subrc so if there is a typo in config it is caught
          IF <field> IS INITIAL.
            ADD 1 TO lv_msg.
            DATA(lv_err_field) = |<item>-msgv{ lv_msg }|.
            ASSIGN (lv_err_field) TO FIELD-SYMBOL(<msgv>).
            <msgv> = <rule>-field_name.
            r_error = 'X'.
            <item>-msgid = 'ZPARK'.
            <item>-msgno = 003.
            IF <rule>-count IS INITIAL.
              <item>-rule_exc = 'X'.
            ENDIF.
            "Missing value in field/s &1 &2 &3 &4
          ENDIF.
        ELSE.
          "this may be an exception
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD validate_valid_field.

    DATA: lt_items       TYPE STANDARD TABLE OF zfi_s_coding_block,
          lt_data        TYPE STANDARD TABLE OF zfi_s_coding_block,
          lv_where       TYPE string,
          lv_where2      TYPE string,
          lv_field       TYPE name_feld,
          lv_cont        TYPE char1,
          lv_from_clause TYPE string,
          lv_select_flds TYPE string,
          lr_fstag       TYPE RANGE OF fstag
          .
    CONSTANTS: lc_field1    TYPE string VALUE 'ZZ1_PRICINGELEMENT_COB',
               lc_field2    TYPE string VALUE 'ZZ1_INVOICECATEGORY_MIH',
               lc_field3    TYPE string VALUE 'ZZ1_PRODUCTCODE_COB',
               lc_from1     TYPE string VALUE 'ZC_ZTF_AMDP_GET_PRICING_ELEMEN',
               lc_from2     TYPE string VALUE 'ZFI_INV_CATEGORY',
               lc_from3     TYPE string VALUE 'ZC_ZTF_AMDP_GET_PRODUCT_CODE',
               lc_selected2 TYPE string VALUE 'INVOICE_CATEGORY'
               .
    FIELD-SYMBOLS: <field> TYPE any.

    CHECK ct_items IS NOT INITIAL AND it_field_rules IS NOT INITIAL.

    DO 3 TIMES.
      CLEAR: lt_data, lr_fstag, lv_cont.

      CASE sy-index.
        WHEN 1.
          lv_field       = lv_select_flds = lc_field1.
          lv_from_clause = lc_from1.
        WHEN 2.
          lv_field       = lc_field2.
          lv_select_flds = lc_selected2.
          lv_from_clause = lc_from2.
        WHEN 3.
          lv_field       = lv_select_flds = lc_field3.
          lv_from_clause = lc_from3.
      ENDCASE.

      lt_items = ct_items.
      "delete all the fields that already have an error code
      DELETE lt_items WHERE msgv1 IS NOT INITIAL.
      "delete all lines where the account group is not within the rules table for the field we look at out of the 3
      DELETE lt_items WHERE fstag NOT IN lr_fstag.
      CHECK lt_items IS NOT INITIAL.

      LOOP AT it_field_rules ASSIGNING FIELD-SYMBOL(<rule>) WHERE field_name = lv_field.
        IF <rule>-count IS NOT INITIAL AND <rule>-lookup_validated IS INITIAL.
          LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item2>).
            DATA(lv_tabix) = sy-tabix.
            IF <item2>-zz1_clientcode_cob IS INITIAL AND <item2>-zz1_serialno_cob IS INITIAL
              AND <item2>-zz1_vehicleno_cob IS INITIAL AND <item2>-zz1_icnno_cob IS INITIAL.
              CONTINUE.
            ENDIF.
            IF <rule>-exc_bukrs IS NOT INITIAL AND <item2>-bukrs <> <rule>-exc_bukrs.
              CONTINUE.
            ENDIF.
            IF <rule>-exc_productcode_cob IS NOT INITIAL AND <item2>-zz1_productcode_cob <> <rule>-exc_productcode_cob.
              CONTINUE.
            ENDIF.
            IF <rule>-exc_pricingelement_cob IS NOT INITIAL AND <item2>-zz1_pricingelement_cob <> <rule>-exc_pricingelement_cob.
              CONTINUE.
            ENDIF.
            IF <rule>-exc_clientcode_cob IS NOT INITIAL AND <item2>-zz1_clientcode_cob <> <rule>-exc_clientcode_cob.
              CONTINUE.
            ENDIF.
            IF <rule>-exc_vehicleno_cob IS NOT INITIAL AND <item2>-zz1_vehicleno_cob <> <rule>-exc_vehicleno_cob.
              CONTINUE.
            ENDIF.
            DELETE lt_items INDEX lv_tabix.
          ENDLOOP.
        ENDIF.
        IF <rule>-fstag IS INITIAL.
          "if there is no account group than this field has to be examined for all the lines
          lv_cont = 'X'.
        ELSE.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = <rule>-fstag ) TO lr_fstag.
        ENDIF.
      ENDLOOP.

      CHECK lt_items IS NOT INITIAL.

      CHECK lr_fstag IS NOT INITIAL OR lv_cont IS NOT INITIAL.
      DELETE ADJACENT DUPLICATES FROM lr_fstag COMPARING low.

      CONCATENATE lv_field 'is initial' INTO lv_where SEPARATED BY space  ##NO_TEXT.
      DELETE lt_items WHERE (lv_where).
      CHECK lt_items IS NOT INITIAL.
      SORT lt_items BY (lv_field).
      DELETE ADJACENT DUPLICATES FROM lt_items COMPARING (lv_field).

      lv_where = |{ lv_select_flds } = @lt_items-{ lv_field }|  ##NO_TEXT.
      CONCATENATE lv_select_flds 'AS' lv_field INTO lv_select_flds SEPARATED BY space.
      SELECT FROM  (lv_from_clause)
             FIELDS (lv_select_flds)
             FOR ALL ENTRIES IN @lt_items
             WHERE (lv_where)
             INTO CORRESPONDING FIELDS OF TABLE @lt_data.

      lv_where = |{ lv_field } is not initial|   ##NO_TEXT.
      LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<item>)
              WHERE (lv_where).
        ASSIGN COMPONENT lv_field OF STRUCTURE <item> TO <field>.
        lv_where2 = |{ lv_field } = '{ <field> }'|.
        LOOP AT lt_data TRANSPORTING NO FIELDS WHERE (lv_where2).
          EXIT.
        ENDLOOP.
        IF sy-subrc IS NOT INITIAL.
          IF <rule>-count IS INITIAL.
            <item>-rule_exc = 'X'.
          ENDIF.
          <item>-msgno = 010.
          <item>-msgid = 'WRPC_XI_PROXY'.
          <item>-msgv1 = lv_field.
          <item>-msgv2 = <field>.
          "Invalid value &2 for field &1
          r_error = 'X'.
        ENDIF.
      ENDLOOP.
      IF r_error IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD complete_error_log.

    LOOP AT it_items ASSIGNING FIELD-SYMBOL(<item>) WHERE msgid IS NOT INITIAL.
      APPEND INITIAL LINE TO rt_park_log ASSIGNING FIELD-SYMBOL(<park>).
      MOVE-CORRESPONDING <item> TO <park>.
      <park>-transaction_key = <item>-zz1_transactionkey_cob.
      <park>-trans_type = i_trans_type.
      <park>-bukrs      = is_hdr-bukrs.
      <park>-gjahr      = is_hdr-gjahr.
      <park>-belnr      = is_hdr-belnr.
      <park>-erdat      = sy-datum.
      <park>-erzet      = sy-uzeit.
      <park>-ernam      = sy-uname.
      CHECK <park>-msgid IS NOT INITIAL.
      MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                 WITH <park>-msgv1 <park>-msgv2 <park>-msgv3 <park>-msgv4 INTO <park>-msg_text.
    ENDLOOP.
  ENDMETHOD.


  METHOD validate_duplicate_invoice.

    CASE i_trans_type.
      WHEN mc_trans_type_journal_entry.

      WHEN mc_trans_type_supplier_invoice.
        "look at either park or posted invoices
        IF is_hdr-xrech IS NOT INITIAL.  "this checking only if invoice, not for other than invoice.
          SELECT SINGLE zz1_invoiceno_mih, belnr, gjahr, bukrs    ##WARN_OK
                 FROM rbkp
                 WHERE zz1_invoiceno_mih = @is_hdr-zz1_invoiceno_mih
                   AND bukrs = @is_hdr-bukrs
                   AND gjahr = @is_hdr-gjahr
                   AND lifnr = @is_hdr-lifnr
                   AND xrech = @is_hdr-xrech
                   AND rbstat EQ '5'
                 INTO @DATA(ls_rbkp).
          IF sy-subrc IS INITIAL.
            READ TABLE ct_items INDEX 1 ASSIGNING FIELD-SYMBOL(<item>).
            APPEND INITIAL LINE TO rt_park_log ASSIGNING FIELD-SYMBOL(<park>).
            <park>-transaction_key = <item>-zz1_transactionkey_cob.
            <park>-trans_type = i_trans_type.
            <park>-bukrs    = is_hdr-bukrs.
            <park>-gjahr    = is_hdr-gjahr.
            <park>-belnr    = is_hdr-belnr.
            <park>-erdat    = sy-datum.
            <park>-erzet    = sy-uzeit.
            <park>-ernam    = sy-uname.
            "Logistics invoice document & / & already exists
            <park>-msgid    = 'ZFI_MSG'.
            <park>-msgno    = 004.
            <park>-msgv1    = ls_rbkp-zz1_invoiceno_mih.
            <park>-msgv2    = ls_rbkp-belnr.
            <park>-msgv3    = ls_rbkp-gjahr.
            <park>-msgv4    = ls_rbkp-bukrs.
            "Duplicated Invoice found for External Invoice &1 (&2/&3 &4)
            MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                       WITH <park>-msgv1 <park>-msgv2 <park>-msgv3 <park>-msgv4 INTO <park>-msg_text.
          ENDIF.

        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD validate_reference_invoice.
    CASE i_trans_type.
      WHEN mc_trans_type_journal_entry.

      WHEN mc_trans_type_supplier_invoice.
        DATA(lv_invoice) = is_hdr-zz1_invoiceno_mih+0(16).
        TRANSLATE lv_invoice TO UPPER CASE.
        IF is_hdr-xblnr NE lv_invoice.
          READ TABLE ct_items INDEX 1 ASSIGNING FIELD-SYMBOL(<item>).
          APPEND INITIAL LINE TO rt_park_log ASSIGNING FIELD-SYMBOL(<park>).
          <park>-transaction_key = <item>-zz1_transactionkey_cob.
          <park>-trans_type = i_trans_type.
          <park>-bukrs    = is_hdr-bukrs.
          <park>-gjahr    = is_hdr-gjahr.
          <park>-belnr    = is_hdr-belnr.
          <park>-erdat    = sy-datum.
          <park>-erzet    = sy-uzeit.
          <park>-ernam    = sy-uname.
          "Logistics invoice document & / & already exists
          <park>-msgid    = 'ZFI_MSG'.
          <park>-msgno    = 005.
          <park>-msgv1    = is_hdr-xblnr.
          <park>-msgv2    = is_hdr-zz1_invoiceno_mih.
          "Reference number &1 is not same as External Invoice &2 first 16 number
          MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                     WITH <park>-msgv1 <park>-msgv2 INTO <park>-msg_text.
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD validate_client_code.

    DATA: lt_items TYPE zfi_t_coding_block.

    lt_items = it_items.
    DATA(lt_rules) = get_validation_rules( EXPORTING i_trans_type = i_trans_type
                                           CHANGING  ct_items     = lt_items
                                            ).
    validate_fields( EXPORTING it_field_rules = lt_rules
                     IMPORTING e_error        = r_error
                     CHANGING  ct_items       = lt_items ).
  ENDMETHOD.


  METHOD INCLUDE_BADI_ERROR_IN_OUTPUT.

    DATA: lt_errprot TYPE mrm_tab_errprot.

    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'MRM_PROT_GET' "get also messages stored in global error log
        IMPORTING
          te_errprot = lt_errprot.
      CHECK lt_errprot IS NOT INITIAL.
      io_log->add_message_from_sy( ).
      io_log->add_message_from_errprot( it_errprot = lt_errprot ).
    ENDIF.

  ENDMETHOD.


  METHOD validate_valid_amdp_vehicle.

    DATA: lt_view        TYPE SORTED TABLE OF zc_ztf_amdp_vehicles
                            WITH NON-UNIQUE KEY zz1_clientcode_cob
                                                zz1_vehicleno_cob
                                                zz1_serialno_cob
                                                zz1_icnno_cob,
          ls_view        TYPE zc_ztf_amdp_vehicles,
          ls_view2       TYPE zc_ztf_amdp_vehicles,
          lt_items       TYPE STANDARD TABLE OF zfi_s_coding_block,
          lv_where       TYPE string,
          lr_struct      TYPE REF TO cl_abap_structdescr,
          lt_rules       TYPE zfi_tt_field_rule_selection,
          lv_select_flds TYPE string,
          lv_index       TYPE n,
          lr_field       TYPE RANGE OF fieldname
          .
    FIELD-SYMBOLS: <field> TYPE any.

    CHECK ct_items IS NOT INITIAL AND it_field_rules IS NOT INITIAL.

    "Get fields to be included in the query for table LT_VIEW
    lr_struct ?= cl_abap_typedescr=>describe_by_data( ls_view ).
    DATA(lt_ddic_info) = lr_struct->get_ddic_field_list( ).
    LOOP AT lt_ddic_info ASSIGNING FIELD-SYMBOL(<ddic>) WHERE fieldname+0(1) <> '.'.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = <ddic>-fieldname ) TO lr_field.
    ENDLOOP.
    CLEAR lt_ddic_info.

    "Process fields with the common view
    LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<item>).
      AT NEW fstag.

        DATA(lv_from) = sy-tabix.
        CLEAR: lv_where, lt_rules, ls_view2.
        DATA(lt_rules_all) = it_field_rules.
        LOOP AT lt_rules_all ASSIGNING FIELD-SYMBOL(<rule>)
              WHERE ( ( bukrs = <item>-bukrs AND fstag = <item>-fstag )
                   OR ( bukrs = '' AND fstag = '' )  )
                  AND field_name IN lr_field
                  .
          IF <rule>-count IS NOT INITIAL.
            IF <rule>-lookup_validated IS NOT INITIAL.
              "on a normal exception the validated flag will be empty on an exception. If we found
              "exception with empty flag we need to consider the exception as "do not check" and
              "remove all the "regular" lines. However it may be that the regular will be not to
              "check and for specific field we do want to check it under an exception. if the flag
              "under the exception is empty than this AMDP validation is unecessary
              DELETE lt_rules_all WHERE bukrs = <rule>-bukrs
                                    AND fstag = <rule>-fstag
                                    AND saknr = <rule>-saknr
                                    AND field_name = <rule>-field_name
                                    AND count IS INITIAL.
            ELSE.
              "This is an exception and we do not want to validate the field - check the fields to see if it is applicable
              IF <rule>-exc_bukrs IS NOT INITIAL.
                CHECK <rule>-exc_bukrs = <item>-bukrs.
              ENDIF.
              IF <rule>-exc_clientcode_cob IS NOT INITIAL.
                CHECK <rule>-exc_clientcode_cob = <item>-zz1_clientcode_cob.
              ENDIF.
              IF <rule>-exc_pricingelement_cob IS NOT INITIAL.
                CHECK <rule>-exc_pricingelement_cob = <item>-zz1_pricingelement_cob.
              ENDIF.
              IF <rule>-exc_productcode_cob IS NOT INITIAL.
                CHECK <rule>-exc_productcode_cob = <item>-zz1_productcode_cob.
              ENDIF.
              IF <rule>-exc_vehicleno_cob IS NOT INITIAL.
                CHECK <rule>-exc_vehicleno_cob = <item>-zz1_vehicleno_cob.
              ENDIF.
              "exception mathces the item fields - remove the "regular rule"
              DELETE lt_rules_all WHERE bukrs = <rule>-bukrs
                                    AND fstag = <rule>-fstag
                                    AND saknr = <rule>-saknr
                                    AND field_name = <rule>-field_name
                                    .
              CONTINUE.
            ENDIF.
          ENDIF.
          IF <rule>-lookup_validated  = 'X' AND <rule>-required = 'X'.
            "only select by fields which are required.
            IF lv_where IS NOT INITIAL.
              lv_where = |{ lv_where } and |.
            ENDIF.
            lv_where = |{ lv_where } { <rule>-field_name } = @lt_items-{ <rule>-field_name }|  ##NO_TEXT.
            APPEND <rule> TO lt_rules.
          ENDIF.
          IF lv_select_flds IS NOT INITIAL.
            lv_select_flds = |{ lv_select_flds }, { <rule>-field_name }|.
          ELSE.
            lv_select_flds = <rule>-field_name.
          ENDIF.
        ENDLOOP.
      ENDAT.

      AT END OF fstag.
        CHECK lv_where IS NOT INITIAL.
        DATA(lv_to) = sy-tabix.
        CLEAR lt_items.
        APPEND LINES OF ct_items FROM lv_from TO lv_to TO lt_items.

        SORT lt_items                            BY        zz1_clientcode_cob zz1_vehicleno_cob zz1_productcode_cob zz1_serialno_cob.
        DELETE ADJACENT DUPLICATES FROM lt_items COMPARING zz1_clientcode_cob zz1_vehicleno_cob zz1_productcode_cob zz1_serialno_cob.

        LOOP AT lt_items INTO DATA(ls_item2).
          "In the AMDP % is disregarded so it selects all values
          "when all the fields are empty the AMDP cannot find the information as all the
          "fields are empty and the whoel table will be selected but the dynamic AMDP where clause requires at least one value
          IF ls_item2-zz1_clientcode_cob IS INITIAL AND ls_item2-zz1_serialno_cob IS INITIAL
            AND ls_item2-zz1_vehicleno_cob IS INITIAL AND ls_item2-zz1_icnno_cob IS INITIAL.
            CONTINUE.
          ENDIF.

          IF ls_item2-zz1_clientcode_cob IS INITIAL.
            ls_item2-zz1_clientcode_cob = '%'.
          ELSE.
            "check that the field is required for validation
            READ TABLE lt_rules TRANSPORTING NO FIELDS
                       WITH KEY field_name = 'ZZ1_CLIENTCODE_COB'.
            IF sy-subrc IS NOT INITIAL.
              "If the rule does not require to validate this field, remove it as the AMDP
              "search requires 4 parameters and we do not need to supply un validated values
              ls_item2-zz1_clientcode_cob = '%'.
            ENDIF.
          ENDIF.
          IF ls_item2-zz1_serialno_cob IS INITIAL.
            ls_item2-zz1_serialno_cob = '%'.
          ELSE.
            "check that the field is required for validation
            READ TABLE lt_rules TRANSPORTING NO FIELDS
                       WITH KEY field_name = 'ZZ1_SERIALNO_COB'.
            IF sy-subrc IS NOT INITIAL.
              ls_item2-zz1_serialno_cob = '%'.
            ENDIF.
          ENDIF.
          IF ls_item2-zz1_vehicleno_cob IS INITIAL.
            ls_item2-zz1_vehicleno_cob = '%'.
          ELSE.
            "check that the field is required for validation
            READ TABLE lt_rules TRANSPORTING NO FIELDS
                       WITH KEY field_name = 'ZZ1_VEHICLENO_COB'.
            IF sy-subrc IS NOT INITIAL.
              ls_item2-zz1_vehicleno_cob = '%'.
            ENDIF.
          ENDIF.
          SELECT  * FROM zc_ztf_amdp_vehicles( "#EC CI_NOWHERE      "#EC CI_ALL_FIELDS_NEEDED
                 p_client  = @ls_item2-zz1_clientcode_cob,
                 p_icnno   = @ls_item2-zz1_icnno_cob,
                 p_serial  = @ls_item2-zz1_serialno_cob,
                 p_vehicle = @ls_item2-zz1_vehicleno_cob )
                 APPENDING TABLE @lt_view.
        ENDLOOP.

        LOOP AT ct_items FROM lv_from TO lv_to ASSIGNING FIELD-SYMBOL(<item_org>).
          CLEAR: lv_index, lv_where.
          ls_view = CORRESPONDING #( <item_org> ).

          IF ls_view <> ls_view2.
            ls_view2 = ls_view.
            LOOP AT lt_rules ASSIGNING <rule>.
              ASSIGN COMPONENT <rule>-field_name OF STRUCTURE <item_org> TO <field>.
              CHECK <field> IS NOT INITIAL.
              IF lv_where IS NOT INITIAL.
                lv_where = |{ lv_where } and |.
              ENDIF.
              lv_where = |{ lv_where } { <rule>-field_name } = '{ <field> }'|.
            ENDLOOP.

            LOOP AT lt_view TRANSPORTING NO FIELDS WHERE (lv_where).
              EXIT.
            ENDLOOP.
            DATA(lv_subrc) = sy-subrc.
          ENDIF.

          IF lv_subrc IS NOT INITIAL.
            "one of the fields is in error, find out exactly which it is
            IF lt_ddic_info IS INITIAL.
              lr_struct ?= cl_abap_typedescr=>describe_by_data( <item_org> ).
              lt_ddic_info = lr_struct->get_ddic_field_list( ).
            ENDIF.

            "since the entry of multiple fields is not in the table we can't say for sure what field causes the error
            LOOP AT lt_rules ASSIGNING <rule>.
              ASSIGN COMPONENT <rule>-field_name OF STRUCTURE <item_org> TO <field>.
              CHECK <field> IS NOT INITIAL.
              ADD 1 TO lv_index.
              DATA(lv_msg_p) = |<item_org>-msgv{ lv_index }|.
              ASSIGN (lv_msg_p) TO FIELD-SYMBOL(<msgv>).
              READ TABLE lt_ddic_info ASSIGNING <ddic>
                         WITH KEY fieldname = <rule>-field_name.
              <msgv> = |{ <ddic>-scrtext_m } { <field> }|.
              IF <rule>-count IS INITIAL.
                <item_org>-rule_exc = 'X'.
              ENDIF.
            ENDLOOP.
            IF <item_org>-msgv1 IS INITIAL AND <item_org>-msgv2 IS INITIAL AND <item_org>-msgv3 IS INITIAL.
              "Custom Fields &1 &2 &3 are empty
              <item_org>-msgid = 'ZPARK'.
              <item_org>-msgno = 006.
              CLEAR lv_index.
              LOOP AT lt_rules ASSIGNING <rule>.
                ADD 1 TO lv_index.
                lv_msg_p = |<item_org>-msgv{ lv_index }|.
                ASSIGN (lv_msg_p) TO <msgv>.
                <msgv> = <rule>.
              ENDLOOP.
            ELSE.
              <item_org>-msgid = 'ZPARK'.
              <item_org>-msgno = 005.
              <item_org>-msgv4 = 'ZC_ZTF_AMDP_VEHICLES'.
            ENDIF.
            "Invalid key combination &1 &2 &3 in query &4
            r_error = 'X'.
          ENDIF.
        ENDLOOP.
      ENDAT.
    ENDLOOP.

  ENDMETHOD.


  METHOD validate_header_fields.


    CASE i_trans_type.
      WHEN mc_trans_type_journal_entry.

      WHEN mc_trans_type_supplier_invoice.

        IF is_hdr-zz1_invoicecategory_mih IS NOT INITIAL.
          "if invoice category is supplied, make sure it is from one of the permitted values in table ZFI_INV_CATEGORY
          SELECT SINGLE invoice_category FROM zfi_inv_category
                 WHERE invoice_category = @is_hdr-zz1_invoicecategory_mih
                 INTO @DATA(lv_inv_cat).
          .
          IF sy-subrc IS NOT INITIAL.
            APPEND INITIAL LINE TO rt_park_log ASSIGNING FIELD-SYMBOL(<park>).
            <park> = CORRESPONDING #( is_hdr ).
            <park>-trans_type = mc_trans_type_supplier_invoice.
            <park>-erdat    = sy-datum.
            <park>-erzet    = sy-uzeit.
            <park>-ernam    = sy-uname.
            "Value &1 not valid in table &2
            <park>-msgid    = 'HRPAYFR_N4DS'.
            <park>-msgno    = 008.
            <park>-msgv1    = is_hdr-zz1_invoicecategory_mih.
            <park>-msgv2    = 'ZFI_INV_CATEGORY'.
            MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                       WITH <park>-msgv1 <park>-msgv2 <park>-msgv3 <park>-msgv4 INTO <park>-msg_text.
          ENDIF.
        ENDIF.

        IF is_hdr-ivtyp IS INITIAL AND is_hdr-zz1_invoicecategory_mih IS INITIAL.  "IVTYP='' -> Online
          "if came from online (fiori app), invoice category is obligatory for US and Canada only.
*          "CR074 - Park if missing on integration for US/CA if invoice category is missing
          SELECT SINGLE bukrs FROM t001
                 WHERE bukrs = @is_hdr-bukrs
                   AND land1 IN ('CA','US')
                 INTO @DATA(lv_bukrs).
          IF sy-subrc IS INITIAL.
            APPEND INITIAL LINE TO rt_park_log ASSIGNING <park>.
            <park> = CORRESPONDING #( is_hdr ).
            <park>-trans_type = mc_trans_type_supplier_invoice.
            <park>-erdat    = sy-datum.
            <park>-erzet    = sy-uzeit.
            <park>-ernam    = sy-uname.
            "Invoice category not maintained for CA/US in Document &1 &2 &3 and hence parked
            <park>-msgid    = 'ZPARK'.
            <park>-msgno    = 020.

            MESSAGE ID <park>-msgid TYPE 'I' NUMBER <park>-msgno
                       WITH <park>-msgv1 <park>-msgv2 <park>-msgv3 <park>-msgv4 INTO <park>-msg_text.
          ENDIF.
        ENDIF.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
