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
    
    var fetchErrorHandler: ((Error) -> Void)?
    
    
    // MARK: Initialization
    init(requestService: DutchPayService) {
        self.requestService = requestService
        self.loadInitialDutchPayData()
    }
    
    private func loadInitialDutchPayData() {
        if UserDefaultUtil.isDataFetchedFromApi() {
            self.fetchDutchPayData()
        } else {
            self.fetchDutchPayDataFromCache()
        }
    }
    
    private func fetchDutchPayDataFromCache() {
        print("cache data")
    }
    
    private func fetchDutchPayData() {
        self.requestService.fetchDutchPayment { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.dutchPayData.value = data
                UserDefaultUtil.setIsDataFetchedFromApi()
            case .failure(let error):
                self.fetchErrorHandler?(error)
                print(error)
            }
        }
    }
    
    func refreshDutchPayData() {
        self.fetchDutchPayData()
    }
    
    func updatePaymentStatus(index: Int) {
        self.dutchPayData.value?.dutchDetailList?[index].updatePaymentStatus()
    }
}
