//
//  FeedCell.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit
import Alamofire
import WebKit
import RxSwift
import RxCocoa

/// A structure defining the content of a feed cell.
struct FeedCellContent: Hashable {
    let videoUrl: URL?  // URL of the video
    let contributorContent: ContributorViewContent?
}

/// A structure defining the content for the contributor view.
struct ContributorViewContent: Hashable {
    let user: User?
    let likesCount: Int?  // Number of likes for the video
}

/// A custom `UICollectionViewCell` for displaying feed content.
final class FeedCell: UICollectionViewCell {
    
    /// Constants used for animations and scaling.
    struct Constants {
        static let animationDuration = 0.1
        static let scaleTransform = 0.95
    }
    
    /// The reuse identifier for the cell.
    static let reuseIdentifier = "FeedCell"
    
    /// A dispose bag for RxSwift subscriptions.
    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    /// The web view for displaying video content.
    private var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A view to contain the video player.
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label to display the number of likes.
    let likesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.font = AppStyle.Font.body
        view.textColor = AppStyle.Color.primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A view for displaying contributor information.
    let contributorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label to display the contributor title.
    let descriptorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = AppStyle.Font.caption
        view.textColor = AppStyle.Color.primaryColor
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "contributor_title".localized
        return view
    }()
    
    /// A button to display the author's name.
    let authorButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.titleLabel?.textAlignment = .right
        view.setTitleColor(AppStyle.Color.primaryColor, for: .normal)
        view.contentHorizontalAlignment = .right
        return view
    }()
    
    /// A stack view to contain the likes label and contributor view.
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    /// Initializes the cell with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        configureRoundedCorners()
        configureShadowEffect()
        configureTapAnimation()
    }
    
    /// Initializes the cell from a decoder.
    ///
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    /// Lays out subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath.
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: AppStyle.Radius.default
        ).cgPath
    }
}

private extension FeedCell {
    
    /// Sets up the layout constraints.
    func layout() {
        playerView.backgroundColor = AppStyle.Color.secondaryBackgroundColor
        
        contentView.layer.masksToBounds = true
        webView.layer.masksToBounds = true
        layer.masksToBounds = false
        
        contentView.addSubview(playerView)
        playerView.addSubview(webView)
        playerView.addSubview(stackView)
        
        stackView.addArrangedSubview(likesLabel)
        stackView.addArrangedSubview(contributorView)
        
        contributorView.addSubview(descriptorLabel)
        contributorView.addSubview(authorButton)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: AppStyle.Spacing.default),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyle.Spacing.default),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppStyle.Spacing.default),
            
            descriptorLabel.topAnchor.constraint(equalTo: contributorView.topAnchor),
            descriptorLabel.bottomAnchor.constraint(equalTo: authorButton.topAnchor),
            descriptorLabel.trailingAnchor.constraint(equalTo: authorButton.trailingAnchor),
            
            authorButton.leadingAnchor.constraint(equalTo: contributorView.leadingAnchor),
            authorButton.trailingAnchor.constraint(equalTo: contributorView.trailingAnchor),
            authorButton.bottomAnchor.constraint(equalTo: contributorView.bottomAnchor)
        ])
        
        leadingConstraint = webView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: AppStyle.Spacing.default)
        leadingConstraint?.isActive = true
        trailingConstraint = webView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -AppStyle.Spacing.default)
        trailingConstraint?.isActive = true
        topConstraint = webView.topAnchor.constraint(equalTo: playerView.topAnchor, constant: AppStyle.Spacing.large)
        topConstraint?.isActive = true
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.small)
        bottomConstraint?.isActive = true
    }
    
    /// Configures tap animation for the player view.
    func configureTapAnimation() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    /// Configures shadow effects for the cell.
    func configureShadowEffect() {
        layer.shadowRadius = AppStyle.Radius.shadowRadius
        layer.shadowOpacity = 0.20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    /// Configures rounded corners for the cell.
    func configureRoundedCorners() {
        contentView.layer.cornerRadius = AppStyle.Radius.default
        webView.layer.cornerRadius = AppStyle.Radius.default
        layer.cornerRadius = AppStyle.Radius.default
    }
    
    /// Handles tap gestures on the player view.
    ///
    /// - Parameter sender: The tap gesture recognizer.
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.playerView.transform = CGAffineTransform(scaleX: Constants.scaleTransform, y: Constants.scaleTransform)
        }) { _ in
            UIView.animate(withDuration: Constants.animationDuration) {
                self.playerView.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - Configuration

extension FeedCell {
    
    /// Configures the cell with the provided content.
    ///
    /// - Parameter content: The content to display in the cell.
    func configure(content: FeedCellContent) {
        guard let videoUrl = content.videoUrl else {
            return
        }
        
        let videoID = videoUrl.absoluteString.components(separatedBy: "=").last ?? ""
        let embedURLString = "https://www.youtube.com/embed/\(videoID)"
        if let embedURL = URL(string: embedURLString) {
            webView.load(URLRequest(url: embedURL))
        }
        
        if let contributorContent = content.contributorContent {
            likesLabel.text = "\(contributorContent.likesCount ?? .zero) likes"
            authorButton.setTitle(contributorContent.user?.userName ?? "", for: .normal)
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
            // Set bottom constraint
            bottomConstraint = webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyle.Spacing.small)
            bottomConstraint?.isActive = true
            // Adjust other constraints
            leadingConstraint?.constant = AppStyle.Spacing.small
            topConstraint?.constant = AppStyle.Spacing.small
            trailingConstraint?.constant = -AppStyle.Spacing.small
        }
    }
}

// MARK: - RxSwift Integration

extension FeedCell {
    
    /// A structure defining the input for the cell's reactive bindings.
    struct Input {
        // Define any inputs if needed
    }
    
    /// A structure defining the cell output
    struct Output {
        let authorButtonTapObservable: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    func connect(_ input: Input) -> Output {
        disposeBag = DisposeBag()
        
        return Output(authorButtonTapObservable: authorButton.rx.tap.asObservable(), disposeBag: disposeBag)
    }
    
}
