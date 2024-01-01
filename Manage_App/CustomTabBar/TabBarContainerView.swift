//
//  TabBarContainerView.swift
//  Manage_App

import SwiftUI



struct TabBarContainerView<Content:View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content){
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0){
            ZStack {
                content
            }
            CustomTabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsKey.self, perform: { value in
            self.tabs = value
        })
    }
}
struct TabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .home, .item, .search, .setting
    ]
    
    static var previews: some View {
        TabBarContainerView(selection: .constant(tabs.first!)){
          //  Color.red
            Home()
        } 
    }
}
