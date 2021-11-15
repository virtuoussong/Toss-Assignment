//
//  DutchPayUser {.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

struct DutchPayData: Codable {
    struct DutchSummary: Codable {
        var ownerName: String?
        var message: String?
        var ownerAmount: Int16?
        var completedAmount: Int16?
        var date: String?
    }
    
    struct DutchDetail: Codable {
        var dutchId: Int?
        var name: String?
        var amount: Int16?
        var transferMessage: String?
        var isDone: Bool?
    }
    
    var dutchSummary: DutchSummary?
    var dutchDetail: DutchDetail?
}
