//
//  AssemblyPoint.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 26/08/2026.
//


import Foundation

struct AssemblyPoint: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let lat: Double
    let lng: Double
    let zone: String
    let capacity: Int?
    let isActive: Bool
}