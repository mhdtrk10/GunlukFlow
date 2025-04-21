//
//  AppDelegate.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 21.04.2025.
//

import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}
