//
//  Mediator+HomeModule.swift
//  Mediator
//
//  Created by yaowang on 2021/5/5.
//

import BasicComponents

extension Mediator {

    public func buildHomeVC(_ callback: @escaping(String) -> Void) -> UIViewController? {
        let params: [String: Any] = ["callback": callback]
        let action = Action("BusinessModule", class: "Target_HomeModule", method: "Action_BuildHomeVC", params: params)
        let vc = perform(action) as? UIViewController
        assert(vc != nil)
        return vc
    }
}
