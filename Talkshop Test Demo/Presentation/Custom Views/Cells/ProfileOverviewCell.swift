//
//  ProfileOverviewCell.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 16/05/24.
//

import UIKit

struct ProfileOverviewContent: Hashable {
    let username: String
    let image: UIImage
}

final class ProfileOverviewCell: UICollectionViewCell {
    
    struct Constants {
        static let imageHeight: CGFloat = 50.0
        static let imageWidth: CGFloat = 50.0
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppStyle.Font.header
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProfileOverviewCell {
    func layout() {
        contentView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            // Constraints for imageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyle.Spacing.default),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            
            // Constraints for nameLabel
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: AppStyle.Spacing.small),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.default)
        ])
    
    }
}

extension ProfileOverviewCell {
    func configure(content: ProfileOverviewContent) {
        imageView.image = content.image
        nameLabel.text = content.username
    }
}
