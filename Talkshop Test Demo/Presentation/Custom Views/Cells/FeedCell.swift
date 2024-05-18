//
//  FeedCell.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit
import Alamofire
import WebKit

// Struct defining the content of a feed cell
struct FeedCellContent: Hashable {
    let videoUrl: URL?     // URL of the video
    let likesCount: Int?   // Number of likes for the video
}

// Custom UICollectionViewCell for displaying feed content
final class FeedCell: UICollectionViewCell {
    
    struct Constants {
        static let animationDuration = 0.1
        static let scaleTransform = 0.95
    }
    
    static let reuseIdentifier = "FeedCell"
    
    // MARK: - Properties
    
    private var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UIView to contain the video player
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Label to display the number of likes
    let likesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = AppStyle.Font.body
        view.textColor = AppStyle.Color.primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    // Initialize the cell
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    // Required initializer not implemented
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: AppStyle.Radius.default
        ).cgPath
    }
    
    // Set up the layout constraints
    private func layout() {
        
        playerView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = AppStyle.Radius.default
        contentView.layer.masksToBounds = true
        
        webView.layer.cornerRadius = AppStyle.Radius.default
        webView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = AppStyle.Radius.default
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = AppStyle.Radius.shadowRadius
        layer.shadowOpacity = 0.20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        contentView.addSubview(playerView)
        
        playerView.addSubview(likesLabel)
        playerView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            webView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: AppStyle.Spacing.default),
            webView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -AppStyle.Spacing.default),
            webView.topAnchor.constraint(equalTo: playerView.topAnchor, constant: AppStyle.Spacing.large),
            
            likesLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: AppStyle.Spacing.default),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.default),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.playerView.transform = CGAffineTransform(scaleX: Constants.scaleTransform, y: Constants.scaleTransform)
        }) { _ in
            UIView.animate(withDuration: Constants.animationDuration) {
                self.playerView.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: - Configuration
    
    // Configure the cell with the provided content
    func configure(content: FeedCellContent) {
        guard let videoUrl = content.videoUrl else {
            return
        }
        
        let videoID = videoUrl.absoluteString.components(separatedBy: "=").last ?? ""
        let embedURLString = "https://www.youtube.com/embed/\(videoID)"
        if let embedURL = URL(string: embedURLString) {
            webView.load(URLRequest(url: embedURL))
        }
        
        likesLabel.text = "\(content.likesCount ?? .zero) likes"
    }
}

