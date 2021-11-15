//
//  DutchPayViewController.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class DutchPayViewController: UIViewController {
    
    private let viewModel: DutchPayViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.viewModel.fetchDutchPayData()
        self.bindViewModel()
    }
    
    init(viewModel: DutchPayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        
    }
}


