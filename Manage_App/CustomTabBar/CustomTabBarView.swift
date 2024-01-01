//
//  CustomTabBarView.swift


import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    
    @Binding var selection: TabBarItem
  
    var body: some View {
        tabBarVersion1
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .home, .item, .search, .setting
    ]
    
    static var previews: some View {
        VStack{
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!))
        }
    }
}

extension CustomTabBarView{
    
    private func tabView(tab: TabBarItem) -> some View{
        VStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 12,weight: .bold,design: .rounded))
        }
        .foregroundColor(selection == tab ? tab.color : Color.gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
       .background(selection == tab ? tab.color.opacity(0.2) :Color.clear)
        .cornerRadius(10)
    }
    
    private var tabBarVersion1: some View{
        HStack {
        ForEach(tabs, id: \.self) { tab in
            tabView(tab: tab)
                .onTapGesture {
                    switchToTab(tab: tab)
                }
        }
    }
    .padding(6)
    .background(Color.white.ignoresSafeArea(edges:.bottom))
    
    }
    
    private func switchToTab(tab: TabBarItem){
        withAnimation(.easeOut){
            selection = tab
        }
    }
}

extension CustomTabBarView {
    
    private func tabView2(tab: TabBarItem) -> some View{
        VStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 12,weight: .bold,design: .rounded))
        }
        .foregroundColor(selection == tab ? tab.color : Color.gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
      //  .background(selection == tab ? tab.color.opacity(0.2) :Color.clear)
        .cornerRadius(10)
    }
    
    private var tabBarVersion2: some View{
        HStack {
        ForEach(tabs, id: \.self) { tab in
            tabView(tab: tab)
                .onTapGesture {
                    switchToTab(tab: tab)
                }
        }
    }
    .padding(6)
    .background(Color.white.ignoresSafeArea(edges:.bottom))
    
    }
}
