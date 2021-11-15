//
//  CaseIterable.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        if let index = all.firstIndex(of: self) {
            let next = all.index(after: index)
            return all[next == all.endIndex ? all.startIndex : next]
        } else {
            return self
        }
    }
}
