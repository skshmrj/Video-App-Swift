//
//  TSViewControllerFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

protocol TSViewControllerFactoryProtocol {
    
    func createMyFeedViewController(viewModel: MyFeedProtocol) -> MyFeedViewController
    
    func createMyProfileViewController(viewModel: MyProfileProtocol) -> MyProfileViewController
    
}
