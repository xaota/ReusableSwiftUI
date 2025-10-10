  //
  //  IconSquare.swift
  //  birthdays
  //
  //  Created by Rinat Ibragimov on 17.03.2025.
  //

import SwiftUI

public struct IconSquare: View {
  @Environment(\.self) var environment

  let foreground = Color.primary // Color(uiColor: UIColor.label)
  let accent = Color.accentColor //  Color(uiColor: UIColor.link)

  let background: Color
  let selected: Bool
    //  let image: Image? = nil
  var icon: String? = nil
  var text: String? = nil
  var size: CGFloat = 24

  public init(_ icon: String, selected: Bool = false, background: Color = Color.clear, size: CGFloat = 24) {
    self.icon = icon
      //    self.image =
    self.background = background
    self.selected = selected
    self.size = size
  }

  public init(text: String, selected: Bool = false, background: Color = Color.clear, size: CGFloat = 24) {
      //    self.image = Image(text)
    self.text = text
    self.background = background
    self.selected = selected
    self.size = size
  }

  var color: Color {
    if !selected { return foreground }
    return background.contrastRatio(against: .white, environment: environment) > 2 ? .white : .black
  }

  @ViewBuilder func backgroundWithColor(color: Color) -> some View {
    if color == .clear {
      background(.ultraThinMaterial)
    } else {
      background(color)
    }
  }

  public var body: some View {
    if self.icon != nil {
      Image(systemName: icon!)
        .frame(width: self.size, height: self.size)
        .padding()
        .foregroundColor(color)
        .backgroundWithColor(color: selected ? (background == .clear ? accent : background) : .clear)
        .clipShape(Circle())
    } else {
      Text(text!).font(.title3)
        .frame(width: self.size, height: self.size)
        .padding()
        .foregroundColor(color)
        .backgroundWithColor(color: selected ? (background == .clear ? accent : background) : .clear)
        .clipShape(Circle())
    }
  }
}

private extension View {
  @ViewBuilder func backgroundWithColor(color: Color) -> some View {
    if color == .clear {
      background(.ultraThinMaterial)
      } else {
        background(color)
        }
    }
}


#Preview {
  IconSquare("arrow.up.right", selected: true, background: Color.cyan)
}

