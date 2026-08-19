//
//  DividerView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.bluePrimary)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    DividerView()
}
