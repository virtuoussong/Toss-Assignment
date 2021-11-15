//
//  DutchPayViewController.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

class DutchPayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        getdata()
    }
    
    let apiService = DutchPayService(requestManager: .shared)
    
    func getdata() {
        apiService.fetchDutchPayment { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}


