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
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://ek7b8b8yq2.execute-api.us-east-2.amazonaws.com"

        case dutchPayList
        
        var httpMethod: Alamofire.HTTPMethod {
            switch self {
            case .dutchPayList:
                return .get
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
                return "\(home)/toss_ios_homework_dutch_detail"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let baseUrl = try Router.baseURLString.asURL()
            var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(path))
            urlRequest.httpMethod = httpMethod.rawValue
            return urlRequest
        }
    }
}
