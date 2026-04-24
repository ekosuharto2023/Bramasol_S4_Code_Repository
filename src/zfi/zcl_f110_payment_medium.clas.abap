class ZCL_F110_PAYMENT_MEDIUM definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_FARP_PAY_RUN_CLASSIC_MEDIUM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_F110_PAYMENT_MEDIUM IMPLEMENTATION.


  method IF_FARP_PAY_RUN_CLASSIC_MEDIUM~USE_CLASSIC_PAYMENT_MEDIUM.
    CV_SWITCH_ON = abap_true.
  endmethod.
ENDCLASS.
