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
        return UserResponse(token: json["token"].stringValue,
                            user: parseJsonUser(json: json))
    }
    
    static func parseJsonUser(json: JSON) -> User {
        return User(
            id: json["_id"].stringValue,
            email: json["email"].stringValue,
            nickname: json["username"].stringValue,
            avatarUrl: json["profilePic"].stringValue,
            isArtist: json["accType"].stringValue == "artist" ? true : false,
            balance: json["balance"].doubleValue,
            level: json["level"].intValue,
            createdAt: Date()
        )
    }
}
