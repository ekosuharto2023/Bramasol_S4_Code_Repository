@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZVEXCHANGERATE'
@Analytics.dataCategory: #FACT
@Analytics.dataExtraction: { enabled: true,
                             delta.changeDataCapture.mapping: [ { table: 'TCURR',
                                                                  role: #MAIN,
                                                                  viewElement: [ 'ExchangeRateType',
                                                                                 'SourceCurrency',
                                                                                 'TargetCurrency',
                                                                                 'GdatuRaw' ],
                                                                  tableElement: [ 'KURST', 'FCURR', 'TCURR', 'GDATU' ] } ] }
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Exchange Rates ODQ'
@ObjectModel.supportedCapabilities: #EXTRACTION_DATA_SOURCE
@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, sizeCategory: #L, serviceQuality: #D }
@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@VDM.viewType: #CONSUMPTION

define view ZC_ExchangeRate
  as select from ZI_EXCHANGERATE as ER
     inner join   tcurr           as TC
      on  TC.kurst = ER.ExchangeRateType
      and TC.fcurr = ER.SourceCurrency
      and TC.tcurr = ER.TargetCurrency
      and TC.gdatu = ER.GdatuRawForJoin
{
  key ER.ExchangeRateType,
  key ER.SourceCurrency,
  key ER.TargetCurrency,
  key TC.gdatu                           as GdatuRaw,

      ER.ExchangeRateEffectiveDate,
      ER.ExchangeRate,
      ER.NumberOfSourceCurrencyUnits,
      ER.NumberOfTargetCurrencyUnits,
      ER.AlternativeExchangeRateType,
      ER.AltvExchangeRateTypeValdtyDate,
      ER.InvertedExchangeRateIsAllowed,
      ER.ReferenceCurrency,
      ER.BuyingRateAvgExchangeRateType,
      ER.SellingRateAvgExchangeRateType,
      ER.FixedExchangeRateIsUsed,
      ER.SpecialConversionIsUsed,
      ER.SourceCurrencyDecimals,
      ER.TargetCurrencyDecimals,
      ER.ExchRateIsIndirectQuotation,
      ER.AbsoluteExchangeRate,
      ER.EffectiveExchangeRate,
      ER.DirectQuotedEffectiveExchRate,
      ER.IndirectQuotedEffctvExchRate,
      ER._ExchangeRateType,
      ER._SourceCurrency,
      ER._TargetCurrency,
      ER._Text
}
