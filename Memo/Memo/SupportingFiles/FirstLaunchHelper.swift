//
//  FirstLaunchHelper.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/08.
//

import Foundation

class FirstLaunch {
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(source: FirstLaunchDataSource) {
        let wasLaunchedBefore = source.wasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            source.setWasLaunchedBefore(true)
        }
    }
}

extension FirstLaunch {
    static func alwaysFirst() -> FirstLaunch {
        let source = AlwaysFirstLaunchDataSource()
        let firstLaunch = FirstLaunch(source: source)
        return firstLaunch
    } }

// 프로토콜
protocol FirstLaunchDataSource {
    func wasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)
    
}

// Debug 모드
struct AlwaysFirstLaunchDataSource : FirstLaunchDataSource {
    func wasLaunchedBefore() -> Bool { return false }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        // do nothing
    }
}

// Release 모드
struct UserDefaultsFirstLaunchDataSource : FirstLaunchDataSource {
    let defaults: UserDefaults
    let key: String
    func wasLaunchedBefore() -> Bool {
        return defaults.bool(forKey: key)
    }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        defaults.set(wasLaunchedBefore, forKey: key)
    }
}
