//
//  AlertDetailsScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import SwiftUI

struct AlertDetailsScreen: View {
    @StateObject var viewModel: AlertDetailsViewModel
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: viewModel.alert.type.displayName, hasBackButton: true) {
                mainNavigation?.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.alert.severity.displayName)
                        .foregroundStyle(Color.textPrimary)
                        .font(.poppinsBold(size: 24))
                    
                    Text(viewModel.alert.message)
                        .foregroundStyle(Color.textSecondary)
                        .font(.poppinsRegular(size: 16))
                    
                    Text("Zone: \(viewModel.alert.zones.joined(separator: ", "))")
                        .foregroundStyle(Color.textSecondary)
                        .font(.poppinsRegular(size: 16))
                    
                    Text("Valabila pana la: \(viewModel.alert.endsAt.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundStyle(Color.redBadge)
                        .font(.poppinsRegular(size: 16))
                    
                    if viewModel.alert.status == .active {
                        PrimaryButton(
                            text: viewModel.hasCheckedIn ? "Confirmat: Sunt in siguranta" : "Sunt in siguranta",
                            isDisabled: viewModel.hasCheckedIn
                        ) {
                            viewModel.checkIn()
                        }
                    }
                }.padding([.top, .horizontal], 16)
            }
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

