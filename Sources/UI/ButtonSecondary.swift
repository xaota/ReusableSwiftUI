
  //
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI

public struct ButtonSecondary: View {
  var text: String
  var icon: String
  var reverse: Bool = false
  var action: () -> Void = {}
  
//  var style: ButtonStyle = .borderedProminent

  public init(
    _ text: String,
    icon: String,
    reverse: Bool = false,
    action: @escaping () -> Void = {}
  ) {
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
          .foregroundStyle(.link)
          .frame(maxWidth: .infinity)
      } else {
        HStack {
          Text(text)
            .foregroundStyle(.link)

          Label(text, systemImage: icon)
            .labelStyle(.iconOnly)
            .foregroundStyle(.link)
        }
        .frame(maxWidth: .infinity)
      }
    }
    .controlSize(.large)
//    .buttonStyle(.bordered)
    .buttonStyle(.glass)
//    .glassEffect()
//    .padding(.horizontal)
  }
}

#Preview {
  HStack {
    ButtonSecondary("temp 1", icon: "person.crop.circle")
    ButtonSecondary("temp 2", icon: "person.crop.circle", reverse: true)
  }
}
