//
//  SideButtonView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import SwiftUI

struct SideButtonView: View {
    let icon: ImageResource
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(icon)
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
