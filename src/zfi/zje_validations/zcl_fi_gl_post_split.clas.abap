class ZCL_FI_GL_POST_SPLIT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_FI_GL_POSTING_SPLIT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FI_GL_POST_SPLIT IMPLEMENTATION.


  method IF_EX_FI_GL_POSTING_SPLIT~ACTIVATE_DOCUMENT_SPLIT.
*    e_split = abap_true.
  endmethod.


  method IF_EX_FI_GL_POSTING_SPLIT~CHANGE_SPL_CLEARNG_LINE_ITM.
  endmethod.
ENDCLASS.
