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

protocol DutchPayCollectionViewCellDelegate: AnyObject {
    func dutchPayCollectionViewCellAnimateProgress(collectionViewCell: DutchPayCollectionViewCell)
}

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
            self.requestPaymentButtonUpdateHandler?(self.paymentStatus)
        }
        r.addTarget(self, action: #selector(self.progressButtonDidTap), for: .touchUpInside)
        return r
    }()
    
    private let adLabel: UILabel = {
        let a = UILabel()
        a.text = "토스 공동계좌를 개설 해 보세요."
        a.font = .boldSystemFont(ofSize: 16)
        a.textColor = .black
        a.textAlignment = .center
        a.layer.cornerRadius = 8
        a.layer.borderWidth = 2
        a.layer.borderColor = UIColor.black.cgColor
        a.backgroundColor = .white
        return a
    }()
    
    // MARK: Stored Property
    var dataSet: DutchPayData.DutchDetail?
    
    var paymentStatus: DutchPaymentStatus = .notReceivedMoney
        
    var requestPaymentButtonUpdateHandler: ((DutchPaymentStatus) -> Void)?
    
    var requestProgressAnimationHandler: (() -> Void)?
    
    var requestCancelHandler: (() -> Void)?
    
    var progressButtonAnimationHandler: (() -> Void)?
    
    weak var delegate: DutchPayCollectionViewCellDelegate?
    
    // MARK: Initialization
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
        
        self.configureRequestAndProgressbutton(status: data.paymentStatus)
        
        self.addComponentToContentStackView()
        
        if data.isAd {
            self.adLabel.isHidden = false
        } else {
            self.adLabel.isHidden = true
        }
    }
    
    private func configureRequestAndProgressbutton(status: DutchPaymentStatus) {
        self.requestButton.paymentStatus = self.paymentStatus

        switch status {
        case .sendingRequest:
            self.progressAnimationButton.isHidden = false
            self.requestButton.isHidden = true
            self.delegate?.dutchPayCollectionViewCellAnimateProgress(collectionViewCell: self)
            self.progressButtonAnimationHandler?()
            
        case .notReceivedMoney, .sentRequestAgain, .receivedMoney:
            self.progressAnimationButton.cancel()
            self.progressAnimationButton.isHidden = true
            self.requestButton.isHidden = false
        }
    }
    
    func updateRequestButtonToSent() {
        self.paymentStatus = .sentRequestAgain
        self.progressAnimationButton.isHidden = true
        self.requestButton.paymentStatus = .sentRequestAgain
    }
    
    // MAKR: Layout
    private func addSubviews() {
        [self.firstNameView, self.contentStackView, self.adLabel].forEach {
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
        
        self.adLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
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
        guard self.paymentStatus != .receivedMoney else {
            return
        }
        self.requestPaymentButtonUpdateHandler?(self.paymentStatus)
    }
    
    @objc private func progressButtonDidTap() {
        self.progressAnimationButton.cancel()
        self.requestCancelHandler?()
    }
}
