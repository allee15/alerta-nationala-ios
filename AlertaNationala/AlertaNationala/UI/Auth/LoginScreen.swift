//
//  LoginScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavBarView(isCloseButton: true)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Bine ai revenit!")
                        .font(.poppinsSemiBold(size: 36))
                        .foregroundStyle(Color.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Introdu email-ul si parola aferente contului tau pentru a te autentifica in aplicatie.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    FloatingField(text: $viewModel.email,
                                  placeHolder: "Adresa de email",
                                  leftIcon: .icFieldEmail,
                                  errorMessage: viewModel.errorMessageEmail)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    
                    FloatingField(text: $viewModel.password,
                                  placeHolder: "Parola",
                                  secureField: true,
                                  leftIcon: .icFieldPassword,
                                  errorMessage: viewModel.errorMessagePassword)
                        .padding(.top, 12)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                    
                    PrimaryButton(text: "Login") {
                        viewModel.login()
                    }.padding(.top, 12)
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
            
        }.background(Color.bgPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .safeAreaInset(edge: .bottom, content: {
                SecondaryButton(text: "Creeaza cont") {
                    navigation.push(RegisterScreen().asDestination(), animated: true)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 20)
            })
            .onChange(of: viewModel.email) { _, _ in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { _, _ in
                viewModel.errorMessagePassword = nil
            }
            .onReceive(viewModel.loginCompletion) { loginCompletion in
            switch loginCompletion {
            case .failure(_):
                let modal = ModalChooseOptionView(title: "Eroare",
                                      description: "A aparut o eroare, te rog sa incerci inca o data.",
                                                  topButtonText: "Reincearca") {
                    navigation.dismissModal(animated: true, completion: nil)
                }
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
            case .login:
                navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
            }
        }
    }
}

#Preview {
    LoginScreen()
}
