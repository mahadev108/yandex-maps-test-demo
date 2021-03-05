//
//  AppDelegate.swift
//  yandex-mapkit-manual-test
//
//  Created by Shukhrat Sagatov on 17.11.2020.
//

import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        YMKMapKit.setApiKey("4c6f458e-416b-4e8e-94b2-e8c9759d4785")
        YMKMapKit.setLocale("en_US")
        return true
    }
}

