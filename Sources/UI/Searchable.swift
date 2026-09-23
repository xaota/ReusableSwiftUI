//
//  Searchable.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 15.04.2026.
//

import SwiftUI

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

  NavigationStack {
    List {
      Text("1")
      Text("2")
      Text("3")
    }
    .searchable(
      if: true,
      text: $queryString,
      placement: .drawer,
      prompt: "Поиск"
    ) {
        Button("complete 34") { queryString = "34" }
        Text("test 12").searchCompletion("12")
    }
  }
}
