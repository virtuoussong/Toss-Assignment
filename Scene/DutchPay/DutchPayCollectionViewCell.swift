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

class DutchPayCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    private let nameLable: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 12)
        name.textColor = .black
        return name
    }()
    
    private let firstNameView = DutchPayUserFirstNameView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue
        self.addSubviews()
        self.layoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DutchPayData.DutchDetail?) {
        let name = data?.name ?? ""
        self.nameLable.text = name
        self.firstNameView.configure(full: name)
    }
    
    private func addSubviews() {
        [self.nameLable, self.firstNameView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func layoutComponents() {
        self.nameLable.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.leading.equalTo(self).offset(20)
        }
        
        self.firstNameView.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).offset(24)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
}
