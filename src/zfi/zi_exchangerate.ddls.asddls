@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wrapper for I_EXCHANGERATE'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_EXCHANGERATE
  as select from I_ExchangeRate
{
  key ExchangeRateType,
  key SourceCurrency,
  key TargetCurrency,
  key ExchangeRateEffectiveDate,

  cast(
    substring(
      cast(
        99999999
        - cast(
            cast( ExchangeRateEffectiveDate as abap.char(8) )
            as abap.int4
          )
        as abap.char(11)
      ),
      1,
      8
    )
    as abap.numc(8)
  ) as GdatuRawForJoin,

  ExchangeRate,
  NumberOfSourceCurrencyUnits,
  NumberOfTargetCurrencyUnits,
  AlternativeExchangeRateType,
  AltvExchangeRateTypeValdtyDate,
  InvertedExchangeRateIsAllowed,
  ReferenceCurrency,
  BuyingRateAvgExchangeRateType,
  SellingRateAvgExchangeRateType,
  FixedExchangeRateIsUsed,
  SpecialConversionIsUsed,
  SourceCurrencyDecimals,
  TargetCurrencyDecimals,
  ExchRateIsIndirectQuotation,
  AbsoluteExchangeRate,
  EffectiveExchangeRate,
  DirectQuotedEffectiveExchRate,
  IndirectQuotedEffctvExchRate,
  _ExchangeRateType,
  _SourceCurrency,
  _TargetCurrency,
  _Text
}
