//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 04.01.2026.
//

import SwiftUI

public struct Bulleted<
  Data: RandomAccessCollection,
  Row: View,
  Bullet: View
>: View {
  private let data: Data
  private let spacing: CGFloat
  private let bulletWidth: CGFloat
  private let content: (Data.Element) -> Row
  private let bullet: () -> Bullet

  public init(
    data: Data,
    spacing: CGFloat = 8,
    bulletWidth: CGFloat = 18,
    @ViewBuilder content: @escaping (Data.Element) -> Row,
    @ViewBuilder bullet: @escaping () -> Bullet
  ) {
    self.data = data
    self.spacing = spacing
    self.bulletWidth = bulletWidth
    self.content = content
    self.bullet = bullet
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: spacing) {
      ForEach(Array(data.enumerated()), id: \.0) { _, element in
        HStack(alignment: .firstTextBaseline, spacing: spacing) {
          bullet()
            .frame(width: bulletWidth, alignment: .leading)

          content(element)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }
}

#Preview {
  struct Feature {
    let title: String
    let highlight: String
  }

  var features: [Feature] = [
    Feature(title: "Добавляйте ", highlight: "вклады"),
    Feature(title: "Указывайте ", highlight: "цели"),
  ]

  return Bulleted(data: features) { f in
    let markdown = f.title + "**" + f.highlight + "**"
    if var attributed = try? AttributedString(markdown: markdown) {
      Text(attributed)
    } else {
      Text("\(f.title)\(f.highlight)")
    }
  } bullet: {
    Image(systemName: "checkmark")
      .foregroundColor(.green)
  }
}
