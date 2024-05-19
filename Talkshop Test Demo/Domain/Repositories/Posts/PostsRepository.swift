//
//  PostRepository.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift
import Alamofire

struct PostRepository: PostsRepositoryProtocol {
    
    func fetchPosts() -> Observable<[ResponsePost]> {
        return Observable.create { observer in
            let url = "https://mocki.io/v1/f958dd91-d26c-43ce-818d-54e9171554ed"
            
            let request = AF.request(url).responseDecodable(of: [ResponsePost].self) { response in
                switch response.result {
                case .success(let posts):
                    observer.onNext(posts)
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
