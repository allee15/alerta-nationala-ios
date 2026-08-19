//
//  PrimaryButton.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 19/08/2026.
//

import SwiftUI

struct PrimaryButton: View {
    
    let text: String
    let icon: ImageResource?
    let displayIconInRight: Bool
    let isDisabled: Bool
    let isLoading: Bool
    let onTap: () -> ()
    
    init(
        text: String,
        icon: ImageResource? = nil,
        displayIconInRight: Bool = false,
        isDisabled: Bool? = nil,
        isLoading: Bool? = nil,
        onTap: @escaping () -> Void
    ) {
        self.text = text
        self.icon = icon
        self.displayIconInRight = displayIconInRight
        self.isDisabled = isDisabled ?? false
        self.isLoading = isLoading ?? false
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            if !isLoading {
                onTap()
            }
        } label: {
            VStack(spacing: 0) {
                if !isLoading {
                    HStack(spacing: 10) {
                        Spacer()
                        if let icon {
                            Image(icon)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 18, height: 18)
                        }
                        Text(text)
                            .foregroundColor(.textPrimary)
                            .font(.poppinsRegular(size: 16))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                    }
                } else {
                    LoaderView(height: 24, width: 24)
                }
            }
            .frame(height: 48)
            .background(isDisabled ? Color.offline : Color.bluePrimary)
            .cornerRadius(16, corners: [.topLeft, .bottomRight])
        }.disabled(isDisabled || isLoading)
    }
}
