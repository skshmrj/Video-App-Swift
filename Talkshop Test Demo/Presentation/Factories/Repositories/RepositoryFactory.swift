//
//  RepositoryFactory.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

struct RepositoryFactory: RepositoryFactoryProtocol {
    
    func createPostsRepository() -> PostsRepositoryProtocol {
        PostRepository()
    }
    
}
