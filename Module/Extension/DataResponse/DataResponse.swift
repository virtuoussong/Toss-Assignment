//
//  DataResponse.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension DataResponse {
    func mapResult<T>(_ f: @escaping ((JSON) -> T)) -> Swift.Result<T, Error> {
        switch self.result {
        case .success(let value):
            let statusCode = self.response?.statusCode ?? 0
            if (200..<300).contains(statusCode) {
                let json = JSON(value)
                let mappedValue = f(json)
                return .success(mappedValue)

            } else {
                let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
