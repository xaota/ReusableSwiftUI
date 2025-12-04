//
//  Onboarding.swift
//  depositario
//
//  Created by Rinat Ibragimov on 30.11.2025.
//

import SwiftUI

public struct OnboardingPage {
  var prompt: String
  var content: () -> AnyView

  public init<V: View>(
    _ prompt: String = String(localized: "app:action:next"),
    @ViewBuilder content: @escaping () -> V
  ) {
    self.prompt = prompt
    self.content = { AnyView(content()) }
  }
}

public extension View {
  public func onboarding (
    pages: [OnboardingPage],
    action: @escaping () -> Void = {},
    storageKey: String = "app:onboarding",
  ) -> some View {
    modifier(OnboardingController(
      pages: pages,
      action: action,
      storageKey: storageKey
    ))
  }
}

private struct OnboardingController: ViewModifier {
  var pages: [OnboardingPage]
  var action: () -> Void

  @AppStorage var finished: Bool
  @State var by: Bool = false

  init(
    pages: [OnboardingPage],
    action: @escaping () -> Void = {},
    storageKey: String
  ) {
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
        Onboarding(pages: pages, action: {
          finished = true
          action()
        })
      }
      // .presentationSizing(.page.sticky(horizontal: false, vertical: true))
      .presentationDragIndicator(.visible)
      .presentationDetents([.large])
  }
}

public struct Onboarding: View {
  @Environment(\.dismiss) private var dismiss

  var pages: [OnboardingPage]
  var action: () -> Void = {}

  @State var selectedIndex: Int = 0

  public var body: some View {
    VStack {
      TabView(selection: $selectedIndex) {
        ForEach(Array(pages.enumerated()), id: \.offset) { index, tab in
          tab
            .content()
            .toolbar(.hidden, for: .tabBar)
            .tag(index)
        }
      }
      .tabViewStyle(.page)

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

  Onboarding(pages: pages)

//  let previewUserDefaults = SampleData.makeAppStorageOnboarding(onboarding: false)
//
//  Text("onboarding sheet demo")
//    .onboarding()
//    .defaultAppStorage(previewUserDefaults)
}

