//
//  GuidesScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI

struct GuidesScreen: View {
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                TitleNavBarView(title: "Ghiduri")
                Spacer()
            }
            
            Text("Guides screen")
                .foregroundStyle(Color.white)
            Spacer(minLength: 80)
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

#Preview {
    GuidesScreen()
}
