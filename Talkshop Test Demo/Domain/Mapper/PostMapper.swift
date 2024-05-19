//
//  PostMapper.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A utility struct responsible for mapping response posts to domain posts.
struct PostMapper {
    
    /// Transforms an array of response posts to an array of domain posts.
    ///
    /// - Parameter posts: The array of response posts.
    /// - Returns: An array of domain posts.
    static func transformPostsResponse(posts: [ResponsePost]) -> [Post] {
        posts.map { post in
                .init(postId: post.postId,
                      videoUrl: post.videoUrl,
                      thumbNailUrl: post.thumbNailUrl,
                      user: .init(userId: post.userId, userName: post.userName, userImage: nil),
                      likeCount: post.likeCount)
        }
    }
    
}
