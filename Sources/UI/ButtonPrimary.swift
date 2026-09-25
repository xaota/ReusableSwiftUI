//
//  ButtonPrimary.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI

public struct ButtonPrimary: View {
  var text: String
  var icon: String
  var reverse: Bool = false
  var action: () -> Void = {}

  public init(
    _ text: String,
    icon: String,
    reverse: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.text = text
    self.icon = icon
    self.reverse = reverse
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      ButtonLabel(text: text, icon: icon, reverse: reverse)
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .glassEffectIfAvailable()
    .padding(.horizontal)
  }
}

/// Общий лейбл для ButtonPrimary / ButtonSecondary:
/// иконка перед текстом или после него (reverse)
struct ButtonLabel: View {
  let text: String
  let icon: String
  let reverse: Bool

  var body: some View {
    if !reverse {
      Label(text, systemImage: icon)
        .labelStyle(.titleAndIcon)
        .frame(maxWidth: .infinity)
    } else {
      HStack {
        Text(text)
        Label(text, systemImage: icon).labelStyle(.iconOnly)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  HStack {
    ButtonPrimary("temp 1", icon: "person.crop.circle")
    ButtonPrimary("temp 2", icon: "person.crop.circle", reverse: true)
  }
}
