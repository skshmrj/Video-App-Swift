//
//  FetchUsersUseCase.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

struct FetchUsersUseCase: FetchUsersUseCaseProtocol {
    
    let repository: UsersRepositoryProtocol
    
    init(repository: UsersRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers() -> Observable<[User]> {
        repository.fetchUsers()
            .map { UserMapper.transformUserResponse(user: $0) }
    }
    
}
