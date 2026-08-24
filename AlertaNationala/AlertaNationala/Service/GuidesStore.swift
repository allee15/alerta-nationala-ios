//
//  GuidesStore.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//


import Foundation

class GuidesStore {
    static let shared = GuidesStore()
    private let key = "stored_guides"
    private let defaults = UserDefaults.standard

    func all() -> [Guide] {
        guard let data = defaults.data(forKey: key),
              let guides = try? JSONDecoder().decode([Guide].self, from: data) else {
            return []
        }
        return guides
    }

    func guide(id: String) -> Guide? {
        all().first { $0.id == id }
    }

    func versionsById() -> [String: Int] {
        Dictionary(uniqueKeysWithValues: all().map { ($0.id, $0.version) })
    }

    func upsert(_ guides: [Guide]) {
        var current = Dictionary(uniqueKeysWithValues: all().map { ($0.id, $0) })
        for guide in guides {
            current[guide.id] = guide
        }
        save(Array(current.values))
    }

    private func save(_ guides: [Guide]) {
        guard let data = try? JSONEncoder().encode(guides) else { return }
        defaults.set(data, forKey: key)
    }
}