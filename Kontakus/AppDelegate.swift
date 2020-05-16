//
//  AppDelegate.swift
//  Kontakus
//
//  Created by Cüneyd on 24.08.2019.
//  Copyright © 2019 com.kontakus.www. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static var launchedBefore = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UISearchBar.appearance().tintColor = .kontakBlue
        UINavigationBar.appearance().tintColor = .kontakBlue
        AppDelegate.launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

        if AppDelegate.launchedBefore {
            print("Not first launch.")
        } else {
            print("First launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            AppDelegate.launchedBefore = true
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
        DatabaseOperations.shared().saveContext()
    }
} // End Of Class


