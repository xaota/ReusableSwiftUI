//
//  Searchable.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 15.04.2026.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
  @ViewBuilder
  func searchable<Content: View>(
    if condition: Bool,
    text: Binding<String>,
    placement: SearchFieldPlacement = .automatic,
    prompt: String,
    @ViewBuilder content: () -> Content
  ) -> some View {
    if condition {
      self.searchable(
        text: text,
        placement: placement,
        prompt: prompt
      ) {
        content()
      }
    } else {
      self
    }
  }
}

#Preview {
  @Previewable @State var queryString: String = ""

#if os(iOS)
  let placement: SearchFieldPlacement = .navigationBarDrawer(displayMode: .automatic)
#else
  let placement: SearchFieldPlacement = .automatic
#endif

  NavigationStack {
    List {
      Text("1")
      Text("2")
      Text("3")
    }
    .searchable(
      if: true,
      text: $queryString,
      placement: placement,
      prompt: "Поиск"
    ) {
        Button("complete 34") { queryString = "34" }
        Text("test 12").searchCompletion("12")
    }
  }
}
