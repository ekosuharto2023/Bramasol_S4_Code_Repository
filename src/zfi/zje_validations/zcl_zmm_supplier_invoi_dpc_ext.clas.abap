class ZCL_ZMM_SUPPLIER_INVOI_DPC_EXT definition
  public
  inheriting from ZCL_ZMM_SUPPLIER_INVOI_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZMM_SUPPLIER_INVOI_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
    CASE io_tech_request_context->get_entity_set_name( ).
      WHEN 'ZI_FI_InvoiceCategorySet'.
        SELECT invoice_category AS invoicecategory,
               description AS description
        FROM zfi_inv_category
        INTO TABLE @DATA(lt_inv_categories)
        .
        IF lt_inv_categories IS NOT INITIAL.

          copy_data_to_ref(
            EXPORTING
              is_data = lt_inv_categories
            CHANGING
              cr_data = er_entityset ).

        ENDIF.
      WHEN OTHERS.
        TRY.
            CALL METHOD super->/iwbep/if_mgw_appl_srv_runtime~get_entityset
              EXPORTING
                iv_entity_name           = iv_entity_name
                iv_entity_set_name       = iv_entity_set_name
                iv_source_name           = iv_source_name
                it_filter_select_options = it_filter_select_options
                it_order                 = it_order
                is_paging                = is_paging
                it_key_tab               = it_key_tab
                it_navigation_path       = it_navigation_path
                iv_filter_string         = iv_filter_string
                iv_search_string         = iv_search_string
                io_tech_request_context  = io_tech_request_context
              IMPORTING
                er_entityset             = er_entityset
                es_response_context      = es_response_context.

          CATCH /iwbep/cx_mgw_busi_exception.
          CATCH /iwbep/cx_mgw_tech_exception.
        ENDTRY.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
