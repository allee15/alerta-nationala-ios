//
//  AlertDetailsViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class AlertDetailsViewModel: BaseViewModel {
    private let alertsService = AlertsService.shared
    
    @Published var hasCheckedIn: Bool
    
    let alert: NationalAlert
    
    init(alert: NationalAlert) {
        self.alert = alert
        _hasCheckedIn = Published(initialValue: CheckedInAlertsStore.shared.hasCheckedIn(alertId: alert.id))
    }
    
    func checkIn() {
        self.hasCheckedIn = true
        alertsService.checkIn(alertId: alert.id)
    }
}
