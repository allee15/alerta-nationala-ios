//
//  PendingCheckinsStore.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation

struct PendingCheckin: Codable {
    let alertId: String
    let clientTimestamp: Date
}

class PendingCheckinsStore {
    static let shared = PendingCheckinsStore()
    private let key = "pending_checkins"
    private let defaults = UserDefaults.standard

    // pastreaza timestamp-ul REAL al apasarii, chiar daca la momentul apelului nu exista net
    func enqueue(alertId: String, clientTimestamp: Date) {
        var items = all()
        if !items.contains(where: { $0.alertId == alertId }) {
            items.append(PendingCheckin(alertId: alertId, clientTimestamp: clientTimestamp))
            save(items)
        }
    }

    func remove(alertId: String) {
        save(all().filter { $0.alertId != alertId })
    }

    func all() -> [PendingCheckin] {
        guard let data = defaults.data(forKey: key),
              let items = try? JSONDecoder().decode([PendingCheckin].self, from: data) else {
            return []
        }
        return items
    }

    private func save(_ items: [PendingCheckin]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: key)
    }
}
