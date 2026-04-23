//
//  OpenWeatherMap.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.04.2026.
//
import Foundation
import CoreLocation

public struct OpenWeatherMapResponse: Codable { // CustomStringConvertible
  public struct Main: Codable {
    public let temp: Double
    public let humidity: Int
  }
  public struct Weather: Codable {
    public let description: String
    public let icon: String
  }
  public let main: Main
  public let weather: [Weather]
  public let name: String

//  public var description: String {
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//    guard let data = try? encoder.encode(self) else { return "OpenWeatherMapResponse" }
//    return String(data: data, encoding: .utf8) ?? "OpenWeatherMapResponse"
//  }
}

extension OpenWeatherMapResponse {
  public var icon: String? { Self.icon(weather.first?.icon) }

  /// Маппинг иконок OpenWeatherMap в SF Symbols
  public static func icon(_ code: String?) -> String? {
    switch code {
      case "01d": return "sun.max.fill"
      case "01n": return "moon.fill"
      case "02d": return "cloud.sun.fill"
      case "02n": return "cloud.moon.fill"
      case "03d", "03n": return "cloud.fill"
      case "04d", "04n": return "cloud.drizzle.fill"
      case "09d", "09n": return "cloud.rain.fill"
      case "10d": return "cloud.sun.rain.fill"
      case "10n": return "cloud.moon.rain.fill"
      case "11d", "11n": return "cloud.bolt.fill"
      case "13d", "13n": return "cloud.snow.fill"
      case "50d", "50n": return "cloud.fog.fill"
      default: return nil
    }
  }
}

public struct OpenWeatherMap: Sendable {
  var key: String = ""
  var lang: String

  public init(lang: String = "en", apiKey: String = "") {
    self.lang = lang
    
    if !apiKey.isEmpty {
      key = apiKey
    }
  }

  public mutating func token(_ apiKey: String) {
    self.key = apiKey
  }

  public func weather(location: CLLocation) async throws -> OpenWeatherMapResponse {
    let latitude: Double = location.coordinate.latitude
    let longitude: Double = location.coordinate.longitude
    let params = "lat=\(latitude)&lon=\(longitude)&units=metric&lang=\(lang)&appid=\(key)"

    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?\(params)")!

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(OpenWeatherMapResponse.self, from: data)
  }
}
