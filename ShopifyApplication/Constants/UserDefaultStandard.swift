//
//  UserDefaultStandard.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import Foundation

class UserDefaultStandard {
    
    static let share = UserDefaultStandard()
    let defaults = UserDefaults.standard
    private init() {}
    
    func saveString(value: String, key: String)
    {
        defaults.set(value, forKey: key)
    }
    
    func getString(key: String) -> String {
        let val: String = defaults.string(forKey: key) ?? ""
        return val
    }
}
