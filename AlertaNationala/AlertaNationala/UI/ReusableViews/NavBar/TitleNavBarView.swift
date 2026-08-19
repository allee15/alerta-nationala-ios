//
//  TitleNavBarView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct TitleNavBarView: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundColor(.textPrimary)
                .font(.poppinsBold(size: 20))
                
            Spacer()
        }
    }
}
