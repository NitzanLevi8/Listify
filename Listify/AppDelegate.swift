//
//  AppDelegate.swift
//  Listify
//

import UIKit
import FirebaseCore
import FirebaseAppCheck

class AppDelegate:NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
