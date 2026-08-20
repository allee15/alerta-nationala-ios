//
//  ApiEnvironment.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation

enum DefaultAPIEnvironment {
    static private let stage = "https://alerta-nationala-backend.vercel.app/"
    
    static var basePath: URL {
        let selectedEnvironment: String = {
            return stage
        }()
        return URL(string: selectedEnvironment)!
    }
}
