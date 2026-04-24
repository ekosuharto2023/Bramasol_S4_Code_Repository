"! <h1>Demo Implementation of Custom Function Interface</h1>
"! <p>This class offers a demo implementation of the interface {@link IF_FIN_RE_CUSTOM_FUNCTION}.<br/> Implementing this interface allows you to integrate custom ABAP logic into the <em>Manage Substitution/Validation Rules</em> app.
"! Once the implementing ABAP class is activated, the implementation is made available as a function inside the <em>Manage Substitution/Validation Rules</em> app,
"! which can be integrated into the custom substitution/validation rules.</p>
"! <p>This demo implementation is intentionally not visible by default, since the method if_fin_re_custom_function~is_disabled down below always returns true.
"! But it can be used as a starting point to implement custom functions in the <em>SAP S/4HANA Cloud ABAP Environment</em>.</p>
"! <p>Since this is simply a demo implementation, the actual logic provided here is very simple: a weekday calculation.
"! But instead of this demo logic any arbitrary functional ABAP logic could be wrapped inside such a class, and thus, made available
"! in the <em>Manage Substitution/Validation Rules</em> app.</p>
class ZCL_FI_VALIDATE_CLIENT_CODE definition
  public
  final
  create public .

public section.

    " Marker interface
  interfaces IF_FIN_RE_CUSTOM_FUNCTION .
private section.

  types:
    " Return type of the function
    t_weekday TYPE c LENGTH 2 .

"! <p>Constant definitions that are used by the implementation.</p>
"! <p><em>To Do</em>: Obviously, this can and should be removed when implementing other functions.
    "!<p><em>Note</em>: The name of the function has to start with either 'Z', 'Y', or a customer name space.
    "!The function has to use the same name space as the implementing ABAP class.</p>
  constants C_FUNCTION_NAME type FIN_RE_CUSTOM_FUNCTION_NAME value 'ZFI_VALIDATE_CLIENT_CODE' ##NO_TEXT.
  constants:
    c_parameter_client_code  TYPE c LENGTH 30 value 'ZZ1_CLIENTCODE_COB' ##NO_TEXT,
    c_parameter_company_code TYPE c LENGTH 30 value 'BUKRS' ##NO_TEXT,
    c_parameter_gl_account   TYPE c LENGTH 30 value 'HKONT' ##NO_TEXT,
    c_parameter_doc_type     TYPE c LENGTH 30 value 'BLART' ##NO_TEXT,
    c_parameter_icn_no       TYPE c LENGTH 30 value 'ZZ1_ICNNO_COB' ##NO_TEXT,
    c_parameter_product_code TYPE c LENGTH 30 value 'ZZ1_PRODUCTCODE_COB' ##NO_TEXT,
    c_parameter_prc_elem     TYPE c LENGTH 30 value 'ZZ1_PRICINGELEMENT_COB' ##NO_TEXT,
    c_parameter_serial_no    TYPE c LENGTH 30 value 'ZZ1_SERIALNO_COB' ##NO_TEXT,
    c_parameter_vehicle_no   TYPE c LENGTH 30 value 'ZZ1_VEHICLENO_COB', ##NO_TEXT
    c_parameter_transactkey  TYPE c LENGTH 30 value 'ZZ1_TRANSACTIONKEY_COB' ##NO_TEXT
    .
ENDCLASS.



CLASS ZCL_FI_VALIDATE_CLIENT_CODE IMPLEMENTATION.


  METHOD IF_FIN_RE_CUSTOM_FUNCTION~CHECK_AT_RULE_ACTIVATION.
    " This method can be used to add additional checks which are executed when a substitution/validation rule using this function
    " is activated. By implementing this function, it can be checked that only values of a specific type
    " are passed to the function, for example. This is displayed below:
    "  In this case, only values of type DATE are allowed as a parameter of the weekday calculation.
    "  If any other type of values are passed to the function, the substitution/validation rule cannot be activated.
    " In the same way, other checks are possible as well. It could, for example, be checked that only specific source fields are passed to the function
    " and not arbitrary values, or only constant values are allowed as parameters.

    " TODO: Adapt the following coding according to the requirements of your use case.
*    IF is_controlblock-parameters[ key p components name = c_parameter_name ]-expression-abap_type->type_kind <> cl_abap_typedescr=>typekind_date.
*      is_controlblock-tracer->trace(  VALUE #(  msgid = 'SUBVAL_WEEKDAY' msgno = '002' ) ).
*      ev_rc = if_fin_re_custom_function=>rc-error.
*    ENDIF.
  ENDMETHOD.


  METHOD if_fin_re_custom_function~execute.

    DATA: lt_items    TYPE zfi_t_coding_block,
          ls_items    TYPE zfi_s_coding_block,
          lv_blart    TYPE blart,
          lv_no_check TYPE char1
          .
    FIELD-SYMBOLS: <field> TYPE any.
    "Set result to OK (No error) and if an error is found then mark it as error
    ev_result = REF #( abap_true ).

    "When coming from incoming Invoice the fields have been already validated so no need to do it again line for line
    IMPORT lv_no_check = lv_no_check FROM MEMORY ID zcl_utility_fidoc_validator=>mc_verify_gje_memory_id.
    CHECK lv_no_check IS INITIAL.

    LOOP AT is_runtime-parameters ASSIGNING FIELD-SYMBOL(<param>).
      CASE <param>-name.
        WHEN 'HKONT'.
          ASSIGN COMPONENT 'SAKNR' OF STRUCTURE ls_items TO <field>.
        WHEN 'BLART'.
          ASSIGN lv_blart TO FIELD-SYMBOL(<blart>).
          <blart> = <param>-value->*.
          CONTINUE.
        WHEN OTHERS.
          ASSIGN COMPONENT <param>-name OF STRUCTURE ls_items TO <field>.
      ENDCASE.
      "Do not check sy-subrc to dump in case of wrong code matching
      IF <param>-value IS BOUND.
        <field> = <param>-value->*.
      ENDIF.
    ENDLOOP.

    IF ls_items-bukrs IS NOT INITIAL AND ls_items-saknr IS NOT INITIAL.
      APPEND ls_items TO lt_items.

      DATA(lv_error) = zcl_utility_fidoc_validator=>validate_client_code( it_items     = lt_items
                                                                          i_trans_type = zcl_utility_fidoc_validator=>mc_trans_type_journal_entry ).
      IF lv_error IS NOT INITIAL.
        ev_result = REF #( abap_false ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD IF_FIN_RE_CUSTOM_FUNCTION~GET_DESCRIPTION.
    " TODO: Return a message ID/No. for the text description of your function that is to be displayed in the Manage Substitution/Validation Rules app.
    rs_msg = VALUE symsg( msgid = 'ZPARK' msgno = '001' ).    "Validate Client Code
  ENDMETHOD.


  METHOD IF_FIN_RE_CUSTOM_FUNCTION~GET_NAME.
    " Provide a unique name in your customer name space.
    rv_name = c_function_name.
  ENDMETHOD.


  METHOD IF_FIN_RE_CUSTOM_FUNCTION~GET_PARAMETERS.

    rt_parameters = VALUE #(
        ( name = c_parameter_client_code
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_CLIENTCODE' ) ) )
        ( name = c_parameter_company_code
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'BUKRS' ) ) )
        ( name = c_parameter_gl_account
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'SAKNR' ) ) )
        ( name = c_parameter_doc_type
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'BLART' ) ) )
        ( name = c_parameter_icn_no
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_ICNNO' ) ) )
        ( name = c_parameter_prc_elem
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_PRICINGELEMENT' ) ) )
        ( name = c_parameter_product_code
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_PRODUCTCODE' ) ) )
        ( name = c_parameter_serial_no
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_SERIALNO' ) ) )
        ( name = c_parameter_vehicle_no
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_VEHICLENO' ) ) )
        ( name = c_parameter_transactkey
          abap_type = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'ZZ1_TRANSACTIONKEY' ) ) )
          ).

  ENDMETHOD.


  METHOD IF_FIN_RE_CUSTOM_FUNCTION~GET_RETURNTYPE.
    " Specify the ABAP type of the value that is set by the method if_fin_re_custom_function~execute.
    " TODO: Change the return type of your function according to your requirements.
    data: lv_client_code type ZZ1_CLIENTCODE.
    ro_type =  CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_data( lv_client_code ) ).
  ENDMETHOD.


  METHOD if_fin_re_custom_function~is_disabled.

    "The function should only be visible in specific events,

    CASE iv_event_id.
      WHEN 'FINS_ACC_JEI_1'.
        rv_disable = abap_false.
      WHEN OTHERS.
        rv_disable = abap_true.
    ENDCASE.

  ENDMETHOD.


  METHOD if_fin_re_custom_function~get_return_valuehelp.

    ev_valuehelp_cdsview = 'ZC_ZTF_AMDP_VEHICLES'.
    ev_valuehelp_cdsfield = 'ZZ1_CLIENTCODE_COB'.

  ENDMETHOD.
ENDCLASS.
