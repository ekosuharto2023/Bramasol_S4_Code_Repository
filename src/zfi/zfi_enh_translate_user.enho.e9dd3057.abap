"Name: \PR:SAPLSX01\FO:READ_NODE_DATA\SE:END\EI
ENHANCEMENT 0 ZFI_ENH_TRANSLATE_USER.
*&---------------------------------------------------------------------*
*& Enhancement ZFI_ENH_TRANSLATE_USER
*&---------------------------------------------------------------------*
*& OBJECT NAME : LSX01F05                           *
*& Transport No:  DS4K900727                                       *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 7-DEC-2025                                            *
*& DESCRIPTION : This enhancement has been created as part of ADO 417040
*          and use SendGrid as email system translate user to lower case
*&---------------------------------------------------------------------*
*&              MODIFICATION HISROTY:                                  *
*&---------------------------------------------------------------------*
IF ls_node-mail_host EQ 'smtp.sendgrid.net'.
  TRANSLATE es_node-smtpuser TO LOWER CASE.
ENDIF.
ENDENHANCEMENT.
