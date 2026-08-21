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
    
    let alert: NationalAlert
    
    init(alert: NationalAlert) {
        self.alert = alert
    }
    
    func checkIn(alertId: String) {
        alertsService.checkIn(alertId: alertId)
    }
}
