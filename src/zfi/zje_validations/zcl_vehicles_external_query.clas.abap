CLASS zcl_vehicles_external_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

  CLASS-METHODS get_vehicles
        FOR TABLE FUNCTION  ZTF_VEHICLES_EXTERNAL_QUERY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_vehicles_external_query IMPLEMENTATION.


  METHOD get_vehicles
    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY.




      declare lt_result table (
      zz1_clientcode nvarchar(5),
      zz1_vehicleno nvarchar(12),
      zz1_serialno nvarchar(30),
      zz1_icnno nvarchar(10) );


        declare lv_dynfrom nvarchar(500);
  lv_dynfrom =
'SELECT zz1_clientcode, zz1_vehicleno, zz1_serialno, zz1_icnno ' ||
  'FROM "BRIM_CM_ZFI_VEHICLES" ';

    EXECUTE immediate :lv_dynfrom INTO lt_result;



    RETURN
      select
        zz1_clientcode,
  zz1_vehicleno,
  zz1_serialno,
  zz1_icnno
      FROM :lt_result;



 ENDMETHOD.
 endclass.
