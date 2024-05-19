//
//  PostViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 19/05/24.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - PostDataSource

struct PostDataSource {
    // Define sections for the data source.
    enum Section: Hashable {
        case user(String)
        case post
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

// MARK: - PostViewModelConnection

enum PostViewModelConnection {
    // Input structure for connecting view model.
    struct Input {
        let isActiveObservable: Observable<Bool>
    }
    
    // Output structure for connecting view model.
    struct Output {
        let dataSource: Observable<[PostDataSource.DataSource]>
        let errorObservable: Observable<Error>
    }
}

// MARK: - PostProtocol

protocol PostProtocol {
    func connect(input: PostViewModelConnection.Input) -> PostViewModelConnection.Output
}

// MARK: - PostViewModel

final class PostViewModel: PostProtocol {
    
    // MARK: Properties
    
    let dataSource = BehaviorRelay<[PostDataSource.DataSource]>(value: [])
    let disposeBag = DisposeBag()
    let errorSubject = PublishSubject<Error>()
    let user: User
    let post: Post
    
    // MARK: Initialization
    
    init(user: User, post: Post) {
        self.post = post
        self.user = user
    }
    
    // MARK: Public Methods
    
    /// Connects the view model to input and output signals.
    func connect(input: PostViewModelConnection.Input) -> PostViewModelConnection.Output {
        
        let dS = generateDataSource(post: post, user: user)
        dataSource.accept(dS)
        
        return PostViewModelConnection.Output(dataSource: dataSource.asObservable(),
                                              errorObservable: errorSubject.asObservable())
    }
    
    // MARK: Private Methods
    
    /// Generates the data source for MyProfileViewController.
    private func generateDataSource(post: Post, user: User) -> [PostDataSource.DataSource] {
        
        let userImage = user.userId != User.currentUser.userId
        ? UIImage.otherUsers
        : user.userImage ?? UIImage.displayPicture
        
        let dataSource: [PostDataSource.DataSource] = [
            .init(section: .post, rows: [
                .myProfileFeedCell(.init(videoUrl: URL(string: post.videoUrl), contributorContent: .init(user: nil, post: post, likesCount: post.likeCount)))
            ]),
            .init(section: .user("contributor_title".localized), rows: [
                .myProfileOverview(.init(username: user.userName, image: userImage))
            ])
        ]
        return dataSource
    }
}
