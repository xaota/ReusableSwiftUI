//
//  BankIcon.swift
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
    if let svg = BankIcon.svg(bank) {
      let monotone = BankStore.get(bank)?.monotone ?? false
      SVGView(svg: svg)
        .renderingMode(monotone ? .template : .original)
        .resizable()
        .scaledToFit()
//        .shadow(color: .white, radius: 2)
//        .shadow(color: .gray, radius: 2, x: 0, y: 0)
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

  public static func svg(_ bank: String) -> SVG? {
    SVG(named: BankIcon.path(bank), in: .module)
  }

}

#Preview {
  let banks: [BankJSON] = BankStore.json.bankJSON
  let cols: Int = 3
  let size: CGFloat = 96
  let rows: Int = Int(ceil(Double(banks.count) / Double(cols)))

  ScrollView {
    Grid() {
      ForEach(0..<rows) { row in
        GridRow {
          ForEach(0..<cols) { col in
            let index = row * cols + col
            if index < banks.count {
              let bank = banks[index]

              VStack {
                BankIcon(bank: bank.code)
                  .frame(width: size, height: size)
                Text("\(index + 1) " + bank.caption).font(.caption)
              }
              .padding()
            } else {
              EmptyView()
            }
          }
        }
      }
    }

  }
}
