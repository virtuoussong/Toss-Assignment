//
//  ApiManager.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import Alamofire

class ApiRequestManager {
    static let shared = ApiRequestManager()
    let host: URL = URL(string: "https://ek7b8b8yq2.execute-api.us-east-2.amazonaws.com")!
    
    var manager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30.0
        let session = Session(configuration: configuration)
        return session
    }()
}

extension ApiRequestManager {
    enum Router: URLConvertible {
        case dutchPayList
        
        var httpMethod: Alamofire.HTTPMethod {
            switch self {
            case .dutchPayList:
                return .get
            }
        }
        
        var baseUrl: URL {
            switch self {
            case .dutchPayList:
                return ApiRequestManager.shared.host
            }
        }
        
        var home: String {
            switch self {
            case .dutchPayList:
                return "/default"
            }
        }
        
        var path: String {
            switch self {
            case .dutchPayList:
                return "/toss_ios_homework_dutch_detail"
            }
        }
        
        var url: URL {
            let resultUrl = baseUrl.appendingPathComponent(path)
            return resultUrl
        }
        
        func asURL() throws -> URL {
            return self.url
        }
    }
}
