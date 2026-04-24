
CLASS zcl_fi_reversal_sync DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.


  PUBLIC SECTION.

    CLASS-METHODS build_accit_from_rbco
      IMPORTING
        !is_rbkp_new     TYPE rbkp
      RETURNING
        !VALUE(rt_accit) TYPE accit_tab.

    CLASS-METHODS build_acchd_accit
      IMPORTING
        is_bkpf_ref TYPE bkpf
      EXPORTING
        es_acchd    TYPE acchd
        et_accit    TYPE accit_tab.
    CLASS-METHODS process_from_supplier_invoice
      IMPORTING is_supplier_invoice_header TYPE rbkp
      RETURNING VALUE(rv_result)           TYPE abap_bool.

    CLASS-METHODS process_from_journal_entry
      IMPORTING is_journal_entry_header TYPE bkpf
      RETURNING VALUE(rv_result)        TYPE abap_bool.


  PRIVATE SECTION.

    TYPES:
      "Internal structure mapped to ZFI_REV_DOC_REF (key: mandt, bukrs, belnr, gjahr)
      BEGIN OF ty_trigger,
        bukrs                  TYPE bukrs,
        belnr                  TYPE belnr_d,
        gjahr                  TYPE gjahr,
        blart                  TYPE blart,
        docln                  TYPE docln,
        lifnr                  TYPE lifnr,
        waers                  TYPE waers,
        wrbtr                  TYPE wrbtr,
        augbl                  TYPE augbl,
        augdt                  TYPE augdt,
        zz1_transactionkey_cob TYPE zz1_transactionkey,
        zz1_clientcode_cob     TYPE zz1_clientcode,
        zz1_vehicleno_cob      TYPE zz1_vehicleno,
        zz1_invoicenumber_cob  TYPE zz1_invoicenumber,
      END OF ty_trigger,
      ty_trigger_tab TYPE SORTED TABLE OF ty_trigger WITH NON-UNIQUE KEY bukrs belnr gjahr zz1_transactionkey_cob.

    "Business constants
    CONSTANTS c_blart_target TYPE blart VALUE 'Y2' ##NO_TEXT.
    CONSTANTS c_gl_account   TYPE hkont VALUE '0019000198' ##NO_TEXT.
    CONSTANTS c_source_skip  TYPE zz1_source VALUE 'BR198REV' ##NO_TEXT.

    CLASS-METHODS get_qualifying_lines
      IMPORTING
        !it_accit       TYPE accit_tab
        !iv_revdoc      TYPE belnr_d
        !iv_revdocyear  TYPE gjahr
      RETURNING
        VALUE(rt_lines) TYPE ty_trigger_tab.

    CLASS-METHODS update_zfi_rev_doc_ref
      IMPORTING
        !is_acchd TYPE acchd
        !it_lines TYPE ty_trigger_tab.




ENDCLASS.



CLASS zcl_fi_reversal_sync IMPLEMENTATION.

  METHOD get_qualifying_lines.
    rt_lines = VALUE ty_trigger_tab(
      FOR wa IN it_accit
      WHERE ( blart                  = c_blart_target
          AND hkont                  = c_gl_account
          AND zz1_source_cob         <> c_source_skip
          AND zz1_transactionkey_cob IS NOT INITIAL )
      ( VALUE #(
          bukrs                  = wa-bukrs
          belnr                  = iv_revdoc
          gjahr                  = iv_revdocyear
          blart                  = wa-blart
          docln                  = wa-buzei
          lifnr                  = wa-lifnr
          waers                  = wa-swaer
          wrbtr                  = wa-lwbtr
          augbl                  = wa-augbl
          augdt                  = wa-augdt
          zz1_transactionkey_cob = wa-zz1_transactionkey_cob
          zz1_clientcode_cob     = wa-zz1_clientcode_cob
          zz1_vehicleno_cob      = wa-zz1_vehicleno_cob
          zz1_invoicenumber_cob  = wa-zz1_invoicenumber_cob ) ) ).
  ENDMETHOD.


  METHOD update_zfi_rev_doc_ref.
    "Insert one row per qualifying line. Skip only if same key (bukrs, belnr, gjahr, docln) already exists.
    "Table key must include docln so multiple lines per document are allowed.
    CHECK it_lines IS NOT INITIAL.

    DATA(lv_ts) = |{ sy-datum }{ sy-uzeit }|. "cl_abap_context_info=>get_system_time( ).

    DATA lt_keys TYPE SORTED TABLE OF zfi_rev_doc_ref WITH UNIQUE KEY bukrs belnr gjahr docln.
    LOOP AT it_lines ASSIGNING FIELD-SYMBOL(<key>).
      INSERT VALUE #( bukrs = <key>-bukrs belnr = <key>-belnr gjahr = <key>-gjahr docln = <key>-docln ) INTO TABLE lt_keys.
    ENDLOOP.
    CHECK lt_keys IS NOT INITIAL.

    " DATA lt_existing TYPE SORTED TABLE OF zfi_rev_doc_ref WITH UNIQUE KEY bukrs belnr gjahr docln.
    SELECT bukrs, belnr, gjahr, docln
      FROM zfi_rev_doc_ref
      FOR ALL ENTRIES IN @lt_keys
      WHERE bukrs = @lt_keys-bukrs
        AND belnr = @lt_keys-belnr
        AND gjahr = @lt_keys-gjahr
        AND docln = @lt_keys-docln
      INTO TABLE @DATA(lt_existing).

    DATA lt_to_insert TYPE TABLE OF zfi_rev_doc_ref.
    LOOP AT it_lines ASSIGNING FIELD-SYMBOL(<line>).
      READ TABLE lt_existing WITH KEY bukrs = <line>-bukrs belnr = <line>-belnr gjahr = <line>-gjahr docln = <line>-docln
        TRANSPORTING NO FIELDS.
      CHECK sy-subrc <> 0.

      DATA(ls_db) = CORRESPONDING zfi_rev_doc_ref( <line> ).
      ls_db-mandt      = sy-mandt.
      ls_db-created_ts = lv_ts.
      ls_db-doc_type = is_acchd-psoak.
      APPEND ls_db TO lt_to_insert.
    ENDLOOP.

    CHECK lt_to_insert IS NOT INITIAL.
    TRY.
        MODIFY zfi_rev_doc_ref FROM TABLE @lt_to_insert.
      CATCH cx_sy_open_sql_db.
        "Intentionally swallow: do not interrupt FI posting.
    ENDTRY.
  ENDMETHOD.

  METHOD build_accit_from_rbco.
    " build supplier invoice reversal lines
    DATA: lt_rbco  TYPE STANDARD TABLE OF rbco,
          ls_accit TYPE accit.
    " Read RBCO based on reversal reference
    SELECT bukrs,
       belnr,
       gjahr,
       saknr,
       cobl_nr,
       zz1_transactionkey_cob,
       zz1_clientcode_cob,
       zz1_vehicleno_cob,
       zz1_invoicenumber_cob,
       zz1_source_cob,
       wrbtr
  FROM rbco
  INTO CORRESPONDING FIELDS OF TABLE @lt_rbco
 WHERE belnr = @is_rbkp_new-stblg
   AND gjahr = @is_rbkp_new-stjah.



    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    " Map RBCO → ACCIT
    LOOP AT lt_rbco ASSIGNING FIELD-SYMBOL(<ls_rbco>).
      CLEAR ls_accit.
      ls_accit-mandt = sy-mandt.
      ls_accit-bukrs = <ls_rbco>-bukrs.
      ls_accit-belnr = <ls_rbco>-belnr.
      ls_accit-gjahr = <ls_rbco>-gjahr.
      ls_accit-blart = is_rbkp_new-blart.
      ls_accit-hkont = <ls_rbco>-saknr.
      ls_accit-docln = <ls_rbco>-cobl_nr.
      ls_accit-buzei = <ls_rbco>-cobl_nr.
      ls_accit-zz1_transactionkey_cob = <ls_rbco>-zz1_transactionkey_cob.
      ls_accit-zz1_clientcode_cob     = <ls_rbco>-zz1_clientcode_cob.
      ls_accit-zz1_vehicleno_cob      = <ls_rbco>-zz1_vehicleno_cob.
      ls_accit-zz1_invoicenumber_cob  = <ls_rbco>-zz1_invoicenumber_cob.
      ls_accit-zz1_source_cob         = <ls_rbco>-zz1_source_cob.
      ls_accit-lifnr = is_rbkp_new-lifnr.
      ls_accit-swaer = is_rbkp_new-waers.
      ls_accit-swaer = is_rbkp_new-waers.
      ls_accit-lwbtr = <ls_rbco>-wrbtr.
      ls_accit-lwbtr = <ls_rbco>-wrbtr.

      APPEND ls_accit TO rt_accit.

    ENDLOOP.
  ENDMETHOD.

  METHOD build_acchd_accit.
    DATA ls_bkpf TYPE bkpf.
    DATA lt_bseg TYPE STANDARD TABLE OF bseg WITH EMPTY KEY.

    CLEAR: es_acchd, et_accit.

    " 1) Read header (BKPF) - reversal document header (STBLG/STJAH)
    SELECT SINGLE bukrs, gjahr, waers, blart, stblg, stjah FROM bkpf
      INTO @DATA(ls_result)
      WHERE bukrs = @is_bkpf_ref-bukrs
        AND belnr = @is_bkpf_ref-stblg
        AND gjahr = @is_bkpf_ref-stjah.

    IF sy-subrc <> 0.
      RETURN.
    ELSE.
      ls_bkpf = CORRESPONDING #( ls_result ).
    ENDIF.

    " 2) Read items (BSEG)
    SELECT bukrs,
        belnr,
        gjahr,
        buzei,
        lifnr,
        kunnr,
        hkont,
        wrbtr,
        augbl,
        augdt,
        shkzg,
        sgtxt,
        zuonr,
        mwskz,
        kostl,
        prctr,
        aufnr,
        zterm,
        zfbdt,
        zz1_source_cob,
        zz1_transactionkey_cob,
        zz1_clientcode_cob,
        zz1_vehicleno_cob,
        zz1_invoicenumber_cob
   FROM bseg
   INTO CORRESPONDING FIELDS OF TABLE @lt_bseg
  WHERE bukrs = @is_bkpf_ref-bukrs
    AND belnr = @is_bkpf_ref-stblg
    AND gjahr = @is_bkpf_ref-stjah
    ORDER BY PRIMARY KEY..


    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " 4) Map BKPF -> ACCHD
    CLEAR es_acchd.
    es_acchd-psoak = 'JE'.

    " Map BSEG -> ACCIT
    LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<ls_bseg>).

      DATA(ls_accit) = VALUE accit( ).

      ls_accit-bukrs                  = <ls_bseg>-bukrs.
      ls_accit-belnr                  = <ls_bseg>-belnr.
      ls_accit-gjahr                  = <ls_bseg>-gjahr.
      ls_accit-buzei                  = <ls_bseg>-buzei.
      ls_accit-blart                  = ls_bkpf-blart.
      ls_accit-lifnr                  = <ls_bseg>-lifnr.
      ls_accit-kunnr                  = <ls_bseg>-kunnr.
      ls_accit-hkont                  = <ls_bseg>-hkont.
      ls_accit-swaer                  = ls_bkpf-waers.
      ls_accit-lwbtr                  = <ls_bseg>-wrbtr.
      ls_accit-augbl                  = <ls_bseg>-augbl.
      ls_accit-augdt                  = <ls_bseg>-augdt.
      ls_accit-shkzg                  = <ls_bseg>-shkzg.
      ls_accit-sgtxt                  = <ls_bseg>-sgtxt.
      ls_accit-zuonr                  = <ls_bseg>-zuonr.
      ls_accit-mwskz                  = <ls_bseg>-mwskz.
      ls_accit-kostl                  = <ls_bseg>-kostl.
      ls_accit-prctr                  = <ls_bseg>-prctr.
      ls_accit-aufnr                  = <ls_bseg>-aufnr.
      ls_accit-zterm                  = <ls_bseg>-zterm.
      ls_accit-zfbdt                  = <ls_bseg>-zfbdt.
      ls_accit-zz1_source_cob         = <ls_bseg>-zz1_source_cob.
      ls_accit-zz1_transactionkey_cob = <ls_bseg>-zz1_transactionkey_cob.
      ls_accit-zz1_clientcode_cob     = <ls_bseg>-zz1_clientcode_cob.
      ls_accit-zz1_vehicleno_cob      = <ls_bseg>-zz1_vehicleno_cob.
      ls_accit-zz1_invoicenumber_cob  = <ls_bseg>-zz1_invoicenumber_cob.

      APPEND ls_accit TO et_accit.

    ENDLOOP.
  ENDMETHOD.

  METHOD process_from_supplier_invoice.
    DATA(lt_supplier_line_items) = build_accit_from_rbco( is_supplier_invoice_header ).
    DATA(lt_qualified_lines) = get_qualifying_lines( it_accit     = lt_supplier_line_items
                                                    iv_revdoc    = is_supplier_invoice_header-stblg
                                                    iv_revdocyear = is_supplier_invoice_header-stjah ).
    DATA(is_acchd) = VALUE acchd( psoak = 'RE' ).
    update_zfi_rev_doc_ref( is_acchd = is_acchd
                            it_lines = lt_qualified_lines ).
  ENDMETHOD.

  METHOD process_from_journal_entry.

    DATA: c_acchd TYPE acchd,
          c_accit TYPE accit_tab.
    build_acchd_accit(
         EXPORTING
          is_bkpf_ref = is_journal_entry_header
          IMPORTING
          es_acchd    = c_acchd
             et_accit    = c_accit ).
    DATA(lt_qualified_lines) = get_qualifying_lines( it_accit     = c_accit
                                                    iv_revdoc    = is_journal_entry_header-belnr
                                                    iv_revdocyear = is_journal_entry_header-gjahr ).
    DATA(is_acchd) = VALUE acchd( psoak = 'JE' ).
    update_zfi_rev_doc_ref( is_acchd = is_acchd
                            it_lines = lt_qualified_lines ).
  ENDMETHOD.

ENDCLASS.
