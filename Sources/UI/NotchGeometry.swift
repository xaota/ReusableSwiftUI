//
//  NotchGeometry.swift
//  Reusable
//

import Foundation

/// Капсула, которую `notch()` прячет под вырезом вверху экрана iPhone — Dynamic Island или чёлкой.
/// Координаты — точки экрана в портрете без Display Zoom.
///
/// Острова сняты приватным `UIScreen._exclusionArea` в симуляторах Xcode 27 — модель, которой нет
/// в таблице, Debug-сборка замечает сама и пишет в лог готовую строку. Чёлку система описывает неточно
/// (у iPhone 12 — как у 13-го), поэтому капсулы в чёлках вписаны по контуру из маски экрана симулятора,
/// а высота — меньшая из глубин по маске и по системе.
struct NotchGeometry: Equatable, Sendable {
  /// Ширина экрана — по ней считается масштаб Display Zoom
  let screenWidth: CGFloat
  /// Остров целиком или капсула, вписанная в чёлку, — от края экрана до низа чёлки
  let capsule: CGRect
  /// Остров система отдаёт тем же прямоугольником — по нему Debug-сборка сверяет таблицу
  let isIsland: Bool

  /// Настолько капсула меньше выреза с каждой стороны: на устройстве не просвечивает кромка по сглаженному краю выреза
  static let inset: CGFloat = 0.5

  static func island (screen: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> NotchGeometry {
    NotchGeometry(screenWidth: screen, capsule: CGRect(x: x, y: y, width: width, height: height), isIsland: true)
  }

  static func notch (screen: CGFloat, x: CGFloat, width: CGFloat, depth: CGFloat) -> NotchGeometry {
    NotchGeometry(screenWidth: screen, capsule: CGRect(x: x, y: 0, width: width, height: depth), isIsland: false)
  }

  /// Капсула в координатах view, растянутого на всё окно; `frame` — его рамка в глобальных координатах.
  /// nil, если view не от левого верхнего угла окна, окно в ландшафте или масштаб не похож на Display Zoom
  func capsule (in frame: CGRect) -> CGRect? {
    guard abs(frame.minX) < 0.5, abs(frame.minY) < 0.5, frame.height > frame.width else { return nil }
    let zoom = frame.width / screenWidth
    guard (0.8...1.01).contains(zoom) else { return nil }
    return capsule
      .applying(CGAffineTransform(scaleX: zoom, y: zoom))
      .insetBy(dx: Self.inset, dy: Self.inset)
  }
}

extension NotchGeometry {
  /// Идентификатор модели (`iPhone19,2`); в симуляторе — модель симулируемого устройства
  static let modelIdentifier: String = {
    #if targetEnvironment(simulator)
    return ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
    #else
    var info = utsname()
    uname(&info)
    return withUnsafeBytes(of: &info.machine) { String(decoding: $0.prefix { $0 != 0 }, as: UTF8.self) }
    #endif
  }()

  /// Вырез этого устройства; nil — iPad, Mac, iPhone без выреза или модель, которой нет в таблице
  static let current = model(modelIdentifier)

  static func model (_ identifier: String) -> NotchGeometry? {
    table[identifier]
  }

  static let table: [String: NotchGeometry] = [
    // Dynamic Island
    "iPhone19,2": .island(screen: 402, x: 153.67, y: 14, width: 94.67, height: 36.67),      // iPhone 18 Pro
    "iPhone19,3": .island(screen: 440, x: 172.67, y: 14, width: 94.67, height: 36.67),      // iPhone 18 Pro Max
    "iPhone19,7": .island(screen: 440, x: 172.67, y: 14, width: 94.67, height: 36.67),      // iPhone 18 Pro Max
    "iPhone18,1": .island(screen: 402, x: 138.33, y: 14, width: 125, height: 36.67),        // iPhone 17 Pro
    "iPhone18,2": .island(screen: 440, x: 157.33, y: 14, width: 125.33, height: 36.67),     // iPhone 17 Pro Max
    "iPhone18,3": .island(screen: 402, x: 138.33, y: 14, width: 125, height: 36.67),        // iPhone 17
    "iPhone18,4": .island(screen: 420, x: 147.33, y: 20, width: 125.33, height: 36.67),     // iPhone Air
    "iPhone17,1": .island(screen: 402, x: 138.33, y: 14, width: 125, height: 36.67),        // iPhone 16 Pro
    "iPhone17,2": .island(screen: 440, x: 157.33, y: 14, width: 125.33, height: 36.67),     // iPhone 16 Pro Max
    "iPhone17,3": .island(screen: 393, x: 134, y: 11.33, width: 125, height: 36.67),        // iPhone 16
    "iPhone17,4": .island(screen: 430, x: 152.33, y: 11.33, width: 125.33, height: 36.67),  // iPhone 16 Plus
    "iPhone16,1": .island(screen: 393, x: 134, y: 11.33, width: 125, height: 36.67),        // iPhone 15 Pro
    "iPhone16,2": .island(screen: 430, x: 152.33, y: 11.33, width: 125.33, height: 36.67),  // iPhone 15 Pro Max
    "iPhone15,4": .island(screen: 393, x: 134, y: 11.33, width: 125, height: 36.67),        // iPhone 15
    "iPhone15,5": .island(screen: 430, x: 152.33, y: 11.33, width: 125.33, height: 36.67),  // iPhone 15 Plus
    "iPhone15,2": .island(screen: 393, x: 134, y: 11.33, width: 125, height: 36.67),        // iPhone 14 Pro
    "iPhone15,3": .island(screen: 430, x: 152.33, y: 11.33, width: 125.33, height: 36.67),  // iPhone 14 Pro Max

    // Чёлка
    "iPhone18,5": .notch(screen: 390, x: 120.62, width: 148.77, depth: 33.67),  // iPhone 17e
    "iPhone17,5": .notch(screen: 390, x: 120.62, width: 148.77, depth: 33.67),  // iPhone 16e
    "iPhone14,7": .notch(screen: 390, x: 120.62, width: 148.77, depth: 33.67),  // iPhone 14
    "iPhone14,8": .notch(screen: 428, x: 139.72, width: 148.57, depth: 33.67),  // iPhone 14 Plus
    "iPhone14,5": .notch(screen: 390, x: 120.62, width: 148.77, depth: 33.67),  // iPhone 13
    "iPhone14,2": .notch(screen: 390, x: 120.62, width: 148.77, depth: 33.67),  // iPhone 13 Pro
    "iPhone14,3": .notch(screen: 428, x: 139.72, width: 148.57, depth: 33.67),  // iPhone 13 Pro Max
    "iPhone14,4": .notch(screen: 375, x: 105.4, width: 164.2, depth: 37.33),    // iPhone 13 mini
    "iPhone13,2": .notch(screen: 390, x: 96.78, width: 196.44, depth: 32),      // iPhone 12
    "iPhone13,3": .notch(screen: 390, x: 96.78, width: 196.44, depth: 32),      // iPhone 12 Pro
    "iPhone13,4": .notch(screen: 428, x: 116.06, width: 195.87, depth: 32),     // iPhone 12 Pro Max
    "iPhone13,1": .notch(screen: 375, x: 81.82, width: 211.37, depth: 34.35),   // iPhone 12 mini
    "iPhone12,1": .notch(screen: 414, x: 97.09, width: 219.81, depth: 32),      // iPhone 11
    "iPhone12,3": .notch(screen: 375, x: 92.86, width: 189.94, depth: 30),      // iPhone 11 Pro
    "iPhone12,5": .notch(screen: 414, x: 110.11, width: 193.78, depth: 30),     // iPhone 11 Pro Max
  ]
}
