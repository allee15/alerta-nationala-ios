//
//  GuidesScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI

struct GuidesScreen: View {
    private let mainNavigation = EnvironmentObjects.navigation
    @StateObject private var viewModel = GuidesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                TitleNavBarView(title: "Ghiduri de urgenta")
                Spacer()
            }
            
            if viewModel.guides.isEmpty {
                Spacer()
                Text("Ghidurile se descarca la prima conectare la internet.")
                    .foregroundStyle(Color.textPrimary)
                    .font(.poppinsBold(size: 16))
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.guides, id: \.id) { guide in
                            WidgetView(title: guide.categoryDisplayName, icon: .icGuideItem) {
                                mainNavigation?.push(GuideDetailsScreen(guide: guide).asDestination(), animated: true)
                            }
                        }
                    }
                    .padding([.top, .horizontal], 16)
                    .padding(.bottom, 32 + SafeAreaInsets.bottom + 12)
                }
            }
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

#Preview {
    GuidesScreen()
}
