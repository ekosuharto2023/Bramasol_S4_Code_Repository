"Name: \PR:SAPLMRM_BAPI\FO:BAPIRETURN_FILL\SE:END\EI
ENHANCEMENT 0 ZMRM_INCOMING_INVOICE.
data: lt_errors type MRM_TAB_ERRPROT.

CALL FUNCTION 'MRM_PROT_GET'
 IMPORTING
   TE_ERRPROT       = lt_errors
          .
loop at lt_errors ASSIGNING FIELD-SYMBOL(<error>).
  clear s_return.
  s_return-TYPE       = <error>-MSGTY.
  s_return-ID         = <error>-MSGID.
  s_return-NUMBER     = <error>-MSGNO.
  s_return-MESSAGE_V1 = <error>-MSGV1.
  s_return-MESSAGE_V2 = <error>-MSGV2.
  s_return-MESSAGE_V3 = <error>-MSGV3.
  s_return-MESSAGE_V4 = <error>-MSGV4.
  MESSAGE ID <error>-msgid TYPE 'I' NUMBER <error>-msgno
             WITH <error>-msgv1 <error>-msgv2 <error>-msgv3 <error>-msgv4 INTO s_return-message.
  COLLECT s_return INTO te_return.
endloop.

ENDENHANCEMENT.
