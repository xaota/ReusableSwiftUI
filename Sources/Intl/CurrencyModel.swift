//
//  CurrencyModel..swift
//  Reusable
//
//  Created by Rinat Ibragimov on 19.10.2025.
//

public final class CurrencyModel: @unchecked Sendable {
  public static let json: CurrencyModel = {
    let instance = CurrencyModel()
    instance.load()
    return instance
  }()

  private var currencyJSON: [CurrencyJSON] = []
  private init() {}

  // You can keep this internal if you don't want external callers to invoke it.
  // It's called within the same file during shared initialization.
  func load() {
    let json: [CurrencyJSON] = decodeCurrencyJSON("currency.json")
    self.currencyJSON = json
  }

  public func by(_ value: CurrencyEnum) -> CurrencyJSON? {
    switch value {
      case .USD: return get("USD")
      case .EUR: return get("EUR")
      case .RUB: return get("RUB")
      case .GEL: return get("GEL")
      case .BGN: return get("BGN")
      case .THB: return get("THB")
      case .LKR: return get("LKR")
      case .GBP: return get("GBP")
      case .KHR: return get("KHR")
      case .TRY: return get("TRY")
      case .AZN: return get("AZN")
      case .KZT: return get("KZT")
      case .AMD: return get("AMD")
      case .ILS: return get("ILS")
      case .VND: return get("VND")
      case .MNT: return get("MNT")
      case .AED: return get("AED")
      case .CNY: return get("CNY")
      case .JPY: return get("JPY")
      case .LAK: return get("LAK")
      case .KRW: return get("KRW")
      case .INR: return get("INR")
      case .CHF: return get("CHF")
      case .UAH: return get("UAH")
      case .KGS: return get("KGS")
      case .BYN: return get("BYN")
      case .PLN: return get("PLN")
      case .SEK: return get("SEK")

      case .BTC: return get("BTC")
    }
  }

  // Can remain internal; make public if you want it accessible externally.
  public func get(_ code: String) -> CurrencyJSON? {
    return self.currencyJSON.first(where: { $0.code == code }) ?? nil
  }
}
