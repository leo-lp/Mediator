//
//  Target_MeModule.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

final class Target_MeModule: NSObject {
    
    @objc func Action_BuildMeVC(_ params: [String: Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("MeViewController build success")
        }
        return MeViewController(style: .plain)
    }
    
}
