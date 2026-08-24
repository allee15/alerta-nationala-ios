//
//  GuideCategory.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//


import Foundation

enum GuideCategory: String {
    case cutremur = "CUTREMUR"
    case incendiu = "INCENDIU"
    case inundatie = "INUNDATIE"
    case meteoExtrem = "METEO_EXTREM"
    case general = "GENERAL"

    var displayName: String {
        switch self {
        case .cutremur: return "Cutremur"
        case .incendiu: return "Incendiu"
        case .inundatie: return "Inundatie"
        case .meteoExtrem: return "Fenomen meteo extrem"
        case .general: return "General"
        }
    }
}

struct GuideSection: Codable {
    let heading: String
    let items: [String]
}

struct Guide: Identifiable, Codable {
    let id: String
    let title: String
    let category: String
    let summary: String
    let version: Int
    let sections: [GuideSection]

    var categoryDisplayName: String {
        GuideCategory(rawValue: category)?.displayName ?? category
    }
}

struct GuideVersion: Codable {
    let id: String
    let version: Int
}