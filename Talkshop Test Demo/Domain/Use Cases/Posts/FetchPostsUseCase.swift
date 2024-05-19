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
        let posts = repository.fetchPosts().map { PostMapper.transformPostsResponse(posts: $0) }
        return posts
//        var posts = generateDummyData()
//        
//        if let userId = userId {
//            let postsOfUser = posts.filter { $0.user.userId == userId }
//            return .just(postsOfUser)
//        } else {
//            return .just(posts)
//        }
    }
    
    private func generateDummyData() -> [Post] {
        [
            .init(postId: "1", 
                  videoUrl: "https://www.youtube.com/watch?v=x0Ky7QVK44c",
                  thumbNailUrl: "",
                  user: .init(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture),
                  likeCount: 1),
            .init(postId: "2",
                  videoUrl: "https://www.youtube.com/watch?v=0OCkTJsMd8U",
                  thumbNailUrl: "",
                  user: .init(userId: "user_B", userName: "Monkey D. Luffy", userImage: UIImage.displayPicture),
                  likeCount: 2),
            .init(postId: "3",
                  videoUrl: "https://www.youtube.com/watch?v=vOd6QAuK2YE",
                  thumbNailUrl: "",
                  user: .init(userId: "user_C", userName: "Roronoa Zoro", userImage: UIImage.displayPicture),
                  likeCount: 3),
            .init(postId: "4",
                  videoUrl: "https://www.youtube.com/watch?v=4ONfrkskNp4",
                  thumbNailUrl: "",
                  user: .init(userId: "user_D", userName: "Nami", userImage: UIImage.displayPicture),
                  likeCount: 4),
            .init(postId: "5",
                  videoUrl: "https://www.youtube.com/watch?v=4_fvXrgAm1A", 
                  thumbNailUrl: "", 
                  user: .init(userId: "user_E", userName: "Usopp", userImage: UIImage.displayPicture),
                  likeCount: 5),
            .init(postId: "1",
                  videoUrl: "https://www.youtube.com/watch?v=UprwkbzUX6g", 
                  thumbNailUrl: "", 
                  user: .init(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture),
                  likeCount: 1),
            .init(postId: "1",
                  videoUrl: "https://www.youtube.com/watch?v=71Gt46aX9Z4",
                  thumbNailUrl: "", 
                  user: .init(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture),
                  likeCount: 1),
            .init(postId: "1",
                  videoUrl: "https://www.youtube.com/watch?v=YQ2nHgZcf3I", 
                  thumbNailUrl: "", 
                  user: .init(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture),
                  likeCount: 1),
            
        ]
    }
}
