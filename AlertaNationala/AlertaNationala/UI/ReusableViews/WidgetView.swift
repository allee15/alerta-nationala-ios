//
//  WidgetView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import SwiftUI

struct WidgetView: View {
    let title: String
    let icon: ImageResource
    var showToggle: Bool = true
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if showToggle {
                    Image(.icItemresultArrow)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.textPrimary)
                }
            }.padding(.horizontal, 16)
                .padding(.vertical, 12)
                .border(Color.textSecondary, width: 1, cornerRadius: 8)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
        }
    }
}
