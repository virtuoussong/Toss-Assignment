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
        self.loadSavedDutchPayRequestListFromUserDefault()
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
            
            let sendRequestUpdatedArray = self.sentRequestListUpate(array: copiedArray)
            
            var copiedData = data
            copiedData.dutchDetailList = sendRequestUpdatedArray
            return copiedData
            
        } else {
            return nil
        }
    }
    
    private func sentRequestListUpate(array: [DutchPayData.DutchDetail]) -> [DutchPayData.DutchDetail] {
        var updatedArray = array
        updatedArray.enumerated().forEach { index, item in
            guard let dutchId = item.dutchId else { return }
            var isSent: Bool {
                get {
                    if DutchPayRequestSentList.shared.paymentRequestedIdList[dutchId] != nil {
                        return true
                    } else {
                        return false
                    }
                }
            }
            
            if isSent {
                updatedArray[index].paymentStatus = .sentRequestAgain
            }
        }
        
        return updatedArray
    }
    
    func refreshDutchPayData() {
        self.fetchDutchPayData()
    }
    
    func updatePaymentStatusToNextCase(index: Int) {
        self.dutchPayData.value?.dutchDetailList?[index].updatePaymentStatusToNextCase()
    }
    
    func updatePaymentStatusToNextCase(dutchId: Int) {
        if let index = self.dutchPayData.value?.dutchDetailList?.firstIndex(where: { $0.dutchId == dutchId }) {
            self.updatePaymentStatusToNextCase(index: index)
        }
    }
    
    func requestCanceled(index: Int) {
        self.dutchPayData.value?.dutchDetailList?[index].requestCanceled()
        if let dutchId = self.dutchPayData.value?.dutchDetailList?[index].dutchId {
            DutchPayRequestSentList.shared.paymentRequestedIdList.removeValue(forKey: dutchId)
        }
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
    
    private func loadSavedDutchPayRequestListFromUserDefault() {
        let list = UserDefaultUtil.getPaymentRequestedUser()
        DutchPayRequestSentList.shared.paymentRequestedIdList = list
    }
    
    func inserRequestedDutchId(id: Int, date: Date) {
        DutchPayRequestSentList.shared.paymentRequestedIdList[id] = date
    }
    
    func getRequestedTime(id: Int) -> Date? {
        if let time = DutchPayRequestSentList.shared.paymentRequestedIdList[id] {
            return time
        }
        return nil
    }
}
