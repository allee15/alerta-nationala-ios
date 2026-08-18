//
//  ApiEnvironment.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation

enum DefaultAPIEnvironment {
    static private let stage = "http://localhost:5001"
    
    static var basePath: URL {
        let selectedEnvironment: String = {
            return stage
        }()
        return URL(string: selectedEnvironment)!
    }
}
