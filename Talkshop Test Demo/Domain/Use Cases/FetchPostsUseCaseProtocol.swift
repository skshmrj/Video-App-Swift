//
//  FetchPostsUseCaseProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift

protocol FetchPostsUseCaseProtocol {
    
    func fetchPosts(userId: String?) -> Observable<[Post]>
    
}
