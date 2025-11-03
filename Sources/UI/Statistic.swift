//
//  Statistic.swift
//  Reusable -> UI
//
//  Created by Rinat Ibragimov on 01.11.2025.
//

import SwiftUI

public struct Statistic<Content: View>: View {
  private let label: String

  private let spacing: CGFloat

  private let cornerRadius: CGFloat

  @ViewBuilder private let content: () -> Content

  public init(
    _ label: String,
    spacing: CGFloat = 8,
    cornerRadius: CGFloat = 12,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.label = label
    self.spacing = spacing
    self.cornerRadius = cornerRadius
    self.content = content
  }

  public var body: some View {
    VStack(spacing: spacing) {
      content()
      Text(label)
    }
    .fixedSize()
    .padding()
    .background(Material.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
  }
}

#Preview {
  Statistic("label") {
    Text("value")
  }
}
