class ZCL_ZODATA_COS_SUPPLIN_DPC_EXT definition
  public
  inheriting from ZCL_ZODATA_COS_SUPPLIN_DPC
  create public .

public section.
protected section.

  methods INVOICECREATESET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZODATA_COS_SUPPLIN_DPC_EXT IMPLEMENTATION.


  method INVOICECREATESET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->INVOICECREATESET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.
ENDCLASS.
