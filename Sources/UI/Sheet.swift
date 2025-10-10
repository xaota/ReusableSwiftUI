import SwiftUI

extension View {
  public func sheetController<InnerContent : View> (
    by: Binding<Bool>,
    title: String = "",
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    //    hideKeyboard: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> InnerContent
  ) -> some View {
    modifier(SheetController(
      by: by,
      title: title,
      icon: icon,
      confirm: confirm,
      action: action,
      //      hideKeyboard: hideKeyboard,
      innerContent: content
    ))
  }
}

struct SheetController<InnerContent: View>: ViewModifier {
  @Environment(\.dismiss) private var dismiss

    //  public var by: Binding<Bool>
  @Binding var by: Bool
  let title: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
    //  let hideKeyboard: (() -> Void)?
  var innerContent: () -> InnerContent

  init(
    by: Binding<Bool>,
    title: String = "",
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    //    hideKeyboard: (() -> Void)? = nil,
    @ViewBuilder innerContent: @escaping () -> InnerContent
  ) {
    self._by = by
    self.title = title
    self.icon = icon
    self.confirm = confirm
    self.action = action
      //    self.hideKeyboard = hideKeyboard
    self.innerContent = innerContent
  }

  public func body (content: Content) -> some View {
    let caption = NSLocalizedString(title, comment: "")

    return content
      .sheet(isPresented: $by) {
        SheetWrapper(
          caption: caption,
          icon: icon,
          confirm: confirm,
          action: action,
          //          hideKeyboard: hideKeyboard
        ) {
          innerContent()
        }
      }
  }
}

struct SheetWrapper<Content: View>: View {
  @Environment(\.dismiss) private var dismiss

  let caption: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
    //  let hideKeyboard: (() -> Void)?
  var content: () -> Content

  init(
    caption: String = "",
    icon: String = "",
    confirm: String = NSLocalizedString("action:done", tableName: "Application", comment: "Done"),
    action: (() -> Void)? = nil,
    //    hideKeyboard: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.caption = caption
    self.icon = icon
    self.confirm = confirm
    self.action = action
      //    self.hideKeyboard = hideKeyboard
    self.content = content
  }

    //  func dismissKeyboard() {
    //    UIApplication.shared.sendAction(
    //      #selector(UIResponder.resignFirstResponder),
    //      to: nil,
    //      from: nil,
    //      for: nil
    //    )
    //  }

  var body: some View {
    let done = NSLocalizedString("action:done", tableName: "Application", comment: "Done")
    let close = NSLocalizedString("action:close", tableName: "Application", comment: "Close")
    let keyboardHide = NSLocalizedString("keyboard:hide", tableName: "Application", comment: "Keyboard hide")

    NavigationStack {
      content()
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button(close, systemImage: "xmark") { dismiss() }
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

            //          if hideKeyboard != nil {
          ToolbarItemGroup(placement: .keyboard) {
            Button(action: dismissKeyboard ) {
              Label(keyboardHide, systemImage: "keyboard.chevron.compact.down")
            }
          }
            //          }
        }
        .navigationTitle(caption)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
    .presentationSizing(.page.sticky(horizontal: false, vertical: true))
    .presentationDragIndicator(.visible)
  }
}

#Preview {
  @Previewable @State var showingSheet: Bool = false

  Button("Test button") { showingSheet.toggle() }
    .sheetController(by: $showingSheet, title: "test sheet", icon: "ellipsis.circle") {
      let title = String(localized: "app:hello-world", bundle: .module)
      Text(title)
    }
}

@MainActor func dismissKeyboard() {
  UIApplication.shared.sendAction(
    #selector(UIResponder.resignFirstResponder),
    to: nil,
    from: nil,
    for: nil
  )
}
