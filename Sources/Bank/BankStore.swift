//
//  File.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.10.2025.
//
import Foundation

public final class BankStore: @unchecked Sendable {
  public static let json: BankStore = {
    let instance = BankStore()
    instance.load()
    return instance
  }()

  private var bankJSON: [BankJSON] = []
  private init() {}

  // You can keep this internal if you don't want external callers to invoke it.
  // It's called within the same file during shared initialization.
  func load() {
    let json: [BankJSON] = decodeBankJSON()
    self.bankJSON = json
  }

  public static func get(_ code: String) -> BankJSON? {
    return BankStore.json.bankJSON.first(where: { $0.code == code }) ?? nil
  }

  public static func filter(_ text: String) -> [BankJSON] {
    let part = searchable(text)
//    if part.count < 3 {
    if part.isEmpty {
      return []
    }

    return BankStore.json.bankJSON.filter {
      let code = $0.code.contains(part)
      let caption = searchable($0.caption).contains(part)
      let index = ($0.search ?? []).map { searchable($0) }.joined().contains(part)
//      print("filter x", code, caption, index, $0.code, searchable($0.caption), ($0.search ?? []).map { searchable($0) }.joined())

      return code || caption || index
    } ?? []
  }

  public static func name(_ bank: String) -> String {
    return BankStore.get(bank)?.caption ?? bank
  }

  public static func searchable(_ text: String) -> String {
    return text
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(
        of: "[\\s+\\-\\|\\.\\,–—/\\\\&\\$\\(\\)\\[\\]\\{\\}]+",
        with: "",
        options: .regularExpression
      )
      .lowercased()
  }
}

func decodeBankJSON(file: String = "bank", fileExtension: String = "json") -> [BankJSON] {
  guard let url = Bundle.module.url(forResource: file, withExtension: fileExtension) else {
    fatalError("Faliled to locate \(file) in bundle")
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
      return try decoder.decode([BankJSON].self, from: data)   // process data
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


  return [] // loadedFile
}
