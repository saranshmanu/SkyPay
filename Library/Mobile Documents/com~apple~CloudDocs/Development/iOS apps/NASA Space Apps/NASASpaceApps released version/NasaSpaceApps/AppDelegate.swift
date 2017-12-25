//
//  AppDelegate.swift
//  NasaSpaceApps
//
//  Created by Vansh Badkul on 09/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import CoreData
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if !UserDefaults.standard.bool(forKey: "TermsAccepted") {
            UserDefaults.standard.set(false, forKey: "TermsAccepted")
        }
        
        if !UserDefaults.standard.bool(forKey: "TokenBool") {
            UserDefaults.standard.set(false, forKey: "TokenBool")
            UserDefaults.standard.setValue("", forKey: "TokenValue")

        }
        let defaults = UserDefaults.standard
        let defaultValue = ["MyKey" : ""]
        defaults.register(defaults: defaultValue)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.init(red: 19/255, green: 32/255, blue: 53/255, alpha: 1.0)//(colorWithHexValue: 0x2E4960)
        UITabBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 19/255, green: 32/255, blue: 53/255, alpha: 0)//(colorWithHexValue: 0x2E4960)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        // Override point for customization after application launch.
         FIRApp.configure()
        
        return true
           }
  

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    
}

