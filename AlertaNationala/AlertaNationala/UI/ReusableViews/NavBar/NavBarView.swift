//
//  NavBarView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct NavBarView: View {
    var isCloseButton: Bool = false
    
    var body: some View {
        HStack {
            if isCloseButton {
                CloseButton()
            } else {
                BackButton()
            }
            Spacer()
        }.padding(.horizontal, 12)
    }
}
