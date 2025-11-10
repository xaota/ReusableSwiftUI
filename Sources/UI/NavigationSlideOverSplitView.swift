//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 09.11.2025.
//

import SwiftUI

public struct NavigationSlideOverSplitView<Content: View, DetailsContent: View, SlideOverContent: View>: View {
  @Binding var allowSlideOver: Bool

  @ViewBuilder var content: () -> Content
  @ViewBuilder var details: () -> DetailsContent
  @ViewBuilder var slideOver: () -> SlideOverContent

  @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn // .all
  @State private var preferredColumn: NavigationSplitViewColumn = .content

  // Public initializer so this can be constructed from other modules
  public init(
    allowSlideOver: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content,
    @ViewBuilder details: @escaping () -> DetailsContent,
    @ViewBuilder slideOver: @escaping () -> SlideOverContent
  ) {
    self._allowSlideOver = allowSlideOver
    self.content = content
    self.details = details
    self.slideOver = slideOver
  }

  public var body: some View {
    if !allowSlideOver {
      NavigationSplitView(columnVisibility: $columnVisibility) {
        content()
          // #if os(macOS)
          // .navigationSplitViewColumnWidth(min: 180, ideal: 200)
          // #endif
          .toolbar(removing: .sidebarToggle)
          .toolbar {
            ToolbarItem(placement: .bottomBar) {
              Button(action: { allowSlideOver = true }) {
                Label("app:filters:show", systemImage: "magnifyingglass.circle.fill")
              }
            }
          }
      } detail: {
        details()
      }
    } else {
      NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: $preferredColumn) {
        List {
          slideOver()

          Button(action: {
            preferredColumn = .content
            columnVisibility = .doubleColumn
          }) {
            Label("app:filters:apply", systemImage: "magnifyingglass")
          }
        }
        .toolbar(removing: .sidebarToggle)
      } content: {
        content()
          .listStyle(.sidebar)
          // #if os(macOS)
          // .navigationSplitViewColumnWidth(min: 180, ideal: 200)
          // #endif
          .navigationBarBackButtonHidden(true)
          .toolbar {
            ToolbarItem(placement: .bottomBar) {
              Button(action: { allowSlideOver = false }) {
                Label("app:filters:hide", systemImage: "magnifyingglass.circle")
              }
            }

            ToolbarItem(placement: .cancellationAction) {
              Button(action: {
                preferredColumn = .sidebar
                columnVisibility = .all
              }) {
                Label("app:filters:hide", systemImage: "text.page.badge.magnifyingglass")
              }
            }
          }
      } detail: {
        details()
      }
    }
  }
}

#Preview {
  @Previewable @State var allowSlideOver: Bool = true

  NavigationSlideOverSplitView(allowSlideOver: $allowSlideOver) {
    Text("Root Content")
  } details: {
    Text("Details Content")
  } slideOver: {
    Text("SlideOver Content")
  }
}

