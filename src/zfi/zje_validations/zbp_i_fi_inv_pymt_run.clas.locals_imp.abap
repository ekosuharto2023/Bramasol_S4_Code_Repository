CLASS lhc_ZI_FI_INV_PYMT_RUN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_inv_pymt_run RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_INV_PYMT_RUN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
