//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI
import Intl
import UI

public struct AmountField: View {
  @Binding var value: Decimal
  var currency: CurrencyEnum
  let currencyChange: (() -> Void)?
  var prompt: String

  @FocusState private var isFocused: Bool

  public init(
    _ prompt: String,
    value: Binding<Decimal>,
    currency: CurrencyEnum,
    currencyChange: (() -> Void)? = nil
  ) {
    self.prompt = prompt
    self._value = value
    self.currency = currency
    self.currencyChange = currencyChange
  }

  public var body: some View {
    let sign: String = CurrencyStore.json.by(currency)?.sign ?? ""

    HCenter {
      HStack(alignment: .center) {
        TextField(prompt, value: $value, format: .number)
          .fieldPrimary(alignment: .trailing)
          .keyboardType(.decimalPad)
          .submitLabel(.done)

      if currencyChange == nil {
        Text(sign).scaleEffect(1.8).padding(.leading)
      } else {
        Button { currencyChange!() } label: {
          HStack (alignment: .bottom) {
              //              Image(systemName: currency.image).scaleEffect(1.5)
            Text(sign).scaleEffect(1.8)
            Image(systemName: "chevron.up.chevron.down").foregroundColor(Color.accentColor)
          }
        }
        .padding(.leading)
      }

      }
    }
  }
}

#Preview {
  @Previewable @State var amount: Decimal = 2025.10

  AmountField(
    "0,00",
    value: $amount,
    currency: .RUB //,
    //      currencyChange: {}
  )
}


  //        TextField(prompt, text: $state)
  //          .onChange(of: state) { newValue in
  //            let allowedCharacters = "0123456789.,"
  //            let filtered = newValue.filter { allowedCharacters.contains($0) } .replacing(/\,/, with: ".")
  //            value = Decimal(string: filtered) ?? 0
  //          }
  //                  TextField(
  //                    prompt,
  //                    value: $value,
  //                    format: .currency(code: "").locale(Locale.current).precision(.fractionLength(2)), // (identifier: "en_US")
  ////                    prompt: Text(prompt)
  //                  )
  //                  .background(Color.red)
