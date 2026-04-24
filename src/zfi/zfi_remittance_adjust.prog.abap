*&---------------------------------------------------------------------*
*& Report ZFI_REMITTANCE_ADJUST
*&---------------------------------------------------------------------*
*& RICEF I014 - NACHA
*& This program will change the grouping for payment proposals to a batch
*& size (determied on the selection screen) by changing the field
*& Payment method supplement to have a value from 00 to 99 so there is
*& an auto split in the payment proposal based on that field aggergation
*& The program also allows to remove all data in this field and to test
*& the groupings via ALV grid view.
*& IAVNI 01/9/2025
*&---------------------------------------------------------------------*
REPORT zfi_remittance_adjust.

TYPES: BEGIN OF tp_docs,
         bukrs TYPE bukrs,
         lifnr TYPE lifnr,
         zlsch TYPE schzw_bseg,
         uzawe TYPE uzawe,
         gjahr TYPE gjahr,
         belnr TYPE belnr_d,
         buzei TYPE buzei,
       END OF tp_docs,
       tp_docs_t TYPE STANDARD TABLE OF tp_docs.
TABLES: bsik.
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  SELECT-OPTIONS: s_bukrs FOR bsik-bukrs OBLIGATORY,
                  s_ZLSCH FOR bsik-zlsch ,
                  s_lifnr FOR bsik-lifnr
                  .
  PARAMETERS: p_sim AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK blk1.
SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-bl2.
  PARAMETERS: p_packet TYPE i DEFAULT 9500,
              p_reset  AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk2.

START-OF-SELECTION.
  IF p_reset IS NOT INITIAL.
    PERFORM reset_data.
  ENDIF.

  PERFORM get_data.



*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: lv_packet      TYPE i,
        lv_sequence(2) TYPE n,
        lv_uzawe       TYPE uzawe,
        lv_seq_count   TYPE i,
        lt_docs        TYPE tp_docs_t,
        lt_tbd         TYPE tp_docs_t,
        lr_alv         TYPE REF TO cl_salv_table
        .

  SELECT FROM bsik
         FIELDS bukrs, lifnr, zlsch, uzawe, COUNT( * ) AS count
         WHERE bukrs IN @s_bukrs
           AND zlsch IN @s_ZLSCH
           AND lifnr IN @s_lifnr
         GROUP BY bukrs, lifnr, zlsch, uzawe
         INTO TABLE @DATA(lt_count)
         .
  SORT lt_count BY bukrs lifnr zlsch uzawe DESCENDING count DESCENDING.

  "We do not care on any count that is less than the packet size
  LOOP AT lt_count ASSIGNING FIELD-SYMBOL(<count>).
    AT NEW lifnr.
      DATA(lv_clear) = 'X'.
    ENDAT.

    IF <count>-count > p_packet.
      CLEAR lv_clear.
    ENDIF.

    AT END OF lifnr.
      IF lv_clear IS NOT INITIAL.
        DELETE lt_count WHERE lifnr = <count>-lifnr.
      ENDIF.
    ENDAT.
  ENDLOOP.

  IF lt_count IS INITIAL.
    MESSAGE s829(63).
    EXIT.
  ENDIF.

  "change the groups to packet size
  LOOP AT lt_count ASSIGNING <count>.
    AT NEW lifnr.
      CLEAR: lv_sequence, lv_seq_count.
      lv_packet = p_packet.
    ENDAT.

    IF lv_sequence = '99'.
      lv_packet = 99999999.
    ENDIF.

    IF <count>-count = lv_packet AND <count>-uzawe <= lv_sequence.
      CONTINUE.
    ENDIF.


    " this is a new group and hence we need to distribute to the next ranges
    SELECT FROM bsik
           FIELDS bukrs, lifnr, zlsch, uzawe, gjahr, belnr, buzei
           WHERE bukrs = @<count>-bukrs
             AND zlsch = @<count>-zlsch
             AND lifnr = @<count>-lifnr
             AND uzawe = @<count>-uzawe
           INTO TABLE @lt_docs
           .
    SORT lt_docs BY bukrs belnr gjahr.
    LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<doc>).
      DATA(lv_tabix) = sy-tabix.
      "if we have later numbers (sequence 99 can have more than 10K
      "items - we need to distribute it first on the lower levels
      "before processing the lower levers
      IF <count>-uzawe IS NOT INITIAL AND lv_seq_count IS INITIAL.
        DO.
          IF lv_sequence = <count>-uzawe.
            EXIT.
          ENDIF.
          READ TABLE lt_count ASSIGNING FIELD-SYMBOL(<count2>)
               WITH KEY bukrs = <count>-bukrs
                        lifnr = <count>-lifnr
                        zlsch = <count>-zlsch
                        uzawe = CONV #( lv_sequence )
                        .
          IF sy-subrc IS INITIAL.
            ADD <count2>-count TO lv_seq_count.
            IF lv_seq_count >= p_packet.
              <count2>-count = <count2>-count - ( lv_seq_count - lv_packet ).
              CLEAR lv_seq_count.
              ADD 1 TO lv_sequence.
            ELSE.
              DELETE lt_count INDEX sy-tabix.
              EXIT.
            ENDIF.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
      ENDIF.

      IF lv_seq_count = lv_packet.
        ADD 1 TO lv_sequence.
        CLEAR lv_seq_count.
        IF <count>-uzawe <> lv_sequence.
          DO.
            READ TABLE lt_count ASSIGNING <count2>
                 WITH KEY bukrs = <count>-bukrs
                          lifnr = <count>-lifnr
                          zlsch = <count>-zlsch
                          uzawe = CONV #( lv_sequence )
                          .
            IF sy-subrc IS INITIAL.
              ADD <count2>-count TO lv_seq_count.
              IF lv_seq_count > lv_packet.
                <count2>-count = <count2>-count - ( lv_seq_count - lv_packet ).
                CLEAR lv_seq_count.
              ELSE.
                DELETE lt_count INDEX sy-tabix.
                EXIT.
              ENDIF.
            ELSE.
              EXIT.
            ENDIF.
          ENDDO.
        ENDIF.
      ENDIF.
      ADD 1 TO lv_seq_count.
      lv_uzawe = lv_sequence.
      IF <doc>-uzawe <> lv_uzawe.
        <doc>-uzawe = lv_sequence.
      ELSE.
        DELETE lt_docs INDEX lv_tabix.
      ENDIF.
    ENDLOOP.
    CHECK lt_docs IS NOT INITIAL.
    IF p_sim IS INITIAL.
      PERFORM update_documents USING lt_docs.
    ELSE.
      APPEND LINES OF lt_docs TO lt_tbd.
    ENDIF.
  ENDLOOP.

  IF p_sim IS NOT INITIAL.
    IF lt_tbd IS INITIAL.
      MESSAGE s235(j3rgtd).
      EXIT.
    ENDIF.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lr_alv
                                CHANGING  t_table      = lt_tbd ).
      CATCH cx_salv_msg.
    ENDTRY.
    TRY.
        lr_alv->get_functions( )->set_all( abap_true ).
        lr_alv->get_columns( )->set_optimize( abap_true ). "Optimized column width
        lr_alv->get_sorts( )->add_sort( 'BUKRS' ).
        lr_alv->get_sorts( )->add_sort( 'LIFNR' ).
        lr_alv->get_sorts( )->add_sort( 'ZLSCH' ).
        lr_alv->get_sorts( )->add_sort( 'UZAWE' ).
      CATCH cx_salv_data_error.
      CATCH cx_salv_existing.
      CATCH cx_salv_not_found.
    ENDTRY.
    lr_alv->display( ).
  ENDIF.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form update_documents
*&---------------------------------------------------------------------*
FORM update_documents  USING   pt_docs TYPE tp_docs_t.

  DATA: lt_bdcdata TYPE STANDARD TABLE OF bdcdata,
        ls_opt     TYPE ctu_params,
        lt_msg     TYPE wdkmsg_tty,
        lv_line(2) TYPE n
        .

  ls_opt-dismode = 'N'.
  ls_opt-updmode = 'S'.

  LOOP AT pt_docs ASSIGNING FIELD-SYMBOL(<doc>).
    CLEAR: lt_msg, lt_bdcdata.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING FIELD-SYMBOL(<bdcdata>).
    <bdcdata>-program  = 'SAPMF05L'.
    <bdcdata>-dynbegin = 'X'.
    <bdcdata>-dynpro   = '0100'.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'BDC_OKCODE'.
    <bdcdata>-fval = '=WEITE'.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'RF05L-BELNR'.
    <bdcdata>-fval = <doc>-belnr.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'RF05L-BUKRS'.
    <bdcdata>-fval = <doc>-bukrs.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'RF05L-GJAHR'.
    <bdcdata>-fval = <doc>-gjahr.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-program  = 'SAPMF05L'.
    <bdcdata>-dynbegin = 'X'.
    <bdcdata>-dynpro   = '0700'.

    lv_line = <doc>-buzei.
    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'BDC_CURSOR'.
    <bdcdata>-fval = |RF05L-ANZDT({ lv_line })'|.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'BDC_OKCODE'.
    <bdcdata>-fval = '=PK'.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-program  = 'SAPMF05L'.
    <bdcdata>-dynbegin = 'X'.
    <bdcdata>-dynpro   = '0302'.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'BSEG-UZAWE'.
    <bdcdata>-fval = <doc>-uzawe.

    APPEND INITIAL LINE TO lt_bdcdata ASSIGNING <bdcdata>.
    <bdcdata>-fnam = 'BDC_OKCODE'.
    <bdcdata>-fval = '=AE'.

    CALL TRANSACTION 'FB02' USING lt_bdcdata
                     OPTIONS FROM ls_opt
                     MESSAGES INTO lt_msg.
    LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<msg>)
            WHERE msgtyp = 'E'.
      MESSAGE ID sy-msgid TYPE <msg>-msgtyp NUMBER <msg>-msgnr
                INTO FINAL(lv_text)
                WITH <msg>-msgv1 <msg>-msgv2 <msg>-msgv3 <msg>-msgv4.
      WRITE: / lv_text.
    ENDLOOP.
    IF sy-subrc IS NOT INITIAL.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDLOOP.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form reset_data
*&---------------------------------------------------------------------*
FORM reset_data .

  DATA: lt_docs TYPE tp_docs_t.

  SELECT FROM bsik
         FIELDS bukrs, lifnr, zlsch, '  ' AS uzawe, gjahr, belnr
         WHERE bukrs IN @s_bukrs
           AND lifnr IN @s_lifnr
           AND uzawe <> ''
         INTO TABLE @lt_docs.

  PERFORM update_documents USING lt_docs.
  MESSAGE s402(/sapapo/ctm1).

ENDFORM.
