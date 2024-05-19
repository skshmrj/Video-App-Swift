//
//  MainFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A factory class responsible for creating various components of the application.
final class MainFactory: MainFactoryProtocol {
    
    /// A lazy-initialized instance of `RepositoryFactoryProtocol` for creating repositories.
    lazy var repositoryFactory: RepositoryFactoryProtocol = {
        RepositoryFactory()
    }()
    
    /// A lazy-initialized instance of `UseCaseFactoryProtocol` for creating use cases.
    lazy var useCaseFactory: UseCaseFactoryProtocol = {
        UseCaseFactory()
    }()
    
    /// A lazy-initialized instance of `TSViewModelFactoryProtocol` for creating view models.
    lazy var viewModelFactory: TSViewModelFactoryProtocol = {
        TSViewModelFactory()
    }()
    
    /// A lazy-initialized instance of `TSViewControllerFactoryProtocol` for creating view controllers.
    lazy var viewControllerFactory: TSViewControllerFactoryProtocol = {
        TSViewControllerFactory()
    }()
}

