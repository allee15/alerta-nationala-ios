//
//  GuideDetailsScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 25/08/2026.
//

import SwiftUI

struct GuideDetailsScreen: View {
    let guide: Guide
    
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: guide.title, hasBackButton: true) {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(guide.category)
                        .font(.poppinsRegular(size: 12))
                        .foregroundStyle(Color.textPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.greenBadge)
                        .clipShape(Capsule())
                    
                    Text(guide.summary)
                        .foregroundStyle(Color.textPrimary)
                        .font(.poppinsSemiBold(size: 16))
                    
                    ForEach(guide.sections, id: \.heading) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(guide.summary)
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsRegular(size: 16))
                            
                            ForEach(section.items, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Text("•")
                                        .foregroundStyle(Color.textPrimary)
                                    Text(item)
                                        .foregroundStyle(Color.textPrimary)
                                        .font(.poppinsRegular(size: 12))
                                }
                            }
                        }
                    }
                }
                .padding([.top, .horizontal], 16)
                .padding(.bottom, 32 + SafeAreaInsets.bottom + 12)
            }
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

