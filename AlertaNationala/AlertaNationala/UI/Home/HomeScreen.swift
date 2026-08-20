//
//  HomeScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 0) {
            FullNavBarView(title: "Acasa",
                           hasBackButton: false,
                           rightButtonIcon: .icMenu) {
                
            } rightButtonAction: {
                mainNavigation?.push(ProfileScreen().asDestination(), animated: true)
            }
            
            Text("Home/alerts screen")
                .foregroundStyle(Color.white)
            Spacer(minLength: 80)
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

#Preview {
    HomeScreen()
}
