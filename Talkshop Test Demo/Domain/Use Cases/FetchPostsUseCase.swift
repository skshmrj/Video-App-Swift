//
//  FetchPostsUseCase.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import RxSwift

struct FetchPostsUseCase: FetchPostsUseCaseProtocol {
    
    let repository: PostsRepositoryProtocol
    
    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPosts(userId: String? = nil) -> Observable<[Post]> {
        //        repository.fetchPosts()
        var posts = generateDummyData()
        
        if let userId = userId {
            let postsOfUser = posts.filter { $0.username == userId }
            return .just(postsOfUser)
        } else {
            return .just(posts)
        }
        
    }
    
    private func generateDummyData() -> [Post] {
        [
            .init(postId: "1", videoUrl: "https://www.youtube.com/watch?v=x0Ky7QVK44c", thumbNailUrl: "", username: "user_A", likeCount: 1),
            .init(postId: "2", videoUrl: "https://www.youtube.com/watch?v=0OCkTJsMd8U", thumbNailUrl: "", username: "user_B", likeCount: 2),
            .init(postId: "3", videoUrl: "https://www.youtube.com/watch?v=vOd6QAuK2YE", thumbNailUrl: "", username: "user_C", likeCount: 3),
            .init(postId: "4", videoUrl: "https://www.youtube.com/watch?v=4ONfrkskNp4", thumbNailUrl: "", username: "user_D", likeCount: 4),
            .init(postId: "5", videoUrl: "https://www.youtube.com/watch?v=4_fvXrgAm1A", thumbNailUrl: "", username: "user_E", likeCount: 5),
            .init(postId: "1", videoUrl: "https://www.youtube.com/watch?v=UprwkbzUX6g", thumbNailUrl: "", username: "user_A", likeCount: 1),
            .init(postId: "1", videoUrl: "https://www.youtube.com/watch?v=71Gt46aX9Z4", thumbNailUrl: "", username: "user_A", likeCount: 1),
            .init(postId: "1", videoUrl: "https://www.youtube.com/watch?v=YQ2nHgZcf3I", thumbNailUrl: "", username: "user_A", likeCount: 1),
            
        ]
    }
}
