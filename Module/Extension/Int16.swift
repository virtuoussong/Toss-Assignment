//
//  Int16.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation


extension Int {
    var formatToCurrencyWon: String {
        let formattedNumber = NumberFormatter()
        formattedNumber.numberStyle = .decimal
        formattedNumber.groupingSeparator = ","
        if let formattedString = formattedNumber.string(for: self) {
            let result = "\(String(describing: formattedString))"
            return result
        } else {
            return ""
        }
    }
}
