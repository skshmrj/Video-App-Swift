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
        case main(String)
        case myPosts
    }
    
    enum Item: Hashable {
        case myProfileOverview(ProfileOverviewContent)
        case myProfileFeedCell(FeedCellContent)
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
    
    let errorSubject = PublishSubject<Error>()
    
    let user: User
    
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.user = user
    }
    
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output {

        
        input.isActiveObservable
            .filter { $0 }
            .withUnretained(self)
            .flatMap { this, arg in
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
    
    func generateDataSource(posts: [Post], user: User) -> [MyProfileDataSource.DataSource] {
        let userName = user.userId != User.currentUser.userId
        ? user.userName
        : "my_profile_tab_bar_title".localized
        
        let userImage = user.userId != User.currentUser.userId
        ? UIImage.otherUsers
        : user.userImage ?? UIImage.displayPicture
        
        let dS: [MyProfileDataSource.DataSource] = [
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
        return dS
    }
}

extension MyProfileViewModel {
    
    func fetchPosts(userId: String) -> Observable<[Post]> {
        return fetchPostsUseCase.fetchPosts(userId: userId)
    }
    
}

