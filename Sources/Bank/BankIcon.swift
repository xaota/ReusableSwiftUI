//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//

import SwiftDraw
import SwiftUI
import UI

public struct BankIcon: View {
  var bank: String

  public init(bank: String) {
    self.bank = bank
  }

  public var body: some View {
    if let uiImage = BankIcon.image(bank) {
      Image(uiImage: uiImage).resizable().scaledToFit()
    }
  }

  public static func path(_ bank: String) -> String {
    let code = bank
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(
        of: "[\\s+\\-\\|\\.\\,–—/\\\\&\\$\\(\\)\\[\\]\\{\\}]+",
        with: "",
        options: .regularExpression
      )
      .lowercased()

    return "svg/" + code + ".svg"
  }

  public static func has(_ bank: String) -> Bool {
    let path = BankIcon.path(bank)
    return Bundle.module.url(forResource: path, withExtension: nil) != nil
  }

  public static func image(_ bank: String) -> UIImage? {
    let path = BankIcon.path(bank)
    return UIImage(svgNamed: path, in: .module)
  }

}

#Preview {
  VStack {
    BankIcon(bank: "sberbank")
    BankIcon(bank: "sbr bgank")
    BankIcon(bank: "sbrank")
    BankIcon(bank: "alfa-bank")
    BankIcon(bank: "revolut")
  }
}
