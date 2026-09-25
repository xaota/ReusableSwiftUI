import SwiftUI
#if DEBUG && os(iOS) && !targetEnvironment(macCatalyst)
import UIKit
#endif

extension View {
  /// Капсула с названием под Dynamic Island или чёлкой. На устройстве её закрывает вырез,
  /// видна она только на скриншотах и записи экрана. Ставится на корень окна.
  /// На macOS, iPad, iPhone без выреза и в ландшафте ничего не рисует
  public func notch (_ title: String = "", offset: CGFloat = .zero) -> some View {
    modifier(NotchLogoView(title, offset: offset))
  }
}

struct NotchLogoView: ViewModifier {
  private var title: String
  private var offset: CGFloat = .zero

  public init (_ title: String = "", offset: CGFloat = .zero) {
    self.title = title
    self.offset = offset
  }

  public func body (content: Content) -> some View {
    #if os(iOS) && !targetEnvironment(macCatalyst)
    content
      .overlay {
        if let geometry = NotchGeometry.current {
          GeometryReader { geo in
            let frame = geo.frame(in: .global)

            if let rect = geometry.capsule(in: frame) {
              Capsule()
                .fill(Color.accentColor)
                .overlay(
                  Text(title)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, rect.height / 4)
                )
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX - frame.minX, y: rect.midY - frame.minY + offset)
            }
          }
          .ignoresSafeArea()
          .dynamicTypeSize(.large)  // вырез не растёт с Dynamic Type — текст тоже
          .allowsHitTesting(false)
          .accessibilityHidden(true)
        }
      }
      #if DEBUG
      .onAppear { NotchGeometry.audit() }
      #endif
    #else
    content
    #endif
  }
}

#if DEBUG && os(iOS) && !targetEnvironment(macCatalyst)
extension NotchGeometry {
  @MainActor private static var audited = false

  /// Сверяет таблицу с тем, что знает система (приватный `UIScreen._exclusionArea`), один раз за запуск.
  /// Модели нет в таблице или вырез разошёлся — пишет в лог готовую строку. В Release этого кода нет
  @MainActor static func audit () {
    guard !audited else { return }
    audited = true

    guard let screen = UIApplication.shared.connectedScenes.lazy.compactMap({ ($0 as? UIWindowScene)?.screen }).first,
          let area = screen.exclusionArea
    else { return }

    let width = screen.nativeBounds.width / screen.scale              // ширина экрана без Display Zoom
    let zoom = screen.fixedCoordinateSpace.bounds.width / width
    let cutout = area.applying(CGAffineTransform(scaleX: 1 / zoom, y: 1 / zoom))
    let island = "\"\(modelIdentifier)\": .island(screen: \(short(width)), x: \(short(cutout.minX)), y: \(short(cutout.minY)), "
      + "width: \(short(cutout.width)), height: \(short(cutout.height))),"

    guard let known = current else {
      print("notch: модели \(modelIdentifier) нет в NotchGeometry.table — капсула не рисуется. Вырез по данным системы: \(cutout).\n"
        + (cutout.minY > 0 ? "Добавь в таблицу:\n  \(island)" : "Похоже на чёлку: впиши капсулу по контуру из маски экрана симулятора"))
      return
    }
    guard known.isIsland else { return }  // чёлку система описывает неточно — сверять не с чем

    let close = [
      (known.capsule.minX, cutout.minX), (known.capsule.minY, cutout.minY),
      (known.capsule.width, cutout.width), (known.capsule.height, cutout.height)
    ].allSatisfy { abs($0 - $1) <= inset }

    if !close {
      print("notch: у \(modelIdentifier) в NotchGeometry.table остров \(known.capsule), а система отдаёт \(cutout). Обнови строку:\n  \(island)")
    }
  }

  private static func short (_ value: CGFloat) -> String {
    String(format: "%g", (value * 100).rounded() / 100)
  }
}

private extension UIScreen {
  /// Прямоугольник выреза из приватного `_exclusionArea`, если система описывает его одним прямоугольником
  var exclusionArea: CGRect? {
    guard responds(to: NSSelectorFromString("_exclusionArea")),
          let shape = value(forKey: "_exclusionArea") as? NSObject,
          shape.responds(to: NSSelectorFromString("rect"))
    else { return nil }
    return (shape.value(forKey: "rect") as? NSValue)?.cgRectValue
  }
}
#endif

#Preview {
  Text("Hello, world!")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .notch("reusable", offset: 100)
}
