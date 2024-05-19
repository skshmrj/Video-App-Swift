//
//  PostViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 19/05/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PostViewController: UIViewController {
    
    struct Constants {
        static let headerHeight: CGFloat = 75.0
    }
    
    /// The view model driving the feed.
    private let viewModel: PostProtocol
    
    /// The data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<PostDataSource.Section, PostDataSource.Item>?
    
    /// Observable for indicating the activity status.
    private let isActiveObservable = PublishSubject<Bool>()
    
    /// Dispose bag for RxSwift subscriptions.
    private let disposeBag = DisposeBag()
    
    /// Collection view for displaying the feed.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppStyle.Color.backgroundColor
        return collectionView
    }()
    
    /// Button for closing the profile view.
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.close, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = AppStyle.Color.primaryColor
        view.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return view
    }()
    
    /// Initializes the view controller with a view model and main factory.
    /// - Parameters:
    ///   - viewModel: The view model for the post.
    init(viewModel: PostProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    /// Action method for handling close button taps.
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Methods

private extension PostViewController {
    /// Sets up the layout constraints for the collection view.
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        
        closeButton.isHidden = presentingViewController == nil
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.Spacing.medium),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppStyle.Spacing.medium),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    /// Action triggered when the refresh control value changes.
    @objc func refreshData() {
        isActiveObservable.onNext(true)
    }
    
    /// Binds view model outputs to the view.
    func bind() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.register(ProfileOverviewCell.self, forCellWithReuseIdentifier: ProfileOverviewCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        bindDataSource()
        bindSupplementaryView()
        
        let output = viewModel.connect(input: .init(isActiveObservable: isActiveObservable))
        
        isActiveObservable.onNext(true)
        
        output.dataSource
            .map { info -> NSDiffableDataSourceSnapshot in
                var snapshot = NSDiffableDataSourceSnapshot<PostDataSource.Section, PostDataSource.Item>()
                snapshot.appendSections(info.map { $0.section })
                info.forEach {
                    snapshot.appendItems($0.rows, toSection: $0.section)
                }
                return snapshot
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, snapshot in
                this.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        output.errorObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, error in
                let alert = UIAlertController(errorMessage: error.localizedDescription)
                this.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// Binds the supplementary view to the data source.
    func bindSupplementaryView() {
        dataSource?.supplementaryViewProvider = { [weak self] (_, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return self?.getHeaderView(indexPath: indexPath)
            default:
                return nil
            }
        }
    }
    
    /// Sets up the data source for the collection view.
    func bindDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PostDataSource.Section, PostDataSource.Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            switch item {
            case let .myProfileFeedCell(content):
                return self?.getFeedCell(collectionView: collectionView, content: content, indexPath: indexPath)
            case let .myProfileOverview(content):
                return self?.getProfileOverviewCell(collectionView: collectionView, content: content, indexPath: indexPath)
            }
        }
    }
}

// MARK: - Layout

private extension PostViewController {
    /// Creates the layout for the collection view.
    /// - Returns: The compositional layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let offset = AppStyle.Spacing.medium
            item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
            
            let fractionalHeight = sectionType == .post ? 0.4 : 0.2
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(fractionalHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.headerHeight))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
}

// MARK: - Cell and Header Configuration

private extension PostViewController {
    /// Dequeues and configures a feed cell.
    /// - Parameters:
    ///   - collectionView: The collection view.
    ///   - content: The content to configure the cell with.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured feed cell.
    func getFeedCell(collectionView: UICollectionView, content: FeedCellContent, indexPath: IndexPath) -> FeedCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else {
            return nil
        }
        cell.configure(content: content)
        
        let output = cell.connect(.init())
        
        output.likeButtonTapObservable
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                let alert = UIAlertController(errorMessage: "", title: "liked".localized)
                this.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        return cell
    }
    
    /// Dequeues and configures a header view.
    /// - Parameter indexPath: The index path of the header view.
    /// - Returns: A configured header view.
    func getHeaderView(indexPath: IndexPath) -> UICollectionReusableView? {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath
        ) as? HeaderView
        
        guard let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
            return nil
        }
        
        switch section {
        case .post:
            headerView?.configure(title: "post".localized)
        case let .user(content):
            headerView?.configure(title: content)
        }
        
        return headerView
    }
    
    /// Configures and returns a profile overview cell for the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view.
    ///   - content: The content to configure the cell.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured profile overview cell.
    private func getProfileOverviewCell(collectionView: UICollectionView, content: ProfileOverviewContent, indexPath: IndexPath) -> ProfileOverviewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileOverviewCell.reuseIdentifier, for: indexPath) as? ProfileOverviewCell else {
            return nil
        }
        cell.configure(content: content)
        return cell
    }
}
