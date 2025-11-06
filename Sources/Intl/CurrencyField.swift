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
    Menu {
      Section {
        Picker(selection: $selectedCurrencyList, label: EmptyView()) {
          Text("popular").tag(CurrencyListENUM.popular)
          Text("other").tag(CurrencyListENUM.other)
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
        Label("select", systemImage: "chevron.down").labelStyle(.iconOnly)
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
  static let popular: [CurrencyEnum] = [.AED, .GEL, .TRY, .THB, .LKR, .KZT, .AMD, .ILS, .VND, .MNT, .KGS, .BYN]
  static let other: [CurrencyEnum] = [
    .CNY, .KHR, .BGN, .AZN, .LAK, .INR, .KRW,
    .GBP, .CHF, .JPY, .PLN, .SEK, .UAH,
    .BTC
  ]
}

#Preview {
  @Previewable @State var currency: CurrencyEnum = .USD

  CurrencyField(value: $currency)
}

