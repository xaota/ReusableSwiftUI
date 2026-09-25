//
//  KeyboardDismissTool.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//
import SwiftUI

/// Кнопка над клавиатурой; скрытие — на стороне владельца, обычно сбросом `@FocusState` в `nil`
public struct KeyboardDismissTool: ToolbarContent {
  let caption = String(localized: "keyboard:dismiss", bundle: .module)
  let action: () -> Void

  // Public initializer so this type can be constructed from other modules
  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some ToolbarContent {
    // На visionOS панели над клавиатурой нет — кнопку не показываем
    if let placement = ToolbarItemPlacement.keyboardIfAvailable {
      ToolbarItem(placement: placement) {
        Button(action: action) {
          Label(caption, systemImage: "keyboard.chevron.compact.down")
        }
      }
    }
  }
}
