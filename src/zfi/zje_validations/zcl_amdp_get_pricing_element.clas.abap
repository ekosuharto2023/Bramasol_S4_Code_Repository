CLASS zcl_amdp_get_pricing_element DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    " Implementation of CDS Table Function
    CLASS-METHODS get_pricing_element
        FOR TABLE FUNCTION ztf_amdp_get_pricing_element.
ENDCLASS.


CLASS zcl_amdp_get_pricing_element IMPLEMENTATION.

  METHOD get_pricing_element
    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY.

    declare lt_result table ( pricing_element_code nvarchar(4) );

  declare lv_dynfrom nvarchar(500);
  lv_dynfrom =
    'SELECT PRICING_ELEMENT_CODE ' ||
    'FROM "BRIM_CM_PRICING_ELEMENT" ';

    EXECUTE immediate :lv_dynfrom INTO lt_result;

    RETURN
      select pricing_element_code
      FROM :lt_result;
  ENDMETHOD.
ENDCLASS.

