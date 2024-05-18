//
//  MainFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

protocol MainFactoryProtocol {
    
    var repositoryFactory: RepositoryFactoryProtocol { get }
    
    var useCaseFactory: UseCaseFactoryProtocol { get }
    
    var viewModelFactory: TSViewModelFactoryProtocol { get }
    
    var viewControllerFactory: TSViewControllerFactoryProtocol { get }
}
