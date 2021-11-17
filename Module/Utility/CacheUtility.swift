//
//  CacheUtility.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/17.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

class CacheUtility {
    enum CacheType {
        case requestList
    }
    
    func saveObject(type: CacheType) {
        switch type {
        case .requestList:
            self.saveRequestSentList()
        }
    }
    
    func saveRequestSentList() {
        let cache = NSCache<NSString, DutchPayRequest>()
    }
}

class DutchPayRequest {
    var data: PaymentRequestedUserAndTime = [:]
}
