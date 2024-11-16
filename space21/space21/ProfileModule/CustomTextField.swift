//
//  CustomTextField.swift
//  space21
//
//  Created by Марина on 16.10.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        setupView(placeholderText: placeholderText)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(placeholderText: "")
    }
    
    private func setupView(placeholderText: String) {
        placeholder = placeholderText
        borderStyle = .roundedRect // Например, скругленные углы
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        attributedPlaceholder = NSAttributedString(
                        string: placeholderText,
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        font = UIFont.systemFont(ofSize: 16, weight: .medium) // Размер шрифта
        textColor = .black // Цвет текста
        backgroundColor = .white // Фон
        isUserInteractionEnabled = false
    
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        leftView = padding
        leftViewMode = .always
    }
}
