//
//  AppDelegate.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var router: Router!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let transitioner = AppTransitioner(window: window)
        let router = AppRouter(transitioner: transitioner)
        self.router = router
        router.goTo(.home, from: nil)

        return true
    }
}

