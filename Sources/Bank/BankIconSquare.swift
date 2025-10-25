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

  public init(bank: String) {
    self.bank = bank
  }

  public var body: some View {
    if BankIcon.has(bank) {
      BankIcon(bank: bank)
        .frame(width: 24, height: 24)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Circle())
    } else {
      let color = BankIconSquare.color(bank)
      let letter = BankIconSquare.letter(bank)

      IconSquare(text: letter, selected: true, background: color)
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
  VStack {
    BankIconSquare(bank: "sberbank")
    BankIconSquare(bank: "sbr bgank")
    BankIconSquare(bank: "sbrank")
    BankIconSquare(bank: "alfa-bank")
    BankIconSquare(bank: "revolut")
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
