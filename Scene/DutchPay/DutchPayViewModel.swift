//
//  DutchPayViewModel.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import RxSwift

final class DutchPayViewModel {
    private let requestService: DutchPayService
    
    init(requestService: DutchPayService) {
        self.requestService = requestService
    }
    
    func fetchDutchPayData() {
        self.requestService.fetchDutchPayment { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
