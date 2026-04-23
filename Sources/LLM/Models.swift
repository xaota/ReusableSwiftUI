//
//  Models.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 23.04.2026.
//

import Foundation

public struct AssistantRequest: Encodable {
  public let model: String
  public let messages: [AssistantMessage]
}

public struct AssistantResponse: Decodable {
  public let choices: [AssistantChoice]
}

public struct AssistantMessage: Codable, Identifiable, Sendable {
  public let id: UUID = UUID()
  public let role: String
  public let content: String

  public init(_ content: String, role: String = "user") {
    self.content = content
    self.role = role
  }

  public enum CodingKeys: String, CodingKey {
    case role, content
  }
}

public struct AssistantChoice: Decodable {
  public let message: AssistantMessage
}
