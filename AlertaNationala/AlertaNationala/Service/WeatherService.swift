//
//  WeatherService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class WeatherService {
    static let shared = WeatherService()
    private let weathersApi = WeatherApi()
    var bag = Set<AnyCancellable>()
    
    private init() { }
    
    func fetchMyWeather() -> AnyPublisher<[ZoneWeather], Error> {
        weathersApi.fetchMyWeather()
    }
}
