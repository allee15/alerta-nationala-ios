//
//  LeftNavBar.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct LeftNavBarView: View {
    let title: String
    var isCloseButton: Bool = false
    var hasBackButton: Bool = true
    let backAction: () -> ()
    
    var body: some View {
        HStack {
            BackButton {
                backAction()
            }.opacity(hasBackButton ? 1 : 0)
            
            Spacer()
            
            TitleNavBarView(title: title)
            
            Spacer()
            
            BackButton {
                backAction()
            }.opacity(0)
        }.padding([.horizontal, .bottom], 16)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 0)
            .zIndex(1)
    }
}

struct FullNavBarView: View {
    let title: String
    var isCloseButton: Bool = false
    var hasBackButton: Bool = true
    let rightButtonIcon: ImageResource
    let backAction: () -> ()
    let rightButtonAction: () -> ()
    
    var body: some View {
        HStack {
            BackButton {
                backAction()
            }.opacity(hasBackButton ? 1 : 0)
            
            Spacer()
            
            TitleNavBarView(title: title)
            
            Spacer()
            
            Button {
                rightButtonAction()
            } label: {
                Image(rightButtonIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: 24, height: 24)
            }
        }.padding([.horizontal, .bottom], 16)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.bgPrimary)
            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 0)
            .zIndex(1)
    }
}
