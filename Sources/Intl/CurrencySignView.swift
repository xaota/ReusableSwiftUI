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
    if json == nil {
      EmptyView()
    } else {
      if let sign = json!.sign {
        Text(sign)
      } else {
        let firstCodeChar = String(json!.code.prefix(1))
        Text(firstCodeChar.isEmpty ? "?" : firstCodeChar)
      }
    }
  }
}

#Preview {
  let currency: CurrencyEnum = .RUB
  CurrencySignView(currency: currency)
}
