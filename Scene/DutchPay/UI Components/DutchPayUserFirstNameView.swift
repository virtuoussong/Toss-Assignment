//
//  DutchPayUserFirstNameView.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

class DutchPayUserFirstNameView: UIView {
    // MARK: UI Component
    let firstNameLabel: UILabel = {
        let f = UILabel()
        f.font = UIFont.systemFont(ofSize: 15)
        f.textColor = .blue
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubView()
        self.layoutComponents()
        self.drawBorderRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(full name: String) {
        let firstName = name.prefix(1)
        self.firstNameLabel.text = String(firstName)
    }
    
    private func addSubView() {
        self.addSubview(self.firstNameLabel)
    }
    
    private func layoutComponents() {
        self.firstNameLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    
    private func drawBorderRadius() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
