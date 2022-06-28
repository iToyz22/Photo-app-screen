//
//  AppDelegate.swift
//  Photo App Screen
//
//  Created by Anatoliy on 25.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light

        return true
    }


}
