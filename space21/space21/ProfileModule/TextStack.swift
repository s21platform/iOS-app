//
//  TextStack.swift
//  space21
//
//  Created by Марина on 16.10.2024.
//

import UIKit

class LabelTextFieldStackView: UIStackView {
    
        override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init(arrangedSubviews: [UIView]) {
        super.init(frame: .zero)
        setupView()
        addArrangedSubviews(arrangedSubviews)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.axis = .horizontal
        self.spacing = 0
//        self.alignment = .leading
        self.distribution = .fillEqually
    }
    
    private func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

