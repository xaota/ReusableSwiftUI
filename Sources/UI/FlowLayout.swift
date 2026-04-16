//
//  FlowLayout.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 16.04.2026.
//

import SwiftUI

public struct FlowLayout: Layout {
  public var spacing: CGFloat = 8

  public init(spacing: CGFloat = 8) {
    self.spacing = spacing
  }

    // Определяем размер контейнера на основе размеров всех вложенных вью
  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let width = proposal.replacingUnspecifiedDimensions().width
    var height: CGFloat = 0
    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var rowHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(.unspecified)

        // Перенос на новую строку
      if currentX + size.width > width {
        currentY += rowHeight + spacing
        currentX = 0
        rowHeight = 0
      }

      rowHeight = max(rowHeight, size.height)
      currentX += size.width + spacing
    }

    return CGSize(width: width, height: currentY + rowHeight)
  }

    // Размещаем каждое вью в сетке
  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    var currentX: CGFloat = bounds.minX
    var currentY: CGFloat = bounds.minY
    var rowHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(.unspecified)

      if currentX + size.width > bounds.maxX {
        currentY += rowHeight + spacing
        currentX = bounds.minX
        rowHeight = 0
      }

      view.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)

      rowHeight = max(rowHeight, size.height)
      currentX += size.width + spacing
    }
  }
}

#Preview {
  let tags = ["SwiftUI", "iOS", "Layout Protocol", "Flow", "Flexible", "Coding", "App Design", "Development", "Mobile"]

  NavigationStack {
    ScrollView {
      FlowLayout(spacing: 10) {
        ForEach(tags, id: \.self) { tag in
          Text(tag)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(20)
            .overlay(Capsule().stroke(Color.blue, lineWidth: 1))
        }
      }
      .padding()
    }
  }
}
