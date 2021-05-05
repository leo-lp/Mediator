//
//  Mediator.swift
//  Mediator
//
//  Created by yaowang on 2021/5/5.
//

import UIKit

public class Mediator {
    public static let shared = { Mediator() }()

    private let lock = UnfairLock()
    private lazy var cachedTarget = [String: NSObject]()

    /// 本地组件调用入口
    /// - Parameters:
    ///   - module: 模块名
    ///   - target: 目标名
    ///   - action: 方法名
    ///   - params: 方法参数
    ///   - shouldCacheTarget: 是否需要缓存`Target`
    /// - Returns: `action`的返回值
    public func perform(_ module: String?, target: String, action: String, params: [String: Any]?, shouldCacheTarget: Bool) -> AnyObject? {
        assert(target.isEmpty == false && action.isEmpty == false)

        // generate target
        let targetClassString: String
        if let swiftModule = module, swiftModule.isEmpty == false {
            targetClassString = "\(swiftModule).Target_\(target)"
        } else {
            targetClassString = "Target_\(target)"
        }

        var target = safeGetCachedTarget(targetClassString)
        if target == nil {
            target = (NSClassFromString(targetClassString) as? NSObject.Type)?.init()
        }

        // generate action
        let actionString = "Action_\(action):"
        let action = NSSelectorFromString(actionString)
        guard let target = target else {
            // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
            noTargetActionResponse(with: targetClassString, selectorString: actionString, originParams: params)
            return nil
        }

        if shouldCacheTarget {
            safeSetCachedTarget(target, key: targetClassString)
        }

        guard target.responds(to: action) else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            let action = NSSelectorFromString("notFound:")
            guard target.responds(to: action) else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                noTargetActionResponse(with: targetClassString, selectorString: actionString, originParams: params)
                removeCachedTargetWith(fullTargetName: targetClassString)
                return nil
            }
            return safePerformAction(action, target: target, params: params)
        }
        return safePerformAction(action, target: target, params: params)
    }

    /// 远程App调用入口
    /// - Parameters:
    ///   - url: scheme://[target]/[action]?[params]
    ///
    /// - Usage example:
    /// ```
    /// aaa://targetA/actionB?id=1234
    /// ```
    public func perform(_ url: URL, completion: (([String: Any]?) -> Void)?) -> AnyObject? {
        var params = [String: Any]()
        let urlComponents = URLComponents(string: url.absoluteString)

        // 遍历所有参数
        urlComponents?.queryItems?.forEach({
            if let value = $0.value { params[$0.name] = value }
        })

        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        let actionName = url.path.replacingOccurrences(of: "/", with: "")
        guard let target = url.host,
              actionName.hasPrefix("native") == false else {
            return NSNumber(value: false)
        }

        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        let result = perform(nil, target: target, action: actionName, params: params, shouldCacheTarget: false)
        if let result = result {
            completion?(["result": result])
        } else {
            completion?(nil)
        }
        return result
    }

    /// 删除缓存的`Target`
    /// - Parameter fullTargetName: 在oc环境下，就是Target_XXXX。要带上Target_前缀。在swift环境下，就是XXXModule.Target_YYY。不光要带上Target_前缀，还要带上模块名
    public func removeCachedTargetWith(fullTargetName: String) {
        assert(fullTargetName.isEmpty == false)

        lock.around {
            cachedTarget.removeValue(forKey: fullTargetName)
        }
    }

    private func noTargetActionResponse(with targetString: String, selectorString: String, originParams: [String: Any]?) {
        guard let target = (NSClassFromString("Target_NoTargetAction") as? NSObject.Type)?.init() else {
            return assert(false)
        }

        let action = NSSelectorFromString("Action_response:")
        var params: [String: Any] = ["targetString": targetString, "selectorString": selectorString]
        if let originParams = originParams {
            params["originParams"] = originParams
        }
        _ = safePerformAction(action, target: target, params: params)
    }

    private func safePerformAction(_ action: Selector, target: NSObject, params: [String: Any]?) -> AnyObject? {
        target.perform(action, with: params)?.takeUnretainedValue()
    }

    // MARK: - Getters and Setters
    private func safeGetCachedTarget(_ key: String) -> NSObject? {
        var obj: NSObject?
        lock.around {
            obj = cachedTarget[key]
        }
        return obj
    }

    private func safeSetCachedTarget(_ target: NSObject, key: String) {
        lock.around {
            cachedTarget[key] = target
        }
    }
}
