//
//  CurrencySignView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 30.10.2025.
//

import SwiftUI

public struct CurrencySignView: View {
  var json: CurrencyJSON?

  public init(currency: CurrencyEnum) {
    self.json = CurrencyStore.json.by(currency)
  }

  public var body: some View {
    if let json {
      Text(json.sign ?? json.code.first.map(String.init) ?? "?")
    }
  }
}

#Preview {
  let currency: CurrencyEnum = .RUB
  CurrencySignView(currency: currency)
}
