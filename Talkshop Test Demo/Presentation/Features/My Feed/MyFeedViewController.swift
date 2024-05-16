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
    
    /// The view model driving the feed.
    let viewModel: MyFeedProtocol
    
    /// The data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<MyFeedDataSource.Section, MyFeedDataSource.Item>?
    
    /// Dispose bag for RxSwift subscriptions.
    private let disposeBag = DisposeBag()
    
    /// Collection view for displaying the feed.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    /// Initializes the view controller with a view model.
    /// - Parameter viewModel: The view model for the feed.
    init(viewModel: MyFeedProtocol) {
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
}

// MARK: - Private Methods
extension MyFeedViewController {
    /// Sets up the layout constraints for the collection view.
    private func layout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    /// Binds view model outputs to the view.
    private func bind() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        
        bindDataSource()
        
        let output = viewModel.connect(input: .init(isActiveObservable: .just(true)))
        
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
                this.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    /// Sets up the data source for the collection view.
    private func bindDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MyFeedDataSource.Section, MyFeedDataSource.Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            switch item {
            case .myFeedCell(let content):
                return self?.getFeedCell(collectionView: collectionView, content: content, indexPath: indexPath)
            }
        }
    }
}

// MARK: - Layout
extension MyFeedViewController {
    /// Creates the layout for the collection view.
    /// - Returns: The compositional layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Cell Configuration
extension MyFeedViewController {
    /// Dequeues and configures a feed cell.
    /// - Parameters:
    ///   - collectionView: The collection view.
    ///   - content: The content to configure the cell with.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured feed cell.
    private func getFeedCell(collectionView: UICollectionView, content: FeedCellContent, indexPath: IndexPath) -> FeedCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell else {
            return nil
        }
        cell.configure(content: content)
        return cell
    }
}
