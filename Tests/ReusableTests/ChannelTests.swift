//
//  ChannelTests.swift
//  Reusable
//

import Combine
import Foundation
import Testing
@testable import Channel

private enum TestEvent: String {
  case ping = "reusable.tests.channel.ping"
  case pong = "reusable.tests.channel.pong"
}

/// Тесты делят один NotificationCenter.default, поэтому выполняются последовательно.
@Suite("Channel", .serialized)
struct ChannelTests {
  @Test("dispatch публикует уведомление с именем события")
  func dispatchUsesRawValueAsNotificationName() async {
    await confirmation("уведомление получено") { received in
      let center = NotificationCenter.default
      let observer = center.addObserver(
        forName: Notification.Name(TestEvent.ping.rawValue),
        object: nil,
        queue: nil
      ) { _ in
        received()
      }

      Channel<TestEvent>.dispatch(.ping)
      center.removeObserver(observer)
    }
  }

  @Test("dispatch передаёт payload в object и userInfo")
  func dispatchCarriesPayload() async {
    await confirmation("уведомление получено") { received in
      let center = NotificationCenter.default
      let observer = center.addObserver(
        forName: Notification.Name(TestEvent.ping.rawValue),
        object: nil,
        queue: nil
      ) { notification in
        #expect(notification.object as? String == "payload")
        #expect(notification.userInfo?["count"] as? Int == 7)
        received()
      }

      Channel<TestEvent>.dispatch(.ping, userInfo: ["count": 7], payload: "payload")
      center.removeObserver(observer)
    }
  }

  @Test("без payload и userInfo уведомление приходит пустым")
  func dispatchWithoutPayload() async {
    await confirmation("уведомление получено") { received in
      let center = NotificationCenter.default
      let observer = center.addObserver(
        forName: Notification.Name(TestEvent.ping.rawValue),
        object: nil,
        queue: nil
      ) { notification in
        #expect(notification.object == nil)
        #expect(notification.userInfo == nil)
        received()
      }

      Channel<TestEvent>.dispatch(.ping)
      center.removeObserver(observer)
    }
  }

  @Test("message создаёт publisher для своего события")
  func messagePublisherReceivesEvent() async {
    await confirmation("publisher доставил событие") { received in
      let subscription = Channel<TestEvent>.message(.ping).sink { notification in
        #expect(notification.object as? String == "payload")
        received()
      }

      Channel<TestEvent>.dispatch(.ping, payload: "payload")
      subscription.cancel()
    }
  }

  @Test("подписка на одно событие не получает другие")
  func messagePublisherIgnoresOtherEvents() async {
    await confirmation("получен только ping", expectedCount: 1) { received in
      let subscription = Channel<TestEvent>.message(.ping).sink { _ in
        received()
      }

      Channel<TestEvent>.dispatch(.pong)
      Channel<TestEvent>.dispatch(.ping)
      Channel<TestEvent>.dispatch(.pong)
      subscription.cancel()
    }
  }

  @Test("после отмены подписки события не приходят")
  func cancelledSubscriptionStopsReceiving() async {
    await confirmation("получено одно событие до отмены", expectedCount: 1) { received in
      let subscription = Channel<TestEvent>.message(.ping).sink { _ in
        received()
      }

      Channel<TestEvent>.dispatch(.ping)
      subscription.cancel()
      Channel<TestEvent>.dispatch(.ping)
    }
  }
}
