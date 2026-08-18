//
//  TabBarViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import Combine

class TabBarViewModel: ObservableObject {
    @Published var selectedTabItem: TabBarItemType
    @Published var tabBarItems: [TabBarItem]
    
    public var oldSelectedTab: TabBarItemType
    
    init() {
        self.selectedTabItem = .home
        self.oldSelectedTab = .home
        
        tabBarItems = [
            homeTabBarItem,
            searchTabBarItem,
            chatsTabBarItem,
            profileNewsTabBarItem
        ]
    }
}

