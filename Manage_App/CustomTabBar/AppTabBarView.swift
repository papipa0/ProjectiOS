//
//  AppTabBarView.swift
//  Manage_App


import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home
    @Binding  var showSignInView: Bool 
   
    

    var body: some View {
    
        TabBarContainerView(selection: $tabSelection){
          
            PlaceView()
              .tabBarItem(tab: .home, selection: $tabSelection)
            
            
            Sharewithme()
            .tabBarItem(tab: .item, selection: $tabSelection)
            
            
            SearchView()
            .tabBarItem(tab: .search, selection: $tabSelection)
            
              
            SettingsView(showSignInView: $showSignInView)
          
              .tabBarItem(tab: .setting, selection: $tabSelection)
           
            
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
  
    static var previews: some View {
        AppTabBarView(showSignInView: .constant(false))
    }
}

extension AppTabBarView{
    
    private var defaultTabView: some View{
        TabView(selection: $selection)
        {
            Color.red
            //Home()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            Color.blue
            
                .tabItem{
                    Image(systemName: "shippingbox")
                    Text("Item")
                }
            Color.orange
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            Color.brown
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Setting")
                }
           
        }
    }
}
