//
//  UseCaseFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

/// A protocol defining a factory for creating use cases related to Talkshop.
protocol UseCaseFactoryProtocol {
    
    /// Creates a use case for fetching posts.
    ///
    /// - Parameter repository: The repository providing access to posts data.
    /// - Returns: A use case conforming to `FetchPostsUseCaseProtocol`.
    func createFetchPostsUseCase(repository: PostsRepositoryProtocol) -> FetchPostsUseCaseProtocol
    
}
