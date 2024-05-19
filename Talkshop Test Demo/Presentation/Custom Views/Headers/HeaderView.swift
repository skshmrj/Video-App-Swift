//
//  HeaderView.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 16/05/24.
//

import UIKit

/// A reusable header view for a collection view section.
final class HeaderView: UICollectionReusableView {
    
    /// The reuse identifier for the header view.
    static let reuseIdentifier = "HeaderView"
    
    /// A label to display the title in the header view.
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppStyle.Color.primaryColor
        view.font = AppStyle.Font.header
        return view
    }()
    
    /// Initializes the header view with a frame.
    ///
    /// - Parameter frame: The frame rectangle for the view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    /// Initializes the header view from a decoder.
    ///
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderView {
    /// Sets up the layout of the header view.
    ///
    /// This method adds the `titleLabel` to the view and sets up its constraints.
    func layout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppStyle.Spacing.default),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyle.Spacing.default),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyle.Spacing.default),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppStyle.Spacing.default)
        ])
    }
}

extension HeaderView {
    /// Configures the header view with a title, optional text color, and optional font.
    ///
    /// - Parameters:
    ///   - title: The text to be displayed in the title label.
    ///   - textColor: An optional text color for the title label. Defaults to `nil`.
    ///   - font: An optional font for the title label. Defaults to `nil`.
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

