//
//  EditZonesScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import SwiftUI

struct EditZonesScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                TitleNavBarView(title: "Zone de interes")
                Spacer()
            }
            
            Text("Edit zones screen")
                .foregroundStyle(Color.white)
            Spacer(minLength: 80)
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

#Preview {
    EditZonesScreen()
}
