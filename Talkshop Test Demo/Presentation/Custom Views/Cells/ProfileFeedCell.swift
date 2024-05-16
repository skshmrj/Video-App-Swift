//
//  File.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 16/05/24.
//

import UIKit
import WebKit

struct ProfileFeedCellContent: Hashable {
    let videoUrl: URL?
}

final class ProfileFeedCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProfileFeedCell {
    
    func layout() {
        contentView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        contentView.addSubview(playerView)
        playerView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.small),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyle.Spacing.small),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyle.Spacing.small),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.small),
            
            webView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: playerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor)
        ])
    }
    
}

extension ProfileFeedCell {
    
    func configure(content: ProfileFeedCellContent) {
        guard let videoUrl = content.videoUrl else {
            return
        }
        
        let videoID = videoUrl.absoluteString.components(separatedBy: "=").last ?? ""
        let embedURLString = "https://www.youtube.com/embed/\(videoID)"
        if let embedURL = URL(string: embedURLString) {
            webView.load(URLRequest(url: embedURL))
        }
    }
    
}
