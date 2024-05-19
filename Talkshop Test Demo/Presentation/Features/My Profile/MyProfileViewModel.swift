//
//  MyProfileViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - MyProfileDataSource

/// Data source for MyProfileViewController.
struct MyProfileDataSource {
    // Define sections for the data source.
    enum Section: Hashable {
        case main(String)
        case myPosts
    }
    
    // Define items within each section.
    enum Item: Hashable {
        case myProfileOverview(ProfileOverviewContent)
        case myProfileFeedCell(FeedCellContent)
    }
    
    // Data structure representing a section with its rows.
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}

// MARK: - MyProfileViewModelConnection

/// Connection inputs and outputs for MyProfileViewModel.
enum MyProfileViewModelConnection {
    // Input structure for connecting view model.
    struct Input {
        let isActiveObservable: Observable<Bool>
    }
    
    // Output structure for connecting view model.
    struct Output {
        let dataSource: Observable<[MyProfileDataSource.DataSource]>
        let errorObservable: Observable<Error>
    }
}

// MARK: - MyProfileProtocol

/// Protocol defining the behavior of MyProfileViewModel.
protocol MyProfileProtocol {
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output
}

// MARK: - MyProfileViewModel

/// View model for MyProfileViewController.
final class MyProfileViewModel: MyProfileProtocol {
    
    // MARK: Properties
    
    let dataSource = BehaviorRelay<[MyProfileDataSource.DataSource]>(value: [])
    let disposeBag = DisposeBag()
    let errorSubject = PublishSubject<Error>()
    let user: User
    let fetchPostsUseCase: FetchPostsUseCaseProtocol
    
    // MARK: Initialization
    
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.user = user
    }
    
    // MARK: Public Methods
    
    /// Connects the view model to input and output signals.
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output {
        input.isActiveObservable
            .filter { $0 }
            .withUnretained(self)
            .flatMap { this, _ in
                this.fetchPosts(userId: this.user.userId)
                    .catch { [weak self] error in
                        self?.errorSubject.onNext(error)
                        return .just([])
                    }
            }
            .subscribe(onNext: { [weak self] posts in
                guard let user = self?.user,
                      let dataSource = self?.generateDataSource(posts: posts, user: user) else {
                    return
                }
                self?.dataSource.accept(dataSource)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        return MyProfileViewModelConnection.Output(dataSource: dataSource.asObservable(),
                                                   errorObservable: errorSubject.asObservable())
    }
    
    // MARK: Private Methods
    
    /// Generates the data source for MyProfileViewController.
    private func generateDataSource(posts: [Post], user: User) -> [MyProfileDataSource.DataSource] {
        let userName = user.userId != User.currentUser.userId
        ? user.userName
        : "my_profile_tab_bar_title".localized
        
        let userImage = user.userId != User.currentUser.userId
        ? UIImage.otherUsers
        : user.userImage ?? UIImage.displayPicture
        
        let dataSource: [MyProfileDataSource.DataSource] = [
            .init(section: .main(userName), rows: [
                .myProfileOverview(.init(username: user.userName, image: userImage))
            ]),
            .init(section: .myPosts, rows: posts.compactMap { post -> MyProfileDataSource.Item? in
                guard let url = URL(string: post.videoUrl) else {
                    return nil
                }
                return .myProfileFeedCell(.init(videoUrl: url, contributorContent: nil))
            })
        ]
        return dataSource
    }
    
    /// Fetches posts for the given user ID.
    private func fetchPosts(userId: String) -> Observable<[Post]> {
        return fetchPostsUseCase.fetchPosts(userId: userId)
    }
}
