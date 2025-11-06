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
  }

  public var body: some View {
    let sign: String = CurrencyStore.json.by(currency)?.sign ?? ""

    HCenter {
      HStack(alignment: .center) {
        TextField(prompt, value: $internalValue, format: .currency(code: "").precision(.fractionLength(2)))
          .fieldPrimary(alignment: .trailing)
          // .focused($isFocused)
          .keyboardType(.decimalPad)
          .submitLabel(.done)
          .onChange(of: internalValue) { newValue in
            value = newValue ?? 0
          }

        CurrencyField(value: $currency)
          .font(.system(size: 36, weight: .light, design: .rounded))
          .imageScale(.small)
          .padding(.leading, 4)

//      if currencyChange == nil {
//        Text(sign).scaleEffect(1.8).padding(.leading)
//      } else {
//        Button { currencyChange!() } label: {
//          HStack (alignment: .bottom) {
//              //              Image(systemName: currency.image).scaleEffect(1.5)
//            Text(sign).scaleEffect(1.8)
//            Image(systemName: "chevron.up.chevron.down").foregroundColor(Color.accentColor)
//          }
//        }
//        .padding(.leading)
//      }

      }
    }
  }
}

#Preview {
  @Previewable @State var amount: Decimal = 0.0
  @Previewable @State var currency: CurrencyEnum = .RUB

  AmountField(
    "0,00",
    value: $amount,
    currency: $currency //,
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
