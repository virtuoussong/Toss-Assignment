//
//  DutchPayRequestSentList.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/17.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

typealias PaymentRequestedUserAndTime = [Int: Date]

final class DutchPayRequestSentList {
    static let shared = DutchPayRequestSentList()
    var paymentRequestedIdList: PaymentRequestedUserAndTime = [:]
}
