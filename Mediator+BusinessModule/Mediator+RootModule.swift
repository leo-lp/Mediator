//
//  Mediator+RootModule.swift
//  Mediator+BusinessModule
//
//  Created by 李鹏 on 2021/5/18.
//

import BasicComponents

extension Mediator {

    public func buildRootVC(_ callback: @escaping(String) -> Void) -> UIViewController? {
        let params: [String: Any] = [
            "callback": callback
        ]
        let action = Action("BusinessModule", class: "Target_RootModule", method: "Action_BuildRootVC", params: params)
        let vc = perform(action) as? UIViewController
        assert(vc != nil)
        return vc
    }
}
