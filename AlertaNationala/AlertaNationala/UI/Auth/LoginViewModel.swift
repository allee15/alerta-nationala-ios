//
//  LoginViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import Foundation

import Foundation
import Combine

enum LoginCompletion {
    case login
    case failure(Error)
}

enum Field {
    case email
    case password
}

class LoginViewModel: BaseViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessageEmail: String?
    @Published var errorMessagePassword: String?
    
    let loginCompletion = PassthroughSubject<LoginCompletion, Never>()
    var userService = UserService.shared
    
    func login() {
        if email.isValidEmail() {
            
        } else {
            if password.isEmpty {
                self.errorMessagePassword = "Parola gresita."
            }
            self.errorMessageEmail = "Email gresit."
        }
    }
}

