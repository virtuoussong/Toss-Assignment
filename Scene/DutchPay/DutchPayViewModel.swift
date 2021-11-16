//
//  DutchPayViewModel.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import SwiftyJSON

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
        if let cachedData = self.importJsonFile() {
            self.dutchPayData.value = cachedData
        }
    }
    
    private func fetchDutchPayData() {
        self.requestService.fetchDutchPayment { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                let mutatedData = self.addAdItem(data: data)
                self.dutchPayData.value = mutatedData
                
                UserDefaultUtil.setIsDataFetchedFromApi()
            case .failure(let error):
                self.fetchErrorHandler?(error)
                print(error)
            }
        }
    }
    
    private func addAdItem(data: DutchPayData) -> DutchPayData? {
        if let array = data.dutchDetailList {
            var copiedArray = array
            let insertingIndex = array.count / 2
            var adItem = DutchPayData.DutchDetail()
            adItem.isAd = true
            copiedArray.insert(adItem, at: insertingIndex)
            
            var copiedData = data
            copiedData.dutchDetailList = copiedArray
            return copiedData
        } else {
            return nil
        }
    }
    
    func refreshDutchPayData() {
        self.fetchDutchPayData()
    }
    
    func updatePaymentStatus(index: Int) {
        self.dutchPayData.value?.dutchDetailList?[index].updatePaymentStatus()
    }
    
    private func importJsonFile() -> DutchPayData? {
        if let path = Bundle.main.path(forResource: "cached_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data)
                let parsedData: DutchPayData = DutchPayData(jsonResult)
                return parsedData
            } catch {
                print("error", error)
                return nil
            }
        } else {
            print("invalid address")
            return nil
        }
    }
}
