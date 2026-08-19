//
//  Colors.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import SwiftUI

extension Color {
    static let bgPrimary = Color(.backgroundPrimary)
    static let sfCard = Color(.surfaceCard)
    static let textPrimary = Color(.textPrincipal)
    static let textSecondary = Color(hex: "#8B95A1")
    static let bluePrimary = Color(hex: "#2E6ADB")
    static let blueSecondary = Color(hex: "#4A90D9")
    static let yellowBadge = Color(hex: "#E8A33D")
    static let redBadge = Color(hex: "#D9392E")
    static let greenBadge = Color(hex: "#3FA66B")
    static let offline = Color(hex: "#8B95A1")
    static let meteo = Color(hex: "#5B7C99")
    
    static let lightGreen = Color(hex: "#1B998B")
    static let lightRed = Color(hex: "#D8263E")
    static let contentSecondary = Color(hex: "#91909B")
    static let bottomSheetLine = Color(hex: "#D5D6D8")
    static let fieldSecondary = Color(hex: "#F5F5F5")
    static let fieldTextSecondary = Color(hex: "#91909B")
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
