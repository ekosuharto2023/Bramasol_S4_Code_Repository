CLASS zcl_amdp_vehicles DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS get_vehicles
        FOR TABLE FUNCTION  ztf_amdp_vehicles.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_vehicles IMPLEMENTATION.

  METHOD get_vehicles
    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    .
    declare lv_counter integer := 0;
     declare lt_result table ( zz1_clientcode nvarchar(5),
                               zz1_vehicleno nvarchar(12),
                               zz1_serialno nvarchar(30),
                               zz1_icnno nvarchar(10) );
           declare lv_dynfrom nvarchar(500);
     lv_dynfrom =
        'SELECT zz1_clientcode, zz1_vehicleno, zz1_serialno, zz1_icnno ' ||
        'FROM "BRIM_CM_ZFI_VEHICLES" WHERE';

       IF :p_client <> '%' then
         lv_dynfrom = '' || lv_dynfrom || ' "ZZ1_CLIENTCODE" = ''' || :p_client || '''';
         lv_counter := lv_counter + 1;
       END if;

       IF :p_vehicle <> '%' then
         IF :lv_counter > 0 then
           lv_dynfrom = '' || lv_dynfrom || ' AND "ZZ1_VEHICLENO" = ''' || :p_vehicle || '''';
         ELSE
           lv_dynfrom = '' || lv_dynfrom || ' "ZZ1_VEHICLENO" = ''' || :p_vehicle || '''';
         END if;
         lv_counter := lv_counter + 1;
       END if;

       IF :p_serial <> '%' then
         IF :lv_counter > 0 then
           lv_dynfrom = '' || lv_dynfrom || ' AND "ZZ1_SERIALNO" = ''' || :p_serial || '''';
         ELSE
           lv_dynfrom = '' || lv_dynfrom || ' "ZZ1_SERIALNO" = ''' || :p_serial || '''';
         END if;
         lv_counter := lv_counter + 1;
       END if;

       IF :p_icnno <> '0000000000' then
         IF :lv_counter > 0 then
           lv_dynfrom = '' || lv_dynfrom || ' AND "ZZ1_ICNNO" = ''' || :p_icnno || '''';
         ELSE
           lv_dynfrom = '' || lv_dynfrom || ' "ZZ1_ICNNO" = ''' || :p_icnno || '''';
         END if;
         lv_counter := lv_counter + 1;
       END if;

       EXECUTE immediate :lv_dynfrom INTO lt_result;

       RETURN
         select
           zz1_clientcode,
           zz1_vehicleno,
           zz1_serialno,
           zz1_icnno
         from :lt_result;

  endmethod.

ENDCLASS.
