FUNCTION zinsert_vendor_alt_payee.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SUPPLIER_ACCOUNT) TYPE  LIFNR
*"     VALUE(COMPANY_CODE) TYPE  BUKRS
*"     VALUE(VENDOR_PERMITTED) TYPE  EMPFK
*"  EXPORTING
*"     VALUE(ERROR_FLAG) TYPE  CHAR1
*"     VALUE(ERROR_MESSAGE) TYPE  CHAR40
*"  EXCEPTIONS
*"      VENDOR_NOT_FOUND
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
  CONSTANTS lc_update TYPE char1 VALUE 'U'.
  CONSTANTS lc_insert TYPE char1 VALUE 'I'.
  CONSTANTS lc_x      TYPE char1 VALUE 'X'.

  DATA: BEGIN OF result,
          supplier                 TYPE lifnr,
          companycode              TYPE bukrs,
          supplieralternativepayee TYPE empfk,
        END OF result.
  DATA ls_main                       TYPE vmds_ei_main.
  DATA lv_recon_account              TYPE akont.
  DATA lv_LayoutSortingRule          TYPE dzuawa.
  DATA lv_paymentterm                TYPE dzterm.
  DATA lv_IsToBeCheckedForDuplicates TYPE reprf.
  DATA lv_PaymentMethodsList         TYPE dzwels.
  DATA lv_CreditMemoPaymentTerms     TYPE guzte.
  DATA l_messages                    TYPE cvis_message.
  DATA l_update_errors               TYPE cvis_message.
  DATA lv_supplier                   TYPE lifnr.
  DATA lv_companycode                TYPE bukrs.
  DATA lv_vendor_permitted           TYPE empfk.
  DATA lt_old_altpayee               TYPE STANDARD TABLE OF lfza.

  " --- Step 1: Format data into SAP format -------------------
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = supplier_account
    IMPORTING
      output = lv_supplier.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = company_code
    IMPORTING
      output = lv_companycode.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = vendor_permitted
    IMPORTING
      output = lv_vendor_permitted.

  " --- Step 2: Verify if vendor and alternate payee exist in S4 -------------------
  SELECT SINGLE supplier
    FROM i_supplier
   WHERE supplier = @lv_supplier
    INTO @DATA(lv_supplier2).

  IF sy-subrc NE 0.  " if Vendor have alternate payee match then
    error_flag = 'X'.
    MESSAGE s037(/fmp/mp) WITH lv_supplier INTO error_message RAISING cx_root.
    RAISE vendor_not_found.
  ELSE.
    SELECT SINGLE supplier
    FROM i_supplier
   WHERE supplier = @lv_vendor_permitted
    INTO @DATA(lv_vendor_permitted2).

    IF sy-subrc NE 0.  " if Vendor have alternate payee match then
      error_flag = 'X'.
      MESSAGE s037(/fmp/mp) WITH lv_supplier INTO error_message.
      RETURN.
    ENDIF.
  ENDIF.

  " --- Step 3: Verify if vendor data has alternate payee-------------------
  SELECT SINGLE supplier, companycode, supplieralternativepayee
    FROM i_suplrpmtdaltvpayee
    WHERE supplier = @lv_supplier AND companycode = @lv_companycode AND supplieralternativepayee = @lv_vendor_permitted
    INTO @result.

  IF sy-subrc = 0.  " if Vendor have alternate payee match then
*    error_flag = 'X'.
    MESSAGE s001(fip_msg_class) INTO error_message.
    RETURN.
  ENDIF.

  " --- Step 4: Get Reconciliation Account for supplier -----------------------------------
  SELECT SINGLE reconciliationaccount, LayoutSortingRule, PaymentTerms, IsToBeCheckedForDuplicates, PaymentMethodsList, CreditMemoPaymentTerms
    FROM i_suppliercompany
    WHERE supplier    = @lv_supplier
      AND companycode = @lv_companycode
    INTO (@lv_recon_account, @lv_LayoutSortingRule, @lv_PaymentTerm, @lv_IsToBeCheckedForDuplicates, @lv_PaymentMethodsList, @lv_CreditMemoPaymentTerms).

  " --- Step 2: Set initial vendor data -----------------------------------
  APPEND INITIAL LINE TO ls_main-vendors ASSIGNING FIELD-SYMBOL(<vendor>).
  <vendor>-header-object_task = lc_update.
  <vendor>-header-object_instance-lifnr = lv_supplier.
  <vendor>-company_data-current_state = lc_insert.
  APPEND INITIAL LINE TO <vendor>-company_data-company ASSIGNING FIELD-SYMBOL(<comp_data>).
  <comp_data>-task = lc_insert.
  <comp_data>-data_key-bukrs = lv_companycode.
  <comp_data>-data-reprf = lv_IsToBeCheckedForDuplicates.
  <comp_data>-dataX-reprf = lc_x.
  <comp_data>-data-guzte = lv_CreditMemoPaymentTerms.
  <comp_data>-datax-guzte = lc_x.
  <comp_data>-data-zwels = lv_PaymentMethodsList.
  <comp_data>-datax-zwels = lc_x.
  <comp_data>-data-zterm = lv_paymentterm.
  <comp_data>-dataX-zterm = lc_x.
  <comp_data>-data-zuawa = lv_LayoutSortingRule.
  <comp_data>-datax-zuawa = lc_x.
  <comp_data>-data-akont = lv_recon_account.
  <comp_data>-datax-akont = lc_x.
  <comp_data>-data-lnrzb = lv_vendor_permitted.
  <comp_data>-datax-lnrzb = lc_x.
  <comp_data>-data-xlfzb = lc_x.
  <comp_data>-datax-xlfzb = lc_x.
  <comp_data>-alt_payee-current_state = lc_insert.
  APPEND INITIAL LINE TO <comp_data>-alt_payee-alt_payee ASSIGNING FIELD-SYMBOL(<payee>).
  <payee>-task = lc_insert.
  <payee>-data_key-empfk = lv_vendor_permitted.

*--------------- If alternate payee exist for the vendor the add it into LFZA ---------*
  SELECT mandt,lifnr, bukrs, empfk FROM lfza
    WHERE lifnr = @lv_supplier
    AND bukrs = @lv_companycode
    INTO TABLE @lt_old_altpayee.

  IF sy-subrc = 0.
    LOOP AT lt_old_altpayee ASSIGNING FIELD-SYMBOL(<old_payee>).
      APPEND INITIAL LINE TO <comp_data>-alt_payee-alt_payee ASSIGNING <payee>.
      <payee>-task = lc_insert.
      <payee>-data_key-empfk = <old_payee>-empfk.
    ENDLOOP.
  ENDIF.

  " --- Step 5: Call MAINTAIN_BAPI ---------------------------------------
  vmd_ei_api=>maintain_bapi( EXPORTING iv_test_run          = ''                 " Blank means commit change
                                       is_master_data       = ls_main
                             IMPORTING es_message_correct   = l_messages
                                       es_message_defective = l_update_errors ).

  " --- Step 6: Check Results and Commit ----------------------------------
  IF l_update_errors-is_error IS INITIAL.
    COMMIT WORK.
  ELSE.
    " Handle update errors, e.g. log or raise message
    ROLLBACK WORK.
    error_flag = l_update_errors-is_error.
    error_message = l_update_errors-messages[ 1 ]-message.
  ENDIF.
ENDFUNCTION.
