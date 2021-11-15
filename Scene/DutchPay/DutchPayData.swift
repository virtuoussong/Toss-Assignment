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
        var ownerAmount: Int16?
        var totalAmount: Int16?
        var completedAmount: Int16?
        var date: String?
        
        init(_ json: JSON) {
            self.ownerName = json["ownerName"].stringValue
            self.message = json["message"].stringValue
            self.ownerAmount = json["ownerAmount"].int16Value
            self.totalAmount = json["totalAmount"].int16Value
            self.completedAmount = json["completedAmount"].int16Value
            self.date = json["date"].stringValue
        }
    }
    
    struct DutchDetail {
        var dutchId: Int?
        var name: String?
        var amount: Int16?
        var transferMessage: String?
        var isDone: Bool = false
        var paymentStatus: DutchPaymentStatus = .notReceivedMoney
        
        init(_ json: JSON) {
            self.dutchId = json["dutchId"].intValue
            self.name = json["name"].stringValue
            self.amount = json["amount"].int16Value
            self.transferMessage = json["transferMessage"].stringValue
            self.isDone = json["isDont"].boolValue
            if self.isDone {
                self.paymentStatus = .receivedMoney
            } else {
                self.paymentStatus = .notReceivedMoney
            }
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
