//
//  MyFeedViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit
import RxSwift
import RxCocoa

/// View controller responsible for displaying a feed.
final class MyFeedViewController: UIViewController {
    
    struct Constants {
        static let headerHeight: CGFloat = 75.0
    }
    
    /// The view model driving the feed.
    private let viewModel: MyFeedProtocol
    
    /// Factory for main functionality.
    private let mainFactory: MainFactoryProtocol
    
    /// The data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<MyFeedDataSource.Section, MyFeedDataSource.Item>?
    
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
    
    /// Refresh control for the collection view.
    private let refreshControl = UIRefreshControl()
    
    /// Activity indicator for indicating loading state.
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Initializes the view controller with a view model and main factory.
    /// - Parameters:
    ///   - viewModel: The view model for the feed.
    ///   - mainFactory: The main factory for the application.
    init(viewModel: MyFeedProtocol, mainFactory: MainFactoryProtocol) {
        self.viewModel = viewModel
        self.mainFactory = mainFactory
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
}

// MARK: - Private Methods

private extension MyFeedViewController {
    /// Sets up the layout constraints for the collection view.
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    /// Function to start animating the activity indicator.
    func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    /// Function to stop animating the activity indicator.
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    /// Action triggered when the refresh control value changes.
    @objc func refreshData() {
        startLoading()
        isActiveObservable.onNext(true)
    }
    
    /// Binds view model outputs to the view.
    func bind() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        bindDataSource()
        bindSupplementaryView()
        
        startLoading()
        
        let output = viewModel.connect(input: .init(isActiveObservable: isActiveObservable))
        
        isActiveObservable.onNext(true)
        
        output.dataSource
            .map { info -> NSDiffableDataSourceSnapshot in
                var snapshot = NSDiffableDataSourceSnapshot<MyFeedDataSource.Section, MyFeedDataSource.Item>()
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
        dataSource = UICollectionViewDiffableDataSource<MyFeedDataSource.Section, MyFeedDataSource.Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            switch item {
            case .myFeedCell(let content):
                return self?.getFeedCell(collectionView: collectionView, content: content, indexPath: indexPath)
            }
        }
    }
}

// MARK: - Layout

private extension MyFeedViewController {
    /// Creates the layout for the collection view.
    /// - Returns: The compositional layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let offset = AppStyle.Spacing.medium
        item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Cell and Header Configuration

private extension MyFeedViewController {
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
        
        output.authorButtonTapObservable
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                guard let user = content.contributorContent?.user else {
                    return
                }
                let fetchPostsUseCase = this.mainFactory.useCaseFactory.createFetchPostsUseCase(
                    repository: this.mainFactory.repositoryFactory.createPostsRepository()
                )
                let viewModel = this.mainFactory.viewModelFactory.createMyProfileViewModel(fetchPostsUseCase: fetchPostsUseCase, user: user)
                let viewController = this.mainFactory.viewControllerFactory.createMyProfileViewController(viewModel: viewModel)
                this.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: output.disposeBag)
        
        output.cellTappedObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                guard let user = content.contributorContent?.user,
                      let post = content.contributorContent?.post else {
                    return
                }
                let viewModel = this.mainFactory.viewModelFactory.createPostViewModel(post: post, user: user)
                let viewController = this.mainFactory.viewControllerFactory.createPostViewController(viewModel: viewModel)
                this.present(viewController, animated: true, completion: nil)
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
        headerView?.configure(title: "my_feed_tab_item_title".localized)
        return headerView
    }
}
