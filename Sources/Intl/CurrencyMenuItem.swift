//
//  CurrencyMenuItem.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 05.11.2025.
//

import UIKit
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
        Image(uiImage: flag.image())
      }
    }
  }
}

#Preview {
  CurrencyMenuItem(currency: .USD)
}

extension String {
  func image(pointSize: CGFloat = 24, backgroundColor: UIColor = .clear) -> UIImage {
    let font = UIFont.systemFont(ofSize: pointSize)
    let emojiSize = self.size(withAttributes: [.font: font])

    return UIGraphicsImageRenderer(size: emojiSize).image { context in
      backgroundColor.setFill()
      context.fill(CGRect(origin: .zero, size: emojiSize))
      self.draw(at: .zero, withAttributes: [.font: font])
    }
  }
}
