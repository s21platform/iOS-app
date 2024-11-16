//
//  TextLabel.swift
//  space21
//
//  Created by Марина on 24.10.2024.
//

import UIKit

class TextLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        setupView(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(text: "")
    }
    
    private func setupView(text: String) {
        self.text = text
        font = .systemFont(ofSize: 15, weight: .bold)
    }

}
