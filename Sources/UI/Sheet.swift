import SwiftUI

extension View {
  public func sheetController<InnerContent: View> (
    _ title: String = "",
    by: Binding<Bool>,
    icon: String = "",
    confirm: String = "",
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    height: Binding<PresentationDetent> = .constant(.adaptive),
    onDismiss: @escaping (() -> Void) = {},
    @ViewBuilder content: @escaping () -> InnerContent
  ) -> some View {
    sheet(isPresented: by, onDismiss: onDismiss) {
      SheetHost(
        caption: NSLocalizedString(title, comment: ""),
        icon: icon,
        confirm: confirm,
        action: action,
        interactiveDismiss: interactiveDismiss,
        height: height,
        content: content
      )
    }
  }

  /// Вариант sheetController, управляемый optional-значением (в духе новых
  /// alert(item:)/confirmationDialog(item:) из SDK 27): шторка показана, пока
  /// значение не nil, и получает его в content.
  public func sheetController<Item: Identifiable, InnerContent: View> (
    _ title: String = "",
    item: Binding<Item?>,
    icon: String = "",
    confirm: String = "",
    action: (() -> Void)? = nil,
    interactiveDismiss: Bool = true,
    height: Binding<PresentationDetent> = .constant(.adaptive),
    onDismiss: @escaping (() -> Void) = {},
    @ViewBuilder content: @escaping (Item) -> InnerContent
  ) -> some View {
    sheet(item: item, onDismiss: onDismiss) { value in
      SheetHost(
        caption: NSLocalizedString(title, comment: ""),
        icon: icon,
        confirm: confirm,
        action: action,
        interactiveDismiss: interactiveDismiss,
        height: height
      ) {
        content(value)
      }
    }
  }
}

/// Общее содержимое шторки для обоих вариантов sheetController:
/// оборачивает контент в SheetWrapper и подгоняет высоту под содержимое.
private struct SheetHost<InnerContent: View>: View {
  let caption: String
  let icon: String
  let confirm: String
  let action: (() -> Void)?
  let interactiveDismiss: Bool
  @Binding var height: PresentationDetent
  var content: () -> InnerContent

  @State private var contentHeight: CGFloat = .zero

  init(
    caption: String,
    icon: String,
    confirm: String,
    action: (() -> Void)?,
    interactiveDismiss: Bool,
    height: Binding<PresentationDetent>,
    @ViewBuilder content: @escaping () -> InnerContent
  ) {
    self.caption = caption
    self.icon = icon
    self.confirm = confirm.isEmpty ? String(localized: "action:done", bundle: .module) : confirm
    self.action = action
    self.interactiveDismiss = interactiveDismiss
    self._height = height
    self.content = content
  }

  var body: some View {
    SheetWrapper(
      caption: caption,
      icon: icon,
      confirm: confirm,
      action: action,
      interactiveDismiss: interactiveDismiss
    ) {
      content()
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

  @ToolbarContentBuilder
  private func confirmItem(action: @escaping () -> Void) -> some ToolbarContent {
    ToolbarItem(placement: .confirmationAction) {
      if icon.isEmpty {
        Button(confirm, action: action)
      } else {
        Button(role: .confirm, action: action) {
          Label(confirm, systemImage: icon)
        }
      }
    }
  }

  var body: some View {
    NavigationStack {
      content()
        .toolbar {
          if interactiveDismiss {
            ToolbarItem(placement: .cancellationAction) {
              Button(role: .close) {
                dismiss()
              }
            }
          }

          if let action {
            // Кнопка подтверждения не должна уезжать в overflow-меню
            confirmItem(action: action).highVisibilityPriority()
          }
        }
        .navigationTitle(caption)
        .inlineNavigationTitle()
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
