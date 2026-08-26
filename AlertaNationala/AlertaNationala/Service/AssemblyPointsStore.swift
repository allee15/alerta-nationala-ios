//
//  AssemblyPointsStore.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 26/08/2026.
//


import Foundation

class AssemblyPointsStore {
    static let shared = AssemblyPointsStore()
    private let key = "stored_assembly_points"
    private let defaults = UserDefaults.standard

    func all() -> [AssemblyPoint] {
        guard let data = defaults.data(forKey: key),
              let points = try? JSONDecoder().decode([AssemblyPoint].self, from: data) else {
            return []
        }
        return points
    }

    func replace(_ points: [AssemblyPoint]) {
        guard let data = try? JSONEncoder().encode(points) else { return }
        defaults.set(data, forKey: key)
    }
}