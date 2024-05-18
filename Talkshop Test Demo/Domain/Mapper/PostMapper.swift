//
//  PostMapper.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

struct PostMapper {
    
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
