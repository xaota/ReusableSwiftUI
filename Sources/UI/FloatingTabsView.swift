//
//  FloatingTabsView.swift
//  Reusable -> UI -> FloatingTabsView
//
//  Created by Rinat Ibragimov on 14.11.2025.
//

import SwiftUI

public struct FloatingTabsView: View {
  let tabs: [FloatingTab]
  @Binding var selectedIndex: Int

  @Namespace private var tabItemTransition

  public init(
    tabs: [FloatingTab],
    selectedIndex: Binding<Int>
  ) {
    self.tabs = tabs
    self._selectedIndex = selectedIndex
  }

  public var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(tabs.indices, id: \.self) { index in
        let tab = tabs[index]
        Tab(tab.name, systemImage: tab.icon ?? "", value: index) {
          tab.content()
        }
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .overlay(alignment: .bottom) {
      ScrollViewReader { scrollView in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            // Place your tab bar items here if needed, using tabs.indices
             ForEach(tabs.indices, id: \.self) { index in
               let tab = tabs[index]
               FloatingTabView(
                tab: tab,
                isActive: selectedIndex == index,
                namespace: tabItemTransition
               )
               .padding(.leading, index == 0 ? 8 : 0)
               .padding(.trailing, index == tabs.count - 1 ? 8 : 0)
               .onTapGesture {
                 withAnimation(.easeInOut) {
                   selectedIndex = index
                 }
               }
             }
          }
        }
        .onChange(of: selectedIndex) { index in
          withAnimation {
            scrollView.scrollTo(index, anchor: .center)
          }
        }
//        .padding(8)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .padding(.horizontal)
      }
    }
  }
}

public struct FloatingTab {
  public var name: String
  public var icon: String?
  var content: () -> AnyView

  // Public initializer that accepts any View and erases it internally
  public init<V: View>(_ name: String, icon: String? = nil, @ViewBuilder content: @escaping () -> V) {
    self.name = name
    self.icon = icon
    self.content = { AnyView(content()) }
  }
}

struct FloatingTabView: View {
  var tab: FloatingTab
  var isActive: Bool = false
  let namespace: Namespace.ID

  let foreground = Color(uiColor: UIColor.label)
  let accent = Color.accentColor

  var body: some View {
    if isActive {
      Text(tab.name)
        .font(.subheadline)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .foregroundColor(.white)
        .background(Capsule().foregroundColor(accent))
        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
    } else {
      Text(tab.name)
        .font(.subheadline)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .foregroundColor(foreground)
    }
  }
}

#Preview {
  @Previewable @State var selectedIndex: Int = 0

  let tabs: [FloatingTab] = [
    FloatingTab("Операции", icon: "star") {
      Text("список платежей")
    },
    FloatingTab("Деньги") {
      Text("список кошельков")
    },
    FloatingTab("Категории", icon: "star") {
      Text("список категорий")
    },
    FloatingTab("Метки", icon: "star") {
      Text("список меток")
    }
  ]

  FloatingTabsView(tabs: tabs, selectedIndex: $selectedIndex)
}
