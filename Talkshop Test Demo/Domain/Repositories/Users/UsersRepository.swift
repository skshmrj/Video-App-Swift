//
//  UsersRepository.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift
import Alamofire

/// A repository struct responsible for fetching user data.
struct UsersRepository: UsersRepositoryProtocol {
    
    /// Fetches users from a remote data source.
    ///
    /// - Returns: An observable sequence of response user objects.
    func fetchUsers() -> Observable<[ResponseUser]> {
        return Observable.create { observer in
            let url = "https://jsonplaceholder.typicode.com/users"
            
            // Make a network request to fetch users
            let request = AF.request(url).responseDecodable(of: [ResponseUser].self) { response in
                switch response.result {
                case .success(let users):
                    // On successful response, send the user data and complete the observable sequence
                    observer.onNext(users)
                    observer.onCompleted()
                case .failure(let error):
                    // On failure, print the error and send the error through the observable sequence
                    print("Request failed with error: \(error)")
                    observer.onError(error)
                }
            }
            
            // Return a disposable to cancel the request if needed
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
