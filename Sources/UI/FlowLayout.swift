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

@available(iOS 27.0, macOS 27.0, *)
extension ReorderDifference where CollectionID == ReorderableSingleCollectionIdentifier {
  /// Применяет перемещение из reorderContainer(for:) к коллекции.
  /// Для контейнеров с одной коллекцией (без секций).
  public func apply<C>(to collection: inout C)
    where C: RangeReplaceableCollection,
          C.Element: Identifiable,
          C.Element.ID == ItemID
  {
    let moving = Set(sources)
    guard !moving.isEmpty else { return }

    // Один проход: убираем перемещаемые элементы, сохраняя их порядок
    var moved: [C.Element] = []
    moved.reserveCapacity(moving.count)
    collection.removeAll { element in
      guard moving.contains(element.id) else { return false }
      moved.append(element)
      return true
    }

    switch destination.position {
    case .before(let id):
      let index = collection.firstIndex { $0.id == id } ?? collection.endIndex
      collection.insert(contentsOf: moved, at: index)
    case .end:
      collection.append(contentsOf: moved)
    }
  }
}

private struct PreviewTag: Identifiable {
  let id = UUID()
  var name: String
}

#Preview {
  @Previewable @State var tags: [PreviewTag] = [
    "SwiftUI", "iOS", "Layout Protocol", "Flow", "Flexible", "Coding", "App Design", "Development", "Mobile"
  ].map { PreviewTag(name: $0) }

  NavigationStack {
    ScrollView {
      if #available(iOS 27.0, macOS 27.0, *) {
        // Долгое нажатие на тег — и его можно перетащить на новое место
        FlowLayout(spacing: 10) {
          ForEach(tags) { tag in
            Text(tag.name)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(Color.blue.opacity(0.1))
              .cornerRadius(20)
              .overlay(Capsule().stroke(Color.blue, lineWidth: 1))
          }
          .reorderable()
        }
        .reorderContainer(for: PreviewTag.self) { difference in
          withAnimation {
            difference.apply(to: &tags)
          }
        }
        .padding()
      }
    }
  }
}
