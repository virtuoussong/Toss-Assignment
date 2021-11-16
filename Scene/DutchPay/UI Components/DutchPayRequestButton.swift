//
//  DutchPayRequestButton.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

final class DutchPayRequestButton: UIButton {
    var paymentStatus: DutchPaymentStatus = .notReceivedMoney {
        didSet {
            self.updateContents()
        }
    }
    
    private func setContentsForDidNotReceiveMoney() {
        self.setTitle("재요청", for: .normal)
        self.setTitleColor(.blue, for: .normal)
        self.isEnabled = true
        self.isHidden = false
    }
    
    private func setContentsForDidSendRequestAgain() {
        self.setTitle("요청함", for: .normal)
        self.setTitleColor(.blue, for: .normal)
        self.isEnabled = true
        self.isHidden = false
    }
    
    private func setContnentsForDidReceiveeMoney() {
        self.setTitle("완료", for: .disabled)
        self.setTitleColor(.black, for: .disabled)
        self.isEnabled = true
        self.isHidden = false
    }
    
    private func updateContents() {
        switch self.paymentStatus {
        case .notReceivedMoney:
            self.setContentsForDidNotReceiveMoney()
        case .sentRequestAgain:
            self.setContentsForDidSendRequestAgain()
        case .receivedMoney:
            self.setContnentsForDidReceiveeMoney()
        case .sendingRequest:
            self.isHidden = true
        }
    }
    
    func didTapRequestButton() {
        self.paymentStatus = self.paymentStatus.next()
    }
}
