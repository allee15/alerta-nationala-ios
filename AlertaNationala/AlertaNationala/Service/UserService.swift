//
//  UserService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import Combine

class UserService {
    static let shared = UserService()
    private let userApi = UserApi()
    var bag = Set<AnyCancellable>()
    private let keychainService = KeychainService.shared
    
    public lazy var userReactiveData = ReactiveData<UserState> { [weak self] in
        guard let self else {return nil}
        
        return Deferred {
            Future<UserState, Error> { promise in
                if self.isLoggedIn {
                    self.getUser() 
                        .map { UserState.loggedIn($0) }
                        .catch { _ in Just(UserState.anonymous) }
                        .eraseToAnyPublisher()
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(error))
                            case .finished:
                                break
                            }
                        }, receiveValue: { userState in
                            promise(.success(userState))
                        })
                        .store(in: &self.bag)
                } else {
                    promise(.success(UserState.anonymous))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public var isLoggedIn: Bool {
        if let token = authToken, !token.isEmpty {
            return true
        }
        return false
    }
    
    var authToken: String? {
        get {
            keychainService.getAccessToken()
        }
    }
    
    private init() {
        if !isLoggedIn {
            self.userReactiveData.pushValue(value: .anonymous)
        }
    }
    
    func login(email: String, password: String) -> AnyPublisher<UserResponse, Error> {
        return userApi.login(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] userResponse in
                guard let self else {return}
                guard !userResponse.user.email.isEmpty else {return}
                self.keychainService.saveAccessToken(userResponse.accessToken)
                self.keychainService.saveRefreshToken(userResponse.refreshToken)
                self.userReactiveData.pushValue(value: .loggedIn(userResponse.user))
            })
            .eraseToAnyPublisher()
    }
    
    func register(email: String, password: String, zones: [String]) -> AnyPublisher<User, Error> {
        return userApi.register(email: email, password: password, zones: zones)
            .eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        self.userApi.getUser()
            .catch { [weak self] error -> AnyPublisher<User, Error> in
                guard let self else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                guard case AuthError.unauthorized = error else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                return self.refreshToken()
                    .flatMap { [weak self] _ -> AnyPublisher<User, Error> in
                        guard let self else {
                            return Fail(error: AuthError.unauthorized).eraseToAnyPublisher()
                        }
                        return self.userApi.getUser()
                    }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.keychainService.clearTokens()
                    self?.userReactiveData.pushValue(value: .anonymous)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Bool, Error> {
        self.userApi.logout()
            .handleEvents(receiveOutput: { _ in
                self.keychainService.clearTokens()
                self.userReactiveData.pushValue(
                    value: .anonymous
                )
            })
            .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<TokenResponse, Error> {
        guard let refreshToken = keychainService.getRefreshToken(),
              !refreshToken.isEmpty else {
            
            return Fail(
                error: AuthError.noRefreshToken
            )
            .eraseToAnyPublisher()
        }
        
        return userApi
            .refreshToken(refreshToken: refreshToken)
            .handleEvents(
                receiveOutput: { [weak self] response in
                    
                    guard let self else {
                        return
                    }
                    
                    self.keychainService.saveAccessToken(
                        response.accessToken
                    )
                    
                    self.keychainService.saveRefreshToken(
                        response.refreshToken
                    )
                }
            )
            .eraseToAnyPublisher()
    }
    
    func updateZones(zones: [String]) -> AnyPublisher<User, Error> {
        userApi.updateZones(zones: zones)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.userReactiveData.pushValue(value: .loggedIn(user))
            }).eraseToAnyPublisher()
    }
}
