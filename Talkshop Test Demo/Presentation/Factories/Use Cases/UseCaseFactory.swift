//
//  UseCaseFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

struct UseCaseFactory: UseCaseFactoryProtocol {
    
    func createFetchPostsUseCase(repository: PostsRepositoryProtocol) -> FetchPostsUseCaseProtocol {
        FetchPostsUseCase(repository: repository)
    }
    
}
