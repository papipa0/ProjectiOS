//
//  CustomTabBar.swift
//  Manage_App
//
//  Created by Pare on 4/4/2566 BE.
//

import SwiftUI



    
struct CustomTabBar: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            Home()
            HStack(spacing: 0){
                
            }
        }
    }
}
//tab

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
        //CustomTabBar(selectedTab: .constant(.house))
    }
}
