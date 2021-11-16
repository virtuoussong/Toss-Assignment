//
//  DutchPayUser {.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DutchPayData {
    struct DutchSummary {
        var ownerName: String?
        var message: String?
        var ownerAmount: Int?
        var totalAmount: Int?
        var completedAmount: Int?
        var date: String?
        
        init(_ json: JSON) {
            self.ownerName = json["ownerName"].stringValue
            self.message = json["message"].stringValue
            self.ownerAmount = json["ownerAmount"].intValue
            self.totalAmount = json["totalAmount"].intValue
            self.completedAmount = json["completedAmount"].intValue
            self.date = json["date"].stringValue
        }
    }
    
    struct DutchDetail {
        var dutchId: Int?
        var name: String?
        var amount: Int?
        var transferMessage: String?
        var isDone: Bool = false
        var paymentStatus: DutchPaymentStatus = .notReceivedMoney
        var isAd: Bool = false
        
        init(_ json: JSON) {
            self.dutchId = json["dutchId"].intValue
            self.name = json["name"].stringValue
            self.amount = json["amount"].intValue
            self.transferMessage = json["transferMessage"].stringValue
            self.isDone = json["isDont"].boolValue
            if self.isDone {
                self.paymentStatus = .receivedMoney
            } else {
                self.paymentStatus = .notReceivedMoney
            }
        }
        
        init() {
            
        }
        
        mutating func updatePaymentStatus() {
            self.paymentStatus = self.paymentStatus.next()
        }
    }
    
    var dutchSummary: DutchSummary?
    var dutchDetailList: [DutchDetail]?
    
    init(_ json: JSON) {
        self.dutchDetailList = json["dutchDetailList"].arrayValue.map {
            DutchDetail($0)
        }
        self.dutchSummary = DutchSummary(json["dutchSummary"])
    }
}

enum DutchPaymentStatus: CaseIterable {
    case notReceivedMoney
    case sendingRequest
    case sentRequestAgain
    case receivedMoney
}
