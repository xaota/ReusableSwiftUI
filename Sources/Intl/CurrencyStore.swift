//
//  CurrencyStore.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 19.10.2025.
//

import Foundation
import JSON

public final class CurrencyStore: @unchecked Sendable {
  public static let json: CurrencyStore = {
    let instance = CurrencyStore()
    instance.load()
    return instance
  }()

  private var currencyJSON: [CurrencyJSON] = []
  private init() {}

  // You can keep this internal if you don't want external callers to invoke it.
  // It's called within the same file during shared initialization.
  func load() {
    let json: [CurrencyJSON] = decodeCurrencyJSON()
    self.currencyJSON = json
  }

  public func by(_ value: CurrencyEnum) -> CurrencyJSON? {
    get(value.rawValue)
  }

  public func get(_ code: String) -> CurrencyJSON? {
    currencyJSON.first(where: { $0.code == code })
  }

  public static func signature(for currency: CurrencyEnum, fallback: String = "") -> String {
    let json: CurrencyJSON? = Self.json.by(currency)
    return json?.sign ?? json?.code ?? fallback
  }
}

func decodeCurrencyJSON(file: String = "currency", fileExtension: String = "json") -> [CurrencyJSON] {
  decodeFileJSON(file, defaultValue: [], bundle: .module, fileExtension: fileExtension)
}
