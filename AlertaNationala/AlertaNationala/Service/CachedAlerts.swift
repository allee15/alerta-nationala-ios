//
//  CachedAlerts.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 27/08/2026.
//


import Foundation

struct CachedAlerts: Codable {
    let alerts: [NationalAlert]
    let fetchedAt: Date
}

class AlertsStore {
    static let shared = AlertsStore()
    private let key = "cached_alerts"
    private let defaults = UserDefaults.standard

    func load() -> CachedAlerts? {
        guard let data = defaults.data(forKey: key),
              let cached = try? JSONDecoder().decode(CachedAlerts.self, from: data) else {
            return nil
        }
        return cached
    }

    func replace(_ alerts: [NationalAlert]) {
        let cached = CachedAlerts(alerts: alerts, fetchedAt: Date())
        guard let data = try? JSONEncoder().encode(cached) else { return }
        defaults.set(data, forKey: key)
    }
}