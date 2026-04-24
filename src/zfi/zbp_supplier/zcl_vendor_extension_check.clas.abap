class ZCL_VENDOR_EXTENSION_CHECK definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_VENDOR_EXTENSION_CHECK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_VENDOR_EXTENSION_CHECK IMPLEMENTATION.
METHOD if_ex_vendor_extension_check~check.

  "----------------------------------------------------------------------"
  " Enforce REGION only for certain company-code countries
  "----------------------------------------------------------------------"


  " 1) Define which company-code countries require REGION
  "    (Replace this with a Z customizing table if you prefer)
  DATA lt_scope_countries TYPE RANGE OF land1.
  lt_scope_countries = VALUE #(
    ( sign = 'I' option = 'EQ' low = 'US' )
    ( sign = 'I' option = 'EQ' low = 'CA' )
  ).

  " 2) Determine whether the incoming vendor data includes any company code
  "    whose country is in scope
  DATA(lv_in_scope) = abap_false.
  DATA: lv_scope_bukrs TYPE bukrs,
  lv_scope_land1 TYPE land1.

  " COMPANY_DATA-COMPANY is a table of VMDS_EI_COMPANY
  LOOP AT is_vendor_ext-company_data-company INTO DATA(ls_company).
    " Skip deletions if relevant in your process
    IF ls_company-task = 'D'.
      CONTINUE.
    ENDIF.

    DATA(lv_bukrs) = ls_company-data_key-bukrs.
    IF lv_bukrs IS INITIAL.
      CONTINUE.
    ENDIF.



          " --- seam so ABAP Unit can stub company-code country ---
    TEST-SEAM t001_land1.
      SELECT SINGLE land1
        FROM t001
        INTO  @DATA(lv_land1)
        WHERE bukrs = @lv_bukrs.
    END-TEST-SEAM.


    IF sy-subrc = 0 AND lv_land1 IN lt_scope_countries.
      lv_in_scope     = abap_true.
      lv_scope_bukrs  = lv_bukrs.
      lv_scope_land1  = lv_land1.
      EXIT.
    ENDIF.
  ENDLOOP.

  " If no in-scope company codes are present, do nothing
  IF lv_in_scope = abap_false.
    RETURN.
  ENDIF.

  " 3) Check REGION on the (main) postal address in the inbound structure
  "    Region lives at: CENTRAL_DATA-ADDRESS-POSTAL-DATA-REGION
  "    (This is the same path used in common VMDS_EI_EXTERN examples)
  IF is_vendor_ext-central_data-address-postal-data-region IS INITIAL.

*    cs_error-is_error = abap_true.
*
*    APPEND VALUE bapiret2(
*      type       = 'E'
*      id         = 'ZPARK'
*      number     = '014'
*      message_v1 = lv_scope_bukrs
*      message_v2 = lv_scope_land1
*    ) TO cs_error-messages.
*
ENDIF.

ENDMETHOD.


ENDCLASS.
