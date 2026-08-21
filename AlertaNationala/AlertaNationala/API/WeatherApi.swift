//
//  WeatherApi.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine
import SwiftyJSON

class WeatherApi {
    func fetchMyWeather() -> AnyPublisher<[ZoneWeather], Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)weather/me")
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            if let token = KeychainService.shared.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let zonesWeather = JSONParsers.parseJsonZonesWeatherList(json: json)
                        promise(.success(zonesWeather))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
