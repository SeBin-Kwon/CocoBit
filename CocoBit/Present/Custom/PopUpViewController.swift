//
//  PopUpViewController.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit

final class PopUpViewController: UIViewController {
    
    let popupView = PopUpView()
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        popupView.backgroundColor = .white
        popupView.messageLabel.text = text
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
