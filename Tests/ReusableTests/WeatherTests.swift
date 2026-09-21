//
//  WeatherTests.swift
//  Reusable
//

import Foundation
import Testing
@testable import Weather

@Suite("OpenWeatherMap: иконки")
struct OpenWeatherMapIconTests {
  @Test("коды OpenWeatherMap маппятся в SF Symbols",
        arguments: [
          ("01d", "sun.max.fill"),
          ("01n", "moon.fill"),
          ("02d", "cloud.sun.fill"),
          ("02n", "cloud.moon.fill"),
          ("03d", "cloud.fill"),
          ("03n", "cloud.fill"),
          ("04d", "cloud.drizzle.fill"),
          ("04n", "cloud.drizzle.fill"),
          ("09d", "cloud.rain.fill"),
          ("09n", "cloud.rain.fill"),
          ("10d", "cloud.sun.rain.fill"),
          ("10n", "cloud.moon.rain.fill"),
          ("11d", "cloud.bolt.fill"),
          ("11n", "cloud.bolt.fill"),
          ("13d", "cloud.snow.fill"),
          ("13n", "cloud.snow.fill"),
          ("50d", "cloud.fog.fill"),
          ("50n", "cloud.fog.fill")
        ])
  func mapsKnownCodes(code: String, symbol: String) {
    #expect(OpenWeatherMapResponse.icon(code) == symbol)
  }

  @Test("неизвестные коды не маппятся",
        arguments: ["", "1d", "01", "01D", "99d", "sun.max.fill"])
  func ignoresUnknownCodes(code: String) {
    #expect(OpenWeatherMapResponse.icon(code) == nil)
  }

  @Test("отсутствующий код не маппится")
  func ignoresNilCode() {
    #expect(OpenWeatherMapResponse.icon(nil) == nil)
  }
}

@Suite("OpenWeatherMapResponse: декодирование")
struct OpenWeatherMapResponseTests {
  private func decode(_ json: String) throws -> OpenWeatherMapResponse {
    try JSONDecoder().decode(OpenWeatherMapResponse.self, from: Data(json.utf8))
  }

  @Test("ответ API декодируется, лишние поля игнорируются")
  func decodesResponse() throws {
    let response = try decode(
      """
      {
        "coord": { "lon": 44.79, "lat": 41.69 },
        "weather": [{ "id": 500, "main": "Rain", "description": "небольшой дождь", "icon": "10d" }],
        "base": "stations",
        "main": { "temp": 12.34, "feels_like": 11.9, "humidity": 81, "pressure": 1014 },
        "visibility": 10000,
        "name": "Tbilisi",
        "cod": 200
      }
      """
    )

    #expect(response.name == "Tbilisi")
    #expect(response.main.temp == 12.34)
    #expect(response.main.humidity == 81)
    #expect(response.weather.count == 1)
    #expect(response.weather.first?.description == "небольшой дождь")
    #expect(response.weather.first?.icon == "10d")
  }

  @Test("icon берётся из первого элемента weather")
  func iconUsesFirstWeather() throws {
    let response = try decode(
      """
      {
        "main": { "temp": -3, "humidity": 90 },
        "weather": [
          { "description": "снег", "icon": "13n" },
          { "description": "туман", "icon": "50n" }
        ],
        "name": "Ulaanbaatar"
      }
      """
    )

    #expect(response.icon == "cloud.snow.fill")
  }

  @Test("пустой weather не даёт иконку")
  func noIconWithoutWeather() throws {
    let response = try decode(
      """
      { "main": { "temp": 20, "humidity": 50 }, "weather": [], "name": "Nowhere" }
      """
    )

    #expect(response.icon == nil)
  }

  @Test("незнакомый код иконки не даёт SF Symbol")
  func noIconForUnknownCode() throws {
    let response = try decode(
      """
      { "main": { "temp": 20, "humidity": 50 }, "weather": [{ "description": "?", "icon": "77x" }], "name": "Nowhere" }
      """
    )

    #expect(response.icon == nil)
  }

  @Test("без обязательного поля декодирование падает")
  func failsWithoutRequiredField() {
    #expect(throws: DecodingError.self) {
      try JSONDecoder().decode(
        OpenWeatherMapResponse.self,
        from: Data(#"{ "weather": [], "name": "Nowhere" }"#.utf8)
      )
    }
  }
}
