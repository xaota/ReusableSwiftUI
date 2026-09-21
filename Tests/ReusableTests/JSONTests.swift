//
//  JSONTests.swift
//  Reusable
//

import Foundation
import Testing
import JSON

private struct Person: Codable, Equatable {
  var name: String
  var age: Int
}

@Suite("decodeFileJSON")
struct JSONTests {
  private let fallback = [Person(name: "fallback", age: -1)]

  @Test("декодирует корректный JSON из бандла")
  func decodesValidFile() {
    let people: [Person] = decodeFileJSON("fixture-people", defaultValue: [], bundle: .module)

    #expect(people == [
      Person(name: "Ann", age: 30),
      Person(name: "Bob", age: 41)
    ])
  }

  @Test("возвращает defaultValue, когда в JSON не хватает ключа")
  func returnsDefaultOnMissingKey() {
    let people: [Person] = decodeFileJSON("fixture-missing-key", defaultValue: fallback, bundle: .module)

    #expect(people == fallback)
  }

  @Test("возвращает defaultValue при несовпадении типов")
  func returnsDefaultOnTypeMismatch() {
    let people: [Person] = decodeFileJSON("fixture-type-mismatch", defaultValue: fallback, bundle: .module)

    #expect(people == fallback)
  }

  @Test("возвращает defaultValue, когда структура файла не совпадает с типом")
  func returnsDefaultOnRootTypeMismatch() {
    // файл содержит массив объектов, а ждём массив строк
    let tags: [String] = decodeFileJSON("fixture-people", defaultValue: ["default"], bundle: .module)

    #expect(tags == ["default"])
  }
}
