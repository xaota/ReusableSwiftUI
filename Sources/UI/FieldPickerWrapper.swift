//
//  SwiftUIView.swift
//  Reusable
//
//  Created by Rinat Ibragimov on 28.10.2025.
//

import SwiftUI

public struct FieldPickerWrapper<Content: View, PickerContent: View>: View {
  private var prompt: String
  private var icon: String
  private var isEmpty: Bool
  private var actionCreate: () -> Void = {}
  private var placeholderCreate: String
  private var iconCreate: String
  @ViewBuilder private let picker: () -> PickerContent
  @ViewBuilder private let content: () -> Content

  public init(
    _ prompt: String,
    icon: String = "house",
    isEmpty: Bool = false,
    actionCreate: @escaping () -> Void = {},
    placeholderCreate: String = "Добавить значение",
    iconCreate: String = "plus.app",
    @ViewBuilder picker: @escaping () -> PickerContent,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.prompt = prompt
    self.icon = icon
    self.isEmpty = isEmpty
    self.actionCreate = actionCreate
    self.placeholderCreate = placeholderCreate
    self.iconCreate = iconCreate
    self.picker = picker
    self.content = content
  }

  public var body: some View {
    HStack {
      Label(prompt, systemImage: icon)
      Spacer()

      if !isEmpty {
        Menu {
          Section {
            Button(action: actionCreate) {
              Label(placeholderCreate, systemImage: iconCreate)
            }

            // Button(action: actionShowAll) {
            //   Label("Показать все", systemImage: "building.columns")
            // }
          }
          // Divider()
          Section {
            content()
          }
        } label: {
          picker()
        }
      } else {
        Button(action: actionCreate) {
          picker()
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var value: String = ""

  let banks: [String] = ["Сбербанк", "Тинькофф", "Альфа-Банк"]

  FieldPickerWrapper(
    "Название",
    icon: "building.columns",
    picker: { Label("выбрать", systemImage: "chevron.right") }
  ) {
    ForEach(banks, id: \.self) { item in
      Button(action: { value = item }) {
        Text(item)
      }
    }
  }
  .padding(.horizontal)
}
