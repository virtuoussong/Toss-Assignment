//
//  DutchPayCollectionViewHeaderCell.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

class DutchPayCollectionViewHeaderCell: UICollectionViewCell {
    
    // MARK: UI Component
    private let ownerName: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 12)
        name.textColor = .black
        return name
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
        self.ownerName.text = data?.ownerName ?? ""
    }
    
    private func addSubviews() {
        [self.ownerName].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func layoutComponents() {
        self.ownerName.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).offset(20)
        }
    }
}
