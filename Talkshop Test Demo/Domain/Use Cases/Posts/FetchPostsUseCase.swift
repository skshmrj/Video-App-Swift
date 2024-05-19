//
//  FetchPostsUseCase.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

/// A use case struct responsible for fetching posts.
struct FetchPostsUseCase: FetchPostsUseCaseProtocol {
    
    /// The repository providing access to post data.
    let repository: PostsRepositoryProtocol
    
    /// Initializes a new instance of `FetchPostsUseCase`.
    ///
    /// - Parameter repository: The repository providing access to post data.
    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Fetches posts from the repository.
    ///
    /// - Parameter userId: Optional user ID to filter posts by a specific user.
    /// - Returns: An observable sequence of posts.
    func fetchPosts(userId: String? = nil) -> Observable<[Post]> {
        let posts = repository.fetchPosts().map { PostMapper.transformPostsResponse(posts: $0) }
        return posts
    }
}
