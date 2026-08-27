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
    
    let store = AlertsStore.shared
    private let userService = UserService.shared
    
    private init() { }
    
    func fetchAlerts() -> AnyPublisher<AlertsResult, Error> {
        let cached = store.load()

        let networkPublisher = alertsApi.fetchAlerts()
            .handleEvents(receiveOutput: { alerts in
                self.store.replace(alerts)
            })
            .map { AlertsResult(alerts: $0, isFromCache: false) }
            .eraseToAnyPublisher()

        guard let cached else { return networkPublisher }

        return Just(AlertsResult(alerts: cached.alerts, isFromCache: true))
            .setFailureType(to: Error.self)
            .append(networkPublisher.catch { _ in Empty<AlertsResult, Error>() })
            .eraseToAnyPublisher()
    }
    
    func checkIn(alertId: String) {
        guard !CheckedInAlertsStore.shared.hasCheckedIn(alertId: alertId) else { return }
        
        CheckedInAlertsStore.shared.markCheckedIn(alertId: alertId)
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
