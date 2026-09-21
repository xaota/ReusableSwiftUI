  //
  //  BankIconSquare.swift
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

  /// Первые буквы первых двух слов названия — для банков без иконки
  static func letter(_ value: String) -> String {
    return value
      .replacingOccurrences(
        of: BankStore.separatorsPattern,
        with: " ",
        options: .regularExpression
      )
      .split(separator: " ")
      .prefix(2)
      .compactMap { $0.first.map(String.init) }
      .joined()
      .uppercased()
  }

  static func color(_ value: String) -> Color {
    let index = abs(strHash(value) % colors.count)
    return Color(hex: colors[index])
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
  let size: CGFloat = 64
  let columns = Array(repeating: GridItem(.fixed(size + 96)), count: 3)

  ScrollView {
    LazyVGrid(columns: columns) {
      ForEach(banks, id: \.code) { bank in
        VStack {
          BankIconSquare(bank: bank.code, size: size)
          Text(bank.caption).font(.caption)
        }
        .padding()
      }
    }
  }
}
