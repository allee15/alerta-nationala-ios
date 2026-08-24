//
//  HomeScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            FullNavBarView(title: "Acasa",
                           hasBackButton: false,
                           rightButtonIcon: .icMenu) {
                
            } rightButtonAction: {
                mainNavigation?.push(ProfileScreen().asDestination(), animated: true)
            }
            
            if viewModel.isLoading {
                Spacer()
                LoaderView()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        if !viewModel.alerts.isEmpty {
                            ForEach(viewModel.alerts) { alert in
                                Button {
                                    let vm = AlertDetailsViewModel(alert: alert)
                                    mainNavigation?.push(AlertDetailsScreen(viewModel: vm).asDestination(), animated: true)
                                } label: {
                                    AlertCardView(alert: alert)
                                }
                            }
                        } else {
                            Text("Nu exista alerte de afisat!")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                        }
                        
                        if !viewModel.warnings.isEmpty {
                            Text("Avertizari meteo oficiale (ANM):")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                            
                            ForEach(viewModel.warnings, id: \.zoneName) { warning in
                                WarningCardView(warning: warning)
                            }
                        } else {
                            Text("Nu exista avertizari meteo de afisat!")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                        }
                        
                        if !viewModel.weather.isEmpty {
                            Text("Prognoza meteo:")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                            
                            ForEach(viewModel.weather, id: \.zoneName) { zone in
                                WeatherCardView(zone: zone)
                            }
                        } else {
                            Text("Nu exista prognoze meteo de afisat!")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                        }
                        
                    }
                    .padding([.top, .horizontal], 16)
                    .padding(.bottom, 32 + SafeAreaInsets.bottom)
                }
            }
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    }
}

fileprivate struct AlertCardView: View {
    let alert: NationalAlert
    
    var color: Color {
        switch alert.severity {
        case .informare:
            return .greenBadge
        case .atentionare:
            return .yellowBadge
        case .pericol:
            return .redBadge
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(alert.type.displayName)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Text(alert.severity.displayName)
                    .font(.poppinsRegular(size: 12))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(color)
                    .clipShape(Capsule())
            }
            
            Text(alert.message)
                .font(.poppinsRegular(size: 12))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.all, 12)
        .border(Color.blueSecondary, width: 1.5, cornerRadius: 12)
    }
}

fileprivate struct WeatherCardView: View {
    let zone: ZoneWeather
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(zone.zoneName)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Text(zone.isSevere ? "Severitate ridicata" : "Severitate scazuta")
                    .font(.poppinsRegular(size: 12))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.offline)
                    .clipShape(Capsule())
            }
            
            Text(zone.description)
                .font(.poppinsSemiBold(size: 12))
                .foregroundStyle(Color.textSecondary)
            
            Text("\(Int(zone.temperature))°C")
                .font(.poppinsBold(size: 16))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.all, 12)
        .border(Color.meteo, width: 1.5, cornerRadius: 12)
    }
}

fileprivate struct WarningCardView: View {
    let warning: WeatherWarning
    
    var color: Color {
        switch warning.color {
        case .yellow: return .yellowBadge
        case .orange: return .orange
        case .red: return .redBadge
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(warning.zoneName)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
            }
            
            Text(warning.event)
                .font(.poppinsSemiBold(size: 12))
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color)
                .clipShape(Capsule())
            
            Text("Valabila pana la \(warning.expires.formatted(date: .abbreviated, time: .shortened))")
                .font(.poppinsBold(size: 14))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.all, 12)
        .border(Color.meteo, width: 1.5, cornerRadius: 12)
    }
}

#Preview {
    HomeScreen()
}
