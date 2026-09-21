//
//  CurrencyTests.swift
//  Reusable
//

import Foundation
import Testing
@testable import Intl

@Suite("CurrencyEnum")
struct CurrencyEnumTests {
  @Test("by находит валюту по её коду", arguments: CurrencyEnum.allCases)
  func findsEveryCase(currency: CurrencyEnum) {
    #expect(CurrencyEnum.by(currency.rawValue) == currency)
  }

  @Test("by не находит неизвестные коды и чувствителен к регистру",
        arguments: ["usd", "Rub", "XXX", "US", "USDT", ""])
  func rejectsUnknown(code: String) {
    #expect(CurrencyEnum.by(code) == nil)
  }

  @Test("коды соответствуют формату ISO 4217: три заглавные буквы")
  func codesLookLikeISO() {
    for currency in CurrencyEnum.allCases {
      #expect(currency.rawValue.count == 3, "\(currency)")
      #expect(currency.rawValue == currency.rawValue.uppercased(), "\(currency)")
    }
  }

  @Test("коды не повторяются")
  func codesAreUnique() {
    let codes = CurrencyEnum.allCases.map(\.rawValue)

    #expect(Set(codes).count == codes.count)
  }
}

@Suite("CurrencyStore")
struct CurrencyStoreTests {
  @Test("currency.json загружается из бандла модуля")
  func loadsBundledJSON() {
    #expect(!decodeCurrencyJSON().isEmpty)
  }

  @Test("get возвращает полную запись по коду")
  func getByCode() {
    let usd = CurrencyStore.json.get("USD")

    #expect(usd?.code == "USD")
    #expect(usd?.sign == "$")
    #expect(usd?.flag == "🇺🇸")
    #expect(usd?.icon == "dollar")
  }

  @Test("get не находит несуществующий код")
  func getUnknown() {
    #expect(CurrencyStore.json.get("XXX") == nil)
  }

  @Test("by(_:) эквивалентен get(rawValue)", arguments: CurrencyEnum.allCases)
  func byMatchesGet(currency: CurrencyEnum) {
    #expect(CurrencyStore.json.by(currency)?.code == CurrencyStore.json.get(currency.rawValue)?.code)
  }

  @Test("для каждого значения CurrencyEnum есть запись в currency.json",
        arguments: CurrencyEnum.allCases)
  func everyEnumCaseHasJSON(currency: CurrencyEnum) {
    #expect(CurrencyStore.json.by(currency) != nil, "нет записи для \(currency.rawValue)")
  }

  @Test("signature отдаёт знак валюты",
        arguments: [
          (CurrencyEnum.USD, "$"),
          (.EUR, "€"),
          (.RUB, "₽"),
          (.GEL, "₾"),
          (.BTC, "₿")
        ])
  func signature(currency: CurrencyEnum, sign: String) {
    #expect(CurrencyStore.signature(for: currency) == sign)
  }

  @Test("signature непустой для всех валют", arguments: CurrencyEnum.allCases)
  func signatureIsNeverEmpty(currency: CurrencyEnum) {
    #expect(!CurrencyStore.signature(for: currency).isEmpty, "нет подписи для \(currency.rawValue)")
  }
}

@Suite("CurrencyJSON")
struct CurrencyJSONTests {
  @Test("необязательные поля декодируются как nil")
  func decodesOptionalFields() throws {
    let json = #"{"code":"XTS"}"#
    let currency = try JSONDecoder().decode(CurrencyJSON.self, from: Data(json.utf8))

    #expect(currency.code == "XTS")
    #expect(currency.sign == nil)
    #expect(currency.flag == nil)
    #expect(currency.icon == nil)
  }

  @Test("полная запись декодируется и кодируется обратно")
  func roundTrip() throws {
    let json = #"{"code":"RUB","sign":"₽","flag":"🇷🇺","icon":"ruble"}"#
    let decoded = try JSONDecoder().decode(CurrencyJSON.self, from: Data(json.utf8))
    let encoded = try JSONEncoder().encode(decoded)
    let again = try JSONDecoder().decode(CurrencyJSON.self, from: encoded)

    #expect(again.code == "RUB")
    #expect(again.sign == "₽")
    #expect(again.flag == "🇷🇺")
    #expect(again.icon == "ruble")
  }
}
