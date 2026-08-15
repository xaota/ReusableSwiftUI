//
//  KeyboardDismissTool.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//
import SwiftUI
#if os(iOS)
import UIKit
#endif

public struct KeyboardDismissTool: ToolbarContent {
  let caption = String(localized: "keyboard:dismiss", bundle: .module)
  // let keyboardHide = NSLocalizedString("keyboard:hide", tableName: "Application", comment: "Keyboard hide")

  // Public initializer so this type can be constructed from other modules
  public init() {}

  public var body: some ToolbarContent {
    ToolbarItem(placement: .keyboard) {
      Button(action: keyboardDismiss) {
        Label(caption, systemImage: "keyboard.chevron.compact.down")
      }
    }
  }
}

public func keyboardDismiss() {
#if os(iOS)
  UIApplication.shared.sendAction(
    #selector(UIResponder.resignFirstResponder),
    to: nil,
    from: nil,
    for: nil
  )
#endif
}
