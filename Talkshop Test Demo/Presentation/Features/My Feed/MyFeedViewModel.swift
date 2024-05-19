//
//  MyFeedViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import RxSwift
import RxCocoa

/// Data source structure for MyFeedViewController.
struct MyFeedDataSource {
    /// Enumeration representing sections in the collection view.
    enum Section: Hashable {
        case main
    }
    
    /// Enumeration representing items in the collection view.
    enum Item: Hashable {
        case myFeedCell(FeedCellContent)
    }
    
    /// Data source model.
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}

/// Connection structure for MyFeedViewModel.
enum MyFeedViewModelConnection {
    /// Input structure for MyFeedViewModel.
    struct Input {
        let isActiveObservable: Observable<Bool>
    }
    
    /// Output structure for MyFeedViewModel.
    struct Output {
        let dataSource: Observable<[MyFeedDataSource.DataSource]>
        let errorObservable: Observable<Error>
    }
}

/// Protocol defining the contract for MyFeedViewModel.
protocol MyFeedProtocol {
    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output
}

/// View model responsible for managing data for MyFeedViewController.
final class MyFeedViewModel: MyFeedProtocol {
    
    /// Behavior relay holding the data source for the view.
    let dataSource = BehaviorRelay<[MyFeedDataSource.DataSource]>(value: [])
    
    /// Publish subject for handling errors.
    let errorSubject = PublishSubject<Error>()
    
    /// Use case for fetching posts.
    let fetchPostsUseCase: FetchPostsUseCaseProtocol
    
    /// Dispose bag for managing disposables.
    let disposeBag = DisposeBag()
    
    /// Initializes the view model with a fetch posts use case.
    /// - Parameter fetchPostsUseCase: The use case for fetching posts.
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    /// Connects the view model to external input and output.
    /// - Parameter input: The input for the view model.
    /// - Returns: The output from the view model.
    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output {
        
        input.isActiveObservable
            .filter { $0 }
            .flatMap { _ in
                self.fetchPosts()
                    .catch { [weak self] error in
                        self?.errorSubject.onNext(error)
                        return .just([])
                    }
            }
            .subscribe(onNext: { [weak self] posts in
                guard let dataSource = self?.generateDataSource(posts: posts) else {
                    return
                }
                self?.dataSource.accept(dataSource)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        return MyFeedViewModelConnection.Output(dataSource: dataSource.asObservable(),
                                                errorObservable: errorSubject.asObservable())
    }
    
    /// Generates the data source for the view.
    /// - Parameter posts: The posts to populate the data source.
    /// - Returns: The generated data source.
    func generateDataSource(posts: [Post]) -> [MyFeedDataSource.DataSource] {
        let dS: [MyFeedDataSource.DataSource] = [
            .init(section: .main, rows: posts.compactMap { post -> MyFeedDataSource.Item? in
                guard let url = URL(string: post.videoUrl) else {
                    return nil
                }
                return .myFeedCell(.init(videoUrl: url, contributorContent: .init(user: post.user, post: post, likesCount: post.likeCount)))
            })
        ]
        return dS
    }
}

extension MyFeedViewModel {
    
    /// Fetches posts from the data source.
    /// - Returns: An observable sequence of posts.
    func fetchPosts() -> Observable<[Post]> {
        return fetchPostsUseCase.fetchPosts(userId: nil)
    }
    
}
