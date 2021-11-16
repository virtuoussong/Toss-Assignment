//
//  DateTimeCalendar.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

class DateTimeCalendarUtil {
    static func differenceInSeconds(from: Date, to: Date) -> Int {
        return Int(to.timeIntervalSince(from))
    }
}
