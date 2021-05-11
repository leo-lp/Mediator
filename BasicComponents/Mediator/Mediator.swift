//
//  Mediator.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

public class Mediator {
    public static let shared = { Mediator() }()

    // MARK: - Target-Action
    private var targets: [String: NSObject] = [:]

    /// 远程App调用入口
    /// - Parameters:
    ///   - url: scheme://[target]/[action]?[params]
    ///
    /// - Usage example:
    /// ```
    /// aaa://targetA/actionB?id=1234
    /// ```
    public func perform(_ url: URL, completion: ((Param?) -> Void)?) -> AnyObject? {
        var params: Param = [:]
        let urlComponents = URLComponents(string: url.absoluteString)

        // 遍历所有参数
        urlComponents?.queryItems?.forEach({
            if let value = $0.value { params[$0.name] = value }
        })

        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        let actionName = url.path.replacingOccurrences(of: "/", with: "")
        guard let target = url.host, actionName.hasPrefix("native") == false else {
            return NSNumber(value: false)
        }

        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        let result = perform(Action(nil, class: target, method: actionName, params: params, toState: nil, shouldCacheTarget: false))
        if let result = result {
            completion?(["result": result])
        } else {
            completion?(nil)
        }
        return result
    }

    public func perform(_ action: Action) -> AnyObject? { // 可以设置更改当前状态
        if let toState = action.toState, toState.isEmpty == false {
            currentState = toState
        }

        // Middleware 中间件
        if let middleware = middlewares[action.cacheKey] {
            middleware.forEach { _ = perform($0) }
        }

        let targetString = action.targetString
        var target = targets[targetString]
        if target == nil {
            target = action.target

            if action.shouldCacheTarget {
                targets[targetString] = target
            }
        }

        guard let target = target else {
            // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
            Notfound_TargetAction(action)
            targets.removeValue(forKey: targetString)
            return nil
        }

        // State action 状态处理
        if currentState.isEmpty == false {
            let stateMethod = NSSelectorFromString("\(action.method)_state_\(currentState):")
            if target.responds(to: stateMethod) {
                return target.perform(stateMethod, params: action.params)
            } else {
                assert(false, "notfount \(action.method)_state_\(currentState):") // debug
            }
        }

        // 普通 action
        let method = action.action
        if target.responds(to: method) {
            return target.perform(method, params: action.params)
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            let notFound_Action = action.notFound_Action
            if target.responds(to: notFound_Action) {
                return target.perform(notFound_Action, params: action.params)
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                Notfound_TargetAction(action)
                assert(false, "notfount \(action.actionString), \(action.notFound_ActionString)") // debug
            }
        }

        targets.removeValue(forKey: targetString)
        return nil
    }

    // MARK: - Middleware
    private var middlewares: [String: [Action]] = [:] // 中间件

    // Middleware 当设置的方法执行时先执行指定的方法，可用于观察某方法的执行，然后通知其它 com 执行观察方法进行响应
    public func addMiddleware(_ action: Action) -> Self {
        let cacheKey = action.cacheKey
        var arr = middlewares[cacheKey] ?? []
        arr.append(action)
        middlewares[cacheKey] = arr
        return self
    }

    // MARK: - State manager
    public private(set) var currentState: String = ""

    public func updateCurrentState(_ state: String) -> Self {
        if state.isEmpty { assert(false); return self }

        currentState = state
        return self
    }

    // MARK: - Observer
    private var observers: [String: [Action]] = [:] // 存储 identifier 观察者

    public func notifyObservers(_ identifier: String) {
        observers[identifier]?.forEach { _ = perform($0) }
    }

    public func addObserver(_ identifier: String, action: Action) -> Self {
        if identifier.isEmpty { assert(false); return self }

        var arr = observers[identifier] ?? []
        arr.append(action)
        observers[identifier] = arr
        return self
    }

    private func Notfound_TargetAction(_ action: Action) {
        if let notFound_Target = action.notFound_Target {
            let notFound_Action = action.notFound_Action
            if notFound_Target.responds(to: notFound_Action) {
                _ = notFound_Target.perform(notFound_Action, params: action.toDictionary)
            } else {
                assert(false, "notfount \(action.notFound_ActionString)") // debug
            }
        } else {
            assert(false, "notfount \(action.targetString), \(action.notFound_TargetString)") // debug
        }
    }
}

extension NSObject {
    fileprivate func perform(_ action: Selector, params: Param?) -> AnyObject? {
        perform(action, with: params)?.takeUnretainedValue()
    }
}
