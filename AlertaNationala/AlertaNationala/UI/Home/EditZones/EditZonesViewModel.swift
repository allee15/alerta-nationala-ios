//
//  EditZonesViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class EditZonesViewModel: BaseViewModel {
    private let userService = UserService.shared
    
    @Published var selectedZones: [String] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var didSave: Bool = false
    
    let zones: [String] = Judete.names
    
    override init() {
        super.init()
        if let currentUser = userService.userReactiveData.currentValue {
            switch currentUser {
            case .anonymous:
                break
            case .loggedIn(let user):
                self.selectedZones = user.zones
            }
        }
    }
    
    func updateZones() {
        guard !selectedZones.isEmpty else {
            errorMessage = "Trebuie sa selectezi cel putin o zona"
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        userService.updateZones(zones: selectedZones)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                self.isLoading = false
                if case .failure = completion {
                    self.errorMessage = "Nu am putut salva zonele. Verifica conexiunea la internet."
                }
            } receiveValue: { [weak self] _ in
                guard let self else {return}
                self.didSave = true
                self.isLoading = false
            }
            .store(in: &bag)

    }
}
