//
//  FetchUsersUseCaseProtocol.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift

protocol FetchUsersUseCaseProtocol {
    
    func fetchUsers() -> Observable<[User]>
    
}
