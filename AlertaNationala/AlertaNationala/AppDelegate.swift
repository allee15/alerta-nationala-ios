//
//  AppDelegate.swift
//  Alerta Nationala
//
//  Created by Alexia Aldea
//

import SwiftUI
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        clearKeychainOnFreshInstall()
        
        NFX.sharedInstance().start()
        return true
    }
    
    private func clearKeychainOnFreshInstall() {
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: UserDefaultsKeys.hasLaunchedBefore) {
            KeychainService.shared.clearTokens()
            defaults.set(true, forKey: UserDefaultsKeys.hasLaunchedBefore)
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}

