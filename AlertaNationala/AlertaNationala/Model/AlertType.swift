//
//  AlertType.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//


import Foundation

enum AlertType: String {
    case cutremur = "CUTREMUR"
    case inundatie = "INUNDATIE"
    case incendiu = "INCENDIU"
    case meteoExtrem = "METEO_EXTREM"
    case alta = "ALTA"

    var displayName: String {
        switch self {
        case .cutremur: return "Cutremur"
        case .inundatie: return "Inundatie"
        case .incendiu: return "Incendiu"
        case .meteoExtrem: return "Fenomen meteo extrem"
        case .alta: return "Alta"
        }
    }
}

enum AlertSeverity: String {
    case informare = "INFORMARE"
    case atentionare = "ATENTIONARE"
    case pericol = "PERICOL"

    var displayName: String {
        switch self {
        case .informare: return "Informare"
        case .atentionare: return "Atentionare"
        case .pericol: return "Pericol"
        }
    }
}

enum AlertStatus: String {
    case active = "ACTIVE"
    case ended = "ENDED"
}

struct NationalAlert: Identifiable {
    let id: String
    let type: AlertType
    let severity: AlertSeverity
    let message: String
    let zones: [String]
    let startsAt: Date
    let endsAt: Date
    let status: AlertStatus
}