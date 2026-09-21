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
    ToolbarItem(placement: .keyboard) {
      Button(action: action) {
        Label(caption, systemImage: "keyboard.chevron.compact.down")
      }
    }
  }
}
