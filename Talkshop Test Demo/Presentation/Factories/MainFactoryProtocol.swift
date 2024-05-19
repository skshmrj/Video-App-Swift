//
//  MainFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A protocol defining the main factory for creating various components of the application.
protocol MainFactoryProtocol {
    
    /// The factory responsible for creating repositories.
    var repositoryFactory: RepositoryFactoryProtocol { get }
    
    /// The factory responsible for creating use cases.
    var useCaseFactory: UseCaseFactoryProtocol { get }
    
    /// The factory responsible for creating view models.
    var viewModelFactory: TSViewModelFactoryProtocol { get }
    
    /// The factory responsible for creating view controllers.
    var viewControllerFactory: TSViewControllerFactoryProtocol { get }
}

