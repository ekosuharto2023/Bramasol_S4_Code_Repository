CLASS lhc_ZI_FI_PARKING_LOG DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_parking_log RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_PARKING_LOG IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
