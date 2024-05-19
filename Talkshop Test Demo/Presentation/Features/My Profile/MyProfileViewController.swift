//
//  MyProfileViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit
import RxSwift

/// View controller responsible for displaying user profile information.
final class MyProfileViewController: UIViewController {
    
    struct Constants {
        static let headerHeight: CGFloat = 75.0
    }
    
    /// The view model driving the user profile.
    let viewModel: MyProfileProtocol
    
    /// The data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<MyProfileDataSource.Section, MyProfileDataSource.Item>?
    
    /// Dispose bag for RxSwift subscriptions.
    private let disposeBag = DisposeBag()
    
    private let isActiveObservable = PublishSubject<Bool>()
    
    /// Collection view for displaying the user profile information.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppStyle.Color.backgroundColor
        return collectionView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.close, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = AppStyle.Color.primaryColor
        view.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return view
    }()
    
    /// Initializes the view controller with a view model.
    /// - Parameter viewModel: The view model for the user profile.
    init(viewModel: MyProfileProtocol) {
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
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Methods
extension MyProfileViewController {
    /// Sets up the layout constraints for the collection view.
    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)
        
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        closeButton.isHidden = presentingViewController == nil
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.Spacing.medium),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppStyle.Spacing.medium),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // Function to start animating the activity indicator
    func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    // Function to stop animating the activity indicator
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @objc private func refreshData() {
        startLoading()
        isActiveObservable.onNext(true)
        
    }
    
    /// Binds view model outputs to the view.
    private func bind() {
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.register(ProfileOverviewCell.self, forCellWithReuseIdentifier: ProfileOverviewCell.reuseIdentifier)
        
        bindDataSource()
        bindSupplementaryView()
        
        startLoading()
        
        let output = viewModel.connect(input: .init(isActiveObservable: isActiveObservable))
        
        isActiveObservable.onNext(true)
        
        output.dataSource
            .map { info -> NSDiffableDataSourceSnapshot in
                var snapshot = NSDiffableDataSourceSnapshot<MyProfileDataSource.Section, MyProfileDataSource.Item>()
                snapshot.appendSections(info.map { $0.section })
                info.forEach {
                    snapshot.appendItems($0.rows, toSection: $0.section)
                }
                return snapshot
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, snapshot in
                this.stopLoading()
                this.refreshControl.endRefreshing()
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
    
    private func bindSupplementaryView() {
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
    private func bindDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MyProfileDataSource.Section, MyProfileDataSource.Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
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
extension MyProfileViewController {
    /// Creates the layout for the collection view.
    /// - Returns: The compositional layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let group: NSCollectionLayoutGroup
            
            switch sectionType {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let offset = AppStyle.Spacing.medium
                item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), // Full width of the section
                    heightDimension: .fractionalHeight(0.25) // Adjust as needed for your design
                )
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            case .myPosts:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5), // Two items per row
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let offset = AppStyle.Spacing.medium
                item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), // Full width of the section
                    heightDimension: .fractionalHeight(0.25) // Adjust as needed for your design
                )
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            }
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Constants.headerHeight)
            )
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

// MARK: - Cell Configuration
extension MyProfileViewController {
    // Additional methods for configuring cells can be added here if needed
    
    private func getFeedCell(collectionView: UICollectionView, content: FeedCellContent, indexPath: IndexPath) -> FeedCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else {
            return nil
        }
        cell.configure(content: content)
        return cell
    }
    
    private func getProfileOverviewCell(collectionView: UICollectionView, content: ProfileOverviewContent, indexPath: IndexPath) -> ProfileOverviewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileOverviewCell.reuseIdentifier, for: indexPath) as? ProfileOverviewCell else {
            return nil
        }
        cell.configure(content: content)
        return cell
    }
    
    private func getHeaderView(indexPath: IndexPath) -> UICollectionReusableView? {
        
        guard let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
            return nil
        }
        
        switch section {
        case let .main(title):
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView
            headerView?.configure(title: title)
            return headerView
        case .myPosts:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView
            headerView?.configure(title: "my_profile_my_posts_title".localized, font: AppStyle.Font.title)
            return headerView
        }
    }
}
