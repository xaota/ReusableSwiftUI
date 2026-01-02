//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 22.11.2025.
//

import SwiftUI

public struct WizzardPage {
  public var forward: String
  public var backward: String
  public var content: () -> AnyView
  public var complete: () -> Bool

  public init<V: View>(
    forward: String = String(localized: "app:action:next"),
    backward: String = String(localized: "app:action:back"),
    @ViewBuilder content: @escaping () -> V,
    complete: @escaping () -> Bool = { true }
  ) {
    self.forward = forward
    self.backward = backward
    self.content = { AnyView(content()) }
    self.complete = complete
  }
}

public struct Wizzard: View {
  @Environment(\.dismiss) private var dismiss

  public var pages: [WizzardPage]
  @State public var selectedIndex: Int = 0

  public var finish: () -> Void = {}
  public var cancel: () -> Void = {}

  public init(
    pages: [WizzardPage],
    selectedIndex: Int = 0,
    finish: @escaping () -> Void = {},
    cancel: @escaping () -> Void = {}
  ) {
    self.pages = pages
    self._selectedIndex = State(initialValue: selectedIndex)
    self.finish = finish
    self.cancel = cancel
  }

  public init(
    pages: [WizzardPage],
    selectedIndex: Int = 0,
    finish: @escaping () -> Void
  ) {
    self.pages = pages
    self._selectedIndex = State(initialValue: selectedIndex)
    self.finish = finish
    self.cancel = {}
  }

  public var body: some View {
    if let page = pages.indices.contains(selectedIndex)
      ? pages[selectedIndex]
      : nil
    {
      page
        .content()
        .padding(.bottom)
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .bottom, spacing: 0) {
          VStack {
            ButtonPrimary(page.forward, icon: "chevron.right", reverse: true) {
              if selectedIndex < pages.count - 1 {
                withAnimation {
                  selectedIndex += 1
                }
              } else {
                dismiss()
                finish()
              }
            }
            .disabled(!page.complete())
            .padding(.top, 12)

            Button(action: {
              if selectedIndex > 0 {
                withAnimation {
                  selectedIndex -= 1
                }
              } else {
                dismiss()
                cancel()
              }
            }) {
              Label(
                page.backward,
                systemImage: selectedIndex == 0
                  ? "arrow.turn.right.down"
                  : "arrow.uturn.left"
              ).font(.subheadline)
            }
            .foregroundColor(.secondary)
            .padding(.top)
          }
        }
    } else {
      EmptyView()
    }
  }
}

#Preview {
  let pages: [WizzardPage] = [
    .init(forward: "go to next") {
      Text("page 1")
    } complete: { false },
    WizzardPage {
      Text("page 2")
    },
    WizzardPage(forward: "finish") {
      Text("page 3")
    }
  ]

  Wizzard(pages: pages)
}

