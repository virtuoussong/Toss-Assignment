//
//  UserDefaultUtil.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

class UserDefaultUtil {
    
    static let isDataFetched = "isDataFetched"
    static func setIsDataFetchedFromApi() {
        UserDefaults.standard.setValue(true, forKey: isDataFetched)
    }
    
    static func isDataFetchedFromApi() -> Bool {
        if let bool = UserDefaults.standard.value(forKey: isDataFetched) as? Bool {
            return bool
        } else {
            return false
        }
    }
}
