//
//  UseCaseFactoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

protocol UseCaseFactoryProtocol {
    
    func createFetchPostsUseCase(repository: PostsRepositoryProtocol) -> FetchPostsUseCaseProtocol
    
}