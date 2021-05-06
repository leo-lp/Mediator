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

        let vc = perform("BusinessModule", target: "RoomModule", action: "BuildRoomVC", params: params, shouldCacheTarget: false) as? UIViewController
        assert(vc != nil)
        return vc
    }
}
