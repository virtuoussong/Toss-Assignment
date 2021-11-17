//
//  DutchPayCollectionViewHeaderCell.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

final class DutchPayCollectionViewHeaderCell: UICollectionViewCell {
    
    // MARK: UI Component
    private let dateLabel: UILabel = {
        let d = UILabel()
        d.textColor = .lightGray
        d.font = .systemFont(ofSize: 14)
        return d
    }()
    
    private let amountLabel: UILabel = {
        let a = UILabel()
        a.textColor = .black
        a.font = .boldSystemFont(ofSize: 20)
        return a
    }()
    
    private let textBubbleView: UIView = {
        let r = UIView()
        r.layer.cornerRadius = 16
        r.backgroundColor = .lightGray
        r.isHidden = true
        return r
    }()
    
    private let messageLabel: UILabel = {
        let m = UILabel()
        m.textColor = .darkGray
        m.font = .systemFont(ofSize: 16)
        m.numberOfLines = 0
        return m
    }()
    
    private let bottomLineView: UIView = {
        let b = UIView()
        b.backgroundColor = .gray
        b.isHidden = true
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.layoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DutchPayData.DutchSummary?) {
        guard let data = data else { return }
        
        let date = data.date ?? ""
        self.dateLabel.text = date.dateFormatter
        
        let completedAmount = abs(data.completedAmount ?? 0)
        let totalAmount = abs(data.totalAmount ?? 0)
        self.amountLabel.text = "\(completedAmount.formatToCurrencyWon) 원 완료 / 총 \(totalAmount.formatToCurrencyWon) 원"
        self.messageLabel.text = "\(data.ownerName ?? ""): \(data.message ?? "")"
        
        self.textBubbleView.isHidden = false
        self.bottomLineView.isHidden = false
    }
    
    private func addSubviews() {
        [self.dateLabel, self.amountLabel, self.textBubbleView, self.bottomLineView].forEach {
            self.contentView.addSubview($0)
        }
        
        self.textBubbleView.addSubview(self.messageLabel)
    }
    
    private func layoutComponents() {
        self.dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalTo(self).offset(24)
        }
        
        self.amountLabel.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.dateLabel)
        }
        
        self.textBubbleView.snp.makeConstraints {
            $0.top.equalTo(self.amountLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-32)
        }
        
        self.messageLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.textBubbleView.snp.bottom).offset(-16)
        }
        
        self.bottomLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
