//
//  UnloggedUserView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import SwiftUI

struct UnloggedUserView: View {
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            Text("Please login to enjoy the full experience of ArtistsLand app!")
                .foregroundColor(.black)
                .font(.poppinsRegular(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            ClearButton(text: "Enter in your account") {
                mainNavigation?.push(HomeScreen().asDestination(), animated: true)
            }.padding(.bottom, 20)
                .padding(.horizontal, 20)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgPrimary)
    }
}
