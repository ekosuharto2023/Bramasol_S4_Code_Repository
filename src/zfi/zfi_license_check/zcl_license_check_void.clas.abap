CLASS zcl_license_check_void DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_check,
             rbkp_belnr TYPE rbkp-belnr,
             rbkp_gjahr TYPE rbkp-gjahr,
             zbukr      TYPE payr-zbukr,
             hbkid      TYPE payr-hbkid,
             hktid      TYPE payr-hktid,
             chect      TYPE payr-chect,
             voidr      TYPE payr-voidr,  " Void reason e.g. '05'
             stgrd      TYPE uf05a-stgrd, " Reversal reason e.g. '01'
           END OF ty_check.
    TYPES tt_check TYPE STANDARD TABLE OF ty_check WITH EMPTY KEY.

    TYPES: BEGIN OF ty_message,
             msgtyp TYPE symsgty,
             msgid  TYPE symsgid,
             msgnr  TYPE symsgno,
             msgv1  TYPE symsgv,
             msgv2  TYPE symsgv,
             msgv3  TYPE symsgv,
             msgv4  TYPE symsgv,
             text   TYPE string,
           END OF ty_message.
    TYPES tt_message TYPE STANDARD TABLE OF ty_message WITH EMPTY KEY.

    TYPES: BEGIN OF ty_result,
             check    TYPE ty_check,
             success  TYPE abap_bool,
             messages TYPE tt_message,
           END OF ty_result.
    TYPES tt_result  TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES ty_r_bukrs TYPE RANGE OF bukrs.
    TYPES ty_r_belnr TYPE RANGE OF belnr_d.
    TYPES ty_r_gjahr TYPE RANGE OF gjahr.
    TYPES ty_r_cpudt TYPE RANGE OF cpudt.
    TYPES ty_r_zlsch TYPE RANGE OF dzlsch.

    METHODS constructor
      IMPORTING iv_dismode TYPE ctu_params-dismode DEFAULT 'N'
                iv_updmode TYPE ctu_params-updmode DEFAULT 'S'
                iv_commit  TYPE abap_bool          DEFAULT abap_true.

    CLASS-METHODS get_checks_to_void
      IMPORTING it_bukrs         TYPE ty_r_bukrs
                it_gjahr         TYPE ty_r_gjahr
                it_cpudt         TYPE ty_r_cpudt OPTIONAL
                it_zlsch         TYPE ty_r_zlsch OPTIONAL
                it_belnr         TYPE ty_r_belnr OPTIONAL
                iv_voidr         TYPE payr-voidr
                iv_stgrd         TYPE uf05a-stgrd
      RETURNING VALUE(rt_checks) TYPE tt_check.

    METHODS void_checks
      IMPORTING it_checks         TYPE tt_check
      RETURNING VALUE(rt_results) TYPE tt_result.

  PRIVATE SECTION.

    DATA ms_ctu TYPE ctu_params.
    DATA mv_commit TYPE abap_bool.

    METHODS build_bdc_fch8
      IMPORTING
        is_check TYPE ty_check
      RETURNING
        VALUE(rt_bdc) TYPE BDCDATA_TAB.

    METHODS call_fch8
      IMPORTING
        it_bdc TYPE  BDCDATA_TAB
      RETURNING
        VALUE(rt_msgcoll) TYPE TAB_BDCMSGCOLL.

    METHODS map_messages
      IMPORTING
        it_msgcoll TYPE TAB_BDCMSGCOLL
      RETURNING
        VALUE(rt_msg) TYPE tt_message.

    METHODS has_error
      IMPORTING
        it_msg TYPE tt_message
      RETURNING
        VALUE(rv_error) TYPE abap_bool.

ENDCLASS.



CLASS zcl_license_check_void IMPLEMENTATION.

  METHOD constructor.
    ms_ctu-dismode = iv_dismode.
    ms_ctu-updmode = iv_updmode.
    mv_commit      = iv_commit.
  ENDMETHOD.

  METHOD void_checks.
    LOOP AT it_checks ASSIGNING FIELD-SYMBOL(<chk>).

      DATA(ls_res) = VALUE ty_result( check = <chk> success = abap_false ).

      DATA(lt_bdc)      = build_bdc_fch8( <chk> ).
      DATA(lt_msgcoll)  = call_fch8( lt_bdc ).
      ls_res-messages   = map_messages( lt_msgcoll ).

      IF has_error( ls_res-messages ) = abap_false.
        ls_res-success = abap_true.
        IF mv_commit = abap_true.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.

      APPEND ls_res TO rt_results.

    ENDLOOP.
  ENDMETHOD.

  METHOD build_bdc_fch8.
    " Matches your SHDB recording:
    " SAPMFCHK 0800, OKCODE =RAGL, fields PAYR-*, UF05A-STGRD, then /EEND

    APPEND VALUE #( program  = 'SAPMFCHK'
                    dynpro   = '0800'
                    dynbegin = 'X' ) TO rt_bdc.

    APPEND VALUE #( fnam = 'BDC_CURSOR'  fval = 'UF05A-STGRD' ) TO rt_bdc.
    APPEND VALUE #( fnam = 'BDC_OKCODE'  fval = '=RAGL'       ) TO rt_bdc.

    APPEND VALUE #( fnam = 'PAYR-ZBUKR'  fval = is_check-zbukr ) TO rt_bdc.
    APPEND VALUE #( fnam = 'PAYR-HBKID'  fval = is_check-hbkid ) TO rt_bdc.
    APPEND VALUE #( fnam = 'PAYR-HKTID'  fval = is_check-hktid ) TO rt_bdc.
    APPEND VALUE #( fnam = 'PAYR-CHECT'  fval = is_check-chect ) TO rt_bdc.
    APPEND VALUE #( fnam = 'PAYR-VOIDR'  fval = is_check-voidr ) TO rt_bdc.
    APPEND VALUE #( fnam = 'UF05A-STGRD' fval = is_check-stgrd ) TO rt_bdc.

    APPEND VALUE #( program  = 'SAPMFCHK'
                    dynpro   = '0800'
                    dynbegin = 'X' ) TO rt_bdc.

    APPEND VALUE #( fnam = 'BDC_OKCODE'  fval = '/EEND'      ) TO rt_bdc.
    APPEND VALUE #( fnam = 'BDC_CURSOR'  fval = 'PAYR-CHECT' ) TO rt_bdc.
  ENDMETHOD.

  METHOD call_fch8.
    CALL TRANSACTION 'FCH8'
      USING        it_bdc
      OPTIONS FROM ms_ctu
      MESSAGES INTO rt_msgcoll.
  ENDMETHOD.

  METHOD map_messages.
    LOOP AT it_msgcoll ASSIGNING FIELD-SYMBOL(<m>).

      DATA(lv_text) = ``.
      MESSAGE ID <m>-msgid TYPE <m>-msgtyp NUMBER <m>-msgnr
        INTO lv_text
        WITH <m>-msgv1 <m>-msgv2 <m>-msgv3 <m>-msgv4.

      APPEND VALUE ty_message(
        msgtyp = <m>-msgtyp
        msgid  = <m>-msgid
        msgnr  = <m>-msgnr
        msgv1  = <m>-msgv1
        msgv2  = <m>-msgv2
        msgv3  = <m>-msgv3
        msgv4  = <m>-msgv4
        text   = lv_text
      ) TO rt_msg.

    ENDLOOP.
  ENDMETHOD.

  METHOD has_error.
    rv_error = abap_false.
    LOOP AT it_msg ASSIGNING FIELD-SYMBOL(<x>)
      WHERE msgtyp CA 'AEX'.   "Abort/Error/System
      rv_error = abap_true.
      EXIT.
    ENDLOOP.
  ENDMETHOD.

METHOD get_checks_to_void.

  "------------------------------------------------------------*
  " Case 1: CPUDT INITIAL
  "------------------------------------------------------------*
  IF it_cpudt IS INITIAL.

    IF it_zlsch IS INITIAL AND it_belnr IS INITIAL.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ELSEIF it_zlsch IS NOT INITIAL AND it_belnr IS INITIAL.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~zlsch IN @it_zlsch
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ELSE.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~zlsch IN @it_zlsch
          AND rb~belnr IN @it_belnr
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ENDIF.

  "------------------------------------------------------------*
  " Case 2: CPUDT PROVIDED
  "------------------------------------------------------------*
  ELSE.

    IF it_zlsch IS INITIAL AND it_belnr IS INITIAL.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~cpudt IN @it_cpudt
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ELSEIF it_zlsch IS NOT INITIAL AND it_belnr IS INITIAL.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~cpudt IN @it_cpudt
          AND rb~zlsch IN @it_zlsch
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ELSE.

      SELECT DISTINCT
          rb~belnr  AS rbkp_belnr,
          rb~gjahr  AS rbkp_gjahr,
          p~zbukr,
          p~hbkid,
          p~hktid,
          p~chect,
          @iv_voidr AS voidr,
          @iv_stgrd AS stgrd
        FROM rbkp AS rb
        INNER JOIN bkpf AS b
          ON b~bukrs = rb~bukrs
         AND b~awkey = CONCAT( rb~rebzg, rb~rebzj )
        INNER JOIN regup AS r
          ON r~bukrs = b~bukrs
         AND r~belnr = b~belnr
         AND r~gjahr = b~gjahr
         AND r~xvorl = ''
        INNER JOIN payr AS p
          ON p~zbukr = r~zbukr
         AND p~vblnr = r~vblnr
         AND p~gjahr = r~gjahr
        WHERE rb~bukrs IN @it_bukrs
          AND rb~gjahr IN @it_gjahr
          AND rb~cpudt IN @it_cpudt
          AND rb~zlsch IN @it_zlsch
          AND rb~belnr IN @it_belnr
          AND rb~rebzg IS NOT INITIAL
          AND rb~blart = 'KG'
          AND rb~hbkid IS NOT INITIAL
          AND rb~hktid IS NOT INITIAL
          AND rb~xrech IS INITIAL
          AND b~blart = 'KR'
          AND p~chect IS NOT INITIAL
          AND p~voidr IS INITIAL
        INTO TABLE @rt_checks.

    ENDIF.

  ENDIF.

ENDMETHOD.

ENDCLASS.
