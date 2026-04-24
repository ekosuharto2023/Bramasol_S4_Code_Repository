PROGRAM zrggbs000 .
*---------------------------------------------------------------------*
* Corrections/ repair
* wms092357 070703 Note 638886: template routines to be used for
*                  workaround to substitute bseg-bewar from bseg-xref1/2
*---------------------------------------------------------------------*
*                                                                     *
*   Substitutions: EXIT-Formpool for Uxxx-Exits                       *
*                                                                     *
*   This formpool is used by SAP for testing purposes only.           *
*                                                                     *
*   Note: If you define a new user exit, you have to enter your       *
*         user exit in the form routine GET_EXIT_TITLES.              *
*                                                                     *
*---------------------------------------------------------------------*
INCLUDE fgbbgd00.              "Standard data types


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*    PLEASE INCLUDE THE FOLLOWING "TYPE-POOL"  AND "TABLES" COMMANDS  *
*        IF THE ACCOUNTING MODULE IS INSTALLED IN YOUR SYSTEM         *
 TYPE-POOLS: GB002. " TO BE INCLUDED IN                       "wms092357
 TABLES: BKPF,      " ANY SYSTEM THAT                         "wms092357
         BSEG,      " HAS 'FI' INSTALLED                      "wms092357
         COBL,                                                "wms092357
         CSKS,                                                "wms092357
         ANLZ,                                                "wms092357
         GLU1.                                                "wms092357
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*


*---------------------------------------------------------------------*
*       FORM U100                                                     *
*---------------------------------------------------------------------*
FORM UFP01.

assert 1 = 2.
ENDFORM.

*----------------------------------------------------------------------*
*       FORM GET_EXIT_TITLES                                           *
*----------------------------------------------------------------------*
*       returns name and title of all available standard-exits         *
*       every exit in this formpool has to be added to this form.      *
*       You have to specify a parameter type in order to enable the    *
*       code generation program to determine correctly how to          *
*       generate the user exit call, i.e. how many and what kind of    *
*       parameter(s) are used in the user exit.                        *
*       The following parameter types exist:                           *
*                                                                      *
*       TYPE                Description              Usage             *
*    ------------------------------------------------------------      *
*       C_EXIT_PARAM_NONE   Use no parameter         Subst. and Valid. *
*                           except B_RESULT                            *
*       C_EXIT_PARAM_FIELD  Use one field as param.  Only Substitution *
*       C_EXIT_PARAM_CLASS  Use a type as parameter  Subst. and Valid  *
*                                                                      *
*----------------------------------------------------------------------*
*  -->  EXIT_TAB  table with exit-name and exit-titles                 *
*                 structure: NAME(5), PARAM(1), TITEL(60)
*----------------------------------------------------------------------*
FORM get_exit_titles TABLES etab.

  DATA: BEGIN OF exits OCCURS 50,
          name(5)   TYPE c,
          param     LIKE c_exit_param_none,
          title(60) TYPE c,
        END OF exits.

  exits-name  = 'U100'.
  exits-param = c_exit_param_none.
  exits-title = text-100.             "Cost center from CSKS
  APPEND exits.

  exits-name  = 'U101'.
  exits-param = c_exit_param_field.
  exits-title = text-101.             "Cost center from CSKS
  APPEND exits.

* begin of insertion                                          "wms092357
  exits-name  = 'U200'.
  exits-param = c_exit_param_field.
  exits-title = text-200.             "Cons. transaction type
  APPEND exits.                       "from xref1/2
* end of insertion                                            "wms092357

************************************************************************
* PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINES *
*        IF THE ACCOUNTING MODULE IS INSTALLED IN YOUR SYSTEM:         *
*  EXITS-NAME  = 'U102'.
*  EXITS-PARAM = C_EXIT_PARAM_CLASS.
*  EXITS-TITLE = TEXT-102.             "Sum is used for the reference.
*  APPEND EXITS.


***********************************************************************
** EXIT EXAMPLES FROM PUBLIC SECTOR INDUSTRY SOLUTION
**
** PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINE
** TO ENABLE PUBLIC SECTOR EXAMPLE SUBSTITUTION EXITS
***********************************************************************
  INCLUDE rggbs_ps_titles.

  REFRESH etab.
  LOOP AT exits.
    etab = exits.
    APPEND etab.
  ENDLOOP.

ENDFORM.                    "GET_EXIT_TITLES


* eject
*---------------------------------------------------------------------*
*       FORM U100                                                     *
*---------------------------------------------------------------------*
*       Reads the cost-center from the CSKS table .                   *
*---------------------------------------------------------------------*
FORM u100.

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINES *
*        IF THE ACCOUNTING MODULE IS INSTALLED IN YOUR SYSTEM:         *
*  SELECT * FROM CSKS
*            WHERE KOSTL EQ COBL-KOSTL
*              AND KOKRS EQ COBL-KOKRS.
*    IF CSKS-DATBI >= SY-DATUM AND
*       CSKS-DATAB <= SY-DATUM.
*
*      MOVE CSKS-ABTEI TO COBL-KOSTL.
*
*    ENDIF.
*  ENDSELECT.

ENDFORM.                                                    "U100

* eject
*---------------------------------------------------------------------*
*       FORM U101                                                     *
*---------------------------------------------------------------------*
*       Reads the cost-center from the CSKS table for accounting      *
*       area '0001'.                                                  *
*       This exit uses a parameter for the cost_center so it can      *
*       be used irrespective of the table used in the callup point.   *
*---------------------------------------------------------------------*
FORM u101 USING cost_center.

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINES *
*        IF THE ACCOUNTING MODULE IS INSTALLED IN YOUR SYSTEM:         *
*  SELECT * FROM CSKS
*            WHERE KOSTL EQ COST_CENTER
*              AND KOKRS EQ '0001'.
*    IF CSKS-DATBI >= SY-DATUM AND
*       CSKS-DATAB <= SY-DATUM.
*
*      MOVE CSKS-ABTEI TO COST_CENTER .
*
*    ENDIF.
*  ENDSELECT.

ENDFORM.                                                    "U101

* eject
*---------------------------------------------------------------------*
*       FORM U102                                                     *
*---------------------------------------------------------------------*
*       Inserts the sum of the posting into the reference field.      *
*       This exit can be used in FI for the complete document.        *
*       The complete data is passed in one parameter.                 *
*---------------------------------------------------------------------*


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINES *
*        IF THE ACCOUNTING MODULE IS INSTALLED IN YOUR SYSTEM:         *
*FORM u102 USING bool_data TYPE gb002_015.
*DATA: SUM(10) TYPE C.
*
*    LOOP AT BOOL_DATA-BSEG INTO BSEG
*                    WHERE    SHKZG = 'S'.
*       BSEG-ZUONR = 'Test'.
*       MODIFY BOOL_DATA-BSEG FROM BSEG.
*       ADD BSEG-DMBTR TO SUM.
*    ENDLOOP.
*
*    BKPF-XBLNR = TEXT-001.
*    REPLACE '&' WITH SUM INTO BKPF-XBLNR.
*
*ENDFORM.


***********************************************************************
** EXIT EXAMPLES FROM PUBLIC SECTOR INDUSTRY SOLUTION
**
** PLEASE DELETE THE FIRST '*' FORM THE BEGINING OF THE FOLLOWING LINE
** TO ENABLE PUBLIC SECTOR EXAMPLE SUBSTITUTION EXITS
***********************************************************************
*INCLUDE rggbs_ps_forms.


*eject
* begin of insertion                                          "wms092357
*&---------------------------------------------------------------------*
*&      Form  u200
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM u200 USING e_rmvct TYPE bseg-bewar.
  PERFORM xref_to_rmvct USING bkpf bseg 1 CHANGING e_rmvct.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  xref_to_rmvct
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM xref_to_rmvct
     USING    is_bkpf         TYPE bkpf
              is_bseg         TYPE bseg
              i_xref_field    type i
     CHANGING c_rmvct         TYPE rmvct.

  data l_msgv type symsgv.
  statics st_rmvct type hashed table of rmvct with unique default key.

* either bseg-xref1 or bseg-xref2 must be used as source...
  if i_xref_field <> 1 and i_xref_field <> 2.
    message x000(gk) with 'UNEXPECTED VALUE I_XREF_FIELD ='
      i_xref_field '(MUST BE = 1 OR = 2)' ''.
  endif.
  if st_rmvct is initial.
    select trtyp from t856 into table st_rmvct.
  endif.
  if i_xref_field = 1.
    c_rmvct = is_bseg-xref1.
  else.
    c_rmvct = is_bseg-xref2.
  endif.
  if c_rmvct is initial.
    write i_xref_field to l_msgv left-justified.
    concatenate text-m00 l_msgv into l_msgv separated by space.
*   cons. transaction type is not specified => send an error message...
    message e123(g3) with l_msgv.
*   Bitte geben Sie im Feld &1 eine Konsolidierungsbewegungsart an
  endif.
* c_rmvct <> initial...
  read table st_rmvct transporting no fields from c_rmvct.
  check not sy-subrc is initial.
* cons. transaction type does not exist => send error message...
  write i_xref_field to l_msgv left-justified.
  concatenate text-m00 l_msgv into l_msgv separated by space.
  message e124(g3) with c_rmvct l_msgv.
* KonsBewegungsart &1 ist ungültig (bitte Eingabe im Feld &2 korrigieren
endform.
* end of insertion                                            "wms092357
