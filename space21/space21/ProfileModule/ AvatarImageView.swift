//
//   AvatarImageView.swift
//  space21
//
//  Created by Марина on 16.10.2024.
//

import UIKit

class AvatarImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentMode = .scaleAspectFill
        
        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        widthAnchor.constraint(equalToConstant: 100).isActive = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
