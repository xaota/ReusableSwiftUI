//
//  BankStoreTests.swift
//  Reusable
//

import Foundation
import Testing
@testable import Bank

@Suite("BankStore.searchable")
struct BankStoreSearchableTests {
  @Test("убирает разделители и приводит к нижнему регистру",
        arguments: [
          ("Альфа-Банк", "альфабанк"),
          ("АК БАРС", "акбарс"),
          ("Credit Agricole", "creditagricole"),
          ("J.P. Morgan", "jpmorgan"),
          ("BNP Paribas (France)", "bnpparibasfrance"),
          ("Raiffeisen | Bank", "raiffeisenbank"),
          ("АТБ — Банк", "атббанк"),
          ("Home/Credit", "homecredit"),
          ("T\\Bank", "tbank"),
          ("M&T", "mt"),
          ("A+B", "ab"),
          ("Bank [RU]", "bankru"),
          ("Bank {2}", "bank2"),
          ("Cash$Flow", "cashflow"),
          ("банк,точка", "банкточка")
        ])
  func normalizes(input: String, expected: String) {
    #expect(BankStore.searchable(input) == expected)
  }

  @Test("обрезает пробелы по краям")
  func trimsWhitespace() {
    #expect(BankStore.searchable("  Тинькофф \n") == "тинькофф")
  }

  @Test("пустая строка и строка из разделителей нормализуются в пустую",
        arguments: ["", "   ", "---", " . , "])
  func emptyResult(input: String) {
    #expect(BankStore.searchable(input).isEmpty)
  }

  @Test("идемпотентна: повторная нормализация ничего не меняет",
        arguments: ["Альфа-Банк", "J.P. Morgan", "  Raiffeisen | Bank "])
  func isIdempotent(input: String) {
    let once = BankStore.searchable(input)

    #expect(BankStore.searchable(once) == once)
  }
}

@Suite("BankStore.filter")
struct BankStoreFilterTests {
  @Test("пустой запрос не возвращает ничего", arguments: ["", "   ", "-", " . "])
  func emptyQuery(query: String) {
    #expect(BankStore.filter(query).isEmpty)
  }

  @Test("находит по коду банка")
  func findsByCode() {
    let codes = BankStore.filter("alfabank").map(\.code)

    #expect(codes.contains("alfabank"))
  }

  @Test("запрос не чувствителен к регистру и разделителям",
        arguments: ["ALFABANK", "Alfa-Bank", "  alfa bank "])
  func queryIsNormalized(query: String) {
    #expect(BankStore.filter(query).map(\.code).contains("alfabank"))
  }

  @Test("находит по названию")
  func findsByCaption() {
    #expect(BankStore.filter("Альфа-Банк").map(\.code).contains("alfabank"))
  }

  @Test("находит по синонимам из search")
  func findsBySearchSynonyms() {
    #expect(BankStore.filter("amex").map(\.code).contains("americanexpress"))
    #expect(BankStore.filter("абб").map(\.code).contains("akbars"))
  }

  @Test("не находит ничего по заведомо отсутствующему запросу")
  func findsNothing() {
    #expect(BankStore.filter("zzzznosuchbank").isEmpty)
  }

  @Test("частичный запрос возвращает несколько банков")
  func partialQueryMatchesSeveral() {
    #expect(BankStore.filter("bank").count > 1)
  }
}

@Suite("BankStore: данные и выборка")
struct BankStoreDataTests {
  @Test("bank.json загружается из бандла модуля")
  func loadsBundledJSON() {
    #expect(!decodeBankJSON().isEmpty)
    #expect(!BankStore.json.bankJSON.isEmpty)
  }

  @Test("коды банков уникальны")
  func codesAreUnique() {
    let codes = BankStore.json.bankJSON.map(\.code)
    let duplicates = Dictionary(grouping: codes, by: { $0 }).filter { $0.value.count > 1 }.keys

    #expect(duplicates.isEmpty, "дубликаты: \(duplicates.joined(separator: ", "))")
  }

  @Test("коды уже нормализованы — иначе filter по коду не сработает")
  func codesAreNormalized() {
    let broken = BankStore.json.bankJSON.map(\.code).filter { BankStore.searchable($0) != $0 }

    #expect(broken.isEmpty, "ненормализованные коды: \(broken.joined(separator: ", "))")
  }

  @Test("у каждого банка есть непустое название")
  func captionsArePresent() {
    let empty = BankStore.json.bankJSON.filter { $0.caption.trimmingCharacters(in: .whitespaces).isEmpty }

    #expect(empty.isEmpty, "банки без названия: \(empty.map(\.code).joined(separator: ", "))")
  }

  @Test("get возвращает банк по коду")
  func getByCode() {
    #expect(BankStore.get("alfabank")?.caption == "Альфа-Банк")
  }

  @Test("get не находит несуществующий код")
  func getUnknown() {
    #expect(BankStore.get("zzzznosuchbank") == nil)
  }

  @Test("name отдаёт название банка")
  func nameByCode() {
    #expect(BankStore.name("alfabank") == "Альфа-Банк")
  }

  @Test("name возвращает исходную строку для неизвестного банка")
  func nameFallsBack() {
    #expect(BankStore.name("zzzznosuchbank") == "zzzznosuchbank")
  }

  @Test("каждый банк находится по своему коду")
  func everyBankIsReachableByCode() {
    let unreachable = BankStore.json.bankJSON.map(\.code).filter { BankStore.get($0) == nil }

    #expect(unreachable.isEmpty)
  }

  @Test("каждый банк находится через filter по своему коду")
  func everyBankIsSearchableByCode() {
    let missing = BankStore.json.bankJSON.map(\.code).filter { code in
      !BankStore.filter(code).map(\.code).contains(code)
    }

    #expect(missing.isEmpty, "не находятся: \(missing.joined(separator: ", "))")
  }
}
