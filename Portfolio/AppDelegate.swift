//
//  AppDelegate.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/11.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setWholeCharactor()
        
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
    
    func setWholeCharactor(){
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red: 0.218, green: 0.5625, blue: 0.973, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor(colorLiteralRed: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(colorLiteralRed: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 0.218, green: 0.5625, blue: 0.973, alpha: 1)
    }

}

