//
//  AppDelegate.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 9/10/15.
//  Copyright (c) 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController = UITabBarController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: EventFormViewController())
        let thirdVC = UINavigationController(rootViewController: NotificationsViewController())
        let fourthVC = UINavigationController(rootViewController: ContactsViewController())
        let fifthVC = UINavigationController(rootViewController: HomeViewController())
        let controllers = [firstVC,secondVC,thirdVC,fourthVC,fifthVC]
        tabBarController.viewControllers = controllers
        firstVC.tabBarItem = UITabBarItem(title: "Home", image:UIImage(named: "home.png"), selectedImage: UIImage(named: "homeselected.png"))
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Search, tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "Alerts", image:UIImage(named: "notifications.png"), selectedImage: UIImage(named: "notificationselected.png"))
        fourthVC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 2)
        fifthVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings.png"), selectedImage: UIImage(named: "settingsfilled.png"))
        
        if let _ = NSUserDefaults.standardUserDefaults().stringForKey("userId") {
            window?.rootViewController = tabBarController
        } else {
            window?.rootViewController = LandingViewController()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

