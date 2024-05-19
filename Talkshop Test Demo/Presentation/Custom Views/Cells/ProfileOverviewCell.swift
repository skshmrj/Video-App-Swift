//
//  ProfileOverviewCell.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 16/05/24.
//

import UIKit

/// A structure defining the content of a profile overview cell.
struct ProfileOverviewContent: Hashable {
    let username: String
    let image: UIImage
}

/// A custom `UICollectionViewCell` for displaying profile overview content.
final class ProfileOverviewCell: UICollectionViewCell {
    
    /// The reuse identifier for the cell.
    static let reuseIdentifier = "ProfileOverviewCell"
    
    /// Constants used for layout and styling.
    struct Constants {
        static let imageHeight: CGFloat = 50.0
        static let imageWidth: CGFloat = 50.0
    }
    
    /// The image view for displaying the profile image.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The label for displaying the username.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppStyle.Font.header
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppStyle.Color.primaryColor
        return label
    }()
    
    // MARK: - Initialization
    
    /// Initializes the cell with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    /// Initializes the cell from a decoder.
    ///
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileOverviewCell {
    
    /// Sets up the layout constraints.
    func layout() {
        // Apply rounded corners to contentView.
        contentView.layer.cornerRadius = AppStyle.Radius.default
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            // Constraints for imageView.
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyle.Spacing.default),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            
            // Constraints for nameLabel.
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: AppStyle.Spacing.small),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.default)
        ])
    }
}

extension ProfileOverviewCell {
    
    /// Configures the cell with the provided content.
    ///
    /// - Parameter content: The content to display in the cell.
    func configure(content: ProfileOverviewContent) {
        imageView.image = content.image
        nameLabel.text = content.username
    }
}
