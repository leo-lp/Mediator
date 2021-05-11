//
//  Action.swift
//  BasicComponents
//
//  Created by 李鹏 on 2021/5/8.
//

import Foundation

public typealias Param = [String: Any]
extension Param {
    public mutating func add(_ key: String, _ value: Any) -> Self {
        self[key] = value
        return self
    }
}

public struct Action {
    public let module: String?
    public let `class`: String
    public let method: String
    public let params: Param?
    /// state
    public let toState: String?
    public let shouldCacheTarget: Bool

    public init(_ module: String? = nil, `class`: String, method: String,  params: Param? = nil, toState: String? = nil, shouldCacheTarget: Bool = false) {
        assert(module?.isEmpty == false)
        assert(`class`.isEmpty == false)
        assert(method.isEmpty == false)
        
        self.module = module
        self.`class` = `class`
        self.method = method
        self.params = params
        self.toState = toState
        self.shouldCacheTarget = shouldCacheTarget
    }

    /// module + class + method
    var cacheKey: String {
        if let module = module {
            return module + `class` + method
        }
        return `class` + method
    }

    /// method.class
    var targetString: String {
        if let module = module, module.isEmpty == false {
            return "\(module).\(`class`)"
        } else {
            return `class`
        }
    }
    /// method:
    var actionString: String { "\(method):" }
    var target: NSObject? { (NSClassFromString(targetString) as? NSObject.Type)?.init() }
    var action: Selector { NSSelectorFromString(actionString) }

    var toDictionary: Param {
        var dic: Param = ["class": `class`, "method": method]
        if let module = module { dic["module"] = module }
        if let params = params { dic["params"] = params }
        if let toState = toState { dic["toState"] = toState }
        return dic
    }

    var notFound_TargetString: String { "NotFound_Class" }
    var notFound_ActionString: String { "NotFound_Method:" }
    var notFound_Target: NSObject? { (NSClassFromString(notFound_TargetString) as? NSObject.Type)?.init() }
    var notFound_Action: Selector { NSSelectorFromString(notFound_ActionString) }
}
