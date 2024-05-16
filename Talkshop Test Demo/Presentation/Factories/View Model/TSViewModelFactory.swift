//
//  TSViewModelFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

struct TSViewModelFactory: TSViewModelFactoryProtocol {
    func createMyFeedViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyFeedProtocol {
        MyFeedViewModel(fetchPostsUseCase: fetchPostsUseCase)
    }
    
    func createMyProfileViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) -> MyProfileProtocol {
        MyProfileViewModel(fetchPostsUseCase: fetchPostsUseCase, user: user)
    }
}
 
