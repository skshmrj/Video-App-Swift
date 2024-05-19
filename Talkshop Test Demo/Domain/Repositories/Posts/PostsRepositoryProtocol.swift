//
//  PostsRepositoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift

/// Protocol defining the methods for fetching posts.
protocol PostsRepositoryProtocol {
    
    /// Fetches posts from a data source.
    ///
    /// - Returns: An observable sequence of response post objects.
    func fetchPosts() -> Observable<[ResponsePost]>
}
