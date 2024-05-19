//
//  Post.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

/// A struct representing a post received from the network response.
struct ResponsePost: Decodable {
    /// The unique identifier of the post.
    let postId: String
    
    /// The URL of the video associated with the post.
    let videoUrl: String
    
    /// The URL of the thumbnail image for the video.
    let thumbNailUrl: String
    
    /// The unique identifier of the user who created the post.
    let userId: String
    
    /// The name of the user who created the post.
    let userName: String
    
    /// The number of likes the post has received.
    let likeCount: Int
}
