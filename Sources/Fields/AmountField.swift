//
//  AmountField.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI
import Intl
import UI

public struct AmountField: View {
  @Binding var value: Decimal
  @Binding var currency: CurrencyEnum
  var prompt: String

  @State private var internalValue: Decimal? = nil

//  @FocusState private var isFocused: Bool

  public init(
    _ prompt: String,
    value: Binding<Decimal>,
    currency: Binding<CurrencyEnum>
  ) {
    self.prompt = prompt
    self._value = value
    self._currency = currency

    let initial = value.wrappedValue
    if initial != 0 {
      self._internalValue = State(initialValue: initial)
    }
  }

  public var body: some View {
//    let sign: String = CurrencyStore.json.by(currency)?.sign ?? ""

    HCenter {
      HStack(alignment: .center) {
        TextField(prompt, value: $internalValue, format: .currency(code: "").precision(.fractionLength(2)))
          .fieldPrimary(alignment: .trailing)
          // .focused($isFocused)
#if os(iOS)
          .keyboardType(.decimalPad)
          .submitLabel(.done)
#endif
//          .keyboardType(.decimalPad)
          .onChange(of: internalValue) {
            value = internalValue ?? 0
          }

        CurrencyField(value: $currency)
          .font(.system(size: 36, weight: .light, design: .rounded))
          .imageScale(.small)
          .padding(.leading, 4)
      }
    }
  }
}

#Preview {
  @Previewable @State var amount: Decimal = 0.0
//  @Previewable @State var amount2: Decimal = 10.0
  @Previewable @State var currency: CurrencyEnum = .RUB
//  @Previewable @State var currency2: CurrencyEnum = .RUB

//  VStack {
    AmountField(
      "0,00",
      value: $amount,
      currency: $currency
    )

//    AmountField(
//      "0,00",
//      value: $amount2,
//      currency: $currency2
//    )
//  }
}
