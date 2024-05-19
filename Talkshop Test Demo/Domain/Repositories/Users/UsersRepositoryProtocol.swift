//
//  UsersRepositoryProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

/// A protocol defining the required methods for a users repository.
protocol UsersRepositoryProtocol {
    
    /// Fetches users from a remote data source.
    ///
    /// - Returns: An observable sequence of response user objects.
    func fetchUsers() -> Observable<[ResponseUser]>
    
}
