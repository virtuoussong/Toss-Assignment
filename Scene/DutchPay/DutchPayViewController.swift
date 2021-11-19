//
//  DutchPayViewController.swift
//  tosshomeworkSample
//
//  Created by chiman song on 2021/11/15.
//  Copyright © 2021 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

final class DutchPayViewController: UIViewController {
    
    private enum CellId {
        static let cell = "cell"
        static let header = "header"
    }
    
    // MARK: UI Compoenent
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.view.frame,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            DutchPayCollectionViewCell.self,
            forCellWithReuseIdentifier: CellId.cell
        )
        collectionView.register(
            DutchPayCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CellId.header
        )
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let refreshController = UIRefreshControl()
    
    var errorView: DutchPayFetErrorView?
    
    //MARK: Property
    private let viewModel: DutchPayViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "더치페이"
        self.addSubviews()
        self.layoutComponents()
        self.bindViewModel()
        self.configureRefreshController()
    }
    
    // MARK: Initialization
    init(viewModel: DutchPayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.configureViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Model Bind
    private func bindViewModel() {
        self.viewModel.dutchPayData.bind { [weak self] data in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
            self.hideErrorView()
            self.refreshController.endRefreshing()
        }
    }
    
    // MARK: Layout
    private func addSubviews() {
        [self.collectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func layoutComponents() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Configuration
    private func configureViewModel() {
        self.viewModel.fetchErrorHandler = { [weak self] error in
            guard let `self` = self else { return }
            let errorCode = error.asAFError?.responseCode
            self.showApiFetchErrorView(errorCode: errorCode)
        }
    }
    
    private func configureRefreshController() {
        self.refreshController.tintColor = .lightGray
        self.refreshController.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.collectionView.addSubview(self.refreshController)
    }
    
    // MARK: Method
    @objc private func refreshData() {
        self.refreshController.beginRefreshing()
        self.viewModel.refreshDutchPayData()
    }
    
    private func showApiFetchErrorView(errorCode: Int?) {
        if self.errorView == nil {
            self.errorView = DutchPayFetErrorView()
            self.errorView?.reloadHandler = { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.refreshDutchPayData()
            }
        }
        
        self.errorView?.frame = self.view.frame
        
        if let code = errorCode {
            self.errorView?.configureErrorCode(errorCode: code)
        }
        
        if let errorView = self.errorView {
            self.view.addSubview(errorView)
        }
        
        self.collectionView.isHidden = true
    }
        
    private func hideErrorView() {
        self.errorView?.isHidden = true
        self.errorView?.removeFromSuperview()
        self.errorView = nil
        self.collectionView.isHidden = false
    }
    
    private func alertRequestPaymentUnable() {
        let alert = UIAlertController(title: "이미 요청 하였습니다", message: "한번 요청 하시면 다시 할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: Collectionview Delegate
extension DutchPayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.cell, for: indexPath) as? DutchPayCollectionViewCell {
            let data: DutchPayData.DutchDetail? = self.viewModel.dutchPayData.value?.dutchDetailList?[indexPath.item]
            
            cell.configure(data: data)
            
            cell.requestPaymentButtonUpdateHandler = { [weak self] status in
                guard let `self` = self else { return }
                guard status != .sentRequestAgain else {
                    self.alertRequestPaymentUnable()
                    return
                }
                self.viewModel.updatePaymentStatusToNextCase(index: indexPath.item)
            }
            
            cell.requestCancelHandler = { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.cancelRequestPayment(index: indexPath.item)
            }
            
            cell.delegate = self
            
            return cell
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dutchPayData.value?.dutchDetailList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellId.header, for: indexPath) as? DutchPayCollectionViewHeaderCell {
                let data = self.viewModel.dutchPayData.value?.dutchSummary
                cell.configure(data: data)
                return cell
            } else {
                fatalError()
            }
        default:
            fatalError()
        }
    }
}

extension DutchPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width, height: 72)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let indexPath = IndexPath(row: 0, section: section)
        if let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? DutchPayCollectionViewHeaderCell {

            let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height

            return CGSize(width: self.view.frame.width, height: height)

        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: DutchCell Delegate
extension DutchPayViewController: DutchPayCollectionViewCellDelegate {
    func dutchPayCollectionViewCellAnimateProgress(collectionViewCell: DutchPayCollectionViewCell) {
        guard let dutchId = collectionViewCell.dataSet?.dutchId else {
            return
        }

        let currentTime = Date()
        let animationDuration = 10
        if let previousRequestedTime = self.viewModel.getPaymentRequestedTime(id: dutchId) {
            let secondsPassedSinceRequested = DateTimeCalendarUtil.differenceInSeconds(from: previousRequestedTime, to: currentTime)
            if secondsPassedSinceRequested < animationDuration {
                let animationStartingPoint = CGFloat(Double(secondsPassedSinceRequested) / Double(10))
                collectionViewCell.progressAnimationButton.animate(from: animationStartingPoint)
            } else {
                collectionViewCell.updateRequestButtonToRequestSent()
                self.viewModel.updatePaymentStatusToNextCase(dutchId: dutchId)
            }
        } else {
            collectionViewCell.progressAnimationButton.animate(from: 0)
            DutchPayRequestSentList.shared.paymentRequestedIdList[dutchId] = currentTime
        }
    }
}

