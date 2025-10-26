//
//  FieldPrimary.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 26.10.2025.
//

import SwiftUI

extension View {
  public func fieldPrimary(alignment: TextAlignment = .leading) -> some View {
    modifier(FieldPrimaryModifier(alignment: alignment))
  }
}

struct FieldPrimaryModifier: ViewModifier {
  @FocusState private var isFocused: Bool

  var alignment: TextAlignment = .leading

  public init(alignment: TextAlignment = .leading) {
    self.alignment = alignment
  }

  public func body (content: Content) -> some View {
    content
      .fixedSize(horizontal: true, vertical: false)
      .font(.system(size: 36, weight: .light, design: .rounded))
      .foregroundColor(Color.primary)
      .accentColor(Color.accentColor)
      .focused($isFocused)
      .multilineTextAlignment(alignment)
//      .submitLabel(.done)
//      .keyboardType(.decimalPad)
      .overlay(
        Divider()
          .frame(maxWidth: .infinity, maxHeight: 3)
          .background(isFocused ? Color.accentColor : Color.secondary.opacity(0.2)),
        alignment: .bottom
      )
  }
}

#Preview {
  // Local types and preview state should be declared, then return a View expression.
//  enum FocusedField {
//    case textField
//  }

  @Previewable @State var text: String = ""
//  @Previewable @FocusState var isFocused: FocusedField?

  TextField("Hello, world!", text: $text)
//    .focused($isFocused, equals: .textField)
    .fieldPrimary(alignment: .trailing)
}
