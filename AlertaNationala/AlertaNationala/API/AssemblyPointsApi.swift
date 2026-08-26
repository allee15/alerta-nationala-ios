//
//  AssemblyPointsApi.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 26/08/2026.
//

import Foundation
import Combine
import SwiftyJSON

class AssemblyPointsApi {
    func fetchAll() -> AnyPublisher<[AssemblyPoint], Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)assembly-points")
            
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
                        let points = JSONParsers.parseJsonAssemblyPoints(json: json)
                        promise(.success(points))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
