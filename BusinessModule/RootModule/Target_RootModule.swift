//
//  Target_RootModule.swift
//  BusinessModule
//
//  Created by 李鹏 on 2021/5/18.
//

import UIKit

class Target_RootModule: NSObject {
    @objc func Action_BuildRootVC(_ params: [String: Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("RootTabBarController build success")
        }
        return RootTabBarController()
    }
}
