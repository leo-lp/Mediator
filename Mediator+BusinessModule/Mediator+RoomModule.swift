//
//  Mediator+RoomModule.swift
//  Mediator
//
//  Created by yaowang on 2021/5/5.
//

import BasicComponents

extension Mediator {

    public func buildRoomVC(_ contentText: String, callback: @escaping(String) -> Void) -> UIViewController? {
        let params: [String: Any] = [
            "callback": callback,
            "contentText": contentText
        ]
        let action = Action("BusinessModule", class: "Target_RoomModule", method: "Action_BuildRoomVC", params: params)
        let vc = perform(action) as? UIViewController
        assert(vc != nil)
        return vc
    }
}
