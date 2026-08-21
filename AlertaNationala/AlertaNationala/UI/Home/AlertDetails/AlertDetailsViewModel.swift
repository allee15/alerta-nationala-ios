//
//  AlertDetailsViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation
import Combine

class AlertDetailsViewModel: BaseViewModel {
    let alert: NationalAlert
    
    init(alert: NationalAlert) {
        self.alert = alert
    }
}
