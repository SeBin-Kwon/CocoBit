//
//  PopUpViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PopUpViewController: UIViewController {
    
    let popupView = PopUpView()
    var text: String?
    var isNetwork: Bool?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func bind() {
        let retryButtonTap = PublishRelay<Void>()
    
        retryButtonTap
            .withLatestFrom(NetworkMonitor.shared.isPopUp)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                if !value {
                    owner.navigate(.dismiss)
                } else {
                    owner.view.makeToast("네트워크 통신이 원활하지 않습니다.", position: .top)
                }
            }
            .disposed(by: disposeBag)
        
        popupView.retryButton.rx.tap
            .debug("retryButton")
            .bind(with: self) { owner, value in
                NotificationCenterManager.retryAPI.post()
                retryButtonTap.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        popupView.backgroundColor = .white
        if isNetwork != nil {
            popupView.messageLabel.text = NetworkError.noConnection.errorDescription
        } else {
            popupView.messageLabel.text = text
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(popupView)
    }
    
    private func configureLayout() {
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.center.equalToSuperview()
        }
    }

}
