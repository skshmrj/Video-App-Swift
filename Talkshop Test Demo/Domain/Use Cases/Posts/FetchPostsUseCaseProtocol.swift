//
//  FetchPostsUseCaseProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift

/// A protocol defining a use case for fetching posts.
protocol FetchPostsUseCaseProtocol {
    
    /// Fetches posts.
    ///
    /// - Parameter userId: Optional user ID to filter posts by a specific user.
    /// - Returns: An observable sequence of posts.
    func fetchPosts(userId: String?) -> Observable<[Post]>
    
}
