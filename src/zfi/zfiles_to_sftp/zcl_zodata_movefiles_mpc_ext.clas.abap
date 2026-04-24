class ZCL_ZODATA_MOVEFILES_MPC_EXT definition
  public
  inheriting from ZCL_ZODATA_MOVEFILES_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZODATA_MOVEFILES_MPC_EXT IMPLEMENTATION.


  method DEFINE.
    super->define( ).
    model->get_entity_type( iv_entity_name = 'File'
           )->get_property( iv_property_name = 'Mimetype'
           )->set_as_content_type( ) .

  endmethod.
ENDCLASS.
