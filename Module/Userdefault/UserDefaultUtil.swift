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
    static let paymentRequestedUserAndTime = "paymentRequestedUserAndTime"
    
    static func setIsDataFetchedFromApi() {
        UserDefaults.standard.setValue(true, forKey: self.isDataFetched)
    }
    
    static func isDataFetchedFromApi() -> Bool {
        if let bool = UserDefaults.standard.value(forKey: self.isDataFetched) as? Bool {
            return bool
        } else {
            return false
        }
    }
    
    static func getPaymentRequestedUser() -> PaymentRequestedUserAndTime {
        if let data = UserDefaults.standard.value(forKey: self.paymentRequestedUserAndTime) as?  PaymentRequestedUserAndTime {
            return data
        }
        let emtyList: PaymentRequestedUserAndTime = [:]
        return emtyList
    }
    
    static func setPaymentRequestedUser(id: Int, time: Date) {
        var list = getPaymentRequestedUser()
        list[id] = time
        print("saving List", list)
        UserDefaults.standard.setValue(list, forKey: self.paymentRequestedUserAndTime)
    }
    
    static func getPaymentRequestedTime(id: Int) -> Date? {
        let userData = getPaymentRequestedUser()
        if let date = userData[id] {
            return date
        }
        
        return nil
    }
}
