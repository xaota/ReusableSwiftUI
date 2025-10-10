//
//  SectionVStack.swift
//  birthdays
//
//  Created by Rinat Ibragimov on 25.03.2025.
//

import SwiftUI

public struct SectionVStack<Content: View>: View {
  var caption: String
  var content: () -> Content
  
  public init(caption: String, @ViewBuilder content: @escaping () -> Content) {
    self.caption = caption
    self.content = content
  }
  
  public var body: some View {
    let string = String.init(localized: String.LocalizationValue(caption))

    Section {
      VStack(alignment: .leading, content: content)
      .padding()
      .frame(maxWidth: .infinity)
    } header: {
      Text(string.uppercased())
        .font(.caption)
        .padding([.leading, .top])
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  SectionVStack(caption: "test section") {
    Text("строка 1")
    Text("строка 2")
    Text("строка 3")
  }
}
