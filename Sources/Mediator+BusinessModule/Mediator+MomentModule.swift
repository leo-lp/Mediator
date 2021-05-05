//
//  Mediator+MomentModule.swift
//  Mediator
//
//  Created by yaowang on 2021/5/5.
//

extension Mediator {

    public func buildMomentVC(_ callback: @escaping(String) -> Void) -> UIViewController? {
        let params: [String: Any] = ["callback": callback]

        let vc = perform("Mediator", target: "MomentModule", action: "BuildMomentVC", params: params, shouldCacheTarget: false) as? UIViewController
        assert(vc != nil)
        return vc
    }
}
