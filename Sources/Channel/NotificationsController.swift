//
//  NotificationsController.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 11.01.2026.
//

import Foundation
import UserNotifications

public actor NotificationsController {
  public static func scedule(_ request: UNNotificationRequest) async -> Void {
    guard await requirePermission() else { return }

    do {
      let center = UNUserNotificationCenter.current()
      try await center.add(request)
    } catch {
      print("Adding notification error \(error.localizedDescription)")
    }
  }

  public static func scedule(_ requests: [UNNotificationRequest]) async {
    let center = UNUserNotificationCenter.current()

    for request in requests {
      do {
        try await center.add(request)
      } catch {
        print("Notification error:", error.localizedDescription)
      }
    }
  }

  public static func pendingRequests() async -> [UNNotificationRequest] {
    let center = UNUserNotificationCenter.current()
    return await center.pendingNotificationRequests()
  }

  public static func resetNotifications() -> Void {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    // center.removeAllDeliveredNotifications()
  }

  public static func requirePermission() async -> Bool {
    do {
      return try await ensurePermission()
    } catch {
      print("Error requesting notification permission: \(error.localizedDescription)")
      return false
    }
  }

  public static func ensurePermission() async throws -> Bool {
    let center = UNUserNotificationCenter.current()
    let settings = await center.notificationSettings()

    switch settings.authorizationStatus {
      case .authorized, .provisional, .ephemeral:
        return true

      case .denied:
        return false

      case .notDetermined:
        return try await center.requestAuthorization(options: [.alert, .sound, .badge])

      @unknown default:
        return false
    }
  }

  public static func unknown() async -> Bool {
    let center = UNUserNotificationCenter.current()
    let settings = await center.notificationSettings()
    return settings.authorizationStatus == .notDetermined
  }

  public static func available() async -> Bool {
    #if os(iOS) || os(watchOS) || os(tvOS)
    let statuses: [UNAuthorizationStatus] = [
      .authorized,
      .provisional,
      .ephemeral,
      .notDetermined
    ]
    #else
    let statuses: [UNAuthorizationStatus] = [
      .authorized,
      .provisional,
      .notDetermined
    ]
    #endif

    let center = UNUserNotificationCenter.current()
    let settings = await center.notificationSettings()
    return statuses.contains(settings.authorizationStatus)
  }
}

