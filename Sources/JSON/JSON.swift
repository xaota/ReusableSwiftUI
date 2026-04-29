//
//  JSON.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 29.04.2026.
//

import Foundation

/// Чтение JSON файла из проекта
public func decodeFileJSON<T: Decodable>(
  _ file: String,
  defaultValue: T,
  bundle: Bundle = .main,
  fileExtension: String = "json",
) -> T {
  guard let url = bundle.url(forResource: file, withExtension: fileExtension) else {
    fatalError("Faliled to locate \(file) in bundle \(bundle.bundlePath)")
  }

  guard let data = try? Data(contentsOf: url) else {
    fatalError("Failed to load file from \(file) from bundle")
  }

  //  print("\(data) Loaded \(file) from bundle")
  //  if let str = String(data: data, encoding: .utf8) {
  //    print("Successfully decoded: \(str)")
  //  }

  let decoder = JSONDecoder()
  do {
    return try decoder.decode(T.self, from: data) // process data
  } catch let DecodingError.dataCorrupted(context) {
    print(context)
  } catch let DecodingError.keyNotFound(key, context) {
    print("Key '\(key)' not found:", context.debugDescription)
    print("codingPath:", context.codingPath)
  } catch let DecodingError.valueNotFound(value, context) {
    print("Value '\(value)' not found:", context.debugDescription)
    print("codingPath:", context.codingPath)
  } catch let DecodingError.typeMismatch(type, context)  {
    print("Type '\(type)' mismatch:", context.debugDescription)
    print("codingPath:", context.codingPath)
  } catch {
    print("error: ", error)
  }

  return defaultValue
}

