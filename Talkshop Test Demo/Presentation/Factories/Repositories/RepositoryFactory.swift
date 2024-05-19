//
//  RepositoryFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

/// A factory struct responsible for creating repositories related to Talkshop.
struct RepositoryFactory: RepositoryFactoryProtocol {
    
    /// Creates a repository for posts.
    ///
    /// - Returns: A repository conforming to `PostsRepositoryProtocol`.
    func createPostsRepository() -> PostsRepositoryProtocol {
        PostRepository()
    }
    
}
