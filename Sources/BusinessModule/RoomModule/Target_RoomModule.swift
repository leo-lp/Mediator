//
//  Target_RoomModule.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

class Target_RoomModule: NSObject {
    
    @objc func Action_BuildRoomVC(_ params: [String: Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        return RoomViewController(contentText: (params["contentText"] as? String) ?? "")
    }

}
