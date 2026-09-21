//
//  BankIconTests.swift
//  Reusable
//

import Foundation
import Testing
@testable import Bank

@Suite("BankIcon")
struct BankIconTests {
  @Test("path собирает нормализованный путь до svg",
        arguments: [
          ("alfabank", "svg/alfabank.svg"),
          ("Альфа-Банк", "svg/альфабанк.svg"),
          ("  J.P. Morgan ", "svg/jpmorgan.svg")
        ])
  func path(bank: String, expected: String) {
    #expect(BankIcon.path(bank) == expected)
  }

  @Test("has находит ресурс известного банка",
        arguments: ["alfabank", "sberbank", "tbank", "n26", "1822direkt"])
  func hasKnownIcon(code: String) throws {
    try #require(BankStore.get(code) != nil, "в bank.json нет банка \(code)")

    #expect(BankIcon.has(code))
  }

  @Test("has не находит ресурс для неизвестного банка",
        arguments: ["zzzznosuchbank", "", "Альфа-Банк"])
  func missingIcon(bank: String) {
    #expect(BankIcon.has(bank) == false)
  }

  @Test("svg загружается для известного банка")
  func loadsSVG() {
    #expect(BankIcon.svg("alfabank") != nil)
  }

  @Test("svg не загружается для неизвестного банка")
  func doesNotLoadMissingSVG() {
    #expect(BankIcon.svg("zzzznosuchbank") == nil)
  }

  @Test("у каждого банка из bank.json есть svg-иконка")
  func everyBankHasIcon() {
    let missing = BankStore.json.bankJSON.map(\.code).filter { !BankIcon.has($0) }

    #expect(missing.isEmpty, "нет иконок: \(missing.joined(separator: ", "))")
  }
}
