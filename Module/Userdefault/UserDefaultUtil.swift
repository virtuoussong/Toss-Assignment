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
        if let data = UserDefaults.standard.value(forKey: self.paymentRequestedUserAndTime) as? Data {
            if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PaymentRequestedUserAndTime {
                return decoded
            }
        }
        
        let emtyList: PaymentRequestedUserAndTime = [:]
        return emtyList
    }
    
    static func savePaymentRequestedUser() {
        let list = DutchPayRequestSentList.shared.paymentRequestedIdList
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: list)
        UserDefaults.standard.setValue(encodedData, forKey: self.paymentRequestedUserAndTime)
    }
}
