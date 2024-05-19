//
//  PostRepository.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift
import Alamofire

/// A repository for fetching posts from a remote data source.
struct PostRepository: PostsRepositoryProtocol {
    
    /// Fetches posts from a remote data source.
    ///
    /// - Returns: An observable sequence of response post objects.
    func fetchPosts() -> Observable<[ResponsePost]> {
        return Observable.create { observer in
            // URL for the remote data source
            let url = "https://mocki.io/v1/543093f4-2d9e-4768-9c2e-5284ab7e0bba"
            
            // Perform a request to fetch posts
            let request = AF.request(url).responseDecodable(of: [ResponsePost].self) { response in
                switch response.result {
                case .success(let posts):
                    // Successfully fetched posts, pass them to the observer
                    observer.onNext(posts)
                    observer.onCompleted()
                case .failure(let error):
                    // Handle the error and pass it to the observer
                    print("Request failed with error: \(error)")
                    observer.onError(error)
                }
            }
            
            // Return a disposable to allow for cleanup
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
