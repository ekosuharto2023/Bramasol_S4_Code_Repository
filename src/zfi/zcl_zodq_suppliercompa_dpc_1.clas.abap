class ZCL_ZODQ_SUPPLIERCOMPA_DPC_1 definition
  public
  inheriting from CL_RSODP_ODATA_ODP_OUT_DPC
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
protected section.

  methods GET_SERVICE_CONFIGURATION
    redefinition .
private section.

  class-data PS_SERVICE_CONFIG type CL_RSODP_ODATA_ODP_OUT_MPC=>TS_SERVICE_CONFIG .
ENDCLASS.



CLASS ZCL_ZODQ_SUPPLIERCOMPA_DPC_1 IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  DATA: ls_odp TYPE cl_rsodp_odata_odp_out_mpc=>ts_odp.
  ps_service_config-model_name      = 'ZODQ_SUPPLIERCOMPANY_1_MDL'.
  ps_service_config-model_version   = '0001'.
  ps_service_config-service_name    = 'ZODQ_SUPPLIERCOMPANY_1_SRV'.
  ps_service_config-service_version = '0001'.
  ps_service_config-mpc_name        = 'ZCL_ZODQ_SUPPLIERCOMPA_MPC_1'.
  ps_service_config-dpc_name        = 'ZCL_ZODQ_SUPPLIERCOMPA_DPC_1'.
  ps_service_config-context         = 'ABAP_CDS'.
  CLEAR ps_service_config-odps.
  ls_odp-odpname    = 'ISUPPLCOMPANY$F'.
  ls_odp-entityname = 'FactsOfISUPPLCOMPANY'.
  APPEND ls_odp TO ps_service_config-odps.
  ps_service_config-active_version  = cl_rsodp_odata_version=>cs_version_1_1.
  ps_service_config-schema_version  = '0003'.
  endmethod.


  method GET_SERVICE_CONFIGURATION.
  e_context    = ps_service_config-context.
  e_t_odp      = ps_service_config-odps.
  e_s_active_version = ps_service_config-active_version.
  e_schema_version = ps_service_config-schema_version.
  endmethod.
ENDCLASS.
