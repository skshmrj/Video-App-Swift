//
//  PostsRepositoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift

protocol PostsRepositoryProtocol {
    func fetchPosts() -> Observable<[ResponsePost]>
}
