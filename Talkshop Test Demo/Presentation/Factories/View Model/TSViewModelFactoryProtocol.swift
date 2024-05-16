//
//  TSViewModelFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

protocol TSViewModelFactoryProtocol {
    func createMyFeedViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyFeedProtocol
    func createMyProfileViewModel(fetchPostsUseCase: FetchPostsUseCaseProtocol, user: User) -> MyProfileProtocol
}
