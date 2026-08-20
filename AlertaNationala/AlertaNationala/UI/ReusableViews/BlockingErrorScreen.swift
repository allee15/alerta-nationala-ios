//
//  BlockingErrorScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct BlockingErrorScreen: View {
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("A aparut o eroare")
                .foregroundColor(.black)
                .font(.poppinsSemiBold(size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Text("A aparut o eroare la preluarea datelor de pe server. Va rugam sa verificati conexiunea la internet si sa incercati din nou. Daca problema persista, va rugam sa ne contactati.")
                .foregroundColor(.black)
                .font(.poppinsRegular(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgPrimary)
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(text: "Reincearca") {
                    action()
                }.padding([.bottom, .horizontal], 16)
            }
    }
}
