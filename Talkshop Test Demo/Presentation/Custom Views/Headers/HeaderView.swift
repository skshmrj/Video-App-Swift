//
//  HeaderView.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 16/05/24.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppStyle.Color.primaryColor
        view.font = .monospacedSystemFont(ofSize: 20, weight: .semibold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension HeaderView {
    func layout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppStyle.Spacing.default),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: AppStyle.Spacing.default),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyle.Spacing.default),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: AppStyle.Spacing.default)
        ])
    }
}

extension HeaderView {
    func configure(title: String, textColor: UIColor? = nil, font: UIFont? = nil) {
        titleLabel.text = title
        
        if let textColor = textColor {
            titleLabel.textColor = textColor
        }
        
        if let font = font {
            titleLabel.font = font
        }
    }
}
