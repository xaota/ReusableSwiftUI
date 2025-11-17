//
//  FloatingTabsView.swift
//  Reusable -> UI -> FloatingTabsView
//
//  Created by Rinat Ibragimov on 14.11.2025.
//

import SwiftUI

public struct FloatingTab {
  public var name: String
  public var icon: String?
  var content: () -> AnyView

  public init<V: View>(_ name: String, icon: String? = nil, @ViewBuilder content: @escaping () -> V) {
    self.name = name
    self.icon = icon
    self.content = { AnyView(content()) }
  }
}

public struct FloatingTabsView: View {
  let tabs: [FloatingTab]
  @Binding var selectedIndex: Int
  @Binding var showTabBar: Bool

  @Namespace private var highlightmenuitem

  @State private var offset: CGFloat = -12
  @State private var opacity: Double = 1

  public init(
    tabs: [FloatingTab],
    selectedIndex: Binding<Int>,
    showTabBar: Binding<Bool> = .constant(true)
  ) {
    self.tabs = tabs
    self._selectedIndex = selectedIndex
    self._showTabBar = showTabBar
  }

  public var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(tabs.indices, id: \.self) { index in
        let tab = tabs[index]

        Tab(tab.name, systemImage: tab.icon ?? "", value: index) {
          tab
            .content()
            .toolbar(.hidden, for: .tabBar)
        }
      }
    }
    // .tabViewStyle(.page(indexDisplayMode: .never))
    .safeAreaInset(edge: .bottom) { // .overlay(alignment: .bottom) {
      FloatingTabsPanel(tabs: tabs, selectedIndex: $selectedIndex, highlightmenuitem: highlightmenuitem)
        .offset(y: offset)
        .opacity(opacity)
    }
    .onChange(of: showTabBar) { value in
      withAnimation() {
        offset = value ? -12 : 50
        opacity = value ? 1 : 0
      }
    }
  }
}

struct FloatingTabsPanel: View {
  var tabs: [FloatingTab]
  @Binding var selectedIndex: Int
  let highlightmenuitem: Namespace.ID

  var body: some View {
    ScrollViewReader { scrollView in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(tabs.indices, id: \.self) { index in
            let tab = tabs[index]

            FloatingTabView(
              tab: tab,
              isActive: selectedIndex == index,
              namespace: highlightmenuitem
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
      .padding(.vertical, 8)
      // .background(.ultraThinMaterial)
      .glassEffect()
      .cornerRadius(32)
      .padding(.horizontal)
      .padding(.horizontal)
    }
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
        .lineLimit(1).fixedSize()
        .font(.subheadline)
        .padding()
//        .padding(.horizontal)
//        .padding(.vertical, 8)
        .foregroundColor(.white)
        .background(Capsule().foregroundColor(accent))
        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
    } else {
      Text(tab.name)
        .lineLimit(1).fixedSize()
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
      NavigationStack {
        List {
          Text("список платежей")
        }
        .navigationTitle("Операции")
      }
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
