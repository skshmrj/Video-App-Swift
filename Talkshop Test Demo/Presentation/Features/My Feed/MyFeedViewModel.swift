//
//  MyFeedViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import RxSwift
import RxCocoa

struct MyFeedDataSource {
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case myFeedCell(FeedCellContent)
    }
    
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}


enum MyFeedViewModelConnection {
    struct Input {
        let isActiveObservable: Observable<Bool>
    }
    
    struct Output {
        let dataSource: Observable<[MyFeedDataSource.DataSource]>
        let errorObservable: Observable<Error>
    }
}


protocol MyFeedProtocol {
    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output
}

final class MyFeedViewModel: MyFeedProtocol {
    
    let dataSource = BehaviorRelay<[MyFeedDataSource.DataSource]>(value: [])
    
    let fetchPostsUseCase: FetchPostsUseCaseProtocol
    
    let disposeBag = DisposeBag()
    
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output {
        
        let errorSubject = PublishSubject<Error>()
        
        input.isActiveObservable
            .filter { $0 }
            .flatMap { arg in
                self.fetchPosts()
            }
            .subscribe(onNext: { [weak self] posts in
                guard let dataSource = self?.generateDataSource(posts: posts) else {
                    return
                }
                self?.dataSource.accept(dataSource)
            }, onError: { error in
                errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        return MyFeedViewModelConnection.Output(dataSource: dataSource.asObservable(),
                                                errorObservable: errorSubject.asObservable())
    }
    
    func generateDataSource(posts: [Post]) -> [MyFeedDataSource.DataSource] {
        let dS: [MyFeedDataSource.DataSource] = [
            .init(section: .main, rows: posts.compactMap { post -> MyFeedDataSource.Item? in
                guard let url = URL(string: post.videoUrl) else {
                    return nil
                }
                return .myFeedCell(.init(videoUrl: url, contributorContent: .init(user: post.user, likesCount: post.likeCount)))
            })
        ]
        return dS
    }
}

extension MyFeedViewModel {
    
    func fetchPosts() -> Observable<[Post]> {
        return fetchPostsUseCase.fetchPosts(userId: nil)
    }
    
}
