//
//  ProfileScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = ProfileViewModel()
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Profil", hasBackButton: true) {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    if viewModel.isLoading {
                        LoaderView(color: [Color.textPrimary])
                    } else if let user = viewModel.user {
                        WidgetView(title: "Schimba tema aplicatiei", icon: .icSystemTheme) {
                            navigation.push(ThemeSettingsScreen().asDestination(),
                                            animated: true)
                        }
                        
                        WidgetView(title: "Logout", icon: .icLogout) {
                            viewModel.logOut()
                        }
                        
                        WidgetView(title: "Editeaza zonele de interes", icon: .icFieldMapPin) {
                            navigation.push(EditZonesScreen().asDestination(), animated: true)
                        }
                    }
                }.padding(.top, 20)
            }
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .safeAreaInset(edge: .bottom) {
                if viewModel.user == nil {
                    PrimaryButton(text: "Login") {
                        mainNavigation?.push(LoginScreen().asDestination(), animated: true)
                    }.padding([.horizontal, .bottom], 16)
                }
            }
    }
}

#Preview {
    ProfileScreen()
}
