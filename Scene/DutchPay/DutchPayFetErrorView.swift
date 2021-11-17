//
//  DutchPayFetErrorView.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/16.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

final class DutchPayFetErrorView: UIView {
    
    private let errorMessageLabel: UILabel = {
        let r = UILabel()
        r.font = .systemFont(ofSize: 24)
        r.numberOfLines = 0
        r.textAlignment = .center
        return r
    }()
    
    private let reloadButton: UIButton = {
        let r = UIButton()
        r.setTitle("다시 시도", for: .normal)
        r.setTitleColor(.blue, for: .normal)
        r.titleLabel?.font = .boldSystemFont(ofSize: 24)
        return r
    }()
    
    var reloadHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubViews()
        self.layoutComponents()
        self.configureCompoponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [self.errorMessageLabel, self.reloadButton].forEach {
            self.addSubview($0)
        }
    }
    
    private func layoutComponents() {
        self.errorMessageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.center.equalToSuperview()
        }
        
        self.reloadButton.snp.makeConstraints {
            $0.top.equalTo(self.errorMessageLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureErrorCode(errorCode: Int) {
        self.errorMessageLabel.text = "에러 코드: \(errorCode) \n문제가 생겼습니다."
    }
    
    private func configureCompoponents() {
        self.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchUpInside)
    }
    
    @objc private func reloadData() {
        self.reloadHandler?()
    }
}
