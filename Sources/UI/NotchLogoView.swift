import SwiftUI

extension View {
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
    ZStack {
      content

      GeometryReader { geo in
          // Получаем верхнюю безопасную вставку из SwiftUI
        let safeAreaTop = geo.safeAreaInsets.top

          // Простая эвристика: если вставка значимая — считаем, что есть вырез/остров
          // Порог можно подстроить при необходимости
        let isDynamicIslandOrNotch: Bool = safeAreaTop > 44

          // Локальные вычисления размеров и положения
        let size: CGSize = safeAreaTop > 50 ? CGSize(width: 120, height: 32) : CGSize(width: 120, height: 28)
        let bottom = safeAreaTop

        if isDynamicIslandOrNotch {
          ZStack {
            Capsule()
              .fill(Color.accentColor)
              .frame(width: size.width, height: size.height)
              .overlay(Text(self.title).foregroundColor(Color.white))
              .position(x: geo.size.width / 2, y: bottom - size.height + offset)
          }
          .edgesIgnoringSafeArea(.top)
        }
      }
    }
  }
}

#Preview {
  Text("Hello, world!")
    .notch(String(localized: "ui-notch"), offset: 100)
}
