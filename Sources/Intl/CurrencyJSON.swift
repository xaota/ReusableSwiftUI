//
//  CurrencyJSON.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//

import Foundation

public struct CurrencyJSON: Codable {
  public var code: String // Locale.currency.identifier
  public var sign: String?
  public var flag: String?
  public var icon: String?
}
