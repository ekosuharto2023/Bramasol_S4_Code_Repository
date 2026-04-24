FUNCTION zfi_cos_suppl_inv.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     VALUE(CT_GL) TYPE  ZFI_TT_SUPPLINV_GL
*"  EXCEPTIONS
*"      ERROR_IN_DOC
*"----------------------------------------------------------------------

  DATA(lo_cos_build) = NEW zcl_cos_data_build( ).

*  lo_cos_build->cos_proccessor( EXPORTING is_rbkp_new     = is_hdr
*                                          it_inv_gls_amts = it_gl ).
**                                 IMPORTING et_gl = data(  )
**lt_gl)

*  RAISE EXCEPTION with error_in_doc.
ENDFUNCTION.
