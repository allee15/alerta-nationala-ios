//
//  BottomSheetLineView.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import SwiftUI

struct BottomSheetLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.bottomSheetLine)
            .frame(width: 36, height: 6)
            .cornerRadius(72, corners: .allCorners)
    }
}
