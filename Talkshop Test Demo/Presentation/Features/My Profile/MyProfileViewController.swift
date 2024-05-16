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
    
    /// The view model driving the user profile.
    let viewModel: MyProfileProtocol
    
    /// The data source for the collection view.
    private var dataSource: UICollectionViewDiffableDataSource<MyProfileDataSource.Section, MyProfileDataSource.Item>?
    
    /// Dispose bag for RxSwift subscriptions.
    private let disposeBag = DisposeBag()
    
    /// Collection view for displaying the user profile information.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
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
}

// MARK: - Private Methods
extension MyProfileViewController {
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
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(ProfileFeedCell.self, forCellWithReuseIdentifier: "ProfileFeedCell")
        collectionView.register(ProfileOverviewCell.self, forCellWithReuseIdentifier: "ProfileOverviewCell")
        
        bindDataSource()
        bindSupplementaryView()
        
        let output = viewModel.connect(input: .init(isActiveObservable: .just(true)))
        
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
                this.dataSource?.apply(snapshot, animatingDifferences: false)
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
                return self?.getProfileFeedCell(collectionView: collectionView, content: content, indexPath: indexPath)
            case let .myProfileOverview(content):
                return self?.getProfileFeedCell(collectionView: collectionView, content: content, indexPath: indexPath)
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
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), // Full width of the section
                    heightDimension: .fractionalHeight(0.20) // Adjust as needed for your design
                )
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            case .myPosts:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5), // Two items per row
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), // Full width of the section
                    heightDimension: .fractionalHeight(0.25) // Adjust as needed for your design
                )
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            }
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(75.0)
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
    
    private func getProfileFeedCell(collectionView: UICollectionView, content: ProfileFeedCellContent, indexPath: IndexPath) -> ProfileFeedCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedCell", for: indexPath) as? ProfileFeedCell else {
            return nil
        }
        cell.configure(content: content)
        return cell
    }
    
    private func getProfileFeedCell(collectionView: UICollectionView, content: ProfileOverviewContent, indexPath: IndexPath) -> ProfileOverviewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileOverviewCell", for: indexPath) as? ProfileOverviewCell else {
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
        case .main:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "HeaderView",
                for: indexPath
            ) as? HeaderView
            headerView?.configure(title: "my_profile_tab_bar_title".localized)
            return headerView
        case .myPosts:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "HeaderView",
                for: indexPath
            ) as? HeaderView
            headerView?.configure(title: "my_profile_my_posts_title".localized, textColor: .label, font: .systemFont(ofSize: 18, weight: .semibold))
            return headerView
        }
    }
}
