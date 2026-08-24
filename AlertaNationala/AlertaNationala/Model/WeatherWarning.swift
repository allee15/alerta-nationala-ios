//
//  WeatherWarning.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//

import Foundation

enum WarningColor: String {
    case yellow = "Yellow"
    case orange = "Orange"
    case red = "Red"
}

struct WeatherWarning {
    let zoneName: String
    let color: WarningColor
    let event: String
    let onset: Date
    let expires: Date
}
