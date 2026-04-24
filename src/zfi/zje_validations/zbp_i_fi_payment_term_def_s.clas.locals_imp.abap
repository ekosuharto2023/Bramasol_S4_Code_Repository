CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZFI_PAYMENT_TERM_BC'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'ZFI_PAYMENT_TERM_BC' table = 'ZFI_PAYMENT_TERM' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PAYTERM_BC_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ZFI_PAYTERM_BC_S
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ZFI_PAYTERM_BC_S~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZFI_PAYTERM_BC_S
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PAYTERM_BC_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
    ENTITY ZFI_PAYTERM_BC_S
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_ZFI_PAYMENT_TERM_BC = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYTERM_BC_S
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYTERM_BC_S
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_FI_PAYMENT_TERM_BC' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_PAYTERM_BC_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_PAYTERM_BC_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-ZFI_PAYTERM_BC_S INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_FI_PAYMENT_TERM_BC DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR ZFI_PAYMENT_TERM_BC~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR ZFI_PAYMENT_TERM_BC~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR ZFI_PAYMENT_TERM_BC
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ZFI_PAYMENT_TERM_BC~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ZFI_PAYMENT_TERM_BC~Invalidate
        RESULT result,
      COPYZFI_PAYMENT_TERM_BC FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ZFI_PAYMENT_TERM_BC~CopyZFI_PAYMENT_TERM_BC,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZFI_PAYMENT_TERM_BC
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ZFI_PAYMENT_TERM_BC
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_FI_PAYMENT_TERM_BC IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_PAYTERM_BC_S.
    SELECT SINGLE TransportRequestID
      FROM ZFI_PAYMENT__D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZFI_PAYMENT_TERM'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-ZFI_PAYMENT_TERM_BC ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ZFI_PAYMENT_TERM_BC).
    DATA(table) = xco_abap_repository=>object->tabl->database_table->for( 'ZFI_PAYMENT_TERM' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE ref to if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT ZFI_PAYMENT_TERM_BC ASSIGNING FIELD-SYMBOL(<ZFI_PAYMENT_TERM_BC>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <ZFI_PAYMENT_TERM_BC>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <ZFI_PAYMENT_TERM_BC>-%TKY
                        %STATE_AREA = |ZFI_PAYMENT_TERM_BC_{ element_check-element }| ) INTO TABLE reported-ZFI_PAYMENT_TERM_BC.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <ZFI_PAYMENT_TERM_BC>-%TKY ) INTO TABLE failed-ZFI_PAYMENT_TERM_BC.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <ZFI_PAYMENT_TERM_BC>-%TKY
                          %STATE_AREA = 'ZFI_PAYMENT_TERM_BC_Input_Check'
                          %PATH-ZFI_PAYTERM_BC_S-SingletonID = 1
                          %PATH-ZFI_PAYTERM_BC_S-%IS_DRAFT = <ZFI_PAYMENT_TERM_BC>-%IS_DRAFT
                          %msg = new_message(
                                   id       = <msg>->value-msgid
                                   number   = <msg>->value-msgno
                                   severity = if_abap_behv_message=>severity-error
                                   v1       = <msg>->value-msgv1
                                   v2       = <msg>->value-msgv2
                                   v3       = <msg>->value-msgv3
                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-ZFI_PAYMENT_TERM_BC ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ZFI_PAYMENT_TERM_BC).
    result = VALUE #( FOR row IN ZFI_PAYMENT_TERM_BC
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ZFI_PAYMENT_TERM_BC = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-ZFI_PAYTERM_BC_S-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ZFI_PAYTERM_BC_S-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ZFI_PAYMENT_TERM_BC).
    result = VALUE #( FOR row IN ZFI_PAYMENT_TERM_BC
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ZFI_PAYMENT_TERM_BC = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-ZFI_PAYTERM_BC_S-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ZFI_PAYTERM_BC_S-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD COPYZFI_PAYMENT_TERM_BC.
    DATA new_ZFI_PAYMENT_TERM_BC TYPE TABLE FOR CREATE ZI_PAYTERM_BC_S\_ZFI_PAYMENT_TERM_BC.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-ZFI_PAYMENT_TERM_BC = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_ZFI_PAYMENT_TERM_BC)
      FAILED DATA(read_failed).

    LOOP AT ref_ZFI_PAYMENT_TERM_BC ASSIGNING FIELD-SYMBOL(<ref_ZFI_PAYMENT_TERM_BC>).
      DATA(key) = keys[ KEY draft %TKY = <ref_ZFI_PAYMENT_TERM_BC>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_ZFI_PAYMENT_TERM_BC>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_ZFI_PAYMENT_TERM_BC>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_ZFI_PAYMENT_TERM_BC> EXCEPT
            ConfigDeprecationCode
            Country
            DefaultTermsCode
            LastChangedAt
            LocalLastChangedAt
            NewTerm
            SingletonID
        ) ) )
      ) TO new_ZFI_PAYMENT_TERM_BC ASSIGNING FIELD-SYMBOL(<new_ZFI_PAYMENT_TERM_BC>).
      <new_ZFI_PAYMENT_TERM_BC>-%TARGET[ 1 ]-Country = to_upper( key-%PARAM-Country ).
      <new_ZFI_PAYMENT_TERM_BC>-%TARGET[ 1 ]-DefaultTermsCode = key-%PARAM-DefaultTermsCode.
      <new_ZFI_PAYMENT_TERM_BC>-%TARGET[ 1 ]-NewTerm = to_upper( key-%PARAM-NewTerm ).
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYTERM_BC_S CREATE BY \_ZFI_PAYMENT_TERM_BC
      FIELDS (
               Country
               DefaultTermsCode
               NewTerm
             ) WITH new_ZFI_PAYMENT_TERM_BC
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-ZFI_PAYMENT_TERM_BC = mapped_create-ZFI_PAYMENT_TERM_BC.
    INSERT LINES OF read_failed-ZFI_PAYMENT_TERM_BC INTO TABLE failed-ZFI_PAYMENT_TERM_BC.

    IF failed-ZFI_PAYMENT_TERM_BC IS INITIAL.
      reported-ZFI_PAYMENT_TERM_BC = VALUE #( FOR created IN mapped-ZFI_PAYMENT_TERM_BC (
                                                 %CID = created-%CID
                                                 %ACTION-CopyZFI_PAYMENT_TERM_BC = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-ZFI_PAYTERM_BC_S-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-ZFI_PAYTERM_BC_S-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_FI_PAYMENT_TERM_BC' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyZFI_PAYMENT_TERM_BC = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_PAYTERM_BC_S IN LOCAL MODE
      ENTITY ZFI_PAYMENT_TERM_BC
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(ZFI_PAYMENT_TERM_BC).

    result =
      VALUE #(
        FOR row IN ZFI_PAYMENT_TERM_BC
        LET Deprecate = COND #( WHEN row-ConfigDeprecationCode = '' AND row-%IS_DRAFT = if_abap_behv=>mk-on
                                THEN if_abap_behv=>fc-o-enabled
                                ELSE if_abap_behv=>fc-o-disabled  )
            Invalidate = COND #( WHEN ( row-ConfigDeprecationCode = '' OR row-ConfigDeprecationCode = 'W' ) AND row-%IS_DRAFT = if_abap_behv=>mk-on
                                THEN if_abap_behv=>fc-o-enabled
                                ELSE if_abap_behv=>fc-o-disabled  )
        IN ( %TKY              = row-%TKY
             %ACTION-Deprecate = Deprecate
             %ACTION-Invalidate = Invalidate
                                        %ACTION-CopyZFI_PAYMENT_TERM_BC = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
