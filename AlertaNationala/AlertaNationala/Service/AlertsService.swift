//
//  AlertsService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class AlertsService {
    static let shared = AlertsService()
    private let alertsApi = AlertsApi()
    var bag = Set<AnyCancellable>()
    
    private let userService = UserService.shared
    
    private init() { }
    
    func fetchAlerts() -> AnyPublisher<[NationalAlert], Error> {
        alertsApi.fetchAlerts()
    }
    
    func checkIn(alertId: String) {
        PendingCheckinsStore.shared.enqueue(alertId: alertId, clientTimestamp: Date())
        flushPendingCheckins()
    }
    
    func flushPendingCheckins() {
        for pending in PendingCheckinsStore.shared.all() {
            alertsApi.checkIn(alertId: pending.alertId, clientTimestamp: pending.clientTimestamp)
                .catch { [weak self] error -> AnyPublisher<Void, Error> in
                    guard let self else { return Fail(error: error).eraseToAnyPublisher() }
                    return self.userService.refreshToken()
                        .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                            guard let self else { return Fail(error: AuthError.unauthorized).eraseToAnyPublisher()}
                            return self.alertsApi.checkIn(alertId: pending.alertId, clientTimestamp: pending.clientTimestamp)
                        }
                        .eraseToAnyPublisher()
                }
                .sink { completion in
                    if case .finished = completion {
                        PendingCheckinsStore.shared.remove(alertId: pending.alertId)
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &bag)
            
        }
    }
}
