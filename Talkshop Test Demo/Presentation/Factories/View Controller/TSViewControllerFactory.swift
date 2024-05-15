//
//  TSViewControllerFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

class TSViewControllerFactory: TSViewControllerFactoryProtocol {
    
    init() { }
    
    func createMyFeedViewController(viewModel: MyFeedProtocol) -> MyFeedViewController {
        MyFeedViewController(viewModel: viewModel)
    }
    
    func createMyProfileViewController(viewModel: MyProfileProtocol) -> MyProfileViewController {
        MyProfileViewController(viewModel: viewModel)
    }
    
}
