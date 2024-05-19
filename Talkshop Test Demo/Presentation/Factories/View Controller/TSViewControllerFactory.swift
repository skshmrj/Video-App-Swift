//
//  TSViewControllerFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

/// A factory class responsible for creating view controllers related to Talkshop.
class TSViewControllerFactory: TSViewControllerFactoryProtocol {
    
    /// Initializes a new instance of `TSViewControllerFactory`.
    init() { }
    
    /// Creates and configures a view controller for My Feed.
    ///
    /// - Parameters:
    ///   - viewModel: The view model for My Feed.
    ///   - mainFactory: The main factory providing dependencies.
    /// - Returns: A configured instance of `MyFeedViewController`.
    func createMyFeedViewController(viewModel: MyFeedProtocol, mainFactory: MainFactoryProtocol) -> MyFeedViewController {
        MyFeedViewController(viewModel: viewModel, mainFactory: mainFactory)
    }
    
    /// Creates and configures a view controller for My Profile.
    ///
    /// - Parameter viewModel: The view model for My Profile.
    /// - Returns: A configured instance of `MyProfileViewController`.
    func createMyProfileViewController(viewModel: MyProfileProtocol) -> MyProfileViewController {
        MyProfileViewController(viewModel: viewModel)
    }
    
}
