//
//  WeatherIcon.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.04.2026.
//

import SwiftUI

public struct WeatherIcon: View {
  var icon: String?

  public init(icon: String?) {
    self.icon = icon
  }

  public var body: some View {
    if let icon {
      Image(systemName: icon)
        .font(.system(size: 48))
        .symbolRenderingMode(.multicolor)
    } else {
      EmptyView()
    }
  }
}

#Preview {
  WeatherIcon(icon: "moon")
}
