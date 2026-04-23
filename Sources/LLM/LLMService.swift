//
//  LLMService.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.04.2026.
//

import Foundation

public struct LLMService: Sendable {
  private var url: URL
  private var llm: String
  private var key: String = ""

  public init(url: String, modelName: String) {
    self.url = URL(string: url)!
    self.llm = modelName
  }

  public mutating func token(_ apiKey: String) {
    self.key = apiKey
  }

  public mutating func model(_ modelName: String) {
    self.llm = modelName
  }

  public func request(_ text: String) async throws -> String {
    try await chat(messages: [.init(text)])
  }

  public func chat(messages: [AssistantMessage]) async throws -> String {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = AssistantRequest(model: llm, messages: messages)
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    // print("data", data)
    // print("response", response)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    guard httpResponse.statusCode == 200 else {
      let body = String(data: data, encoding: .utf8) ?? "No body"
      print("LLM API error (\(httpResponse.statusCode)): \(body)")
      throw URLError(.badServerResponse)
    }

    let decodedResponse = try JSONDecoder().decode(AssistantResponse.self, from: data)
    return decodedResponse.choices.first?.message.content ?? "No response"
  }

  public static let DeepSeek = LLMService(url: "https://api.deepseek.com/v1/chat/completions", modelName: "deepseek-chat")
  public static let OpenAI = LLMService(url: "https://api.openai.com/v1/chat/completions", modelName: "gpt-o5-mini")
}
