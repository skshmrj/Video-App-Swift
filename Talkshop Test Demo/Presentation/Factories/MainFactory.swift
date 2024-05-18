//
//  MainFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

final class MainFactory: MainFactoryProtocol {
    
    lazy var repositoryFactory: RepositoryFactoryProtocol = {
        RepositoryFactory()
    }()
    
    lazy var useCaseFactory: UseCaseFactoryProtocol = {
        UseCaseFactory()
    }()
    
    lazy var viewModelFactory: TSViewModelFactoryProtocol = {
        TSViewModelFactory()
    }()
    
    lazy var viewControllerFactory: TSViewControllerFactoryProtocol = {
        TSViewControllerFactory()
    }()
}

