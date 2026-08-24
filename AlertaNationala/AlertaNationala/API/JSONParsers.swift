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
    
    static func parseJsonAlerts(json: JSON) -> [NationalAlert] {
        return json.arrayValue.map({ parseJsonAlert(json: $0) })
    }
    
    static func parseJsonAlert(json: JSON) -> NationalAlert {
        let type = AlertType(rawValue: json["type"].stringValue)
        let severity = AlertSeverity(rawValue: json["severity"].stringValue)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        
        let startsAt = formatter.date(from: json["startsAt"].stringValue) ?? Date()
        let endsAt = formatter.date(from: json["endsAt"].stringValue) ?? Date()
        
        let status = AlertStatus(rawValue: json["status"].stringValue)
        
        return NationalAlert(id: json["id"].stringValue,
                             type: type ?? .alta,
                             severity: severity ?? .informare,
                             message: json["message"].stringValue,
                             zones: json["zones"].arrayValue.map({ $0.stringValue}),
                             startsAt: startsAt,
                             endsAt: endsAt,
                             status: status ?? .ended)
    }
    
    static func parseJsonZonesWeatherList(json: JSON) -> [ZoneWeather] {
        return json.arrayValue.map({ parseJsonZoneWeather(json: $0) })
    }
    
    static func parseJsonZoneWeather(json: JSON) -> ZoneWeather {
        return ZoneWeather(zoneName: json["zoneName"].stringValue,
                           temperature: json["temperature"].doubleValue,
                           weatherCode: json["weatherCode"].intValue,
                           description: json["description"].stringValue,
                           isSevere: json["isSevere"].boolValue)
    }
    
    static func parseJsonWeatherWarnings(json: JSON) -> [WeatherWarning] {
        return json.arrayValue.compactMap({ parseJsonWarning(json: $0) })
    }
    
    static func parseJsonWarning(json: JSON) -> WeatherWarning {
        let color = WarningColor(rawValue: json["color"].stringValue)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        
        let onset = formatter.date(from: json["onset"].stringValue) ?? Date()
        let expires = formatter.date(from: json["expires"].stringValue) ?? Date()
        
        return WeatherWarning(zoneName: json["zoneName"].stringValue,
                              color: color ?? .yellow,
                              event: json["event"].stringValue,
                              onset: onset,
                              expires: expires)
    }
    
    static func parseJsonGuideVersions(json: JSON) -> [GuideVersion] {
        return json.arrayValue.map({ GuideVersion(id: $0["id"].stringValue,
                                                  version: $0["version"].intValue) })
    }
    
    static func parseJsonGuides(json: JSON) -> [Guide] {
        return json.arrayValue.map({ parseJsonGuide(json: $0) })
    }
    
    static func parseJsonGuide(json: JSON) -> Guide {
        return Guide(id: json["id"].stringValue,
                     title: json["title"].stringValue,
                     category: json["category"].stringValue,
                     summary: json["summary"].stringValue,
                     version: json["version"].intValue,
                     sections: json["sections"].arrayValue.map({ section in
            GuideSection(heading: section["heading"].stringValue,
                         items: section["items"].arrayValue.map({ $0.stringValue }))
        }))
    }
}

