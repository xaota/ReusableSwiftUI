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

    let flag: String = json?.flag != nil ? json!.flag! : ""
    let icon: String = json?.icon != nil ? json!.icon! + "sign" : ""
    // let sign: String = json?.sign != nil ? json!.sign! : ""

    if !flag.isEmpty {
//      self.image = Image(uiImage: flag.image(pointSize: 20))
      self.label = String(describing: currency) + (json?.sign != nil ? ", \(json!.sign!)" : "")
    } else {
//      self.image = Image(systemName: icon)
      self.label = String(describing: currency)
    }

    self.flag = flag
    self.icon = icon
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
