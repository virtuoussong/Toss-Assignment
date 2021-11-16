//
//  DutchPayCollectionViewCell.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class DutchPayCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    private let nameLable: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = .black
        return name
    }()
    
    private let firstNameView = DutchPayUserFirstNameView(circleSize: 40)
    
    private let contentStackView: UIStackView = {
        let c = UIStackView()
        c.axis = .vertical
        c.spacing = 8
        return c
    }()
    
    private let amountLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 12)
        name.textAlignment = .right
        return name
    }()
    
    private let messageLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 14)
        name.textColor = .darkGray
        name.textAlignment = .left
        return name
    }()
    
    private lazy var requestButton: DutchPayRequestButton = {
        let r = DutchPayRequestButton()
        r.addTarget(self, action: #selector(self.requestButtonDidTap), for: .touchUpInside)
        return r
    }()
    
    lazy var progressAnimationButton: ProgressButton = {
        let r = ProgressButton(color: .blue, radius: 16, duration: 10) { [weak self] in
            guard let `self` = self else { return}
            self.requestPaymentButtonTapHandler?(self.paymentStatus)
        }
        r.addTarget(self, action: #selector(self.progressButtonDidTap), for: .touchUpInside)
        return r
    }()
    
    // MARK: Stored Property
    var dataSet: DutchPayData.DutchDetail?
    
    var paymentStatus: DutchPaymentStatus = .notReceivedMoney
        
    var requestPaymentButtonTapHandler: ((DutchPaymentStatus) -> Void)?
    
    var progressButtonAnimationHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.layoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    func configure(data: DutchPayData.DutchDetail?) {
        guard let data = data else { return }
        self.dataSet = data
        self.paymentStatus = data.paymentStatus
        
        let name = data.name ?? ""
        
        self.firstNameView.configure(full: name)
        
        self.nameLable.text = name
        
        self.amountLabel.text = "\(data.amount?.formatToCurrencyWon ?? "")원"
        
        self.messageLabel.text = data.transferMessage
        
        switch self.paymentStatus {
        case .notReceivedMoney, .sendingRequest,.sentRequestAgain:
            self.amountLabel.font = .systemFont(ofSize: 16)
            self.amountLabel.textColor = .lightGray
            
        case .receivedMoney:
            self.amountLabel.font = .boldSystemFont(ofSize: 16)
            self.amountLabel.textColor = .black
        }
        
        self.requestButton.configureRequestState(paymentStatus: data.paymentStatus)
        self.configureRequestAndProgressbutton()
        self.addComponentToContentStackView()
    }
    
    private func configureRequestAndProgressbutton() {
        switch self.paymentStatus {
        case .sendingRequest:
            self.progressAnimationButton.isHidden = false
            self.requestButton.isHidden = true
            self.progressButtonAnimationHandler?()
            
        case .notReceivedMoney, .sentRequestAgain, .receivedMoney:
            self.progressAnimationButton.isHidden = true
            self.requestButton.isHidden = false
        }
    }
    
    // MAKR: Layout
    private func addSubviews() {
        [self.firstNameView, self.contentStackView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func layoutComponents() {
        self.firstNameView.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).offset(32)
        }
        
        self.contentStackView.snp.makeConstraints {
            $0.leading.equalTo(self.firstNameView.snp.trailing).offset(16)
            $0.trailing.equalTo(self.contentView).offset(-32)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func addComponentToContentStackView() {
        let firstRowView = UIView()
        [self.nameLable, self.amountLabel, self.requestButton, self.progressAnimationButton].forEach {
            firstRowView.addSubview($0)
        }
        
        self.nameLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.amountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.requestButton.snp.leading).offset(-32)
        }
        
        let buttonSize: CGSize = self.paymentStatus == .receivedMoney ? CGSize(width: 50, height: 24) : CGSize(width: 50, height: 40)
        
        self.requestButton.snp.makeConstraints {
            $0.size.equalTo(buttonSize)
            $0.trailing.centerY.equalToSuperview()
        }
        
        self.progressAnimationButton.snp.makeConstraints {
            $0.center.equalTo(self.requestButton)
        }
        
        firstRowView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.requestButton)
        }
        
        self.contentStackView.addArrangedSubview(firstRowView)
        
        if self.dataSet?.transferMessage != "" {
            self.contentStackView.addArrangedSubview(self.messageLabel)
        } else {
            self.contentStackView.removeArrangedSubview(self.messageLabel)
        }
    }
    
    override func prepareForReuse() {
        self.contentStackView.arrangedSubviews.forEach {
            self.contentStackView.removeArrangedSubview($0)
        }
    }
    
    @objc private func requestButtonDidTap() {
        guard self.paymentStatus == .notReceivedMoney else {
            return
        }
        self.requestPaymentButtonTapHandler?(self.paymentStatus)
    }
    
    @objc private func progressButtonDidTap() {
        
    }
}
