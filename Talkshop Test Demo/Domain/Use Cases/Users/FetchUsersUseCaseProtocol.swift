//
//  FetchUsersUseCaseProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

/// A protocol defining a use case for fetching users.
protocol FetchUsersUseCaseProtocol {
    
    /// Fetches users.
    ///
    /// - Returns: An observable sequence of users.
    func fetchUsers() -> Observable<[User]>
    
}
