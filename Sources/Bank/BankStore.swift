//
//  BankStore.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//
import Foundation
import JSON

public final class BankStore: @unchecked Sendable {
  public static let json: BankStore = {
    let instance = BankStore()
    instance.load()
    return instance
  }()

  public var bankJSON: [BankJSON] = []
  private init() {}

  // You can keep this internal if you don't want external callers to invoke it.
  // It's called within the same file during shared initialization.
  func load() {
    let json: [BankJSON] = decodeBankJSON()
    self.bankJSON = json
  }

  public static func get(_ code: String) -> BankJSON? {
    BankStore.json.bankJSON.first(where: { $0.code == code })
  }

  public static func filter(_ text: String) -> [BankJSON] {
    let part = searchable(text)
    if part.isEmpty {
      return []
    }

    return BankStore.json.bankJSON.filter {
      let code = $0.code.contains(part)
      let caption = searchable($0.caption).contains(part)
      let index = ($0.search ?? []).map { searchable($0) }.joined().contains(part)
//      print("filter x", code, caption, index, $0.code, searchable($0.caption), ($0.search ?? []).map { searchable($0) }.joined())

      return code || caption || index
    }
  }

  public static func name(_ bank: String) -> String {
    return BankStore.get(bank)?.caption ?? bank
  }

  /// Регулярка «разделителей» в названиях банков (пробелы, знаки препинания, скобки и т.п.)
  static let separatorsPattern = "[\\s+\\-\\|\\.\\,–—/\\\\&\\$\\(\\)\\[\\]\\{\\}]+"

  /// Нормализация названия банка: убирает разделители, приводит к нижнему регистру
  public static func searchable(_ text: String) -> String {
    return text
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(
        of: separatorsPattern,
        with: "",
        options: .regularExpression
      )
      .lowercased()
  }
}

func decodeBankJSON(file: String = "bank", fileExtension: String = "json") -> [BankJSON] {
  decodeFileJSON(file, defaultValue: [], bundle: .module, fileExtension: fileExtension)
}
