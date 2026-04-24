CLASS lhc_ZI_FI_INVOICE_CATEGORY DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_invoice_category RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_INVOICE_CATEGORY IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
