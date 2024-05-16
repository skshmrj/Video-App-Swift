//
//  MyProfileViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import Foundation
import RxSwift
import RxCocoa

struct MyProfileDataSource {
    enum Section: Hashable {
        case main
        case myPosts
    }
    
    enum Item: Hashable {
        case myProfileOverview(ProfileOverviewContent)
        case myProfileFeedCell(ProfileFeedCellContent)
    }
    
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}

enum MyProfileViewModelConnection {
    struct Input {
        let isActiveObservable: Observable<Bool>
    }
    
    struct Output {
        let dataSource: Observable<[MyProfileDataSource.DataSource]>
        let errorObservable: Observable<Error>
    }
}

protocol MyProfileProtocol {
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output
}

final class MyProfileViewModel: MyProfileProtocol {
    
    let dataSource = BehaviorRelay<[MyProfileDataSource.DataSource]>(value: [])
    
    let fetchPostsUseCase: FetchPostsUseCaseProtocol
    
    let disposeBag = DisposeBag()
    
    let user: User
    
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.user = user
    }
    
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output {
        
        let errorSubject = PublishSubject<Error>()
        
        input.isActiveObservable
            .filter { $0 }
            .withUnretained(self)
            .flatMap { this, arg in
                this.fetchPosts(userId: this.user.userId)
            }
            .subscribe(onNext: { [weak self] posts in
                guard let user = self?.user,
                      let dataSource = self?.generateDataSource(posts: posts, user: user) else {
                    return
                }
                self?.dataSource.accept(dataSource)
            }, onError: { error in
                errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        return MyProfileViewModelConnection.Output(dataSource: dataSource.asObservable(),
                                                   errorObservable: errorSubject.asObservable())
    }
    
    func generateDataSource(posts: [Post], user: User) -> [MyProfileDataSource.DataSource] {
        let dS: [MyProfileDataSource.DataSource] = [
            .init(section: .main, rows: [
                .myProfileOverview(.init(username: user.userName, image: user.userProfileImage))
            ]),
            .init(section: .myPosts, rows: posts.compactMap { post -> MyProfileDataSource.Item? in
                guard let url = URL(string: post.videoUrl) else {
                    return nil
                }
                return .myProfileFeedCell(.init(videoUrl: url))
            })
        ]
        return dS
    }
}

extension MyProfileViewModel {
    
    func fetchPosts(userId: String) -> Observable<[Post]> {
        return fetchPostsUseCase.fetchPosts(userId: userId)
    }
    
}

