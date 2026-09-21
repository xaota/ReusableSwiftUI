//
//  ColorTests.swift
//  Reusable
//

import SwiftUI
import Testing
@testable import UI

@Suite("Color+extension")
struct ColorTests {
  private var environment: EnvironmentValues {
    var environment = EnvironmentValues()
    environment.colorScheme = .light
    return environment
  }

  @Test("init(hex:) разбирает целочисленный hex",
        arguments: [
          (0x000000, "000000"),
          (0xFFFFFF, "FFFFFF"),
          (0xEB4F60, "EB4F60"),
          (0x1A9F29, "1A9F29"),
          (0x0D7518, "0D7518"),
          (0xFF0000, "FF0000"),
          (0x00FF00, "00FF00"),
          (0x0000FF, "0000FF")
        ])
  func hexInit(hex: Int, expected: String) {
    #expect(Color(hex: hex).toString() == expected)
  }

  @Test("fromString и toString обратимы",
        arguments: ["000000", "FFFFFF", "EB4F60", "1A9F29", "FF000080"])
  func roundTrip(hex: String) {
    #expect(Color.fromString(hex).toString() == hex)
  }

  @Test("fromString игнорирует # и пробелы по краям",
        arguments: ["#EB4F60", "  #EB4F60  ", "EB4F60\n"])
  func sanitizesInput(hex: String) {
    #expect(Color.fromString(hex).toString() == "EB4F60")
  }

  @Test("fromString возвращает clear для некорректной строки",
        arguments: ["", "xyz", "FFF", "EB4F6", "EB4F60AABB", "#"])
  func invalidInput(hex: String) {
    #expect(Color.fromString(hex) == .clear)
  }

  @Test("непрозрачный цвет кодируется шестью символами")
  func opaqueIsSixCharacters() {
    #expect(Color(hex: 0xEB4F60).toString().count == 6)
  }

  @Test("полупрозрачный цвет кодируется восемью символами")
  func translucentIsEightCharacters() {
    #expect(Color(hex: 0xEB4F60, opacity: 0.5).toString().count == 8)
  }

  @Test("альфа-канал восьмизначного hex сохраняется")
  func preservesAlpha() {
    #expect(Color.fromString("FF000000").toString() == "FF000000")
    #expect(Color.fromString("FF0000FF").toString() == "FF0000")
  }

  @Test("яркость белого равна 1, чёрного — 0")
  func luminanceBounds() {
    #expect(abs(Color.white.luminance(environment: environment) - 1) < 0.0001)
    #expect(abs(Color.black.luminance(environment: environment) - 0) < 0.0001)
  }

  @Test("контраст чёрного и белого равен 21:1")
  func maximumContrast() {
    let ratio = Color.white.contrastRatio(against: .black, environment: environment)

    #expect(abs(ratio - 21) < 0.01)
  }

  @Test("контраст симметричен")
  func contrastIsSymmetric() {
    let direct = Color.white.contrastRatio(against: .black, environment: environment)
    let reversed = Color.black.contrastRatio(against: .white, environment: environment)

    #expect(abs(direct - reversed) < 0.0001)
  }

  @Test("контраст цвета с самим собой равен 1:1",
        arguments: [0x000000, 0xFFFFFF, 0xEB4F60])
  func selfContrast(hex: Int) {
    let color = Color(hex: hex)

    #expect(abs(color.contrastRatio(against: color, environment: environment) - 1) < 0.0001)
  }
}
