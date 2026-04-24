*&---------------------------------------------------------------------*
*& Subroutinenpool ZFIRP_SAPFM06P
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& OBJECT NAME : ZFIRP_SAPFM06P                        *
*& TITLE       : Purchase Order Print Program                          *
*& DEVELOPER   : Rishi Dhanju                                          *
*& USER ID     : RDHANJU                                               *
*& CRDATE      : 03/20/2026                                            *
*& DESCRIPTION : This program helps to run print program to print preview *
*& ADO         : 390141
*&---------------------------------------------------------------------*
*&              MODIFICATION HISTORY:                                  *
*&---------------------------------------------------------------------*
*& Date        Userid          Transport No        Changes             *

*&---------------------------------------------------------------------*
PROGRAM zfirp_sapfm06p.

TABLES: nast.

START-OF-SELECTION.

  PERFORM adobe_entry_neu USING space space.

FORM adobe_entry_neu USING ent_retco  LIKE sy-subrc
                           ent_screen TYPE c.

  DATA: lv_po TYPE ebeln.

  lv_po = nast-objky.

  DATA(lo_app) = NEW zcl_purchase_order( p_ebeln = lv_po ).

  lo_app->process( ).

  CLEAR ent_retco.

ENDFORM.                    " adobe_entry_neu
