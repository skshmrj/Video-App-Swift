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
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .gray
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
    
    // Set up the layout constraints
    private func layout() {
        
        contentView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        contentView.addSubview(playerView)
        contentView.addSubview(likesLabel)
        playerView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyle.Spacing.default),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyle.Spacing.large),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            playerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.large),
            
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.small),
            
            webView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: playerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor)
        ])
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

