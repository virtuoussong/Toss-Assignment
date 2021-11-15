//
//  DutchPayViewModel.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

final class DutchPayViewModel {
    // MARK: Property
    private let requestService: DutchPayService
    var dutchPayData: Observable<DutchPayData?> = Observable(nil)
    
    // MARK: Initialization
    init(requestService: DutchPayService) {
        self.requestService = requestService
        self.loadInitialDutchPayData()
    }
    
    private func loadInitialDutchPayData() {
        if self.isNewDataRequested() {
            self.fetchDutchPayData()
        } else {
            self.fetchDutchPayDataFromCache()
        }
    }
    
    private func isNewDataRequested() -> Bool {
        return true
    }
    
    private func fetchDutchPayDataFromCache() {
        
    }
    
    private func fetchDutchPayData() {
        self.requestService.fetchDutchPayment { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.dutchPayData.value = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshDutchPayData() {
        self.fetchDutchPayData()
    }
}
