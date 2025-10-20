//
//  File.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 19.10.2025.
//

import Foundation

public struct CurrencyJSON: Codable {
  public var code: String
  public var sign: String?
  public var flag: String?
  public var icon: String?
}

public func decodeCurrencyJSON(_ file: String) -> [CurrencyJSON] {
  guard let url = Bundle.module.url(forResource: file, withExtension: nil) else {
    fatalError("Faliled to locate \(file) in bundle")
  }

  guard let data = try? Data(contentsOf: url) else {
    fatalError("Failed to load file from \(file) from bundle")
  }

  let decoder = JSONDecoder()

  guard let loadedFile = try? decoder.decode([CurrencyJSON].self, from: data) else {
    fatalError("Failed to decode \(file) from bundle")
  }

  return loadedFile
}
