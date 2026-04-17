//
//  Chip.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 16.04.2026.
//

import SwiftUI

public struct Chip: View {
  var label: String
  var icon: String
  var color: Color
  var selected: Bool
  var action: () -> Void = {}

  public init(
    _ label: String,
    icon: String = "",
    color: Color = Color.accentColor,
    selected: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.label = label
    self.icon = icon
    self.color = color
    self.selected = selected
    self.action = action
  }

  var stroke: Color { color }
  var fill: Color { color.opacity(0.1) }

  public var body: some View {
    HStack {
      if !icon.isEmpty {
        Label(label, systemImage: icon).labelStyle(.iconOnly)
      }
      Text(label)
    }
    .font(.subheadline)
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background {
      Capsule()
        .fill(fill)
        .stroke(stroke, lineWidth: selected ? 1 : 0)
    }
    .onTapGesture(perform: action)
  }
}

#Preview {
  Chip("test", icon: "plus", color: Color.red)
}
