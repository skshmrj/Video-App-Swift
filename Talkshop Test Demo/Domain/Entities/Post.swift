//
//  Post.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A struct representing a post.
struct Post {
    /// The unique identifier of the post.
    let postId: String
    
    /// The URL of the video associated with the post.
    let videoUrl: String
    
    /// The URL of the thumbnail image for the video.
    let thumbNailUrl: String
    
    /// The user who created the post.
    let user: User
    
    /// The number of likes the post has received.
    let likeCount: Int
}
