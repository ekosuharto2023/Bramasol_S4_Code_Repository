class ZCL_COS_DATA_BUILD definition
  public
  create public .

public section.

  types:
    BEGIN OF ty_cos_gl_amts,
        itemno_acc          TYPE numc3,
        zz1_productcode_cob TYPE zz1_productcode,
        source_gl           TYPE zsource_gl,    " Input Gl from BADI
        markup_gl           TYPE zmarkup_gl,
        sales_gl            TYPE zsales_gl,     " for Credit Entry ( SHKZG = H ) line item
        cos_gl              TYPE zcos_gl,       " for Debit  Entry ( SHKZG = S ) line item
        currency            TYPE waers,
        amt_doccur          TYPE wrbtr,
        costcenter          TYPE kostl,
        profit_ctr          TYPE prctr,
      END OF ty_cos_gl_amts .
  types:
    tt_cos_gl_amts TYPE STANDARD TABLE OF ty_cos_gl_amts .
  types:
    ty_zz1_source_rng TYPE RANGE OF acdoca-zz1_source_cob .

  constants MC_FI_COS_OBJ_TYPE type AWTYP value 'BKPFF' ##NO_TEXT.
  constants MC_FI_COS_DOC_TYPE type BLART value 'Y2' ##NO_TEXT.
  constants MC_COS_UK_COUNTRY type LAND1 value 'GB' ##NO_TEXT.
  constants MC_COS_EXCL_ZZ1_SOURCE_COB_SET type RVARI_VNAM value 'ZCOS_EXCL_ZZ1_SOURCE_COB' ##NO_TEXT.

  class-methods COS_PROCCESSOR
    importing
      !IS_RBKP_NEW type RBKP optional
      !IS_BAPI_DOC_HEADER type BAPI_INCINV_CREATE_HEADER optional
    changing
      !CT_ACCIT type ACCIT_TAB optional
      !CT_ACCCR type ACCCR_TAB optional
      !CT_BAPI_GLACCOUNT type BAPI_INCINV_CREATE_GL_ACCT_T optional
      !CT_BAPI_EXTENSION2 type BAPIPAREX_T optional .
  class-methods CHECK_DOC_TO_BE_EXPLODED
    importing
      !I_POST_BAPI_CHANGE type CHAR1 optional
      !IT_ACCIT type ACCIT_TAB optional
      !IT_ACCCR type ACCCR_TAB optional
      !I_TRANS_TYPE type ZTRANS_TYPE
    exporting
      !ET_RETURN type BAPIRET2_T
      !ET_GL type CTE_T_INCINV_GL_ACCOUNT
    changing
      !C_BUKRS type BUKRS optional
      !C_BELNR type RE_BELNR optional
      !C_GJAHR type GJAHR optional
    returning
      value(R_AUTO_RELEASE) type CHAR1 .
  class-methods CONVERT_ACCIT_TO_XML_EXTENSION
    importing
      !IT_ACCIT type ACCIT_TAB
      !I_TRANS_TYPE type ZTRANS_TYPE
    returning
      value(RT_EXTENSION) type BAPIPAREX_T .
  PROTECTED SECTION.
private section.

  class-data:
    mt_gl_rules TYPE SORTED TABLE OF zmap_cos_rules
                        WITH UNIQUE KEY productcode source_gl .
  class-data:
    mt_set      TYPE STANDARD TABLE OF rgsbv .
  class-data MC_REVERSAL type CRM_ISU_E_REVERSED .

  class-methods CHECK_COS_REQUIRED
    importing
      !IS_RBKP type RBKP
    returning
      value(R_COS_NEEDED) type ABAP_BOOLEAN .
  class-methods GET_COS_RELEVANT_GL_ITEMS
    importing
      !IT_ACCIT type ACCIT_TAB
    returning
      value(RT_ACCIT) type ACCIT_TAB .
  class-methods EXPLODE_COS_GL_ITEMS
    importing
      !IT_ACCIT type ACCIT_TAB
      !IT_ACCCR type ACCCR_TAB
      !I_LINES type I
      !I_TRANS_TYPE type ZTRANS_TYPE
      !IS_HDR type RBKP
    exporting
      !ET_ACCIT type ACCIT_TAB
      !ET_ACCCR type ACCCR_TAB
    changing
      !CT_BAPI_EXTENSION2 type BAPIPAREX_T .
  class-methods CONVERT_ACCIT_TO_BAPI
    importing
      !IT_ACCIT type ACCIT_TAB
      !IT_ACCCR type ACCCR_TAB
    exporting
      !ET_BAPI_GLACCOUNT type BAPI_INCINV_CREATE_GL_ACCT_T .
  class-methods CONVERT_BAPI_TO_ACCIT
    importing
      !IT_BAPI_GLACCOUNT type BAPI_INCINV_CREATE_GL_ACCT_T
      !IT_BAPI_EXTENSION2 type BAPIPAREX_T
    exporting
      !ET_ACCIT type ACCIT_TAB
      !ET_ACCCR type ACCCR_TAB
      !ES_HDR type RBKP .
  class-methods EXPLODE_BAPIEXT
    importing
      !IS_ACCIT type ACCIT
      !I_POSNR type POSNR_ACC
      !I_TRANS_TYPE type ZTRANS_TYPE
    changing
      !CT_BAPI_EXTENSION2 type BAPIPAREX_T .
ENDCLASS.



CLASS ZCL_COS_DATA_BUILD IMPLEMENTATION.


  METHOD cos_proccessor.

    DATA: lt_accit TYPE accit_tab,
          lt_acccr TYPE acccr_tab,
          ls_hdr   TYPE rbkp.

    IF ct_bapi_glaccount IS SUPPLIED.
      convert_bapi_to_accit(
        EXPORTING
          it_bapi_glaccount  = ct_bapi_glaccount
          it_bapi_extension2 = ct_bapi_extension2
        IMPORTING
          et_accit           = lt_accit
          et_acccr           = lt_acccr
          es_hdr             = ls_hdr
      ).
    ELSE.
      ls_hdr = is_rbkp_new.
      lt_accit = ct_accit.
      lt_acccr = ct_acccr.
    ENDIF.

    " COS process should be triggerred only for UK company code. Exit for other company codes
    CHECK check_cos_required( ls_hdr ) IS NOT INITIAL.

    DATA(lt_accit_valid) = get_cos_relevant_gl_items( lt_accit ).
    CHECK lt_accit_valid IS NOT INITIAL.

    IF ls_hdr-stblg IS NOT INITIAL OR is_bapi_doc_header-inv_ref_no IS NOT INITIAL.
      mc_reversal = 'X'.
    ENDIF.

    explode_cos_gl_items( EXPORTING i_trans_type       = zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice
                                    it_accit           = lt_accit
                                    it_acccr           = lt_acccr
                                    i_lines            = lines( lt_accit )
                                    is_hdr             = is_rbkp_new
                          IMPORTING et_accit           = DATA(lt_expl_accit)
                                    et_acccr           = DATA(lt_expl_acccr)
                          CHANGING  ct_bapi_extension2 = ct_bapi_extension2
                                  ).
    APPEND LINES OF lt_expl_accit TO lt_accit.
    APPEND LINES OF lt_expl_acccr TO lt_acccr.

    IF ct_bapi_glaccount IS SUPPLIED.
      convert_accit_to_bapi(
        EXPORTING
          it_accit          = lt_expl_accit
          it_acccr          = lt_expl_acccr
        IMPORTING
          et_bapi_glaccount = ct_bapi_glaccount
      ).
    ELSE.
      ct_accit = lt_accit.
      ct_acccr = lt_acccr.
    ENDIF.

  ENDMETHOD.


  METHOD get_cos_relevant_gl_items.

    rt_accit = it_accit.

    IF mt_gl_rules IS INITIAL.
      CALL FUNCTION 'G_SET_FETCH'
        EXPORTING
          setnr           = mc_cos_excl_zz1_source_cob_set
        TABLES
          set_lines_basic = mt_set
        EXCEPTIONS
          OTHERS          = 0.

      SORT mt_set BY from.

      SELECT *
            FROM zmap_cos_rules
            INTO TABLE mt_gl_rules
            WHERE validfrom <= sy-datum
               AND validto >= sy-datum.
    ENDIF.

    LOOP AT rt_accit ASSIGNING FIELD-SYMBOL(<accit>).
      DATA(lv_tabix) = sy-tabix.

      "Line items with specific ZZ1_SOURCE_COB values should be excluded from COS process
      "These values are maintained in set ZCOS_EXCL_ZZ1_SOURCE_COB
      IF <accit>-zz1_source_cob IS NOT INITIAL.
        READ TABLE mt_set TRANSPORTING NO FIELDS
                   WITH KEY from = <accit>-zz1_source_cob
                   BINARY SEARCH
                   .
        IF sy-subrc IS INITIAL.
          DELETE rt_accit INDEX lv_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.

      READ TABLE mt_gl_rules TRANSPORTING NO FIELDS
                  WITH KEY productcode = <accit>-zz1_productcode_cob
                           source_gl   = <accit>-hkont
                           .
      IF sy-subrc IS NOT INITIAL.
        DELETE rt_accit INDEX lv_tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_cos_required.

    CONSTANTS: lc_zfi_is_cos_active TYPE tvarvc-name VALUE 'ZFI_IS_COS_ACTIVE'.

    SELECT SINGLE low FROM tvarvc   ##NEEDED
           WHERE name = @lc_zfi_is_cos_active
             AND low  = 'X'
           INTO @DATA(lv_cos_active).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT SINGLE land1   ##NEEDED
           FROM t001
           WHERE bukrs = @is_rbkp-bukrs
             AND land1 = @mc_cos_UK_country
           INTO @DATA(lv_country).
    IF sy-subrc IS INITIAL.
      r_cos_needed = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD explode_cos_gl_items.

    TYPES: BEGIN OF ty_cos_worker,
             productcode TYPE zz1_productcode,
             source_gl   TYPE hkont,
             markup_gl   TYPE hkont,
             sales_gl    TYPE hkont,
             cos_gl      TYPE hkont,
             debit_amt   TYPE wrbtr,
             credit_amt  TYPE wrbtr,
             accit_line  TYPE accit,   " Original accit line
           END OF ty_cos_worker.

    DATA: lv_debit_total  TYPE wrbtr,
          lv_credit_total TYPE wrbtr,
          lv_difference   TYPE wrbtr,
          lv_index        TYPE posnr_acc,
          lv_old_doc      TYPE dzuonr,
          lt_agg          TYPE STANDARD TABLE OF ty_cos_worker.

    IF mc_reversal IS INITIAL.
      DATA(lv_debit)  = 'S'.
      DATA(lv_post_key_debit) = '40'.
      DATA(lv_credit) = 'H'.
      DATA(lv_post_key_credit) = '50'.
    ELSE.
      lv_debit  = 'H'.
      lv_post_key_debit = '50'.
      lv_credit = 'S'.
      lv_post_key_credit = '40'.
    ENDIF.

    CASE i_trans_type.
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice.
        lv_old_doc = |{ is_hdr-belnr }{ is_hdr-gjahr }|.
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.
        lv_old_doc = |{ is_hdr-belnr }{ is_hdr-bukrs }{ is_hdr-gjahr }|.
    ENDCASE.

    LOOP AT it_accit ASSIGNING FIELD-SYMBOL(<accit>) WHERE shkzg = lv_debit.
      READ TABLE mt_gl_rules ASSIGNING FIELD-SYMBOL(<rule>)
           WITH KEY productcode = <accit>-zz1_productcode_cob
                    source_gl   = <accit>-hkont.
      CHECK sy-subrc IS INITIAL.

      "Get corresponding document currency line
      READ TABLE it_acccr ASSIGNING FIELD-SYMBOL(<acccr>)
        WITH KEY posnr = <accit>-posnr
                 curtp = '00'.

      READ TABLE lt_agg ASSIGNING FIELD-SYMBOL(<agg>)
        WITH KEY productcode = <rule>-productcode
                 source_gl   = <rule>-source_gl
                 markup_gl   = <rule>-markup_gl.

      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO lt_agg ASSIGNING <agg>.
        <agg>-productcode = <rule>-productcode.
        <agg>-source_gl   = <rule>-source_gl.
        <agg>-markup_gl   = <rule>-markup_gl.
        <agg>-sales_gl    = <rule>-sales_gl.
        <agg>-cos_gl      = <rule>-cos_gl.
        <agg>-debit_amt   = <acccr>-wrbtr.
        <agg>-accit_line   = <accit>.
      ELSE.
        <agg>-debit_amt += <acccr>-wrbtr.
      ENDIF.
    ENDLOOP.

*--------------------------------------------------------------------*
* STEP 2: Aggregate CREDIT amounts (by Markup GL)
*--------------------------------------------------------------------*
    LOOP AT it_accit ASSIGNING <accit> WHERE shkzg = lv_credit.
      LOOP AT lt_agg ASSIGNING <agg>
              WHERE markup_gl   = <accit>-hkont.
        READ TABLE it_acccr ASSIGNING <acccr>
              WITH KEY posnr = <accit>-posnr
                       curtp = '00'.

        <agg>-credit_amt += <acccr>-wrbtr.
      ENDLOOP.
    ENDLOOP.
*--------------------------------------------------------------------*
* STEP 3: Debit / Credit difference
*--------------------------------------------------------------------*
    "Payload do not have a credit in negative amount.
    "If coming from a manual entry and database is read we will have a negative credit amount.
    "Since we collect all debits and all credits both need to be in a positive amount in the aggregation table
    "reset thos amounts and calculate the document balance to be distributed
    LOOP AT lt_agg ASSIGNING <agg>.
      IF <agg>-credit_amt < 0.
        <agg>-credit_amt = <agg>-credit_amt * -1.
      ENDIF.
      lv_debit_total += <agg>-debit_amt.
      lv_credit_total += <agg>-credit_amt.
    ENDLOOP.

    lv_difference = lv_debit_total - lv_credit_total.

    "Get tax codes for accounts
    CHECK lt_agg IS NOT INITIAL.
    SELECT FROM skb1 AS a JOIN zmap_cos_rules AS b ON a~saknr = b~cos_gl
                                                  AND a~bukrs = @<accit>-bukrs
        FIELDS saknr,
               CASE mwskz
                 WHEN '+' THEN 'A0'
                 WHEN '-' THEN 'V0'
                 ELSE mwskz
               END AS tax_code
    UNION
    SELECT FROM skb1 AS a JOIN zmap_cos_rules AS b ON a~saknr = b~sales_gl
                                                  AND a~bukrs = @<accit>-bukrs
        FIELDS saknr,
               CASE mwskz
                 WHEN '+' THEN 'A0'
                 WHEN '-' THEN 'V0'
                 ELSE mwskz
               END AS tax_code
        ORDER BY saknr
        INTO TABLE @DATA(lt_gl)
        .

*--------------------------------------------------------------------*
* STEP 4: Build COS Debit and Sales Credit lines
*--------------------------------------------------------------------*
    lv_index = i_lines.
    LOOP AT lt_agg ASSIGNING <agg>.
      DATA(lv_final_amt) =
        CONV wrbtr( <agg>-debit_amt * lv_difference / lv_debit_total ).

*---- COS Debit Line -------------------------------------------------*
      APPEND INITIAL LINE TO et_accit ASSIGNING <accit>.
      ADD 1 TO lv_index.
      <accit> = <agg>-accit_line.
      explode_bapiext( EXPORTING i_trans_type       = i_trans_type
                                 is_accit           = <accit>
                                 i_posnr            = lv_index
                       CHANGING  ct_bapi_extension2 = ct_bapi_extension2 ).

      <accit>-posnr = <accit>-bapi_tabix = lv_index.
      <accit>-shkzg = lv_debit.
      <accit>-bschl = lv_post_key_debit.
      <accit>-hkont = <accit>-saknr = <agg>-cos_gl.
      <accit>-sgtxt = |COS { <agg>-productcode }|.
      <accit>-zuonr = lv_old_doc.

      CLEAR: <accit>-kostl, <accit>-prctr.
      READ TABLE lt_gl ASSIGNING FIELD-SYMBOL(<gl>)
                 WITH KEY saknr = <accit>-hkont
                 BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        <accit>-mwskz = <gl>-tax_code.
      ENDIF.

      DATA(ls_amt_deb) = VALUE acccr(
        BASE it_acccr[ 1 ]
        posnr = <accit>-posnr
        wrbtr = lv_final_amt ).

      APPEND ls_amt_deb TO et_acccr.

*---- Sales Credit Line ---------------------------------------------*
      APPEND INITIAL LINE TO et_accit ASSIGNING <accit>.
      <accit> = <agg>-accit_line.
      ADD 1 TO lv_index.
      explode_bapiext( EXPORTING i_trans_type       = i_trans_type
                                 is_accit           = <accit>
                                 i_posnr            = lv_index
                       CHANGING  ct_bapi_extension2 = ct_bapi_extension2 ).
      <accit>-posnr = <accit>-bapi_tabix = lv_index.
      <accit>-shkzg = lv_credit.
      <accit>-bschl = lv_post_key_credit.
      <accit>-hkont = <accit>-saknr = <agg>-sales_gl.
      <accit>-sgtxt = |COS { <agg>-productcode }|.
      <accit>-zuonr = lv_old_doc.

      READ TABLE lt_gl ASSIGNING <gl>
                 WITH KEY saknr = <accit>-hkont
                 BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        <accit>-mwskz = <gl>-tax_code.
      ENDIF.

      DATA(ls_amt_cr) = ls_amt_deb.
      ls_amt_cr-posnr = <accit>-posnr.
      ls_amt_cr-wrbtr = lv_final_amt * -1.

      APPEND ls_amt_cr TO et_acccr.
    ENDLOOP.
    SORT et_accit BY posnr.
    SORT et_acccr BY posnr.

  ENDMETHOD.


  METHOD convert_accit_to_bapi.

    FIELD-SYMBOLS: <src> TYPE any,
                   <dst> TYPE any.

    SELECT * FROM zbc_map
           WHERE bapiname = 'BAPI_INCOMINGINVOICE_CREATE1'
            AND bapi_tab = 'GLACCOUNTDATA'
            AND fieldname <> ''
            INTO TABLE @DATA(lt_map).

    LOOP AT it_accit ASSIGNING FIELD-SYMBOL(<accit>).
      APPEND INITIAL LINE TO et_bapi_glaccount ASSIGNING FIELD-SYMBOL(<gl>).
      LOOP AT lt_map ASSIGNING FIELD-SYMBOL(<map>).
        ASSIGN COMPONENT <map>-fieldname OF STRUCTURE <accit> TO <src>.
        CHECK sy-subrc IS INITIAL.
        ASSIGN COMPONENT <map>-bapi_fld OF STRUCTURE <gl> TO <dst>.
        <dst> = <src>.
      ENDLOOP.
      READ TABLE it_acccr ASSIGNING FIELD-SYMBOL(<acccr>)
                 WITH KEY posnr = <accit>-posnr.
      <gl>-item_amount = abs( <acccr>-wrbtr ).
    ENDLOOP.

  ENDMETHOD.


  METHOD convert_bapi_to_accit.

    DATA: lv_xml     TYPE string,
          lv_dummy   TYPE string,
          lv_dummy2  TYPE string,
          ref_struct TYPE REF TO cl_abap_structdescr,
          lv_str     TYPE string
          .
    FIELD-SYMBOLS: <src> TYPE any,
                   <dst> TYPE any.

    SELECT * FROM zbc_map
           WHERE bapiname = 'BAPI_INCOMINGINVOICE_CREATE1'
            AND  bapi_tab = 'GLACCOUNTDATA'
            AND fieldname <> ''
            INTO TABLE @DATA(lt_map).

    ref_struct ?= cl_abap_typedescr=>describe_by_name( 'INCL_EEW_COBL' ).
    DATA(lt_ddic) = ref_struct->get_ddic_field_list( ).
    DELETE lt_ddic WHERE fieldname+0(3) <> 'ZZ1'.

    LOOP AT it_bapi_glaccount ASSIGNING FIELD-SYMBOL(<gl>).
      AT FIRST.
        es_hdr-bukrs = <gl>-comp_code.
      ENDAT.
      APPEND INITIAL LINE TO et_accit ASSIGNING FIELD-SYMBOL(<accit>).
      LOOP AT lt_map ASSIGNING FIELD-SYMBOL(<map>).
        ASSIGN COMPONENT <map>-bapi_fld OF STRUCTURE <gl> TO <src>.
        ASSIGN COMPONENT <map>-fieldname OF STRUCTURE <accit> TO <dst>.
        CHECK sy-subrc IS INITIAL.
        <dst> = <src>.
      ENDLOOP.

      APPEND INITIAL LINE TO et_acccr ASSIGNING FIELD-SYMBOL(<acccr>).
      <acccr>-posnr = <accit>-posnr.
      <acccr>-wrbtr = <gl>-item_amount.
      <acccr>-curtp = '00'.

      "Add custom fields
      DATA(lv_str_get) = |<KEY>{ <gl>-invoice_doc_item }|.
      FIND FIRST OCCURRENCE OF lv_str_get IN TABLE it_bapi_extension2 RESULTS DATA(ls_results).
      CHECK sy-subrc IS INITIAL.
      READ TABLE it_bapi_extension2 ASSIGNING FIELD-SYMBOL(<ext>)
                 INDEX ls_results-line.
      CHECK sy-subrc IS INITIAL.
      IF <ext>-structure = 'MMIV_SI_S_BAPI_GLACCITM_EXT_1'.
        lv_xml = <ext>.
        SHIFT lv_xml LEFT BY 30 PLACES.
        "we can't use any transformation or class calls - will create a dump so we ned to program it
        LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<ddic>).
          CONCATENATE '<' <ddic>-fieldname '.*>' INTO lv_str.
          FIND FIRST OCCURRENCE OF REGEX lv_str IN lv_xml RESULTS ls_results   ##REGEX_POSIX.
          CHECK sy-subrc IS INITIAL.
          ASSIGN COMPONENT <ddic>-fieldname OF STRUCTURE <accit> TO <dst>.
          lv_dummy = lv_xml.
          SHIFT lv_dummy LEFT BY ls_results-offset PLACES.
          SPLIT lv_dummy AT '>' INTO lv_dummy lv_dummy2.
          SPLIT lv_dummy2 AT '<' INTO lv_dummy2 lv_dummy.
          <dst> = lv_dummy2.
        ENDLOOP.
      ELSE.
        ASSERT 1 = 2.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD explode_bapiext.
    DATA: lv_posnr_get TYPE string,
          lv_posnr_set TYPE string
          .
    "XML has only 6 digits in the position
    CASE i_trans_type.
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice.
        lv_posnr_get = is_accit-posnr+4(6).
        lv_posnr_set = i_posnr+4(6).
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.
        lv_posnr_get = is_accit-posnr.
        lv_posnr_set = i_posnr.
    ENDCASE.

    DATA(lv_str_get) = |<KEY>{ lv_posnr_get }|.
    FIND FIRST OCCURRENCE OF lv_str_get IN TABLE ct_bapi_extension2 RESULTS DATA(ls_results).
    CHECK sy-subrc IS INITIAL.
    DATA(lv_str_set) = |<KEY>{ lv_posnr_set }|.
    TRY.
        DATA(lv_guid_c32) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_uuid_error ##NO_HANDLER.
    ENDTRY.
    READ TABLE ct_bapi_extension2 INTO DATA(ls_ext)
               INDEX ls_results-line.
    ls_ext-valuepart1+0(32) = lv_guid_c32.
    REPLACE FIRST OCCURRENCE OF lv_str_get IN ls_ext WITH lv_str_set.
    APPEND ls_ext TO ct_bapi_extension2.

  ENDMETHOD.


  METHOD check_doc_to_be_exploded.

    DATA: lt_accit      TYPE accit_tab,
          lt_acccr      TYPE acccr_tab,
          lt_ext        TYPE bapiparex_t,
          ls_hdr        TYPE rbkp,
          ls_tab_change TYPE bapi_incinv_chng_tables,
          ls_hdr_acc    TYPE bapiache09,
          lv_obj_key    TYPE bapiache09-obj_key,
          lt_gl         TYPE STANDARD TABLE OF bapiacgl09,
          lt_cur        TYPE STANDARD TABLE OF bapiaccr09
          .
    r_auto_release = abap_true.

    IF c_belnr IS SUPPLIED.
      CASE i_trans_type.
        WHEN zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.
          SELECT SINGLE * FROM bkpf
                 WHERE bukrs = @c_bukrs
                   AND belnr = @c_belnr
                   AND gjahr = @c_gjahr
                   INTO CORRESPONDING FIELDS OF @ls_hdr.

          CHECK check_cos_required( ls_hdr ) IS NOT INITIAL.

          SELECT * FROM vbsegs
                 WHERE bukrs = @c_bukrs
                   AND belnr = @c_belnr
                   AND gjahr = @c_gjahr
                 INTO TABLE @DATA(lt_bseg).
          CHECK sy-subrc IS INITIAL.
          LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<bseg>).
            APPEND INITIAL LINE TO lt_accit ASSIGNING FIELD-SYMBOL(<accit>).
            <accit> = CORRESPONDING #( <bseg> MAPPING posnr = buzei
                                                      hkont = saknr ).
            APPEND INITIAL LINE TO lt_acccr ASSIGNING FIELD-SYMBOL(<acccr>).
            <acccr>-posnr = <bseg>-buzei.
            IF <bseg>-shkzg = 'S'.
              <acccr>-wrbtr = <bseg>-wrbtr.
            ELSE.
              <acccr>-wrbtr = <bseg>-wrbtr * -1.
            ENDIF.
            <acccr>-curtp = '00'.
          ENDLOOP.
          DATA(lv_lines) = lines( lt_bseg ).

        WHEN zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice.
          SELECT SINGLE * FROM rbkp
                 WHERE belnr = @c_belnr
                   AND gjahr = @c_gjahr
                   INTO @ls_hdr.

          IF check_cos_required( ls_hdr ) IS INITIAL.
            CLEAR r_auto_release.
            RETURN.
          ENDIF.

          SELECT * FROM rbco
                 WHERE belnr = @c_belnr
                   AND gjahr = @c_gjahr
                 INTO TABLE @DATA(lt_rbco).
          CHECK sy-subrc IS INITIAL.
          LOOP AT lt_rbco ASSIGNING FIELD-SYMBOL(<rbco>).
            APPEND INITIAL LINE TO lt_accit ASSIGNING <accit>.
            <accit> = CORRESPONDING #( <rbco> MAPPING posnr = cobl_nr
                                                      hkont = saknr ).
            APPEND INITIAL LINE TO lt_acccr ASSIGNING <acccr>.
            <acccr>-posnr = <rbco>-cobl_nr.
            <acccr>-wrbtr = <rbco>-wrbtr.
            <acccr>-curtp = '00'.
          ENDLOOP.
          lv_lines = lines( lt_rbco ).
      ENDCASE.
    ELSE.
      lt_accit = it_accit.
      lt_acccr = it_acccr.
    ENDIF.

    DATA(lt_accit_all) = lt_accit. "We need to send to the BAPI all items including originals
    IF mt_gl_rules IS INITIAL.
      lt_accit = get_cos_relevant_gl_items( lt_accit ).
    ENDIF.

    "Loop at all items and remove all that was previously exploded to see if anything is left to be exploded
    LOOP AT lt_accit ASSIGNING <accit>.
      DATA(lv_tabix) = sy-tabix.

      READ TABLE mt_gl_rules ASSIGNING FIELD-SYMBOL(<rule>)
           WITH KEY productcode = <accit>-zz1_productcode_cob
                    source_gl   = <accit>-hkont.
      IF sy-subrc IS NOT INITIAL.
        DELETE lt_accit INDEX lv_tabix.
        CONTINUE.
      ENDIF.
      "check that the offset line exists in the document
      READ TABLE lt_accit TRANSPORTING NO FIELDS
           WITH KEY hkont               = <rule>-cos_gl
                    zz1_productcode_cob = <accit>-zz1_productcode_cob.
      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.
      DELETE lt_accit INDEX sy-tabix.

      READ TABLE lt_accit TRANSPORTING NO FIELDS
            WITH KEY hkont               = <rule>-sales_gl
                     zz1_productcode_cob = <accit>-zz1_productcode_cob.
      IF sy-subrc IS INITIAL.
        DELETE lt_accit INDEX sy-tabix.
      ENDIF.
      DELETE lt_accit INDEX lv_tabix.
    ENDLOOP.

    CHECK lt_accit IS NOT INITIAL.
    CLEAR r_auto_release.

    "check a BAPI call is requested
    CHECK i_post_bapi_change IS NOT INITIAL.

    lt_ext = convert_accit_to_xml_extension( i_trans_type = i_trans_type
                                             it_accit     = lt_accit_all ).
    "Build the extension table so it can be exploded and adjusted to the new items added

    explode_cos_gl_items( EXPORTING i_trans_type       = i_trans_type
                                    it_accit           = lt_accit_all
                                    it_acccr           = lt_acccr
                                    i_lines            = lv_lines
                                    is_hdr             = ls_hdr
                          IMPORTING et_accit           = DATA(lt_expl_accit)
                                    et_acccr           = DATA(lt_expl_acccr)
                          CHANGING  ct_bapi_extension2 = lt_ext
                                  ).
    APPEND LINES OF lt_expl_accit TO lt_accit_all.
    APPEND LINES OF lt_expl_acccr TO lt_acccr.

    convert_accit_to_bapi(
      EXPORTING
        it_accit          = lt_accit_all
        it_acccr          = lt_acccr
      IMPORTING
        et_bapi_glaccount = et_gl
    ).

    CASE i_trans_type.
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice.

        ls_tab_change-glaccountdata = 'X'.

        CALL FUNCTION 'BAPI_INCOMINGINVOICE_CHANGE'
          EXPORTING
            invoicedocnumber   = c_belnr
            fiscalyear         = c_gjahr
            invoice_doc_status = 'B' "parked as complete
            table_change       = ls_tab_change
          TABLES
            glaccountdata      = et_gl
            return             = et_return
            extensionin        = lt_ext.

      WHEN zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.

        lt_gl = CORRESPONDING #( et_gl MAPPING itemno_acc = invoice_doc_item ).

        SELECT SINGLE * FROM bkpf
                     WHERE bukrs = @c_bukrs
                       AND belnr = @c_belnr
                       AND gjahr = @c_gjahr
               INTO @DATA(ls_bkpf).
        ls_hdr_acc-doc_type   = ls_bkpf-blart.
        ls_hdr_acc-username   = sy-uname.
        ls_hdr_acc-header_txt = ls_bkpf-bktxt.
        ls_hdr_acc-comp_code  = ls_bkpf-bukrs.
        ls_hdr_acc-doc_date   = ls_bkpf-bldat.
        ls_hdr_acc-pstng_date = ls_bkpf-budat.
        ls_hdr_acc-ref_doc_no = ls_bkpf-xblnr.
        ls_hdr_acc-doc_status = '4'.

        LOOP AT et_gl ASSIGNING FIELD-SYMBOL(<gl>).
          APPEND INITIAL LINE TO lt_cur ASSIGNING FIELD-SYMBOL(<cur>).
          <cur>-itemno_acc = <gl>-invoice_doc_item.
          <cur>-curr_type = '00'.
          <cur>-currency = ls_bkpf-waers.
          IF <gl>-db_cr_ind = 'S'.
            <cur>-amt_doccur = <gl>-item_amount.
          ELSE.
            <cur>-amt_doccur = <gl>-item_amount * -1.
          ENDIF.
        ENDLOOP.

        CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
          EXPORTING
            documentheader = ls_hdr_acc
          IMPORTING
            obj_key        = lv_obj_key
          TABLES
            accountgl      = lt_gl
            currencyamount = lt_cur
            extension2     = lt_ext
            return         = et_return.
        IF lv_obj_key IS NOT INITIAL.
          c_belnr = lv_obj_key+0(10).
          c_bukrs = lv_obj_key+10(4).
          c_gjahr = lv_obj_key+14(4).
        ENDIF.
    ENDCASE.

    READ TABLE et_return TRANSPORTING NO FIELDS
               WITH KEY type = 'E'.
    IF sy-subrc IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    ENDIF.

  ENDMETHOD.


  METHOD convert_accit_to_xml_extension.

    DATA: lr_gl_si_item TYPE REF TO mmiv_si_s_bapi_glaccitm_ext,
          lt_si         TYPE mmiv_si_t_bapi_glaccitm_ext,
          lt_bapi_ext   TYPE STANDARD TABLE OF accbapi_s4ext
          .
    "Build the extension table so it can be exploded and adjusted to the new items added
    DATA(lo_bapi_mapping) = cl_cfd_bapi_mapping=>get_instance( ).

    CASE i_trans_type.
      WHEN zcl_utility_fidoc_validator=>mc_trans_type_supplier_invoice.
        LOOP AT it_accit ASSIGNING FIELD-SYMBOL(<accit>).
          APPEND INITIAL LINE TO lt_si REFERENCE INTO lr_gl_si_item.
          lr_gl_si_item->key = <accit>-posnr.
          MOVE-CORRESPONDING <accit> TO lr_gl_si_item->data.
        ENDLOOP.

        GET REFERENCE OF lt_si INTO DATA(lr_gl_si_items).
        TRY.
            lo_bapi_mapping->map_to_bapiparex_multi(
              EXPORTING
                ir_source_table = lr_gl_si_items
              CHANGING
                ct_bapiparex    = rt_extension
            ).
          CATCH cx_cfd_bapi_mapping ##NO_HANDLER.
        ENDTRY.

      WHEN zcl_utility_fidoc_validator=>mc_trans_type_journal_entry.
        LOOP AT it_accit ASSIGNING <accit>.
          APPEND INITIAL LINE TO lt_bapi_ext REFERENCE INTO DATA(lr_ext).
          lr_ext->key = <accit>-posnr.
          MOVE-CORRESPONDING <accit> TO lr_ext->data.
        ENDLOOP.

        GET REFERENCE OF lt_bapi_ext INTO DATA(lr_bapi_ext).
        TRY.
            lo_bapi_mapping->map_to_bapiparex_multi(
              EXPORTING
                ir_source_table = lr_bapi_ext
              CHANGING
                ct_bapiparex    = rt_extension
            ).
          CATCH cx_cfd_bapi_mapping ##NO_HANDLER.
        ENDTRY.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
