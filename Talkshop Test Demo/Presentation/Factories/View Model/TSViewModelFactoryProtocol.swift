//
//  TSViewModelFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

/// A protocol defining a factory for creating view models related to Talkshop.
protocol TSViewModelFactoryProtocol {
    
    /// Creates a view model for My Feed.
    ///
    /// - Parameter fetchPostsUseCase: The use case for fetching posts.
    /// - Returns: A view model conforming to `MyFeedProtocol`.
    func createMyFeedViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyFeedProtocol
    
    /// Creates a view model for My Profile.
    ///
    /// - Parameters:
    ///   - fetchPostsUseCase: The use case for fetching posts.
    ///   - user: The user object representing the profile.
    /// - Returns: A view model conforming to `MyProfileProtocol`.
    func createMyProfileViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) -> MyProfileProtocol
}
