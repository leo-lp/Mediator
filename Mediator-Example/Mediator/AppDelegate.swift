//
//  AppDelegate.swift
//  Mediator
//
//  Created by 李鹏 on 2021/5/6.
//

import UIKit
import Mediator_BusinessModule
import BasicComponents

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Mediator.shared.buildRootVC({
            print($0)
        })
        window?.makeKeyAndVisible()
        return true
    }
}
