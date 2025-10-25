//
//  SwiftUIView.swift
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

  @FocusState private var isFocused: Bool

  public init(
    _ prompt: String,
    value: Binding<Decimal>
  ) {
    self.prompt = prompt // NSLocalizedString(prompt, comment: "")
    self._value = value
  }

  public var body: some View {
    HCenter {
      HStack(alignment: .center) {
        TextField(prompt, value: $value, format: .number.scale(100))
          .keyboardType(.decimalPad)
          .fixedSize(horizontal: true, vertical: false)
          .font(.system(size: 36, weight: .light, design: .rounded))
          .foregroundColor(Color.primary)
          .multilineTextAlignment(.trailing)
          .accentColor(Color.accentColor)
          .submitLabel(.done)
          .focused($isFocused)
          .overlay(
            Divider()
              .frame(maxWidth: .infinity, maxHeight: 3)
              .background(isFocused ? Color.accentColor : Color.secondary.opacity(0.2)),
            alignment: .bottom
          )

        Text("%").scaleEffect(1.8).padding(.leading)
      }
    }
  }
}

#Preview {
  @Previewable @State var percent: Decimal = 0.05

  PercentField(
    "10",
    value: $percent
  )
}
