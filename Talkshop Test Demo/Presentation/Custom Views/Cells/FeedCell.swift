//
//  FeedCell.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit
import AVKit
import Alamofire

// Struct defining the content of a feed cell
struct FeedCellContent: Hashable {
    let videoUrl: URL?     // URL of the video
    let likesCount: Int?   // Number of likes for the video
}

// Custom UICollectionViewCell for displaying feed content
final class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var playerViewController: AVPlayerViewController?
    
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
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyle.Spacing.default),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyle.Spacing.large),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            playerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.large),
            
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.small)
        ])
    }
    
    // MARK: - Configuration
    
    // Configure the cell with the provided content
    func configure(content: FeedCellContent) {
        guard let videoUrl = content.videoUrl else {
            return
        }
        let player = AVPlayer(url: videoUrl)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.showsPlaybackControls = true // Add this line
        
        if let playerViewController = playerViewController {
            playerView.addSubview(playerViewController.view)
            playerViewController.view.frame = playerView.bounds
            
            // Automatically play the video when the view is loaded
            playerViewController.player?.play()
        }
        
        likesLabel.text = "\(content.likesCount ?? .zero) likes"
    }
}

