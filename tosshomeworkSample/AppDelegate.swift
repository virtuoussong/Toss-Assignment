//
//  AppDelegate.swift
//  tosshomeworkSample
//
//  Created by 정준영 on 23/05/2019.
//  Copyright © 2019 Viva Republica. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let dutchPayApiService = DutchPayService(requestManager: .shared)
        let dutchPayViewModel = DutchPayViewModel(requestService: dutchPayApiService)
        let initialViewController = DutchPayViewController(viewModel: dutchPayViewModel)

        let navigationController = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaultUtil.savePaymentRequestedUser()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UserDefaultUtil.savePaymentRequestedUser()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaultUtil.savePaymentRequestedUser()
    }
}

