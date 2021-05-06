//
//  Target_MomentModule.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

final class Target_MomentModule: NSObject {
    
    @objc func Action_BuildMomentVC(_ params: [String: Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        return MomentViewController()
    }

}
