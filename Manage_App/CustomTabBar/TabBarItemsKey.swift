//
//  TabBarItems.swift
//  Manage_App
//

import Foundation
import SwiftUI

struct TabBarItemsKey: PreferenceKey{
    
    static var defaultValue:  [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
    
}

struct TabBarItemModifer: ViewModifier{
    
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View{
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsKey.self, value: [tab])
    }
}

extension View {
    
    func tabBarItem(tab: TabBarItem, selection:Binding<TabBarItem>) -> some View{
       
            modifier(TabBarItemModifer(tab: tab, selection: selection))
    }
    
}
