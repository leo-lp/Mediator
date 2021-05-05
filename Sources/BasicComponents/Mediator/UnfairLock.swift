//
//  UnfairLock.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import Foundation

final public class UnfairLock {
    private let unfairLock: os_unfair_lock_t

    public init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    @discardableResult
    public func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    public func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }

    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
