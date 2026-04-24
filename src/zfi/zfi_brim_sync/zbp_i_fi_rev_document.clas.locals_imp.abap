CLASS lhc_ZI_FI_REV_DOCUMENT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_rev_document RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_REV_DOCUMENT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
