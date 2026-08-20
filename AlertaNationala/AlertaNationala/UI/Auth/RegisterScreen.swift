//
//  RegisterScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI

struct RegisterScreen: View {
    @StateObject var viewModel = RegisterViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: RegisterField?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavBarView()
            
            StepIndicatorView(currentStep: 1, totalSteps: 2)
                .padding(.horizontal, 16)
                .padding(.top, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Creeaza-ti cont")
                        .font(.poppinsSemiBold(size: 36))
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Introdu-ti detaliile mai jos.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 12) {
                        FloatingField(text: $viewModel.name,
                                      placeHolder: "Name",
                                      leftIcon: .icFieldAccount,
                                      errorMessage: viewModel.errorMessageName)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        
                        FloatingField(text: $viewModel.email,
                                      placeHolder: "Email address",
                                      leftIcon: .icFieldEmail,
                                      errorMessage: viewModel.errorMessageEmail)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                        
                        FloatingField(text: $viewModel.password,
                                      placeHolder: "Password",
                                      secureField: true,
                                      leftIcon: .icFieldPassword,
                                      errorMessage: viewModel.errorMessagePassword)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                        
                        PrimaryButton(text: "Continua") {
                            if viewModel.firstFieldsAreComleted() {
                                navigation.push(RegisterStep2Screen(viewModel: viewModel).asDestination(), animated: true)
                            }
                        }
                    }
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.name) { _, _ in
                viewModel.errorMessageName = nil
            }
            .onChange(of: viewModel.email) { _, _ in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { _, _ in
                viewModel.errorMessagePassword = nil
            }
    }
}

struct RegisterStep2Screen: View {
    @ObservedObject var viewModel: RegisterViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavBarView()
            
            StepIndicatorView(currentStep: 2, totalSteps: 2)
                .padding(.horizontal, 16)
                .padding(.top, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Creeaza-ti cont")
                        .font(.poppinsSemiBold(size: 36))
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Introdu-ti detaliile mai jos.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 12) {
                        SelectZonesView(selectedZones: $viewModel.selectedZones, zonesList: viewModel.zones, errorMessage: viewModel.errorMessZone)
                        
                        PrimaryButton(text: "Creeaza cont") {
                            viewModel.allFieldAreCompleted()
                        }
                    }
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.selectedZones) { _, _ in
                viewModel.errorMessZone = nil
            }
            .onReceive(viewModel.registerCompletion) { registerCompletion in
                switch registerCompletion {
                case .failure(_):
                    let modal = ModalChooseOptionView(title: "Eroare",
                                                      description: "A aparut o eroare, te rog sa incerci inca o data.",
                                                      topButtonText: "Reincearca") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                case .register:
                    navigation.push(LoginScreen().asDestination(), animated: true)
                }
            }
    }
}

struct StepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.textPrimary)
                    .frame(height: 4)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.blueSecondary)
                    .frame(
                        width: geometry.size.width * (CGFloat(currentStep) / CGFloat(totalSteps)),
                        height: 4
                    )
            }
        }
        .frame(height: 4)
    }
}
