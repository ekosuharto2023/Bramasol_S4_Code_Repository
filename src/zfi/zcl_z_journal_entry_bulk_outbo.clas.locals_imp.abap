
class lcl_fill_data implementation.

  method ZJOURNAL_ENTRY_BULK_CREATE_CON.
    call method ZJOURNAL_ENTRY_CREATE_CONFIRM2
      importing
        out = out-JOURNAL_ENTRY_BULK_CREATE_CONF.
  endmethod.

  method ZJOURNAL_ENTRY_CREATE_CONFIRM2.
    call method ZBUSINESS_DOCUMENT_MESSAGE_HE2
      importing
        out = out-MESSAGE_HEADER.
    call method ZINTERFACE_NAME
      importing
        out = out-CONFIRMATION_INTERFACE_ORIGN_N.
    call method ZJOURNAL_ENTRY_CREATE_CONF_TAB
      importing
        out = out-JOURNAL_ENTRY_CREATE_CONFIRMAT.
    call method ZLOGC
      importing
        out = out-LOG.
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_HE2.
    call method ZBUSINESS_DOCUMENT_MESSAGE_ID1
      importing
        out = out-ID.
    call method ZUUID
      importing
        out = out-UUID.
    call method ZBUSINESS_DOCUMENT_MESSAGE_ID1
      importing
        out = out-REFERENCE_ID.
    call method ZUUID
      importing
        out = out-REFERENCE_UUID.
    call method ZGLOBAL_DATE_TIME
      importing
        out = out-CREATION_DATE_TIME.
    call method ZINDICATOR
      importing
        out = out-TEST_DATA_INDICATOR.
    call method ZINDICATOR
      importing
        out = out-RECONCILIATION_INDICATOR.
    call method ZBUSINESS_SYSTEM_ID
      importing
        out = out-SENDER_BUSINESS_SYSTEM_ID.
    call method ZBUSINESS_SYSTEM_ID
      importing
        out = out-RECIPIENT_BUSINESS_SYSTEM_ID.
    call method ZBUSINESS_DOCUMENT_MESSAGE_HE1
      importing
        out = out-SENDER_PARTY.
    call method ZBUSINESS_DOCUMENT_MESSAGE_TAB
      importing
        out = out-RECIPIENT_PARTY.
    call method ZBUSINESS_SCOPE_TAB
      importing
        out = out-BUSINESS_SCOPE.
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_ID1.
    out-SCHEME_ID = `Token 1`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 2`. "#EC NOTEXT
    call method ZBUSINESS_DOCUMENT_MESSAGE_ID
      importing
        out = out-CONTENT.
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_ID.
    out = `Token 3`. "#EC NOTEXT
  endmethod.

  method ZUUID.
    out-SCHEME_ID = `Token 4`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 5`. "#EC NOTEXT
    call method ZUUID_CONTENT
      importing
        out = out-CONTENT.
  endmethod.

  method ZUUID_CONTENT.
    out = `1234567890ABCDEF0123456789ABCDEF`. "#EC NOTEXT
  endmethod.

  method ZGLOBAL_DATE_TIME.
    out = `20060328120000.1234567 `. "#EC NOTEXT
  endmethod.

  method ZINDICATOR.
    out = `X`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_SYSTEM_ID.
    out = `Token 6`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_HE1.
    call method ZPARTY_INTERNAL_ID
      importing
        out = out-INTERNAL_ID.
    call method ZPARTY_STANDARD_ID_TAB
      importing
        out = out-STANDARD_ID.
    call method ZBUSINESS_DOCUMENT_MESSAGE_HEA
      importing
        out = out-CONTACT_PERSON.
  endmethod.

  method ZPARTY_INTERNAL_ID.
    out-SCHEME_ID = `Token 7`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 8`. "#EC NOTEXT
    call method ZPARTY_INTERNAL_ID_CONTENT
      importing
        out = out-CONTENT.
  endmethod.

  method ZPARTY_INTERNAL_ID_CONTENT.
    out = `Token 9`. "#EC NOTEXT
  endmethod.

  method ZPARTY_STANDARD_ID_TAB.
    data: ls_out like line of out.
    call method ZPARTY_STANDARD_ID
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZPARTY_STANDARD_ID.
    out-SCHEME_AGENCY_ID = `Tok`. "#EC NOTEXT
    call method ZPARTY_STANDARD_ID_CONTENT
      importing
        out = out-CONTENT.
  endmethod.

  method ZPARTY_STANDARD_ID_CONTENT.
    out = `Token 11`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_HEA.
    call method ZCONTACT_PERSON_INTERNAL_ID
      importing
        out = out-INTERNAL_ID.
    call method ZLANGUAGEINDEPENDENT_MEDIU_TAB
      importing
        out = out-ORGANISATION_FORMATTED_NAME.
    call method ZLANGUAGEINDEPENDENT_LONG__TAB
      importing
        out = out-PERSON_FORMATTED_NAME.
    call method ZPHONE_NUMBER_TAB
      importing
        out = out-PHONE_NUMBER.
    call method ZPHONE_NUMBER_TAB
      importing
        out = out-FAX_NUMBER.
    call method ZEMAIL_URI_TAB
      importing
        out = out-EMAIL_URI.
  endmethod.

  method ZCONTACT_PERSON_INTERNAL_ID.
    out-SCHEME_ID = `Token 12`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 13`. "#EC NOTEXT
    call method ZCONTACT_PERSON_INTERNAL_ID_CO
      importing
        out = out-CONTENT.
  endmethod.

  method ZCONTACT_PERSON_INTERNAL_ID_CO.
    out = `Token 14`. "#EC NOTEXT
  endmethod.

  method ZLANGUAGEINDEPENDENT_MEDIU_TAB.
    data: ls_out like line of out.
    call method ZLANGUAGEINDEPENDENT_MEDIUM_NA
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZLANGUAGEINDEPENDENT_MEDIUM_NA.
    out = `String 15`. "#EC NOTEXT
  endmethod.

  method ZLANGUAGEINDEPENDENT_LONG__TAB.
    data: ls_out like line of out.
    call method ZLANGUAGEINDEPENDENT_LONG_NAME
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZLANGUAGEINDEPENDENT_LONG_NAME.
    out = `String 16`. "#EC NOTEXT
  endmethod.

  method ZPHONE_NUMBER_TAB.
    data: ls_out like line of out.
    call method ZPHONE_NUMBER
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZPHONE_NUMBER.
    call method ZPHONE_NUMBER_AREA_ID
      importing
        out = out-AREA_ID.
    call method ZPHONE_NUMBER_SUBSCRIBER_ID
      importing
        out = out-SUBSCRIBER_ID.
    call method ZPHONE_NUMBER_EXTENSION_ID
      importing
        out = out-EXTENSION_ID.
    call method ZCOUNTRY_CODE
      importing
        out = out-COUNTRY_CODE.
    call method ZCOUNTRY_DIALLING_CODE
      importing
        out = out-COUNTRY_DIALLING_CODE.
    call method ZMEDIUM_NAME
      importing
        out = out-COUNTRY_NAME.
  endmethod.

  method ZPHONE_NUMBER_AREA_ID.
    out = `Token 17`. "#EC NOTEXT
  endmethod.

  method ZPHONE_NUMBER_SUBSCRIBER_ID.
    out = `Token 18`. "#EC NOTEXT
  endmethod.

  method ZPHONE_NUMBER_EXTENSION_ID.
    out = `Token 19`. "#EC NOTEXT
  endmethod.

  method ZCOUNTRY_CODE.
    out = `Tok`. "#EC NOTEXT
  endmethod.

  method ZCOUNTRY_DIALLING_CODE.
    out = `Token 21`. "#EC NOTEXT
  endmethod.

  method ZMEDIUM_NAME.
    call method ZLANGUAGE_CODE
      importing
        out = out-LANGUAGE_CODE.
    call method ZMEDIUM_NAME_CONTENT
      importing
        out = out-CONTENT.
  endmethod.

  method ZLANGUAGE_CODE.
    out = `EN`. "#EC NOTEXT
  endmethod.

  method ZMEDIUM_NAME_CONTENT.
    out = `String 22`. "#EC NOTEXT
  endmethod.

  method ZEMAIL_URI_TAB.
    data: ls_out like line of out.
    call method ZEMAIL_URI
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZEMAIL_URI.
    out-SCHEME_ID = `Token 23`. "#EC NOTEXT
    out-CONTENT = `http://sap.com/anyURI`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_DOCUMENT_MESSAGE_TAB.
    data: ls_out like line of out.
    call method ZBUSINESS_DOCUMENT_MESSAGE_HE1
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZBUSINESS_SCOPE_TAB.
    data: ls_out like line of out.
    call method ZBUSINESS_SCOPE
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZBUSINESS_SCOPE.
    call method ZBUSINESS_SCOPE_TYPE_CODE
      importing
        out = out-TYPE_CODE.
    call method ZBUSINESS_SCOPE_INSTANCE_ID
      importing
        out = out-INSTANCE_ID.
    call method ZBUSINESS_SCOPE_ID
      importing
        out = out-ID.
  endmethod.

  method ZBUSINESS_SCOPE_TYPE_CODE.
    out-LIST_ID = `Token 24`. "#EC NOTEXT
    out-LIST_VERSION_ID = `Token 25`. "#EC NOTEXT
    out-LIST_AGENCY_ID = `Token 26`. "#EC NOTEXT
    call method ZBUSINESS_SCOPE_TYPE_CODE_CONT
      importing
        out = out-CONTENT.
  endmethod.

  method ZBUSINESS_SCOPE_TYPE_CODE_CONT.
    out = `Toke`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_SCOPE_INSTANCE_ID.
    out-SCHEME_ID = `Token 28`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 29`. "#EC NOTEXT
    call method ZBUSINESS_SCOPE_INSTANCE_ID_CO
      importing
        out = out-CONTENT.
  endmethod.

  method ZBUSINESS_SCOPE_INSTANCE_ID_CO.
    out = `Token 30`. "#EC NOTEXT
  endmethod.

  method ZBUSINESS_SCOPE_ID.
    out-SCHEME_ID = `Token 31`. "#EC NOTEXT
    out-SCHEME_AGENCY_ID = `Token 32`. "#EC NOTEXT
    call method ZBUSINESS_SCOPE_ID_CONTENT
      importing
        out = out-CONTENT.
  endmethod.

  method ZBUSINESS_SCOPE_ID_CONTENT.
    out = `Token 33`. "#EC NOTEXT
  endmethod.

  method ZINTERFACE_NAME.
    out = `Token 34`. "#EC NOTEXT
  endmethod.

  method ZJOURNAL_ENTRY_CREATE_CONF_TAB.
    data: ls_out like line of out.
    call method ZJOURNAL_ENTRY_CREATE_CONFIRMA
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZJOURNAL_ENTRY_CREATE_CONFIRMA.
    call method ZBUSINESS_DOCUMENT_MESSAGE_HE2
      importing
        out = out-MESSAGE_HEADER.
    call method ZJOURNAL_ENTRY_CREATE_CONFIRM1
      importing
        out = out-JOURNAL_ENTRY_CREATE_CONFIRMAT.
    call method ZLOGC
      importing
        out = out-LOG.
  endmethod.

  method ZJOURNAL_ENTRY_CREATE_CONFIRM1.
    call method ZACCOUNTING_DOCUMENT
      importing
        out = out-ACCOUNTING_DOCUMENT.
    call method ZCOMPANY_CODE_ID
      importing
        out = out-COMPANY_CODE.
    call method ZFISCAL_YEAR_ID
      importing
        out = out-FISCAL_YEAR.
  endmethod.

  method ZACCOUNTING_DOCUMENT.
    out = `Token 35`. "#EC NOTEXT
  endmethod.

  method ZCOMPANY_CODE_ID.
    out = `Toke`. "#EC NOTEXT
  endmethod.

  method ZFISCAL_YEAR_ID.
    out = `Toke`. "#EC NOTEXT
  endmethod.

  method ZLOGC.
    call method ZPROCESSING_RESULT_CODE
      importing
        out = out-BUSINESS_DOCUMENT_PROCESSING_R.
    call method ZLOG_ITEM_SEVERITY_CODE
      importing
        out = out-MAXIMUM_LOG_ITEM_SEVERITY_CODE.
    call method ZLOG_ITEM_TAB
      importing
        out = out-ITEM.
  endmethod.

  method ZPROCESSING_RESULT_CODE.
    out = `To`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_SEVERITY_CODE.
    out = `T`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_TAB.
    data: ls_out like line of out.
    call method ZLOG_ITEM
      importing
        out = ls_out.
    do 3 times.
      append ls_out to out.
    enddo.
  endmethod.

  method ZLOG_ITEM.
    call method ZLOG_ITEM_TYPE_ID
      importing
        out = out-TYPE_ID.
    call method ZLOG_ITEM_CATEGORY_CODE
      importing
        out = out-CATEGORY_CODE.
    call method ZLOG_ITEM_SEVERITY_CODE
      importing
        out = out-SEVERITY_CODE.
    call method ZOBJECT_NODE_PARTY_TECHNICAL_I
      importing
        out = out-REFERENCE_OBJECT_NODE_SENDER_T.
    call method ZLANGUAGEINDEPENDENT_NAME
      importing
        out = out-REFERENCE_MESSAGE_ELEMENT_NAME.
    call method ZLOG_ITEM_NOTE
      importing
        out = out-NOTE.
    call method ZLOG_ITEM_NOTE_TEMPLATE_TEXT
      importing
        out = out-NOTE_TEMPLATE_TEXT.
    call method ZLOG_ITEM_NOTE_PLACEHOLDER_SUB
      importing
        out = out-LOG_ITEM_NOTE_PLACEHOLDER_SUBS.
    call method ZWEB_URI
      importing
        out = out-WEB_URI.
  endmethod.

  method ZLOG_ITEM_TYPE_ID.
    out = `Token 40`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_CATEGORY_CODE.
    out-LIST_ID = `Token 41`. "#EC NOTEXT
    out-LIST_VERSION_ID = `Token 42`. "#EC NOTEXT
    out-LIST_AGENCY_ID = `Token 43`. "#EC NOTEXT
    call method ZLOG_ITEM_CATEGORY_CODE_CONTEN
      importing
        out = out-CONTENT.
  endmethod.

  method ZLOG_ITEM_CATEGORY_CODE_CONTEN.
    out = `Token 44`. "#EC NOTEXT
  endmethod.

  method ZOBJECT_NODE_PARTY_TECHNICAL_I.
    out = `Token 45`. "#EC NOTEXT
  endmethod.

  method ZLANGUAGEINDEPENDENT_NAME.
    out = `String 46`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_NOTE.
    out = `String 47`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_NOTE_TEMPLATE_TEXT.
    out = `String 48`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_NOTE_PLACEHOLDER_SUB.
    call method ZLOG_ITEM_TEMPLATE_PLACEHOLDER
      importing
        out = out-FIRST_PLACEHOLDER_ID.
    call method ZLOG_ITEM_TEMPLATE_PLACEHOLDER
      importing
        out = out-SECOND_PLACEHOLDER_ID.
    call method ZLOG_ITEM_TEMPLATE_PLACEHOLDER
      importing
        out = out-THIRD_PLACEHOLDER_ID.
    call method ZLOG_ITEM_TEMPLATE_PLACEHOLDER
      importing
        out = out-FOURTH_PLACEHOLDER_ID.
    call method ZLOG_ITEM_PLACEHOLDER_SUBSTITU
      importing
        out = out-FIRST_PLACEHOLDER_SUBSTITUTION.
    call method ZLOG_ITEM_PLACEHOLDER_SUBSTITU
      importing
        out = out-SECOND_PLACEHOLDER_SUBSTITUTIO.
    call method ZLOG_ITEM_PLACEHOLDER_SUBSTITU
      importing
        out = out-THIRD_PLACEHOLDER_SUBSTITUTION.
    call method ZLOG_ITEM_PLACEHOLDER_SUBSTITU
      importing
        out = out-FOURTH_PLACEHOLDER_SUBSTITUTIO.
  endmethod.

  method ZLOG_ITEM_TEMPLATE_PLACEHOLDER.
    out = `T`. "#EC NOTEXT
  endmethod.

  method ZLOG_ITEM_PLACEHOLDER_SUBSTITU.
    out = `String 50`. "#EC NOTEXT
  endmethod.

  method ZWEB_URI.
    out = `http://sap.com/anyURI`. "#EC NOTEXT
  endmethod.

endclass.

