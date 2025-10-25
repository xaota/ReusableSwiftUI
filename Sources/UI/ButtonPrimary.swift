//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI

public struct ButtonPrimary: View {
  var text: String
  var icon: String
  var action: () -> Void = {}
  var reverse: Bool = false

  public init(_ text: String, icon: String, action: @escaping () -> Void = {}, reverse: Bool = false) {
    self.text = text
    self.icon = icon
    self.action = action
    self.reverse = reverse
  }

  public var body: some View {
    Button(action: action) {
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
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.horizontal)
  }
}

#Preview {
  HStack {
    ButtonPrimary("temp 1", icon: "person.crop.circle")
    ButtonPrimary("temp 2", icon: "person.crop.circle", reverse: true)
  }
}
