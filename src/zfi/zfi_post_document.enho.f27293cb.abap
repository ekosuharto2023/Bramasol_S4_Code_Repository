"Name: \FU:POST_DOCUMENT\SE:BEGIN\EI
ENHANCEMENT 0 ZFI_POST_DOCUMENT.
**replace bseg-zuonr with bkpf-xblnr for payment
TYPES: BEGIN OF tp_regup,
         vblnr TYPE vblnr,
         bukrs TYPE bukrs,
         belnr TYPE belnr_d,
         gjahr TYPE gjahr,
         xblnr TYPE xblnr1,
       END OF tp_regup.

DATA: lt_regup   TYPE STANDARD TABLE OF tp_regup,
      lt_bkpf_zp TYPE STANDARD TABLE OF bkpf,
      lv_xblnr   TYPE xblnr1.

LOOP AT t_bkpf WHERE blart = 'ZS'.
  APPEND t_bkpf TO lt_bkpf_zp.
ENDLOOP.

IF lt_bkpf_zp IS NOT INITIAL.
  SELECT vblnr bukrs belnr gjahr xblnr
    FROM regup
    INTO TABLE lt_regup
    FOR ALL ENTRIES IN lt_bkpf_zp
   WHERE vblnr = lt_bkpf_zp-belnr
     AND bukrs = lt_bkpf_zp-bukrs
     AND gjahr = lt_bkpf_zp-gjahr
     AND xvorl = ''
     AND zlsch = 'L'.
  SORT lt_regup BY vblnr.
ENDIF.

IF lt_regup IS NOT INITIAL.
  LOOP AT t_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg_zp>).
    READ TABLE lt_regup ASSIGNING FIELD-SYMBOL(<fs_regup1>)
         WITH KEY vblnr = <fs_bseg_zp>-belnr
                  bukrs = <fs_bseg_zp>-bukrs
                  gjahr = <fs_bseg_zp>-gjahr BINARY SEARCH.

    IF sy-subrc = 0.
      <fs_bseg_zp>-zuonr = <fs_regup1>-xblnr+2.
    ENDIF.
  ENDLOOP.
ENDIF.
ENDENHANCEMENT.
