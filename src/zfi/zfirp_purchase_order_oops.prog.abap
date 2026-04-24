*&---------------------------------------------------------------------*
*& Report ZFIRP_PURCHASE_ORDER_OOPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfirp_purchase_order_oops.

DATA: i_ebeln TYPE ebeln.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_ebeln TYPE ebeln OBLIGATORY.

SELECTION-SCREEN END OF BLOCK blk1.

INITIALIZATION.

START-OF-SELECTION.

*i_ebeln = '2000000133'.
  DATA(lo_app) = NEW zcl_purchase_order(
    p_ebeln = p_ebeln ).

  lo_app->process( ).
  lo_app->email_form( ).
