//
//  ClearButton.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct ClearButton: View {
    let text: String
    var colorText: Color = Color.textPrimary
    var bgColor: Color = Color.bgPrimary
    let action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                
                Text(text)
                    .font(.poppinsSemiBold(size: 14))
                    .foregroundColor(colorText)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth:.infinity)
                
                Spacer()
            }.padding(.vertical, 16)
                .background(bgColor)
                .cornerRadius(4, corners: .allCorners)
        }
    }
}
