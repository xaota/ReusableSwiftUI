  //
  //  SwiftUIView.swift
  //  Reusable -> Bank
  //
  //  Created by Rinat Ibragimov on 23.10.2025.
  //

import SwiftUI
import UI

public struct BankIconSquare: View {
  var bank: String
  var size: CGFloat = 24

  public init(bank: String, size: CGFloat = 24) {
    self.bank = bank
    self.size = size
  }

  public var body: some View {
    if BankIcon.has(bank) {
      BankIcon(bank: bank)
        .frame(width: size, height: size)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Circle())
    } else {
      let color = BankIconSquare.color(bank)
      let letter = BankIconSquare.letter(bank)

      IconSquare(text: letter, selected: true, background: color, size: size)
    }
  }

  static func letter(_ value: String) -> String {
    return value
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(
        of: "[\\s\\-\\|\\.\\,–—/\\\\&\\$\\(\\)\\[\\]\\{\\}]+",
        with: " ",
        options: .regularExpression
      )
      .split(separator: " ")
      .prefix(2)
      .map { String($0.first ?? Character("")) }
      .joined()
      .uppercased()
  }

  static func color(_ value: String) -> Color {
    let id = BankIconSquare.strHash(value)
    let count = colors.count

    if id >= 0 && id < count {
      return Color(hex: BankIconSquare.colors[id])
    }

    let colorIndex = abs(id % count)
    return Color(hex: BankIconSquare.colors[colorIndex])
  }

  private static let colors: [Int] = [
    0xEB4F60,
    0xFF9157,
    0x997AE8,
    0x50C541,
    0x3DC2C1,
    0x409ADB,
    0xFC55A0,
  ]

  private static func strHash(_ str: String) -> Int {
    let unicodeScalars = str.unicodeScalars.map { $0.value }
    return unicodeScalars.reduce(5381) {
      ($0 << 5) &+ $0 &+ Int($1)
    }
  }
}

#Preview {
  let banks: [BankJSON] = BankStore.json.bankJSON
  let cols: Int = 3
  let size: CGFloat = 64
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
                BankIconSquare(bank: bank.code, size: size)
                Text(bank.caption).font(.caption)
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

extension Color {
  init(hex: Int, opacity: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 08) & 0xff) / 255,
      blue: Double((hex >> 00) & 0xff) / 255,
      opacity: opacity
    )
  }
}
