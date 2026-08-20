//
//  UserApi.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import Combine
import SwiftyJSON

class UserApi {
    func login(email: String, password: String) -> AnyPublisher<UserResponse, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)auth/login")
            
            let body: [String: Any] = [
                "email": email,
                "password": password
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUserResponse(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)user/get-user")
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "GET"

            if let token = KeychainService.shared.getAccessToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    promise(.failure(AuthError.unauthorized))
                    return
                }

                do {
                    let json = try JSON(data: data!)
                    let user = JSONParsers.parseJsonUser(json: json)
                    promise(.success(user))
                } catch {
                    promise(.failure(error))
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func register(email: String, password: String, zones: [String]) -> AnyPublisher<User, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)auth/register")
            
            let body: [String: Any] = [
                "email": email,
                "password": password,
                "zones": zones
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUser(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)auth/logout")
    
            guard let refreshToken =
                    KeychainService.shared.getRefreshToken()
            else {
                KeychainService.shared.clearTokens()
                promise(.success(true))
                return
            }
            
            let body: [String: Any] = [
                "refreshToken": refreshToken
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        KeychainService.shared.clearTokens()
                        promise(.success(true))
                    } else {
                        KeychainService.shared.clearTokens()
                        promise(.success(false))
                    }
                }
            }
            
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func refreshToken(refreshToken: String) -> AnyPublisher<TokenResponse, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)auth/refresh")
            let body: [String: Any] = ["refreshToken": refreshToken]
            let jsonData = try? JSONSerialization.data(withJSONObject: body)

            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    promise(.failure(AuthError.unauthorized))
                    return
                }

                do {
                    let json = try JSON(data: data!)
                    let accessToken = json["accessToken"].stringValue
                    let refreshToken = json["refreshToken"].stringValue
                    promise(.success(TokenResponse(accessToken: accessToken, refreshToken: refreshToken)))
                } catch {
                    promise(.failure(error))
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
