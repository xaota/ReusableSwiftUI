//
//  CurrencyMenuItem.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 05.11.2025.
//

import SwiftUI

struct CurrencyMenuItem: View {
  var label: String
  var flag: String
  var icon: String
  var action: () -> Void = {}

  init(currency: CurrencyEnum, action: @escaping () -> Void = {}) {
    self.action = action
    let json: CurrencyJSON? = CurrencyStore.json.by(currency)

    self.flag = json?.flag ?? ""
    self.icon = json?.icon.map { $0 + "sign" } ?? ""

    if let sign = json?.sign, !flag.isEmpty {
      self.label = "\(currency.rawValue), \(sign)"
    } else {
      self.label = currency.rawValue
    }
  }

  var body: some View {
    Button(action: action) {
      Text(label)
      if flag.isEmpty {
        Image(systemName: icon)
      } else {
        flag.image()
      }
    }
  }
}

#Preview {
  CurrencyMenuItem(currency: .USD)
}

extension String {
  func image(pointSize: CGFloat = 24, backgroundColor: Color = .clear) -> Image {
    #if swift(>=5.9)
    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
      // Ensure all ImageRenderer interactions happen on the main actor
      return MainActor.assumeIsolated {
        let view = Text(self)
          .font(.system(size: pointSize))
          .padding(0)
          .background(backgroundColor)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 1

        #if canImport(UIKit)
        if let uiImage = renderer.uiImage {
          return Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = renderer.nsImage {
          return Image(nsImage: nsImage)
        }
        #endif

        return Image(systemName: "rectangle")
      }
    }
    #endif

    return Image(systemName: "rectangle")
  }
}
