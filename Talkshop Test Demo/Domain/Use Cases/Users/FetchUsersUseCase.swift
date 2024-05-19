//
//  FetchUsersUseCase.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

/// A use case struct responsible for fetching users.
struct FetchUsersUseCase: FetchUsersUseCaseProtocol {
    
    /// The repository providing access to user data.
    let repository: UsersRepositoryProtocol
    
    /// Initializes a new instance of `FetchUsersUseCase`.
    ///
    /// - Parameter repository: The repository providing access to user data.
    init(repository: UsersRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Fetches users from the repository.
    ///
    /// - Returns: An observable sequence of users.
    func fetchUsers() -> Observable<[User]> {
        repository.fetchUsers()
            .map { UserMapper.transformUserResponse(user: $0) }
    }
    
}
