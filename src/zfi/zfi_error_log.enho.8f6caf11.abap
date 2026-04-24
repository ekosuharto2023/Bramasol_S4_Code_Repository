"Name: \FU:MRM_BADI_INVOICE_CHECK\SE:END\EI
ENHANCEMENT 0 ZFI_ERROR_LOG.
  DATA: lt_errors TYPE mrm_tab_errprot,
        ls_error  TYPE mrm_errprot.

  IF sy-subrc <> 0.
    IMPORT lt_errors = lt_errors FROM MEMORY ID 'ZMRM_ERRORS'.
    IF sy-subrc IS INITIAL.
      ls_error-msgty = 'E'.
      MODIFY lt_errors FROM ls_error TRANSPORTING msgty
             WHERE msgty IS INITIAL.
      APPEND LINES OF lt_errors TO et_errprot.
      CALL FUNCTION 'MRM_PROT_FILL'
        TABLES
          t_errprot = lt_errors.
      DELETE FROM MEMORY ID 'ZMRM_ERRORS'.
    ENDIF.
  ENDIF.
ENDENHANCEMENT.
