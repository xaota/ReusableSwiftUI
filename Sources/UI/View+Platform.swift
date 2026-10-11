//
//  View+Platform.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.09.2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// Платформенные различия iOS / macOS / visionOS в одном месте, чтобы экраны не обрастали #if.
// Здесь только API, которых на macOS или visionOS действительно нет (проверено компилятором),
// и API iOS/macOS 27, у которых на 26 нет замены — там обёртка ничего не делает.

extension View {
  /// Прячет таб-бар на экранах деталей (на macOS таб-бара нет — ничего не делает)
  public func hiddenTabBar() -> some View {
    #if os(iOS)
    return toolbar(.hidden, for: .tabBar)
    #else
    return self
    #endif
  }

  /// Компактный заголовок в навбаре (на macOS заголовок и так в тулбаре окна)
  public func inlineNavigationTitle() -> some View {
    #if os(iOS)
    return navigationBarTitleDisplayMode(.inline)
    #else
    return self
    #endif
  }

  /// Секция списка без горизонтальных отступов (на macOS отступы секций не настраиваются)
  public func noHorizontalSectionMargins() -> some View {
    #if os(iOS)
    return listSectionMargins(.horizontal, 0)
    #else
    return self
    #endif
  }

  /// Секция вплотную: без горизонтальных отступов и без интервала до соседних секций (только iOS)
  public func edgeToEdgeSection() -> some View {
    #if os(iOS)
    return listSectionSpacing(0).listSectionMargins(.horizontal, 0)
    #else
    return self
    #endif
  }

  /// Сворачивать навбар при скролле вниз (только iOS 27; на iOS 26 навбар не сворачивается)
  @ViewBuilder
  public func minimizesNavigationBarOnScroll() -> some View {
    #if os(iOS)
    if #available(iOS 27, *) {
      toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
    } else {
      self
    }
    #else
    self
    #endif
  }

  /// Liquid Glass под контентом (на visionOS glassEffect нет — стекло там системное, ничего не делает)
  public func glassEffectIfAvailable() -> some View {
    #if os(iOS) || os(macOS)
    return glassEffect()
    #else
    return self
    #endif
  }

  /// Кнопка в стиле Liquid Glass (на visionOS стиля .glass нет — обычная bordered-кнопка)
  public func glassButtonStyle() -> some View {
    #if os(iOS) || os(macOS)
    return buttonStyle(.glass)
    #else
    return buttonStyle(.bordered)
    #endif
  }
}

extension ToolbarContent {
  /// Элемент тулбара уходит в overflow-меню последним (приоритеты .high/.low — с iOS и macOS 27;
  /// на 26 и на visionOS ничего не делает)
  @ToolbarContentBuilder
  public func highVisibilityPriority() -> some ToolbarContent {
    #if os(iOS) || os(macOS)
    if #available(iOS 27, macOS 27, *) {
      visibilityPriority(.high)
    } else {
      self
    }
    #else
    self
    #endif
  }
}

extension ToolbarItemPlacement {
  /// Панель над клавиатурой (на visionOS клавиатура в отдельном окне и панели над ней нет — nil)
  public static var keyboardIfAvailable: ToolbarItemPlacement? {
    #if os(iOS) || os(macOS)
    return .keyboard
    #else
    return nil
    #endif
  }
}

extension SearchFieldPlacement {
  /// Поиск всегда виден: под навбаром на iOS, в тулбаре окна на macOS
  public static var alwaysVisible: SearchFieldPlacement {
    #if os(iOS)
    return .navigationBarDrawer(displayMode: .always)
    #else
    return .toolbar
    #endif
  }

  /// Поиск под навбаром на iOS (показывается при скролле), на macOS — как решит система
  public static var drawer: SearchFieldPlacement {
    #if os(iOS)
    return .navigationBarDrawer(displayMode: .automatic)
    #else
    return .automatic
    #endif
  }
}

extension Color {
  /// Фон сгруппированного списка (на macOS у List нет отдельного grouped-фона)
  public static var groupedBackground: Color {
    #if os(iOS)
    return Color(UIColor.systemGroupedBackground)
    #else
    return .clear
    #endif
  }
}
