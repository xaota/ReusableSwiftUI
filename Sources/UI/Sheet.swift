import SwiftUI

extension View {
  public func sheetController<InnerContent: View> (
    _ title: String = "",
    by: Binding<Bool>,
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    adaptiveHeight: PresentationDetent = .large,
    // hideKeyboard: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> InnerContent
  ) -> some View {
    modifier(SheetController(
      by: by,
      title: title,
      icon: icon,
      confirm: confirm,
      action: action,
      interactiveDismiss: interactiveDismiss,
      adaptiveHeight: adaptiveHeight,
      //      hideKeyboard: hideKeyboard,
      innerContent: content
    ))
  }
}

struct SheetController<InnerContent: View>: ViewModifier {
  @Binding var by: Bool

  let title: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
  let interactiveDismiss: Bool
  let adaptiveHeight: PresentationDetent
  // let hideKeyboard: (() -> Void)?
  var innerContent: () -> InnerContent

  @State private var contentHeight: CGFloat = .zero

  init(
    by: Binding<Bool>,
    title: String = "",
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    adaptiveHeight: PresentationDetent = .large,
    // hideKeyboard: (() -> Void)? = nil,
    @ViewBuilder innerContent: @escaping () -> InnerContent
  ) {
    self._by = by
    self.title = title
    self.icon = icon
    self.confirm = confirm
    self.action = action
    self.interactiveDismiss = interactiveDismiss
    self.adaptiveHeight = adaptiveHeight
    // self.hideKeyboard = hideKeyboard
    self.innerContent = innerContent
  }

  public func body (content: Content) -> some View {
    let caption = NSLocalizedString(title, comment: "")

    return content
      .background(
        innerContent()
          .background(
            GeometryReader { proxy in
              Color.clear
                .task(id: proxy.size.height) {
                  contentHeight = proxy.size.height + 128
                }
            }
          )
          .hidden()
      )
      .sheet(isPresented: $by) {
        SheetWrapper(
          caption: caption,
          icon: icon,
          confirm: confirm,
          action: action,
          interactiveDismiss: interactiveDismiss
          // hideKeyboard: hideKeyboard
          // contentHeight: $contentHeight
        ) {
          innerContent()
        }
        .presentationSizing(.page.sticky(horizontal: false, vertical: true))
        .presentationDragIndicator(interactiveDismiss ? .visible : .hidden)
        .interactiveDismissDisabled(!interactiveDismiss)
        .presentationDetents([adaptiveHeight == .height(0) ? .height(contentHeight) : adaptiveHeight])
      }
  }
}

struct SheetWrapper<Content: View>: View {
  @Environment(\.dismiss) private var dismiss

  let caption: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
  let interactiveDismiss: Bool
    //  let hideKeyboard: (() -> Void)?

//  @Binding var contentHeight: CGFloat
  var content: () -> Content

  init(
    caption: String = "",
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = false,
    //    hideKeyboard: (() -> Void)? = nil,
//    contentHeight: Binding<CGFloat>,
    @ViewBuilder content: @escaping () -> Content,
  ) {
    self.caption = caption
    self.icon = icon
    self.confirm = confirm
    self.action = action
    self.interactiveDismiss = interactiveDismiss
    // self.hideKeyboard = hideKeyboard
    self.content = content
//    _contentHeight = contentHeight
  }

  var body: some View {
    let done = NSLocalizedString("action:done", tableName: "Application", comment: "Done")
    let close = NSLocalizedString("action:close", tableName: "Application", comment: "Close")
    let keyboardHide = NSLocalizedString("keyboard:hide", tableName: "Application", comment: "Keyboard hide")

    NavigationStack {
      content()
//        .onGeometryChange(for: CGFloat.self) { proxy in
//          proxy.size.height
//        } action: { newSize in
//          contentHeight = newSize
//        }
        .toolbar {
          if interactiveDismiss != false {
            ToolbarItem(placement: .cancellationAction) {
              Button(close, systemImage: "xmark") { dismiss() }
            }
          }

          if action != nil {
            ToolbarItem(placement: .confirmationAction) {
              if icon.isEmpty {
                Button(done, action: action!)
              } else {
                Button(action: action!) { Label(confirm, systemImage: icon) }
              }
            }
          }

          // if hideKeyboard != nil {
          ToolbarItemGroup(placement: .keyboard) {
            Button(action: dismissKeyboard ) {
              Label(keyboardHide, systemImage: "keyboard.chevron.compact.down")
            }
          }
          // }
        }
        .navigationTitle(caption)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
  }
}

#Preview {
  @Previewable @State var showingSheet: Bool = true

  @Previewable @State var step: Int = 0 // 0..2

  @Previewable @State var contentHeight: [CGFloat] = [100, 200, 300, 400]

  Button("Test button") { showingSheet.toggle() }
    .sheetController(
      "test sheet",
      by: $showingSheet,
      icon: "ellipsis.circle",
      adaptiveHeight: .height(0)
//      interactiveDismiss: false
    ) {
      let title = String(localized: "app:hello-world", bundle: .module)

      VStack {
        Text(title)

        Text("step: \(step)")

        if step == 1 {
          Text("step 1")
        }

        if step > 1 {
          Text("step 2+")
        }

        if step == 3 {
          Rectangle()
            .fill(.red)
            .frame(height: 120)
        }

        Button(action: { step = (step + 1) % 4}) {
          Text("next")
        }
        .padding(.top, 20)
      }
    }
    .presentationDetents([.height(contentHeight[step] + 120)])
}

@MainActor func dismissKeyboard() {
  UIApplication.shared.sendAction(
    #selector(UIResponder.resignFirstResponder),
    to: nil,
    from: nil,
    for: nil
  )
}
