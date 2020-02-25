//
//  AppDelegate.swift
//  FeelGoodKK
//
//  Created by Kajetan Kuczorski on 17.02.20.
//  Copyright © 2020 Kajetan Kuczorski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - try writing to plist -
    var plistPathInDocuments: String = String()
    
    func preparePlistForUse() {
        // document directory path
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // create a new path - main bundle is read-only
        plistPathInDocuments = rootPath + "/collection.plist"
        if !FileManager.default.fileExists(atPath: plistPathInDocuments) {
            let plistPathInBundle = Bundle.main.path(forResource: "Collection", ofType: "plist")
            // check if copied path already exist
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInDocuments)
            } catch {
                print("Error occured while copying file to document \(error)")
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.preparePlistForUse()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.preparePlistForUse()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

