import SwiftUI

extension View {
  public func sheetController<InnerContent: View> (
    _ title: String = "",
    by: Binding<Bool>,
    icon: String = "",
    confirm: String = "",
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    height: Binding<PresentationDetent> = .constant(.large),
    onDismiss: @escaping (() -> Void) = {},
    @ViewBuilder content: @escaping () -> InnerContent
  ) -> some View {
    modifier(SheetController(
      by: by,
      title: title,
      icon: icon,
      confirm: confirm.isEmpty ? String(localized: "action:done", bundle: .module) : confirm,
      action: action,
      interactiveDismiss: interactiveDismiss,
      height: height,
      onDismiss: onDismiss,
      innerContent: content
    ))
  }
}

struct SheetController<InnerContent: View>: ViewModifier {
  @Binding var by: Bool
  @Binding var height: PresentationDetent

  let title: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
  let interactiveDismiss: Bool
  let onDismiss: (() -> Void)
  var innerContent: () -> InnerContent

  @State private var contentHeight: CGFloat = .zero

  init(
    by: Binding<Bool>,
    title: String = "",
    icon: String = "",
    confirm: String = String(localized: "action:done", bundle: .module),
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    height: Binding<PresentationDetent>,
    onDismiss: @escaping (() -> Void) = {},
    @ViewBuilder innerContent: @escaping () -> InnerContent
  ) {
    self._by = by
    self.title = title
    self.icon = icon
    self.confirm = confirm
    self.action = action
    self.interactiveDismiss = interactiveDismiss
    self._height = height
    self.onDismiss = onDismiss
    self.innerContent = innerContent
  }

  public func body (content: Content) -> some View {
    let caption = NSLocalizedString(title, comment: "")

    return content
      .sheet(isPresented: $by, onDismiss: onDismiss) {
        SheetWrapper(
          caption: caption,
          icon: icon,
          confirm: confirm,
          action: action,
          interactiveDismiss: interactiveDismiss
        ) {
          innerContent()
            .onGeometryChange(for: CGSize.self) { proxy in
              proxy.size
            } action: {
              contentHeight = $0.height + 128
            }
        }
        .presentationSizing(.form)
        .presentationDragIndicator(interactiveDismiss ? .visible : .hidden)
        .interactiveDismissDisabled(!interactiveDismiss)
        .presentationDetents([height == .adaptive ? .height(contentHeight) : height])
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
  var content: () -> Content

  init(
    caption: String = "",
    icon: String = "",
    confirm: String = String(localized: "action:done", bundle: .module),
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = false,
    @ViewBuilder content: @escaping () -> Content,
  ) {
    self.caption = caption
    self.icon = icon
    self.confirm = confirm
    self.action = action
    self.interactiveDismiss = interactiveDismiss
    self.content = content
  }

  var body: some View {
    let done = String(localized: "action:done", bundle: .module)

    NavigationStack {
      content()
        .toolbar {
          if interactiveDismiss != false {
            ToolbarItem(placement: .cancellationAction) {
              Button(role: .close) {
                dismiss()
              }
            }
          }

          if action != nil {
            ToolbarItem(placement: .confirmationAction) {
              if icon.isEmpty {
                Button(done, action: action!)
              } else {
                // Button(action: action!) { Label(confirm, systemImage: icon) }
                Button(role: .confirm, action: action!) {
                  Label(confirm, systemImage: icon) // .labelStyle(.iconOnly)
                }
              }
            }
          }
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
      height: .constant(.adaptive),
      onDismiss: { print("dismiss") }
      // interactiveDismiss: false
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
}

extension PresentationDetent {
  public static let adaptive = Self.custom(AdaptiveDetent.self)
}

private struct AdaptiveDetent: CustomPresentationDetent {
  static func height(in context: Context) -> CGFloat? { 0 }
}
