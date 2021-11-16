//
//  DateFormatter.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

extension String {
    var dateFormatter: String {
        let receivedDate = DateFormatter()
        receivedDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let outputDate = DateFormatter()
        outputDate.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        
        if let date = receivedDate.date(from: self) {
            print(date)
            return outputDate.string(from: date)
        } else {
            return "날짜 에러"
        }
    }
}
