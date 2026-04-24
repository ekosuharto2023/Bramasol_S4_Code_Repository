CLASS lhc_ZI_FI_PAYMENT_TERM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_payment_term RESULT result.
    METHODS validate_fk FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fi_payment_term~validate_fk.
    METHODS validate_mandatory FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_fi_payment_term~validate_mandatory.

ENDCLASS.

CLASS lhc_ZI_FI_PAYMENT_TERM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

METHOD validate_fk.

  READ ENTITIES OF zi_fi_payment_term IN LOCAL MODE
    ENTITY zi_fi_payment_term
      FIELDS ( Country NewTerm )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_term).

  LOOP AT lt_term INTO DATA(ls_term).

    "Country check
    SELECT SINGLE land1 FROM t005
      WHERE land1 = @ls_term-country
      INTO @DATA(lv_land).

    IF sy-subrc <> 0.
      APPEND VALUE #( %tky = ls_term-%tky ) TO failed-zi_fi_payment_term.
      APPEND VALUE #(
        %tky             = ls_term-%tky
        %msg             = new_message_with_text(
                             severity = if_abap_behv_message=>severity-error
                             text     = 'Country is invalid' )
        %element-country = if_abap_behv=>mk-on
      ) TO reported-zi_fi_payment_term.
    ENDIF.

    "Payment term check
    SELECT SINGLE zterm FROM t052
      WHERE zterm = @ls_term-newterm
      INTO @DATA(lv_term).

    IF sy-subrc <> 0.
      APPEND VALUE #( %tky = ls_term-%tky ) TO failed-zi_fi_payment_term.
      APPEND VALUE #(
        %tky             = ls_term-%tky
        %msg             = new_message_with_text(
                             severity = if_abap_behv_message=>severity-error
                             text     = 'Payment term is invalid' )
        %element-newterm = if_abap_behv=>mk-on
      ) TO reported-zi_fi_payment_term.
    ENDIF.

  ENDLOOP.

ENDMETHOD.



  METHOD validate_mandatory.
  "Read the values being saved (don’t rely on KEYS for non-key fields)
    READ ENTITIES OF zi_fi_payment_term IN LOCAL MODE
      ENTITY zi_fi_payment_term
        FIELDS ( Country NewTerm )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_rows).

    LOOP AT lt_rows INTO DATA(ls_row).

      IF ls_row-country IS INITIAL.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed-zi_fi_payment_term.
        APPEND VALUE #(
          %tky             = ls_row-%tky
          %msg             = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'Country is required' )
          %element-country = if_abap_behv=>mk-on
        ) TO reported-zi_fi_payment_term.
      ENDIF.

      IF ls_row-newterm IS INITIAL.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed-zi_fi_payment_term.
        APPEND VALUE #(
          %tky              = ls_row-%tky
          %msg              = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = 'New Term is required' )
          %element-newterm  = if_abap_behv=>mk-on
        ) TO reported-zi_fi_payment_term.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
