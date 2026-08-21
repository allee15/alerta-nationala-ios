//
//  EditZonesScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import SwiftUI

struct EditZonesScreen: View {
    private let mainNavigation = EnvironmentObjects.navigation
    @StateObject private var viewModel = EditZonesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Zone de interes", hasBackButton: true) {
                mainNavigation?.pop(animated: true)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Alege judetele pentru care vrei sa primesti alerte.")
                    .foregroundStyle(Color.blueSecondary)
                    .font(.poppinsSemiBold(size: 16))
                
                SelectZonesView(selectedZones: $viewModel.selectedZones,
                                zonesList: viewModel.zones,
                                errorMessage: viewModel.errorMessage)
                
                Spacer()
                
                PrimaryButton(text: "Salveaza", isLoading: viewModel.isLoading) {
                    viewModel.updateZones()
                }.padding(.bottom, 20)
                
            }.padding([.top, .horizontal], 16)
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .onChange(of: viewModel.didSave) { _, _ in
                mainNavigation?.pop(animated: true)
            }
    }
}

#Preview {
    EditZonesScreen()
}
