//
//  HomeViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    private let alertsService = AlertsService.shared
    private let weatherService = WeatherService.shared
    
    @Published var alerts: [NationalAlert] = []
    @Published var weather: [ZoneWeather] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var warnings: [WeatherWarning] = []
    
    override init() {
        super.init()
        self.loadInfo()
    }
    
    func loadInfo() {
        isLoading = true
        errorMessage = nil
        
        alertsService.flushPendingCheckins()
        
        alertsService.fetchAlerts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.errorMessage = "Nu am putut incarca alertele. Verifica conexiunea la internet."
                }
                self?.isLoading = false
            } receiveValue: { [weak self] alerts in
                guard let self else {return}
                self.alerts = alerts
                self.isLoading = false
            }
            .store(in: &bag)

        weatherService.fetchMyWeather()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] zones in
                guard let self else {return}
                self.weather = zones
                self.isLoading = false
            }
            .store(in: &bag)

        weatherService.fetchMyWarnings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] warnings in
                guard let self else {return}
                self.warnings = warnings
            }
            .store(in: &bag)

    }
}
