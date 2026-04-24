class ZCL_FI_PMT_APPROVAL_WF definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_PAYMENT_PROPOSAL_WF .
protected section.
private section.

  data GR_STANDARD type ref to CL_FI_PAYMENT_PROPOSAL_WF .
ENDCLASS.



CLASS ZCL_FI_PMT_APPROVAL_WF IMPLEMENTATION.


METHOD if_ex_payment_proposal_wf~check_wf_active.
*----------------------------------------------------------------------*
* The standard implementation uses database table T042WF, maintained   *
* in IMG or directly with transaction F110WFR.                         *
*----------------------------------------------------------------------*

  DATA: lt_items  TYPE STANDARD TABLE OF zea_item,
        lt_actors TYPE tswhactor,
        lv_objkey TYPE wtmg_tabkey
        .

  APPEND INITIAL LINE TO lt_items ASSIGNING FIELD-SYMBOL(<item>).

  <item>-bukrs = i_zbukr.
  <item>-zlsch = i_zwels.
  IF <item>-land1 IS INITIAL.
    SELECT SINGLE land1 FROM t001
           INTO <item>-land1
           WHERE bukrs = i_zbukr.
  ENDIF.

  CONCATENATE i_laufd i_laufi INTO lv_objkey.

  TRY.
      CALL METHOD zcl_elect_approval=>get_approvers
        EXPORTING
          i_objtype   = zcl_elect_approval=>gc_objtype_f110
          i_objkey    = lv_objkey
          i_bukrs     = i_zbukr
          it_items    = lt_items
        IMPORTING
          et_approver = lt_actors.
      IF lt_actors IS NOT INITIAL.
        e_wf_active = 'X'.
        CONCATENATE i_laufd i_laufi INTO DATA(lv_objkey2) SEPARATED BY space.

        UPDATE zea_appr
               SET archive = 'X'
               WHERE objtype = zcl_elect_approval=>gc_objtype_f110
                 AND objkey  = lv_objkey2.
      ENDIF.
    CATCH zcx_ea_exceptions.
  ENDTRY.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~delete_wf_packages.

*----------------------------------------------------------------------*
* The standard implementation deletes entries in table REGUH_WFR,      *
* which is only filled and used in this BAdI implementation.           *
*----------------------------------------------------------------------*

  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

  CALL METHOD gr_standard->delete_wf_packages
    EXPORTING
      i_laufd = i_laufd
      i_laufi = i_laufi.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~get_wf_package_1.
*----------------------------------------------------------------------*
* The standard implementation uses database table T042WFR, maintained  *
* in IMG or directly with transaction F110WFR.                         *
* The result is stored in database table REGUH_WFR, which is only      *
* filled and used in this BAdI implementation.                         *
*----------------------------------------------------------------------*
  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

  CALL METHOD gr_standard->get_wf_package_1
    EXPORTING
      is_account   = is_account
      is_reguh     = is_reguh
    IMPORTING
      e_wf_package = e_wf_package.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~get_wf_package_2.

*----------------------------------------------------------------------*
* If you create a new implementation of BAdI FI_PAYMENT_PROPOSAL_WF    *
* you can call the SAP standard default implementation as below.       *
*                                                                      *
* Advantage of calling the default code (instead of copying) is        *
* that you benefit from future corrections and enhancements of SAP.    *
* This recommendation works for all methods of this BAdI respectively. *
*                                                                      *
* The above recommendation is feasible if you don't want to change     *
* the default behavior or if you only want to add specific logic       *
* before or after the default logic.                                   *
*                                                                      *
* The recommendation is not feasible if you want to replace the        *
* default logic without reusing part of it.                            *
*----------------------------------------------------------------------*
* The standard implementation uses database table T042WFR, maintained  *
* in IMG or directly with transaction F110WFR.                         *
* The result is stored in database table REGUH_WFR, which is only      *
* filled and used in this BAdI implementation.                         *
*----------------------------------------------------------------------*
  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

*----------------------------------------------------------------------*
* Standard calculation of the total amount used as rule condition:     *
*   Sum of  payment  amounts (REGUH-RBETR) respecting the sign         *
*   and of exception amounts (REGUP-DMBTR): add debit, subtract credit *
* This standard calculation can be revised here.                       *
*----------------------------------------------------------------------*

  DATA l_amount TYPE dmshb_x8.
  l_amount = i_amount.                "recalculate amount here if needed

  CALL METHOD gr_standard->get_wf_package_2
    EXPORTING
      is_account   = is_account
      i_amount     = l_amount
      it_reguh     = it_reguh
      it_regup     = it_regup
    IMPORTING
      e_wf_package = e_wf_package.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~get_wf_package_actors.
*----------------------------------------------------------------------*
* The standard implementation uses database table T042WFR, maintained  *
* in IMG or directly with transaction F110WFR and the results stored   *
* in database table REGUH_WFR, which is only filled and used in this   *
* BAdI implementation.                                                 *
*----------------------------------------------------------------------*

  DATA: lt_items     TYPE STANDARD TABLE OF zea_item.

  "Let the default SAP bring back the full entry and then replace the
  "ACTORS (WF approvers) based on our Z table customization
  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

  CALL METHOD gr_standard->get_wf_package_actors
    EXPORTING
      i_laufd       = i_laufd
      i_laufi       = i_laufi
    IMPORTING
      et_wf_package = et_wf_package.

  LOOP AT et_wf_package ASSIGNING FIELD-SYMBOL(<package>).
    CLEAR lt_items.

    SELECT FROM reguh_wfr AS w JOIN reguh AS h ON w~laufd = h~laufd
                                              AND w~laufi = h~laufi
                                              AND h~laufd = @i_laufd
                                              AND h~laufi = @i_laufi
                               JOIN t001 AS t  ON t~bukrs = @<package>-zbukr "#EC CI_BUFFJOIN
           FIELDS DISTINCT w~zbukr AS bukrs, h~rzawe AS zlsch, t~land1
           WHERE w~zbukr      = @<package>-zbukr
             AND w~absbu      = @<package>-absbu
             AND w~wf_package = @<package>-package
           INTO CORRESPONDING FIELDS OF TABLE @lt_items.

    TRY.
        CALL METHOD zcl_elect_approval=>get_approvers
          EXPORTING
            i_objtype   = zcl_elect_approval=>gc_objtype_f110
            i_bukrs     = <package>-zbukr
            it_items    = lt_items
          IMPORTING
            et_approver = <package>-actors.
      CATCH zcx_ea_exceptions.
    ENDTRY.
  ENDLOOP.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~get_wf_package_description.
*----------------------------------------------------------------------*
* The standard implementation uses the content of table REGUH_WFR,     *
* which is only filled and used in this BAdI implementation.           *
*----------------------------------------------------------------------*

  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

  CALL METHOD gr_standard->get_wf_package_description
    EXPORTING
      i_laufd          = i_laufd
      i_laufi          = i_laufi
      i_zbukr          = i_zbukr
      i_absbu          = i_absbu
      i_wf_package     = i_wf_package
    IMPORTING
      e_description_cc = e_description_cc
      e_description    = e_description.

ENDMETHOD.


METHOD if_ex_payment_proposal_wf~start_wf_postprocessing.
*----------------------------------------------------------------------*
* The standard implementation schedules the payment run for the        *
* proposal data checked by the workflow actors.                        *
*----------------------------------------------------------------------*

  IF NOT gr_standard IS BOUND.
    CREATE OBJECT gr_standard.
  ENDIF.

*----------------------------------------------------------------------*
* Set attributes to schedule the payment run. Default settings:        *
*   Schedule payment run with payment media and lists                  *
*   Start immediately                                                  *
*   No specification of server group                                   *
*   Start with current user (usually WF-BATCH)                         *
* This standard logic can be revised here.                             *
*----------------------------------------------------------------------*

  DATA: l_xmitd TYPE xmitd,
        l_xmitl TYPE xmitl,
        l_bhost TYPE bhost,
        l_immed TYPE btcchar1,
        l_user  TYPE uname,
        l_date  TYPE btcsdate,
        l_time  TYPE btcstime.

  l_xmitd = l_xmitl = l_immed = 'X'.
  CLEAR:l_bhost, l_user, l_date, l_time.

  CALL METHOD gr_standard->set_job_details
    EXPORTING
      i_xmitd     = l_xmitd
      i_xmitl     = l_xmitl
      i_bhost     = l_bhost
      i_strtimmed = l_immed
      i_sdlstrtdt = l_date
      i_sdlstrttm = l_time
      i_user      = l_user.

  CALL METHOD gr_standard->start_wf_postprocessing
    EXPORTING
      i_laufd = i_laufd
      i_laufi = i_laufi.

ENDMETHOD.
ENDCLASS.
