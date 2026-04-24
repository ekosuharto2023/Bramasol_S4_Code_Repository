FUNCTION zbte_get_je_doc_00005011.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_CHGTYPE)
*"     REFERENCE(I_ORIGIN) LIKE  RSDSWHERE-LINE
*"     REFERENCE(I_TABNAME) LIKE  DNTAB-TABNAME DEFAULT 'BKPF'
*"     REFERENCE(I_STRUCTURE) OPTIONAL
*"  TABLES
*"      T_STRUCTURE OPTIONAL
*"  EXCEPTIONS
*"      ERROR
*"----------------------------------------------------------------------
  DATA lt_zfi_parklog TYPE zfi_parklog_tbltype.

  CONSTANTS lc_bkpf_status_park TYPE bstat VALUE 'V'.

  FIELD-SYMBOLS <fs_bkpf> TYPE bkpf.

  IF i_tabname = 'BKPF'.
    ASSIGN i_structure TO <fs_bkpf>.
  ENDIF.

  CLEAR lt_zfi_parklog.
  " clear out zfi_parklog
  CHECK <fs_bkpf>-belnr IS ASSIGNED.
  DELETE FROM zfi_parklog
       WHERE bukrs = <fs_bkpf>-bukrs
         AND belnr = <fs_bkpf>-belnr
         AND gjahr = <fs_bkpf>-gjahr.

  " - Begin of E004 S4 BRIM Synchronization
  " if its a reversal log in the BRIM Sync table
  IF <fs_bkpf>-stblg IS ASSIGNED.
    zcl_fi_reversal_sync=>process_from_journal_entry( <fs_bkpf> ).
  ENDIF.
  " - End of E004 S4 BRIM Synchronization

  IMPORT lt_zfi_parklog FROM MEMORY ID 'ZLOG' IGNORING STRUCTURE BOUNDARIES.
  FREE MEMORY ID 'ZLOG'.
  IF lt_zfi_parklog IS NOT INITIAL AND <fs_bkpf>-bstat = lc_bkpf_status_park. " V = PARKED
    LOOP AT lt_zfi_parklog ASSIGNING FIELD-SYMBOL(<log>).
      <log>-belnr = <fs_bkpf>-belnr.
      <log>-bukrs = <fs_bkpf>-bukrs.
      <log>-gjahr = <fs_bkpf>-gjahr.
    ENDLOOP.
    MODIFY zfi_parklog FROM TABLE lt_zfi_parklog.
  ENDIF.

ENDFUNCTION.
