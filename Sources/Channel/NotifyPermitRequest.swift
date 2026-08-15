//
//  NotifyPermitRequest.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 15.01.2026.
//

import SwiftUI
import UserNotifications

public struct NotifyPermitRequest: View {
  @State var unknownNotifyPermit: Bool = false
  var caption: String
  var action: () -> Void = {}

  public init(caption: String = "", action: @escaping () -> Void = {}) {
    self.caption = caption.isEmpty ? String(localized: "app:notifications:action:enable", bundle: .module) : caption
    self.action = action
  }

  public var body: some View {
    VStack {
      if unknownNotifyPermit {
        Button(caption, systemImage: "bell.badge") {
          Task {
            let center = UNUserNotificationCenter.current()
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
            if granted {
              unknownNotifyPermit = false
              action()
            }
          }
        }
        .controlSize(.large)
        .buttonStyle(.borderless)
        .buttonSizing(.flexible)
      }
    }
    .task { @MainActor in
      let center = UNUserNotificationCenter.current()
      let settings = await center.notificationSettings()
      unknownNotifyPermit = settings.authorizationStatus == .notDetermined
    }
  }
}

#Preview {
  NotifyPermitRequest()
}
