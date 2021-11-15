//
//  DutchPayService.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation

class DutchPayService {
    
    let requestManager: ApiRequestManager
    
    init(requestManager: ApiRequestManager) {
        self.requestManager = requestManager
    }
    
    func fetchDutchPayment(completion: @escaping (Result<DutchPayData, Error>) -> Void) {
        do {
            let endPoint = try ApiRequestManager.Router.dutchPayList.asURLRequest()
            self.requestManager.manager
                .request(endPoint)
                .validate()
                .responseJSON { response in
                    let result = response.mapResult { json in
                        return DutchPayData(json)
                    }
                    completion(result)
                }
        } catch {
            print(error)
        }
                            
    }
}




