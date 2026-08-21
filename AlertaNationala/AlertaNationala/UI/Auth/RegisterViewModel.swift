//
//  RegisterViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import Foundation
import UIKit
import Combine

enum RegisterCompletion {
    case register
    case failure(Error)
}

enum RegisterField {
    case name
    case email
    case password
}

class RegisterViewModel: BaseViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var errorMessageName: String?
    @Published var errorMessageGender: String?
    @Published var errorMessageEmail: String?
    @Published var errorMessagePassword: String?
    
    @Published var zones: [String] = Judete.names
    @Published var selectedZones: [String] = []
    @Published var errorMessZone: String?
    
    let registerCompletion = PassthroughSubject<RegisterCompletion, Never>()
    var userService = UserService.shared
    
    func firstFieldsAreComleted() -> Bool {
        if name.isEmpty {
            self.errorMessageName = "Acest camp este obligatoriu."
        }
        
        if !email.isValidEmail() {
            self.errorMessageEmail = "Introdu o adresa de email valida."
        }
        
        if password.isEmpty {
            self.errorMessagePassword = "Acest camp este obligatoriu."
        } else if password.count < 6 {
            self.errorMessagePassword = "Parola trebuie sa contina minim 6 caractere."
        }
        
        if errorMessageName == nil && errorMessageGender == nil && errorMessageEmail == nil, errorMessagePassword == nil {
            return true
        }
        return false
    }
    
    func allFieldAreCompleted() {
        if selectedZones.isEmpty {
            self.errorMessZone = "Acest camp este obligatoriu."
        }
        
        if errorMessZone == nil {
            self.register()
        }
    }
    
    private func register() {
        userService.register(email: email, password: password, zones: selectedZones)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.registerCompletion.send(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.registerCompletion.send(.register)
            }
            .store(in: &bag)
    }
}

