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
        let wasLaunchedBefore = source.getWasLaunchedBefore()
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

protocol FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)
    
}

struct AlwaysFirstLaunchDataSource : FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool { return false }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        // do nothing
    }
}

struct UserDefaultsFirstLaunchDataSource : FirstLaunchDataSource {
    let defaults: UserDefaults
    let key: String
    func getWasLaunchedBefore() -> Bool {
        return defaults.bool(forKey: key)
    }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        defaults.set(wasLaunchedBefore, forKey: key)
    }
}
