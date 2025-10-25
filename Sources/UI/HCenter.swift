//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 21.10.2025.
//

import SwiftUI

public struct HCenter<Content: View>: View {
  @ViewBuilder private let content: () -> Content

  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    HStack {
      Spacer()
      content()
      Spacer()
    }
  }
}

#Preview {
  HCenter {
    RoundedRectangle(cornerRadius: 20)
      .fill(Color.red)
      .frame(width: 100, height: 100)
  }
}
