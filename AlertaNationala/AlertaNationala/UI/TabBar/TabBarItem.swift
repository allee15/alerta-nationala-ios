//
//  TabBarItem.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import SwiftUI

enum TabBarItemType: Equatable {
    case home
    case maps
    case guides
}

struct TabBarItem {
    let type: TabBarItemType
    let title: String
    let imageName: ImageResource
}

let homeTabBarItem = TabBarItem(
    type: .home,
    title: "Acasa",
    imageName: .icHome
)

let mapsTabBarItem = TabBarItem(
    type: .maps,
    title: "Harta",
    imageName: .icFieldMapPin
)

let guidesTabBarItem = TabBarItem(
    type: .guides,
    title: "Ghiduri",
    imageName: .icGuide
)

struct TabBarItemView: View {
    let tabBarItem: TabBarItem
    let isSelected: Bool
    let selectAction: (TabBarItem) -> ()
    
    var body: some View {
        Button {
            selectAction(tabBarItem)
        } label: {
            VStack(spacing: 4) {
                Image(tabBarItem.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? Color(hex: "#0B0F14") : Color.textSecondary)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                
                Text(tabBarItem.title)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(isSelected ? Color(hex: "#0B0F14") : Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 0.5)
                            )
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 2)
                    }
                }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
    }
}

struct TabBarView: View {
    @Binding var selectedItem: TabBarItemType
    let items: [TabBarItem]
    
    var body: some View {
        HStack {
            ForEach(items, id: \.type) { item in
                TabBarItemView(
                    tabBarItem: item,
                    isSelected: selectedItem == item.type) { tabBarItem in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedItem = item.type
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 2)
                .overlay(alignment: .top) {
                    Capsule()
                        .fill(Color.white.opacity(0.35))
                        .frame(height: 1)
                        .padding(.horizontal, 24)
                        .padding(.top, 0.5)
                }
        )
        .padding(.horizontal, 14)
        .padding(.bottom, -8)
    }
}
