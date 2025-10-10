import SwiftUI

extension View {
  public func notch (_ title: String = "") -> some View {
    modifier(NotchLogoView(title, offset: .zero))
  }

  public func notch (_ title: String = "", offset: CGFloat = .zero) -> some View {
    modifier(NotchLogoView(title, offset: offset))
  }
}


struct NotchLogoView: ViewModifier {
  private var title: String
  private var offset: CGFloat = .zero

//  @State private var safeAreaTop: CGFloat = 0

  @State private var hasZone: Bool = false
  @State private var zoneSize: CGSize = .zero
  @State private var zoneBottom: CGFloat = .zero

  public init (_ title: String = "", offset: CGFloat = .zero) {
    self.title = title
    self.offset = offset
  }

  public func body (content: Content) -> some View {
    ZStack {
      content

      if (hasZone) {
        GeometryReader { geo in
//          let diSize = calculateDynamicIslandSize()

          ZStack {
              // Create the border with the capsule shape
            Capsule()
              .fill(Color.accentColor)
//              .stroke(Color.red, lineWidth: 2)
              .frame(width: zoneSize.width, height: zoneSize.height)
              .overlay(Text(self.title).foregroundColor(Color.white))
              .position(x: geo.size.width / 2, y: zoneBottom - zoneSize.height + offset)
              //              .offset(y: -100)
          }
          .edgesIgnoringSafeArea(.top)
        }
      }
    }
    .onAppear {
        // Get the safe area inset
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let safeAreaTop = windowScene.windows.first?.safeAreaInsets.top {
//        self.safeAreaTop = safeAreaTop

        let isDynamicIsland = safeAreaTop > 50 && UIDevice.current.userInterfaceIdiom == .phone
        let isNotch = safeAreaTop > 44

        self.hasZone = isDynamicIsland || isNotch
        self.zoneSize = isDynamicIsland ? CGSize(width: 120, height: 32) : CGSize(width: 120, height: 28)
        self.zoneBottom = safeAreaTop
      }
    }
  }
}

#Preview {
  Text("Hello, world!")
    .notch(String(localized: "ui-notch"), offset: 100)
}
