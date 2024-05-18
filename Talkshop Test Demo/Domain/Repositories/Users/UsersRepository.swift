//
//  UsersRepository.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import RxSwift
import Alamofire

struct UsersRepository: UsersRepositoryProtocol {
    
    func fetchUsers() -> Observable<[ResponseUser]> {
        return Observable.create { observer in
            let url = "https://jsonplaceholder.typicode.com/users"
            
            let request = AF.request(url).responseDecodable(of: [ResponseUser].self) { response in
                switch response.result {
                case .success(let users):
                    observer.onNext(users)
                    observer.onCompleted()
                case .failure(let error):
                    // Handle the error and return an empty array or appropriate fallback
                    print("Request failed with error: \(error)")
                    observer.onNext([])
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
