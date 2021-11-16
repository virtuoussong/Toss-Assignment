//
//  Observable.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> Void
    var listner: Listener?
    
    var value: T {
        didSet {
            self.listner?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listner = listener
        listner?(value)
    }
}
