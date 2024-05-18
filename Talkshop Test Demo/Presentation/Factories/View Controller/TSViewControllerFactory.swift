//
//  TSViewControllerFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

class TSViewControllerFactory: TSViewControllerFactoryProtocol {
    
    init() { }
    
    func createMyFeedViewController(viewModel: MyFeedProtocol, mainFactory: MainFactoryProtocol) -> MyFeedViewController {
        MyFeedViewController(viewModel: viewModel, mainFactory: mainFactory)
    }
    
    func createMyProfileViewController(viewModel: MyProfileProtocol) -> MyProfileViewController {
        MyProfileViewController(viewModel: viewModel)
    }
    
}
