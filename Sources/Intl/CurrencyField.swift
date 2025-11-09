//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 04.11.2025.
//

import SwiftUI

public struct CurrencyField: View {
  @Binding var value: CurrencyEnum

  enum CurrencyListENUM: String, CaseIterable, Identifiable {
    case popular, other
    var id: Self { self }
  }

  @State private var selectedCurrencyList: CurrencyListENUM = .popular
  @State private var list: [CurrencyEnum] = CurrencyField.popular

  public init(value: Binding<CurrencyEnum>) {
    self._value = value
  }

  public var body: some View {
    let selectCurrencyString = String(localized: "popular", bundle: .module)
    let popularCurrenciesString = String(localized: "popular", bundle: .module)
    let otherCurrenciesString = String(localized: "other", bundle: .module)

    Menu {
      Section {
        Picker(selection: $selectedCurrencyList, label: EmptyView()) {
          Text(popularCurrenciesString).tag(CurrencyListENUM.popular)
          Text(otherCurrenciesString).tag(CurrencyListENUM.other)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
      }

      Section {
        ControlGroup(content: {
          ForEach(CurrencyField.general, id: \.self) { curr in
            CurrencyMenuItem(currency: curr) { value = curr }
          }
        })
      }

      Section {
        ForEach(list, id: \.self) { curr in
          CurrencyMenuItem(currency: curr) { value = curr }
        }
      }

      // CurrencyMenuItem(currency: .BTC) { currency = .BTC }
    } label: {
      HStack {
        CurrencySignView(currency: value)
        Label(selectCurrencyString, systemImage: "chevron.down").labelStyle(.iconOnly)
      }
    }
    .onChange(of: selectedCurrencyList) { newValue in
      switch newValue {
        case .popular:
          self.list = CurrencyField.popular
        case .other:
          self.list = CurrencyField.other
      }
    }
  }

  static let general: [CurrencyEnum] = [.USD, .EUR, .RUB]
  static let popular: [CurrencyEnum] = [.CNY, .AED, .GEL, .TRY, .THB, .LKR, .KZT, .AMD, .ILS, .VND, .MNT, .KGS, .BYN]
  static let other: [CurrencyEnum] = [
    .KHR, .BGN, .AZN, .LAK, .INR, .KRW,
    .GBP, .CHF, .JPY, .PLN, .SEK, .UAH,
    .BTC
  ]
}

#Preview {
  @Previewable @State var currency: CurrencyEnum = .USD

  CurrencyField(value: $currency)
}

