//
//  JSONParsers.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation
import SwiftyJSON

class JSONParsers {
    static func parseJsonUserResponse(json: JSON) -> UserResponse {
        return UserResponse(accessToken: json["accessToken"].stringValue,
                            refreshToken: json["refreshToken"].stringValue,
                            user: parseJsonUser(json: json["user"]))
    }
    
    static func parseJsonUser(json: JSON) -> User {
        return User(id: json["id"].stringValue,
                    email: json["email"].stringValue,
                    role: json["role"].stringValue,
                    zones: json["zones"].arrayValue.map({ $0.stringValue }))
    }
}

