//
//  CheckedInAlertsStore.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//


import Foundation

class CheckedInAlertsStore {
    static let shared = CheckedInAlertsStore()
    private let key = "checked_in_alert_ids"
    private let defaults = UserDefaults.standard

    func hasCheckedIn(alertId: String) -> Bool {
        ids().contains(alertId)
    }

    func markCheckedIn(alertId: String) {
        var current = ids()
        current.insert(alertId)
        defaults.set(Array(current), forKey: key)
    }

    private func ids() -> Set<String> {
        Set(defaults.stringArray(forKey: key) ?? [])
    }
}