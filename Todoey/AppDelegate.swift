//
//  AppDelegate.swift
//  Todoey
//
//  Created by Yarden Katz on 19/04/2021.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Realm init failed. \(error)")
        }
        
        return true
    }
}


