//
//  RepositoryFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

/// A protocol defining a factory for creating repositories related to Talkshop.
protocol RepositoryFactoryProtocol {
    
    /// Creates a repository for posts.
    ///
    /// - Returns: A repository conforming to `PostsRepositoryProtocol`.
    func createPostsRepository() -> PostsRepositoryProtocol
    
}
