//
//  AppDelegate.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 01. 21..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var openLastUsedFile: Bool = true

    // connections
    var window: UIWindow?
    weak var modelsVC: ModelsVC?


    // --------------------------------------------------------------------------------------------
    // MARK:-    APPLICATION life cycle
    // --------------------------------------------------------------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // setup connections
        guard let splitVC = window?.rootViewController as? UISplitViewController,
            let masterNavC = splitVC.viewControllers.first as? UINavigationController,
            let masterVC = masterNavC.topViewController as? ModelsVC
//            let detailNavC = splitVC.viewControllers.last as? UINavigationController,
//            let detailVC = detailNavC.topViewController as? ChannelsVC
            else { fatalError("Inconsistent storyboard structure") }
        modelsVC = masterVC
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if let project = modelsVC?.project, project.hasData {
            project.saveFLP(to: AC.string.lastUsedFile)
        }
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
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    FILE handling
    // --------------------------------------------------------------------------------------------

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        openLastUsedFile = false
        
        if let success = modelsVC?.openFile(url) {
            return success
        }
        return false
    }


}

