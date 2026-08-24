//
//  GuidesApi.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//

import Foundation
import Combine
import SwiftyJSON

class GuidesApi {
    func fetchVersions() -> AnyPublisher<[GuideVersion], Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)guides/versions")
            
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
                        let versions = JSONParsers.parseJsonGuideVersions(json: json)
                        promise(.success(versions))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func fetchAll() -> AnyPublisher<[Guide], Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)guides")
            
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
                        let guides = JSONParsers.parseJsonGuides(json: json)
                        promise(.success(guides))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func fetchOne(id: String) -> AnyPublisher<Guide, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)guides/\(id)")
            
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
                        let guide = JSONParsers.parseJsonGuide(json: json)
                        promise(.success(guide))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
