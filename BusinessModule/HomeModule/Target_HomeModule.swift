//
//  Target_HomeModule.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

final class Target_HomeModule: NSObject {

    @objc func Action_BuildHomeVC(_ params: [String: Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("HomeViewController build success")
        }
        return HomeViewController()
    }

}
