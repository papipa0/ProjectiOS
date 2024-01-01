//
//  TabBarItem.swift
//  Manage_App

import SwiftUI

enum TabBarItem: Hashable {
    
    case home,item,search,setting
    
    var iconName: String{
        switch self {
        case .home: return "house"
        case .item: return "square.and.arrow.up"
        case .search: return "magnifyingglass"
        case .setting: return "gearshape"
            
        }
    }
    
    var title: String{
        switch self {
        case .home: return "Place"
        case .item: return "Share with me"
        case .search: return "Searchs"
        case .setting: return "Setting"
            
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.green
        case .item: return Color.blue
        case .search: return Color.red
        case .setting: return Color.purple
            
        }
    }
}


