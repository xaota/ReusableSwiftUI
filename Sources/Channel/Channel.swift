//
//  Cahnnel.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 14.10.2025.
//

import Foundation
import Combine

public struct Channel<AppEventType: RawRepresentable> where AppEventType.RawValue == String {
  public static func dispatch(_ event: AppEventType, meta: [AnyHashable: Any]? = nil, object: Any? = nil) {
    let name = Notification.Name(rawValue: event.rawValue)
    NotificationCenter.default.post(name: name, object: object, userInfo: meta)
  }

  public static func message(_ event: AppEventType) -> NotificationCenter.Publisher {
    let name = Notification.Name(rawValue: event.rawValue)
    return NotificationCenter.default.publisher(for: name)
  }
}
