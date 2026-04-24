CLASS lhc_ZI_FI_MAP_COS_RULES DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_fi_map_cos_rules RESULT result.

ENDCLASS.

CLASS lhc_ZI_FI_MAP_COS_RULES IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
