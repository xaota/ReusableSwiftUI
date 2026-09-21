//
//  LLMTests.swift
//  Reusable
//

import Foundation
import Testing
@testable import LLM

@Suite("AssistantMessage")
struct AssistantMessageTests {
  @Test("роль по умолчанию — user")
  func defaultRole() {
    let message = AssistantMessage("привет")

    #expect(message.role == "user")
    #expect(message.content == "привет")
  }

  @Test("роль можно задать явно", arguments: ["system", "assistant", "tool"])
  func explicitRole(role: String) {
    #expect(AssistantMessage("текст", role: role).role == role)
  }

  @Test("у каждого сообщения свой id")
  func idsAreUnique() {
    #expect(AssistantMessage("одинаковый текст").id != AssistantMessage("одинаковый текст").id)
  }

  @Test("в JSON уходят только role и content — id остаётся локальным")
  func encodesOnlyAPIFields() throws {
    let data = try JSONEncoder().encode(AssistantMessage("вопрос"))
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

    #expect(Set(json.keys) == Set(["role", "content"]))
  }

  @Test("сообщение декодируется из ответа модели")
  func decodes() throws {
    let json = #"{"role":"assistant","content":"42"}"#
    let message = try JSONDecoder().decode(AssistantMessage.self, from: Data(json.utf8))

    #expect(message.role == "assistant")
    #expect(message.content == "42")
  }
}

@Suite("AssistantRequest")
struct AssistantRequestTests {
  @Test("запрос кодируется в формат chat completions")
  func encodesRequest() throws {
    let request = AssistantRequest(
      model: "deepseek-chat",
      messages: [
        AssistantMessage("ты — помощник", role: "system"),
        AssistantMessage("сколько будет 2+2?")
      ]
    )

    let data = try JSONEncoder().encode(request)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

    #expect(json["model"] as? String == "deepseek-chat")

    let messages = try #require(json["messages"] as? [[String: Any]])
    #expect(messages.count == 2)
    #expect(messages[0]["role"] as? String == "system")
    #expect(messages[0]["content"] as? String == "ты — помощник")
    #expect(messages[1]["role"] as? String == "user")
    #expect(messages[1]["content"] as? String == "сколько будет 2+2?")
  }

  @Test("порядок сообщений сохраняется")
  func keepsMessageOrder() throws {
    let contents = ["один", "два", "три"]
    let request = AssistantRequest(model: "m", messages: contents.map { AssistantMessage($0) })

    let data = try JSONEncoder().encode(request)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    let messages = try #require(json["messages"] as? [[String: Any]])

    #expect(messages.compactMap { $0["content"] as? String } == contents)
  }
}

@Suite("AssistantResponse")
struct AssistantResponseTests {
  @Test("ответ модели декодируется, лишние поля игнорируются")
  func decodesResponse() throws {
    let json = """
    {
      "id": "chatcmpl-1",
      "object": "chat.completion",
      "choices": [
        { "index": 0, "message": { "role": "assistant", "content": "4" }, "finish_reason": "stop" }
      ],
      "usage": { "total_tokens": 12 }
    }
    """

    let response = try JSONDecoder().decode(AssistantResponse.self, from: Data(json.utf8))

    #expect(response.choices.count == 1)
    #expect(response.choices.first?.message.role == "assistant")
    #expect(response.choices.first?.message.content == "4")
  }

  @Test("ответ без вариантов декодируется в пустой список")
  func decodesEmptyChoices() throws {
    let response = try JSONDecoder().decode(
      AssistantResponse.self,
      from: Data(#"{"choices":[]}"#.utf8)
    )

    #expect(response.choices.isEmpty)
  }

  @Test("ответ без choices не декодируется")
  func failsWithoutChoices() {
    #expect(throws: DecodingError.self) {
      try JSONDecoder().decode(AssistantResponse.self, from: Data(#"{}"#.utf8))
    }
  }
}
