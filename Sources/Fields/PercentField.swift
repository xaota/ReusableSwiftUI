//
//  PercentField.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI
import Intl
import UI

public struct PercentField: View {
  @Binding var value: Decimal
  var prompt: String

//  @FocusState private var isFocused: Bool

  @State private var internalValue: Decimal? = nil

  public init(
    _ prompt: String,
    value: Binding<Decimal>
  ) {
    self.prompt = prompt // NSLocalizedString(prompt, comment: "")
    self._value = value
    let initial = value.wrappedValue
    if initial != 0 {
      self._internalValue = State(initialValue: initial)
    }
  }

  public var body: some View {
    HCenter {
      HStack(alignment: .center) {
        TextField(prompt, value: $internalValue, format: .number.scale(100).precision(.fractionLength(0...2)))
          .fieldPrimary(alignment: .trailing)
          // .focused($isFocused)
#if os(iOS)
          .keyboardType(.decimalPad)
          .submitLabel(.done)
#endif
          .onChange(of: internalValue) {
            value = internalValue ?? 0
          }

        Text("%").scaleEffect(1.8).padding(.leading)
      }
    }
  }

  private let quantityFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .percent
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.zeroSymbol = ""
    formatter.percentSymbol = ""
    return formatter
  }()
}

#Preview {
  @Previewable @State var percent1: Decimal = 0.0
  @Previewable @State var percent2: Decimal = 0.1

  VStack(spacing: 20) {
    PercentField("0,00", value: $percent1)
    PercentField("0,00", value: $percent2)
  }
}
