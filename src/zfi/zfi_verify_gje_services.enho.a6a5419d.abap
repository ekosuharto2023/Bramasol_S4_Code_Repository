"Name: \TY:CL_FDC_ACCDOC_VER_SERVICES\ME:GET_WORKFLOW_ITEM_STATUS\SE:END\EI
ENHANCEMENT 0 ZFI_VERIFY_GJE_SERVICES.
 if rv_result = cl_fdc_accdoc_ver_services=>co_approval_status-in_approval.
   "When the SAP "standard" wf is in process (WS02800046) and the WF (WS90000001)
   "has been rejected, this WF will still be active while the multi level WF has
   "been rejected and finished. In order to allow the user to edit the document
   "the response here should match the status of the WF we are handling

   "The SAP original WF will not look if the document has been approved since our
   "WF will post the entry which will end the SAP original WF. The only inquiry
   "will be when the user wants to edit the document after it has been rejected. Original WF Alive. Our WF - ended.
      SELECT single * FROM zea_appr
             WHERE objtype = @zcl_elect_approval=>gc_objtype_fi
               and bukrs = @iv_ausbk
               and belnr = @iv_belnr
               AND gjahr = @iv_gjahr
               AND archive = ''
               and reject = 'X'
              into @data(ls_appr).
   if sy-subrc is INITIAL.
     rv_result = cl_fdc_accdoc_ver_services=>co_approval_status-rejected.
   endif.
 endif.
ENDENHANCEMENT.
