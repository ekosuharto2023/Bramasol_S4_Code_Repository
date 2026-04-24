CLASS lhc_ZI_FI_PAYMENT_METH DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_payment_meth RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_PAYMENT_METH IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
