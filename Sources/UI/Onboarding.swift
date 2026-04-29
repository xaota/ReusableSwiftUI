//
//  Onboarding.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 30.11.2025.
//

import SwiftUI

public struct OnboardingPage {
  var prompt: String
  var content: () -> AnyView

  public init<V: View>(
    _ prompt: String = "",
    @ViewBuilder content: @escaping () -> V
  ) {
    self.prompt = prompt.isEmpty ? String(localized: "app:action:next", bundle: .module) : prompt
    self.content = { AnyView(content()) }
  }
}

public extension View {
  func onboarding (
    _ caption: String = "",
    pages: [OnboardingPage],
    action: @escaping () -> Void = {},
    storageKey: String = "app:onboarding",
  ) -> some View {
    modifier(OnboardingController(
      caption: caption,
      pages: pages,
      action: action,
      storageKey: storageKey
    ))
  }
}

private struct OnboardingController: ViewModifier {
  var caption: String = ""
  var pages: [OnboardingPage]
  var action: () -> Void

  @AppStorage var finished: Bool
  @State var by: Bool = false

  init(
    caption: String = "",
    pages: [OnboardingPage],
    action: @escaping () -> Void = {},
    storageKey: String
  ) {
    self.caption = caption
    self._finished = AppStorage(wrappedValue: false, storageKey)
    self.action = action
    self.pages = pages
  }

  func body(content: Content) -> some View {
    return content
      .onAppear {
        if !finished {
          by = true
        }
      }
      .sheet(isPresented: $by) {
        NavigationStack {
          Onboarding(caption: caption, pages: pages) {
            finished = true
            action()
          }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.fraction(0.92)])
      }
      // .presentationSizing(.page.sticky(horizontal: false, vertical: true))
  }
}

public struct Onboarding: View {
  @Environment(\.dismiss) private var dismiss

  var caption: String = ""
  var pages: [OnboardingPage]
  var action: () -> Void = {}

  @State var selectedIndex: Int = 0

  public var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(Array(pages.enumerated()), id: \.offset) { index, tab in
        tab
          .content()
          .toolbar(.hidden, for: .tabBar)
          .tag(index)
      }
    }
    .tabViewStyle(.page)
    .safeAreaInset(edge: .bottom) {
      if !pages.isEmpty {
        let prompt = pages[selectedIndex].prompt

        ButtonPrimary(prompt, icon: "chevron.right", reverse: true) {
          if selectedIndex < max(0, pages.count - 1) {
            withAnimation {
              selectedIndex += 1
            }
          } else {
            dismiss()
            action()
          }
        }
        .disabled(pages.isEmpty)
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(caption)
          .font(selectedIndex > 0 ? .callout : .title3)
          .fontWeight(.medium)
          .fontDesign(.rounded)
      }
    }
  }
}

#Preview {
  let pages: [OnboardingPage] = [
    OnboardingPage("go to next") {
      Text("page 1")
    },
    OnboardingPage {
      Text("page 2")
    },
    OnboardingPage("finish") {
      Text("page 3")
    }
  ]

  Onboarding(caption: "Onboarding", pages: pages)

//  let previewUserDefaults = SampleData.makeAppStorageOnboarding(onboarding: false)
//
//  Text("onboarding sheet demo")
//    .onboarding()
//    .defaultAppStorage(previewUserDefaults)
}

