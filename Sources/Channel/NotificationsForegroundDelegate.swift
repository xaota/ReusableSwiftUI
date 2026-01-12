//
//  NotificationsForegroundDelegate.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 11.01.2026.
//

import Foundation
import UserNotifications

/// - баннер в foreground
public final class NotificationsForegroundDelegate: NSObject, UNUserNotificationCenterDelegate {
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .badge]
  }
}
