//
//  AlertsApi.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine
import SwiftyJSON

class AlertsApi {
    func fetchAlerts() -> AnyPublisher<[NationalAlert], Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)alerts")
            
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
                        let alerts = JSONParsers.parseJsonAlerts(json: json)
                        promise(.success(alerts))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func checkIn(alertId: String, clientTimestamp: Date) -> AnyPublisher<Void, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)alerts/\(alertId)/checkin")
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = KeychainService.shared.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let body = ["clientTimestamp": formatter.string(from: clientTimestamp)]
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    promise(.success(()))
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
